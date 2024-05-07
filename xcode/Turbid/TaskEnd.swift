//
//  TaskEnd.swift
//  Turbid
//
//  Created by Jayen Agrawal on 5/6/24.
//

import SwiftUI

struct TaskEnd: View {
    @EnvironmentObject var controller: EncryptionController
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(systemName: controller.taskStatus == .success ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .font(.system(size: 42.0))
                    .foregroundColor(controller.taskStatus == .success ? Color.green : Color.pink)
                Spacer()
                Text(controller.taskStatus == .success ? "Success" : "An error occurred.\nYour file is unharmed.")
                    .font(.title)
                Spacer()
                Spacer()
                HStack {
                    Button(action: {
                        controller.state = .task_configure
                        controller.taskStatus = nil
                    }, label: {
                        Label("Back", systemImage: "arrowshape.backward.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(Color.primary)
                    })
                    .buttonStyle(.borderless)
                    Spacer()
                    Button(action: {
                        controller.filePath = nil
                        controller.taskStatus = nil
                        controller.state = .file_input
                    }, label: {
                        Label("Restart", systemImage: "arrow.counterclockwise")
                            .imageScale(.large)
                            .foregroundColor(Color.primary)
                    })
                    .buttonStyle(.borderless)
                }
                .padding()
            }
            Spacer()
        }
        .padding()
        .frame(width: 325, height: 300)
    }
}

#Preview {
    TaskEnd()
}
