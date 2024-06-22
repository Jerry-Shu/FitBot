//
//  LoginView.swift
//  FitBotiOS
//
//  Created by Jiarui Shu on 6/22/24.
//

import SwiftUI

struct LoginPage: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "figure.walk")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("FitBot")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            HStack {
                Button(action: {
                    // Action for login button
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: {
                    // Action for signup button
                }) {
                    Text("Signup")
                        .foregroundColor(.blue)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            Button(action: {
                // Action for login button
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
