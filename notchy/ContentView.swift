//
//  ContentView.swift
//  notchy
//
//  Created by Arjun on 30/08/25.
//

import SwiftUI

struct ContentView: View {
    
    init() {
            print("🔍 ContentView initialized") // Debug log in console
        }
    var body: some View {
        VStack {
            Text("✅ Debug Window Visible")
                            .padding()
                            .border(Color.blue, width: 3)
                    
        }
    }
}

#Preview {
    ContentView()
}
