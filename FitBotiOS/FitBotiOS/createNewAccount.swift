//
//  createNewAccount.swift
//  FitBotiOS
//
//  Created by yu bai on 6/22/24.
//


import SwiftUI


struct createNewAccount: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isFormValid = false
    @State private var accountCreated = false
    @State private var returned = false
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("User Info")) {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    
                    SecureField("Password", text: $password)
                }

                Section {
                    Button("Create Account") {
                        // Here you can add the action to create the account
                        accountCreated = false
                        createAccount()
                    }
                    .disabled(!isFormValid)
                    
                }
                
            }
            Button(action: {
                
                self.returned = true
                // Perform action when the button is pressed
                print("Button was pressed")
            }) {
                Image(systemName: "arrow.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(30) // Increase padding for even larger button size
            }
            .frame(width: 0.0)
            .buttonStyle(CircularButtonStyle(fillColor: .black, size: 80)).padding(100)
            
            
            .navigationTitle("Create Account")
            .onChange(of: username) { newUsername, oldUsername in
                            validateForm()
                        }
            .onChange(of: email) { newEmail, oldEmail in
                            validateForm()
                        }
            .onChange(of: password) { newPassword, oldPassword in
                            validateForm()
                        }
            
            
            
        }
        if accountCreated {
            
            
            NavigationLink(value:accountCreated ) {
            
                UploadVideoView()
                
            }
            
            .fullScreenCover(isPresented: $accountCreated) {
            
                UploadVideoView()
                
            }
        }
        else if returned {
            NavigationLink(value:returned ) {
            
                ContentView()
                
            }
            
            .fullScreenCover(isPresented: $returned) {
            
                ContentView()
                
            }
        }
        
        
        
    }

    private func validateForm() {
        isFormValid = !(username.isEmpty || email.isEmpty || password.isEmpty)
    }

    private func createAccount() {
        print("Creating account for \(username) with email \(email)")
        // Add your account creation logic here
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        createNewAccount()
    }
}

