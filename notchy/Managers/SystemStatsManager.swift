//
//  SystemStatsManager.swift
//  notchy
//
//  Created by Arjun on 31/08/25.
//


import SwiftUI
import Combine

class SystemStatsManager: ObservableObject {
    static let shared = SystemStatsManager()
    
    @Published var cpu: Double = 0
    @Published var ram: Double = 0
    @Published var disk: Double = 0
    
    private var timer: Timer?
    
    private init() {
        startUpdating()
    }
    
    private func startUpdating() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                self.cpu = SystemStats.cpuUsagePercent()
                self.ram = SystemStats.ramUsagePercent()
                self.disk = SystemStats.diskUsagePercent()
            }
        }
    }
}
