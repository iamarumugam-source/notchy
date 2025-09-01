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

// Keep one controller alive
@MainActor
private let globalNotchController = NotchController()

func showNetworkStatus() {
    Task { @MainActor in
        let networkNotch = DynamicNotchInfo(
            icon: .init(systemName: ""),
            title: "Test",
            compactLeading: .init(content: {
                leadingView()
            }),
            compactTrailing: .init(content: {
                trailingView(notchController: globalNotchController)
            })
        )
        
        await networkNotch.compact()
    }
}

// MARK: - Upload (leading view)

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

// MARK: - Download + Clipboard (trailing view)

struct trailingView: View {
    @StateObject private var monitor = NetworkStatsManager.shared
    
    let notchController: NotchController   // injected
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                Image(systemName: "arrow.down.circle.fill")
                    .foregroundColor(monitor.downloadSpeedValue > 0 ? .blue : .gray)
                    .font(.system(size: 12))
                    .frame(width: 14, height: 14, alignment: .center)
                Text(monitor.downloadSpeed)
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
            }
            
            HStack(spacing: 4) {
                Image(systemName: "clipboard.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 12))
                    .frame(width: 14, height: 14, alignment: .center)
                Text("25")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .onHover { isHovering in
            if isHovering {
                notchController.expand()
            } else {
                notchController.hide()
            }
        }
    }
}
