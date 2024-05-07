//
//  encryptApp.swift
//  encrypt
//
//  Created by Jayen Agrawal on 5/6/24.
//

import SwiftUI

enum AppState {
    case file_input, task_configure, task_end
}

@main
struct encryptApp: App {
    @StateObject public var controller: EncryptionController = EncryptionController()
    
    var body: some Scene {
        WindowGroup {
            switch controller.state {
            case .file_input:
                FileInput()
                    .frame(width: 325, height: 300)
                    .environmentObject(controller)
            case .task_configure:
                TaskConfigure()
                    .frame(width: 325, height: 300)
                    .environmentObject(controller)
            case .task_end:
                TaskEnd()
                    .frame(width: 325, height: 300)
                    .environmentObject(controller)
            }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowResizabilityContentSize()
    }
}

extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}
