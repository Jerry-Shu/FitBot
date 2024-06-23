import SwiftUI

struct ResponseView: View {
    var response: String

    var body: some View {
        VStack {
            // Top Section
            HStack {
                Image(systemName: "return")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .foregroundColor(.black)
                Spacer()
                Text("FitBot")
                    .font(.title)
                    .bold()
                    .padding(.trailing, 40)
                Spacer()
            }
            .padding(.vertical, 0) // Reduce vertical padding to make the bar thinner
            .padding(.horizontal, 10) // Adjust the horizontal padding as needed
            .background(Color.black)
            .foregroundColor(.white)
            
            // Content Section
            VStack {
                Text("Response")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                
                Text(response)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                //                Button(action: {
                //                    // Perform action when the button is pressed
                //                    print("Button was pressed")
                //                }) {
                //                    Image(systemName: "arrow.left")
                //                        .resizable()
                //                        .aspectRatio(contentMode: .fit)
                //                        .padding(30) // Increase padding for even larger button size
                //                        .frame(width: 120, height: 150)
                //                }
                //                .padding(100)
                //                .position(x:190, y:470)
                //            }
                //
                //            Spacer()
            }
            // Bottom Navigation Bar
            
            // Buttons
        }
    }
}

struct ResponseView_Previews: PreviewProvider {
    static var previews: some View {
        ResponseView(response: "Hello World")
    }
}


