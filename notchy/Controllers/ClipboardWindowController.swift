//
//  ClipboardWindowController.swift
//  notchy
//
//  Created by Arjun on 31/08/25.
//
import SwiftUI
import AppKit

class ClipboardWindowController: NSWindowController {
    static let shared = ClipboardWindowController()

    private init() {
        let contentView = ClipboardHistoryView()
        let hostingController = NSHostingController(rootView: contentView)

        let window = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 360, height: 480),
            styleMask: [.nonactivatingPanel, .hudWindow], // borderless floating
            backing: .buffered,
            defer: false
        )

        window.center()
        window.isReleasedWhenClosed = false
        window.isOpaque = false
        window.backgroundColor = .clear // transparent so SwiftUI bg shows
        window.hasShadow = true
        window.level = .floating // stays above normal windows
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true

        window.contentView = hostingController.view
        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func toggle() {
        guard let window = self.window else { return }
        if window.isVisible {
            window.orderOut(nil)
        } else {
            if let screenFrame = NSScreen.main?.visibleFrame {
                let x = screenFrame.midX - window.frame.width / 2
                let y = screenFrame.midY - window.frame.height / 2
                window.setFrameOrigin(NSPoint(x: x, y: y))
            }
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
