//
//  ClipboardHistoryView.swift
//  notchy
//
//  Created by Arjun on 31/08/25.
//

import SwiftUI
import AppKit

// MARK: - Clipboard Manager with Persistence

class ClipboardManager: ObservableObject {
    static let shared = ClipboardManager()
    
    @Published var history: [String] = []
    
    private let storageKey = "clipboardHistory_v1"
    private var changeCount = NSPasteboard.general.changeCount
    private var timer: Timer?
    
    private init() {
        loadHistory()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.checkClipboard()
        }
    }
    
    private func checkClipboard() {
        let pasteboard = NSPasteboard.general
        guard pasteboard.changeCount != changeCount else { return }
        changeCount = pasteboard.changeCount
        
        if let str = pasteboard.string(forType: .string), !str.isEmpty {
            DispatchQueue.main.async {
                if self.history.first != str {
                    self.history.insert(str, at: 0)
                    self.saveHistory()
                    
                    // Show transient info
                    showClipboardInfo(str)
                }
            }
        }
    }
    
    // MARK: - Persistence
    
    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        if let saved = try? JSONDecoder().decode([String].self, from: data) {
            self.history = saved
        }
    }
    
    private func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    func clearHistory() {
        history.removeAll()
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}


// MARK: - Minimal Maccy-style Clipboard View

struct ClipboardHistoryView: View {
    @StateObject private var manager = ClipboardManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            HStack {
                Text("📋 Clipboard")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Button(action: { manager.clearHistory() }) {
                    Image(systemName: "trash")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            
            Divider()
            
            // History List
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    if manager.history.isEmpty {
                        Text("No clipboard history yet.")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 40)
                    } else {
//                        ForEach(manager.history, id: \.self) { item in
//                            ClipboardItemRowMinimal(text: item)
//                        }
                        ForEach(Array(manager.history.enumerated()), id: \.offset) { index, item in
                            ClipboardItemRowMinimal(id: index, text: item)
                        }
                    }
                }
                .padding(8)
            }
        }
        .frame(width: 320, height: 400)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.windowBackgroundColor))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        )
    }
}

// MARK: - Minimal Row for each clipboard item

struct ClipboardItemRowMinimal: View {
    let id: Int
    let text: String
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            // Copy to clipboard on click
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(text, forType: .string)
        }) {
            HStack {
                Text(text)
                    .font(.system(size: 13))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isHovered ? Color.accentColor.opacity(0.15) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.1)) {
                isHovered = hovering
            }
        }
    }
}
