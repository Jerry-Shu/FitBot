import SwiftUI

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToCreateAccount = false
    @State private var login = false
    var body: some View {
        
        
            
            VStack {
                Spacer()
                
                // Logo and title
                HStack{
                    Image("icon dumbbell") // Use the name of your image file without the extension
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(.bottom, 100)
                    
                    
                    Text("FitBot")
                        .font(.largeTitle)
                        .fontWeight(.bold).padding(.bottom, 100)
                }
                // Login and Signup Buttons
                
                
                // Email and Password Fields
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 0).padding(.horizontal,50)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 150).padding(.horizontal,50)
                
                // Login Button
                Button(action: {
                    
                    self.login = true
                    // Perform action when the button is pressed
                    print("Button was pressed")
                }) {
                    Image(systemName: "arrow.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(30) // Increase padding for even larger button size
                }
                .buttonStyle(CircularButtonStyle(fillColor: .black, size: 80)) // Significantly increased size
                Spacer()
                
                Button(action: {
                    self.navigateToCreateAccount = true
                    // Perform action for creating a new account
                    print("Create new account")
                }) {
                    Text("No account? Create new account")
                        .underline()
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                if navigateToCreateAccount {
                    
                    NavigationLink(value: navigateToCreateAccount) {
                        createNewAccount()
                    }
                    .fullScreenCover(isPresented: $navigateToCreateAccount) {
                        createNewAccount()
                    }
                }
                else if login {
                    NavigationLink(value: login) {
                    
                        UploadVideoView()
                        
                    }
                    
                    .fullScreenCover(isPresented: $login) {
                    
                        UploadVideoView()
                        
                    }
                }
                
            }
        }
    
    
}


// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct CircularButtonStyle: ButtonStyle {
    var fillColor: Color
    var size: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .background(fillColor)
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(radius: configuration.isPressed ? 5 : 100) // Adjusted shadow for larger button
            .scaleEffect(configuration.isPressed ? 0.95 : 1.1)
            .animation(.spring(), value: configuration.isPressed)
            
    }
}



// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
