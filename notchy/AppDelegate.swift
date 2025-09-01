//
//  AppDelegate.swift
//  notchy
//
//  Created by Arjun on 01/09/25.
//


import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private var notchController: NotchController!
    private var hotKeyManager: HotKeyManager!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        // Initialize systems
        notchController = NotchController()
        hotKeyManager = HotKeyManager(notchController: notchController)

        _ = ClipboardManager.shared
    }

    func applicationWillTerminate(_ notification: Notification) {
        notchController.cleanup()
    }
}
