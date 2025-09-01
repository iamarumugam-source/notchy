//
//  NotchClipboardSummaryView.swift
//  notchy
//
//  Created by Arjun on 31/08/25.
//


import SwiftUI

struct NotchClipboardSummaryView: View {
    @StateObject private var manager = ClipboardManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let first = manager.history.first {
                Text(first.components(separatedBy: .newlines).first ?? first)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
            } else {
                Text("Clipboard is empty")
                    .foregroundColor(.secondary)
            }
            
            Button(action: {
                ClipboardWindowController.shared.toggle()
            }) {
                Text("\(manager.history.count) clip(s) =>")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)
            }.buttonStyle(BorderlessButtonStyle())
        }.frame(maxWidth: 100)
    }
}
