//
//  NotchController.swift
//  notchy
//
//  Created by Arjun on 01/09/25.
//

import SwiftUI
import AppKit
import DynamicNotchKit

@MainActor
final class NotchController {
    private var notch: DynamicNotch<NotchPopup, EmptyView, EmptyView>
    private(set) var isExpanded = false
    
    private var idleTimer: Timer?
    private let idleTimeout: TimeInterval = 3
    
    private var hoverWindow: HoverHotspotWindow!
    
    init() {
        notch = DynamicNotch(hoverBehavior: .keepVisible) { NotchPopup() }
        hoverWindow = HoverHotspotWindow(delegate: self)
    }
    
    func expand() {
        Task { @MainActor in
            guard !isExpanded else { return }
            await notch.expand()
            isExpanded = true
            startIdleTimer()
        }
    }
    
    func hide() {
        Task { @MainActor in
            guard isExpanded else { return }
            await notch.hide()
            isExpanded = false
            idleTimer?.invalidate()
        }
    }
    
    private func startIdleTimer() {
        idleTimer?.invalidate()
        idleTimer = Timer.scheduledTimer(withTimeInterval: idleTimeout, repeats: false) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.hide()
            }
        }
    }


    func cleanup() {
        hoverWindow.cleanup()
    }
}

extension NotchController: HoverHotspotDelegate {
    nonisolated func hoverEntered() {
        Task { @MainActor in self.expand() }
    }
    
    nonisolated func hoverExited() {
        Task { @MainActor in self.hide() }
    }
}
