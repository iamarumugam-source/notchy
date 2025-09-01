//
//  HoverHotspotDelegate.swift
//  notchy
//
//  Created by Arjun on 01/09/25.
//


import AppKit

protocol HoverHotspotDelegate: AnyObject {
    func hoverEntered()
    func hoverExited()
}

final class HoverHotspotWindow {
    private var window: NSWindow!
    private var globalMonitor: Any?
    weak var delegate: HoverHotspotDelegate?

    init(delegate: HoverHotspotDelegate) {
        self.delegate = delegate
        createWindow()
        setupGlobalMonitor()
    }
    
    private func createWindow() {
        guard let screen = NSScreen.main else { return }
        
        let width: CGFloat = 220
        let height: CGFloat = 36
        let x = (screen.frame.width - width) / 2.0
        let y = screen.frame.height - height - 8.0
        let rect = NSRect(x: x, y: y, width: width, height: height)

        window = NSWindow(contentRect: rect,
                          styleMask: .borderless,
                          backing: .buffered,
                          defer: false)
        window.level = .statusBar
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.ignoresMouseEvents = false
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]

        let view = HoverTrackingView(frame: rect)
        view.delegate = delegate
        window.contentView = view
        window.makeKeyAndOrderFront(nil)
    }
    
    private func setupGlobalMonitor() {
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { [weak self] _ in
            guard let self, let window = self.window else { return }
            let location = NSEvent.mouseLocation
            if !window.frame.contains(location) {
                self.delegate?.hoverExited()
            }
        }
    }

    func cleanup() {
        if let gm = globalMonitor {
            NSEvent.removeMonitor(gm)
        }
    }
}

final class HoverTrackingView: NSView {
    weak var delegate: HoverHotspotDelegate?

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach(removeTrackingArea)
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways, .inVisibleRect]
        let area = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        addTrackingArea(area)
    }

    override func mouseEntered(with event: NSEvent) {
        delegate?.hoverEntered()
    }
}
