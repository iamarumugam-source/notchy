//
//  NetworkStatus.swift
//  notchy
//
//  Created by Arjun on 01/09/25.
//

import SwiftUI
import AppKit
import DynamicNotchKit


let frameWidth: CGFloat = 96



func showNetworkStatus(){
    Task {
        @MainActor in
        let networkNotch = DynamicNotchInfo(
            icon: .init(systemName: ""), 
            title: "Test",
            compactLeading: .init(content: {
                leadingView()
            }),
            compactTrailing: .init(content: {
                trailingView()
            })
        )
        
        await networkNotch.compact()
    }
}

struct leadingView: View {
    @StateObject private var monitor = NetworkStatsManager.shared
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.up.circle.fill")
                .foregroundColor(monitor.uploadSpeedValue > 0 ? .pink : .gray)
                .font(.system(size: 12))
            Text(monitor.uploadSpeed)
                .font(.system(size: 11, weight: .medium, design: .monospaced))
        }
    }
}

struct trailingView: View {
    @StateObject private var monitor = NetworkStatsManager.shared
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.down.circle.fill")
                .foregroundColor(monitor.downloadSpeedValue > 0 ? .blue : .gray)
                .font(.system(size: 12))
            Text(monitor.downloadSpeed)
                .font(.system(size: 11, weight: .medium, design: .monospaced))
        }
    }
}
