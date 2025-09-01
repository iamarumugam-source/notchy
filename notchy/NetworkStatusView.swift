//
//  NetworkStatusView.swift
//  notchy
//
//  Created by Arjun on 30/08/25.
//
import SwiftUI

struct NetworkStatusView: View {
    @StateObject private var monitor = NetworkStatsManager.shared
    
    var body: some View {
        HStack(spacing: 6) {
            // pload Speed
            HStack {
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(monitor.uploadSpeedValue > 0 ? .pink : .gray)
                    .font(.system(size: 12))
                VStack(alignment: .leading, spacing: 2) {
                    Text("UP")
                        .font(.system(size: 9, weight: .semibold,design: .monospaced))
                        .foregroundColor(.secondary)
                    Text(monitor.uploadSpeed)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                }
            }
            // Download Speed
            HStack {
                Image(systemName: "arrow.down.circle.fill")
                    .foregroundColor(monitor.downloadSpeedValue > 0 ? .blue : .gray)
                    .font(.system(size: 12))
                VStack(alignment: .leading, spacing: 2) {
                    Text("DOWN")
                        .font(.system(size: 9, weight: .semibold, design: .monospaced))
                        .foregroundColor(.secondary)
                    Text(monitor.downloadSpeed)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.tertiarySystemFill).opacity(0.3))
        )
    }
}
