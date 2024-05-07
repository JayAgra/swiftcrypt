//
//  ContentView.swift
//  Turbid
//
//  Created by Jayen Agrawal on 5/6/24.
//

import SwiftUI

struct FileInput: View {
    @State private var dragOver = false
    @EnvironmentObject var controller: EncryptionController
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(systemName: "tray.and.arrow.down.fill")
                    .font(.system(size: 42.0))
                    .foregroundColor(dragOver ? Color.accentColor : Color.primary)
                Spacer()
                Text("Drop a file")
                    .font(.title)
                    .foregroundColor(dragOver ? Color.accentColor : Color.primary)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .onDrop(of: ["public.file-url"], isTargeted: $dragOver) { providers -> Bool in
            providers.first?.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { (data, error) in
                if let data = data, let path = NSString(data: data, encoding: 4), let url = URL(string: path as String) {
                    controller.filePath = url
                    controller.state = .task_configure
                }
            })
            return true
        }
        .frame(width: 325, height: 300)
    }
}

#Preview {
    FileInput()
}
