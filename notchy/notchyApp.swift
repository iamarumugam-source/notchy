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

