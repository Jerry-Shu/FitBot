import SwiftUI
import UIKit
import AVKit

struct UploadVideoView: View {
    @State private var selectedVideoURL: URL?
    @State private var showImagePicker = false
    @State private var videoData: Data?
    
    var body: some View {
        VStack {
            // Top Section
            HStack {
                Image(systemName: "return")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                Spacer()
                Text("FitBot")
                    .font(.title)
                    .bold()
                    .padding(.trailing,40)
                Spacer()
            }
            .padding(.vertical, 0) // Reduce vertical padding to make the bar thinner
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
                    // Implement video recording functionality here
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
                    showImagePicker = true
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
                .sheet(isPresented: $showImagePicker) {
                    VideoPicker(videoURL: $selectedVideoURL, videoData: $videoData)
                }
                
                Button(action: {
                    if let videoData = videoData {
                        uploadVideo(videoData: videoData)
                    }
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
    
    func uploadVideo(videoData: Data) {
        let url = URL(string: "YOUR_BACKEND_URL_HERE")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("video/mp4", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: videoData) { data, response, error in
            if let error = error {
                print("Upload error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("Upload successful")
            } else {
                print("Upload failed")
            }
        }
        
        task.resume()
    }
}

struct VideoPicker: UIViewControllerRepresentable {
    @Binding var videoURL: URL?
    @Binding var videoData: Data?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: VideoPicker
        
        init(parent: VideoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[.mediaURL] as? URL {
                parent.videoURL = url
                do {
                    parent.videoData = try Data(contentsOf: url)
                } catch {
                    print("Error loading video data: \(error)")
                }
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.movie"]
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UploadVideoView()
    }
}
