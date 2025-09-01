//
//  NotchPopup.swift
//  notchy
//
//  Created by Arjun on 30/08/25.
//

import SwiftUI


struct NotchPopup: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer() // pushes title+icon to center
                
                HStack(spacing: 6) {
                    Image(systemName: "apple.terminal").imageScale(.large)
                        .foregroundStyle(.orange)
                    Text("Notchy")
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                }
                
                Spacer() // balances the left and right .font(.system(size: 11, weight: .medium, design: .monospaced))
                
            }.padding(.top)

            Divider()

            VStack(alignment: .leading, spacing: 8) {
//                HStack {
//                    Image(systemName: "network").foregroundStyle(.blue)
//                    Text("Network Status")
//                    Spacer()
//                    NetworkStatusView()
//                }
                
                HStack {
                    Image(systemName: "list.clipboard").foregroundStyle(.orange).imageScale(.medium)
                        .padding(.leading)
                    Text("Clipboard").font(.system(size: 10, weight: .regular, design: .monospaced))
                    Spacer()
                    NotchClipboardSummaryView().padding(.trailing)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()
            
            VStack {
                
                Text("SYSTEM STATUS").font(.system(size: 10, weight: .bold, design: .monospaced))
                
                Divider()
                
                HStack {
                    SystemStatsStatusView()
                }.padding(.top,5)
                HStack{
                    NetworkStatusView()
                }
                
            }
            
           
            
            
            
//            HStack {
//                Button(action: {
//                    ClipboardWindowController.shared.toggle()
//                }) {
//                    Text("Open Dashboard")
//                        .padding()
//                        .background(Color.accentColor)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }.buttonStyle(PlainButtonStyle())
//                
//                Button(action: {
//                    NSApp.terminate(nil)
//                }) {
//                    Text("Close Notchy")
//                        .padding()
//                        .background(Color.secondary)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }.buttonStyle(PlainButtonStyle())
//            }

            
        }
//        .padding()// expanded content
        .background(Color.black.opacity(0.95))
        .shadow(radius: 6)
        .frame(minWidth: 340)
    }
}

#Preview {
    NotchPopup()
}
