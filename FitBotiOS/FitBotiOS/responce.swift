import SwiftUI

struct responce: View {
    @State private var selectedTab = 0
    @State private var message = ""
    
    @State private var returned = false
    var body: some View {
        VStack {
            // Top Section
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding()
                Spacer()
                Text("FitBot")
                    .font(.title)
                    .bold()
                Spacer()
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding()
            }
            .padding(.vertical, -10) // Reduce vertical padding to make the bar thinner
            .padding(.horizontal, 10) // Adjust the horizontal padding as needed
            .background(Color.black)
            .foregroundColor(.white)
            
            // Content Section
            VStack {
                Text("Suggestions")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                
                Text("Record a new video or select an existing one from your device. Your video will be analyzed to provide motion improvement suggestions.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
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
                
                
                
            }
            
            Spacer()
            
            // Bottom Navigation Bar
            
            // Buttons
            if returned{
                
                
                NavigationLink(value:returned ) {
                
                    UploadVideoView()
                    
                }
                
                .fullScreenCover(isPresented: $returned) {
                
                    UploadVideoView()
                    
                }
            }
            
        }
    }
    
}

struct Previews: PreviewProvider {
    static var previews: some View {
        responce()
    }
}
