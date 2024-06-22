import SwiftUI

struct UploadVideoView: View {
    @State private var selectedTab = 0

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
                Text("Send Video for Analysis")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                
                Text("Record a new video or select an existing one from your device. Your video will be analyzed to provide motion improvement suggestions.")
                    .multilineTextAlignment(.center)
                    .padding()
                Image("training")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 20)
                Spacer()
                
                Button(action: {
                    // Action for recording new video
                }) {
                    Text("Record New Video")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
                
                Button(action: {
                    // Action for selecting existing video
                }) {
                    Text("Select Existing Video")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
                
                Button(action: {
                    // Action for submitting video
                }) {
                    Text("Submit Video")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                }
            }
            
            Spacer()
            
            // Bottom Navigation Bar
            
            // Buttons
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UploadVideoView()
    }
}
