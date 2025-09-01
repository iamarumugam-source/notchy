//
// NetworkMonitor.swift
// notchy
//

import Foundation
import Combine
import Network

class NetworkStatsManager: ObservableObject {
    static let shared = NetworkStatsManager()
    
    @Published var downloadSpeed: String = "-- KB/s"
    @Published var uploadSpeed: String = "-- KB/s"
    
    @Published var downloadSpeedValue: Double = 0
    @Published var uploadSpeedValue: Double = 0
    
    private var timer: Timer?
    private var lastReceived: UInt64 = 0
    private var lastSent: UInt64 = 0
    
    private let debugLogs = false
    
    private init() {
        // take initial sample
        sampleInterfaces()
        startMonitoring()
    }
    
    private func startMonitoring() {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.sampleInterfaces()
            }
            RunLoop.current.add(self.timer!, forMode: .common)
        }
    }
    
    private func sampleInterfaces() {
        var ifaddrsPtr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddrsPtr) == 0, let first = ifaddrsPtr else {
            if debugLogs { print("getifaddrs failed or returned nil") }
            return
        }
        defer { freeifaddrs(ifaddrsPtr) }
        
        var totalRx: UInt64 = 0
        var totalTx: UInt64 = 0
        
        var ptr = first
        while true {
            let ifa = ptr.pointee
            let flags = Int32(ifa.ifa_flags)
            let isUp = (flags & (IFF_UP|IFF_RUNNING)) == (IFF_UP|IFF_RUNNING)
            if isUp {
                if let addrPtr = ifa.ifa_addr {
                    let family = addrPtr.pointee.sa_family
                    if family == UInt8(AF_LINK) {
                        if let dataPtr = ifa.ifa_data?.assumingMemoryBound(to: if_data.self) {
                            let data = dataPtr.pointee
                            totalRx += UInt64(bitPattern: Int64(data.ifi_ibytes))
                            totalTx += UInt64(bitPattern: Int64(data.ifi_obytes))
                        }
                    }
                }
            }
            
            if let next = ptr.pointee.ifa_next {
                ptr = next
            } else { break }
        }
        
        // compute deltas
        let deltaRx = totalRx >= lastReceived ? totalRx - lastReceived : 0
        let deltaTx = totalTx >= lastSent ? totalTx - lastSent : 0
        lastReceived = totalRx
        lastSent = totalTx
        
        let downKB = Double(deltaRx) / 1024.0
        let upKB = Double(deltaTx) / 1024.0
        
        let downStr = formatSpeed(bytes: deltaRx)
        let upStr = formatSpeed(bytes: deltaTx)
        
        DispatchQueue.main.async {
            self.downloadSpeedValue = downKB
            self.uploadSpeedValue = upKB
            self.downloadSpeed = downStr
            self.uploadSpeed = upStr
        }
    }
    
    private func formatSpeed(bytes: UInt64) -> String {
        let kb = Double(bytes) / 1024.0
        if kb < 1024.0 {
            return String(format: "%.0f KB/s", kb)
        } else {
            return String(format: "%.2f MB/s", kb / 1024.0)
        }
    }
}
