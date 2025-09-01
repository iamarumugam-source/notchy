//
//  SystemStatsStatusView.swift
//  notchy
//
//  Created by Arjun on 31/08/25.
//


import SwiftUI
import AppKit

struct SystemStatsStatusView: View {

    
    @StateObject private var manager = SystemStatsManager.shared

    
    var body: some View {
        HStack(spacing: 12) {
            statItem(icon: "cpu", color: .orange, value: manager.cpu)
            statItem(icon: "memorychip", color: .purple, value: manager.ram)
            statItem(icon: "internaldrive", color: .green, value: manager.disk)
        }
        .font(.system(size: 11, weight: .medium, design: .monospaced))

    }
    
    @ViewBuilder
    private func statItem(icon: String, color: Color, value: Double) -> some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text("\(Int(value))%")
        }
    }
    
}

// MARK: - System Stats Helper
struct SystemStats {
    static func cpuUsagePercent() -> Double {
        var load = host_cpu_load_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: load)/MemoryLayout<integer_t>.size)
        let result = withUnsafeMutablePointer(to: &load) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
            }
        }
        guard result == KERN_SUCCESS else { return 0 }

        let user = Double(load.cpu_ticks.0)
        let system = Double(load.cpu_ticks.1)
        let idle = Double(load.cpu_ticks.2)
        let nice = Double(load.cpu_ticks.3)
        let total = user + system + idle + nice
        return total > 0 ? ((user + system + nice) / total) * 100 : 0
    }

    static func ramUsagePercent() -> Double {
        var stats = vm_statistics64()
            var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.stride / MemoryLayout<integer_t>.stride)
            let result = withUnsafeMutablePointer(to: &stats) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                    host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
                }
            }
            guard result == KERN_SUCCESS else { return 0 }

            // Used memory: active + wired + compressed
            let used = Double(stats.active_count + stats.wire_count + stats.compressor_page_count) * Double(vm_kernel_page_size)

            // Total memory: active + inactive + wired + free + compressed
            let total = Double(stats.active_count + stats.inactive_count + stats.wire_count + stats.free_count + stats.compressor_page_count) * Double(vm_kernel_page_size)

            return total > 0 ? (used / total) * 100 : 0
    }


    static func diskUsagePercent() -> Double {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(forPath: "/")
            if let total = attrs[.systemSize] as? NSNumber,
               let free = attrs[.systemFreeSize] as? NSNumber {
                let used = total.doubleValue - free.doubleValue
                return (used / total.doubleValue) * 100
            }
        } catch {
            return 0
        }
        return 0
    }
}
