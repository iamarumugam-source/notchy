//
//  notchyApp.swift
//  notchy
//
//  Created by Arjun on 30/08/25.

import SwiftUI
import AppKit
import HotKey
import DynamicNotchKit

@main
struct notchyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings { EmptyView() }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var hotKey: HotKey?
    var hk: HotKey?
    var notch: DynamicNotch<NotchPopup, EmptyView, EmptyView>?
    var isExpanded = false
    var idleTimer: Timer?
    let idleTimeout: TimeInterval = 5
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        setupHotkey()
        
        _ = ClipboardManager.shared
        
        notch = DynamicNotch(hoverBehavior: .keepVisible) {
            NotchPopup()
        }
    }
    
    func startIdleTimer() {
        idleTimer?.invalidate() // cancel previous timer if any
        idleTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
            Task {
                guard let self, let notch = self.notch else { return }
                await notch.hide()
                self.isExpanded = false
            }
        }
    }


    
    private func setupHotkey() {
        hotKey = HotKey(key: .a, modifiers: [.command, .control])
        hotKey?.keyDownHandler = { [weak self] in
            guard let self, let notch = self.notch else { return }
            
            Task{
                if self.isExpanded {
                    await notch.hide()
                    self.isExpanded = false
                    self.idleTimer?.invalidate()
                } else {
                    await notch.expand()
                    self.isExpanded = true
                    self.startIdleTimer()
                }
//                try await Task.sleep(for: .seconds(5))
//                await notch.hide()
            }
            
            
        }
        
        hk = HotKey(key: .c, modifiers: [.command, .control])
        hk?.keyDownHandler = {
            ClipboardWindowController.shared.toggle()
        }
    }
}



