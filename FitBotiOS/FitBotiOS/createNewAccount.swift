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
                        createAccount()
                    }
                    .disabled(!isFormValid)
                }
            }
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

