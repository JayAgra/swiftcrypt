//
//  TaskConfigure.swift
//  encrypt
//
//  Created by Jayen Agrawal on 5/6/24.
//

import SwiftUI
import CryptoKit

struct TaskConfigure: View {
    @EnvironmentObject var controller: EncryptionController
    @State private var showPasswordBox: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(controller.filePath?.lastPathComponent ?? "No file selected")
                    .truncationMode(.middle)
                    .lineLimit(1)
                Spacer()
                Picker("", selection: $controller.operation) {
                    Text("Encrypt")
                        .tag(OperationType.encrypt)
                    Text("Decrypt")
                        .tag(OperationType.decrypt)
                }
                .pickerStyle(RadioGroupPickerStyle())
                .horizontalRadioGroupLayout()
                HStack {
                    if showPasswordBox {
                        TextField("password", text: $controller.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled(true)
                            .border(controller.taskStatus == .failure ? Color.red : Color.clear)
                    } else {
                        SecureField("password", text: $controller.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled(true)
                            .background(controller.taskStatus == .failure && controller.operation == .decrypt ? Color.red : Color.clear)
                    }
                    Spacer()
                    Button(action: {
                        showPasswordBox.toggle()
                    }, label: {
                        if showPasswordBox {
                            Label("", systemImage: "eye.slash")
                                .labelStyle(.iconOnly)
                                .foregroundColor(Color.accentColor)
                        } else {
                            Label("", systemImage: "eye")
                                .labelStyle(.iconOnly)
                                .foregroundColor(Color.accentColor)
                        }
                    })
                    .buttonStyle(.borderless)
                }
                .padding()
                Spacer()
                HStack {
                    Button(action: {
                        controller.filePath = nil
                        controller.state = .file_input
                    }, label: {
                        Label("Back", systemImage: "arrowshape.backward.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(Color.primary)
                    })
                    .buttonStyle(.borderless)
                    Spacer()
                    Button(action: {
                        if controller.operation == .encrypt {
                            do {
                                try controller.encryptFile()
                                controller.taskStatus = .success
                                controller.state = .task_end
                            } catch {
                                print(error)
                                controller.taskStatus = .failure
                                controller.state = .task_end
                            }
                        } else {
                            do {
                                try controller.decryptFile()
                                controller.taskStatus = .success
                                controller.state = .task_end
                            } catch {
                                print(error)
                                controller.taskStatus = .failure
                            }
                        }
                    }, label: {
                        Label(controller.operation == .encrypt ? "Encrypt" : "Decrypt", systemImage: "arrowshape.forward.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(controller.password.isEmpty ? Color.gray.opacity(0.4) : Color.primary)
                    })
                    .buttonStyle(.borderless)
                    .disabled(controller.password.isEmpty)
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
    TaskConfigure()
}
