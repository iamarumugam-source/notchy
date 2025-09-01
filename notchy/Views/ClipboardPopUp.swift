//
//  ClipboardPopUp.swift
//  notchy
//
//  Created by Arjun on 31/08/25.
//

import SwiftUI
import AppKit
import DynamicNotchKit

// Call this whenever a new clipboard item is detected
func showClipboardInfo(_ text: String) {
    Task { @MainActor in
        
        let firstLine = text.components(separatedBy: .newlines).first ?? ""
        let truncatedLine = firstLine.count > 60 ? String(firstLine.prefix(57)) + "…" : firstLine
        
        let info = DynamicNotchInfo(
            icon: .init(systemName: "doc.on.clipboard", color: .blue),
            title: "Copied to Clipboard",
            description: "\(truncatedLine)",
            compactLeading: .init(systemName: "wave.3.left", color: .blue),
            compactTrailing: .init(systemName: "wave.3.right", color: .blue),
            hoverBehavior: .keepVisible
        )
        
        await info.expand()
        try await Task.sleep(for: .seconds(5))
        await info.hide()
    }
}


