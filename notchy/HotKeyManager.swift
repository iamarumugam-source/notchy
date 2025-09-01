//
//  HotKeyManager.swift
//  notchy
//
//  Created by Arjun on 01/09/25.
//


import HotKey

@MainActor
final class HotKeyManager {
    private var toggleNotchHotKey: HotKey?
    private var clipboardHotKey: HotKey?
    private unowned let notchController: NotchController

    init(notchController: NotchController) {
        self.notchController = notchController
        setupHotkeys()
    }

    private func setupHotkeys() {
        toggleNotchHotKey = HotKey(key: .a, modifiers: [.command, .control])
        toggleNotchHotKey?.keyDownHandler = { [weak self] in
            guard let self else { return }
            if self.notchController.isExpanded {
                self.notchController.hide()
            } else {
                self.notchController.expand()
            }
        }
        
        clipboardHotKey = HotKey(key: .c, modifiers: [.command, .control])
        clipboardHotKey?.keyDownHandler = {
            ClipboardWindowController.shared.toggle()
        }
    }
}
