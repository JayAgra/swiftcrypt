//
//  EncryptionController.swift
//  Turbid
//
//  Created by Jayen Agrawal on 5/6/24.
//

import Foundation
import CryptoKit
import AppKit

enum OperationType {
    case encrypt, decrypt
}

enum TaskResult {
    case success, failure
}

class EncryptionController: ObservableObject {
    @Published public var state: AppState = .file_input
    @Published public var filePath: URL? = nil
    @Published public var operation: OperationType = .encrypt
    @Published public var password: String = ""
    @Published public var outputPath: URL? = nil
    @Published public var taskStatus: TaskResult? = nil
    
    public func encryptFile() throws {
        // read file
        let fileContent = try Data(contentsOf: filePath!)
        
        // hash password
        let key = SymmetricKey(data: SHA256.hash(data: Data(password.utf8)))
        
        // encrypt file content
        let sealedBox = try AES.GCM.seal(fileContent, using: key)
        
        // get target path
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save Encrypted File"
        savePanel.nameFieldStringValue = filePath!.lastPathComponent + ".turbid"
        savePanel.directoryURL = filePath!.deletingLastPathComponent()
        let response = savePanel.runModal()
        
        // write
        outputPath = response == .OK ? savePanel.url : URL(fileURLWithPath: filePath!.relativePath + ".turbid")
        try sealedBox.combined?.write(to: outputPath!)
    }
    
    public func decryptFile() throws {
        // read encrypted file
        let encryptedFileContent = try Data(contentsOf: filePath!)
        
        // hash password
        let key = SymmetricKey(data: SHA256.hash(data: Data(password.utf8)))
        
        // decrypt
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedFileContent)
        let decryptedFileData = try AES.GCM.open(sealedBox, using: key)
        
        // get target path
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save Decrypted File"
        let fileName = filePath?.lastPathComponent ?? "file.turbid"
        savePanel.nameFieldStringValue = fileName.contains(".turbid") ? String(fileName[..<fileName.index(fileName.endIndex, offsetBy: -7)]) : fileName
        let response = savePanel.runModal()
        
        // write
        outputPath = response == .OK ? savePanel.url : URL(fileURLWithPath: (filePath!.deletingLastPathComponent().relativeString + (fileName.contains(".turbid") ? String(fileName[..<fileName.index(fileName.endIndex, offsetBy: -7)]) : fileName)))
        try decryptedFileData.write(to: outputPath!)
    }
    
}
