import SwiftUI
import UIKit
import AVKit

struct UploadVideoView: View {
    @State private var selectedVideoURL: URL?
    @State private var showImagePicker = false
    @State private var videoData: Data?
    @State private var filePath: String?
    @State private var backendResponse: [String: Any]?
    @State private var navigateToResponse = false

    var body: some View {
        NavigationView {
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
                        .padding(.trailing, 40)
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
                    
                    NavigationLink(destination: ResponseView(backendResponse: backendResponse ?? [:]), isActive: $navigateToResponse) {
                        EmptyView()
                    }
                    
                    if let filePath = filePath {
                        Text("Uploaded file path: \(filePath)")
                            .padding(.top, 20)
                    }
                    
                    if backendResponse != nil {
                        Text("Backend response received.")
                            .padding(.top, 20)
                    }
                }
                
                Spacer()
                
                // Bottom Navigation Bar
                
                // Buttons
                
            }
        }
    }
    
    func uploadVideo(videoData: Data) {
        let url = URL(string: "http://10.56.64.33:5656/api/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let fullData = createBody(boundary: boundary, data: videoData, mimeType: "video/mp4", filename: "video.mp4")

        let task = URLSession.shared.uploadTask(with: request, from: fullData) { data, response, error in
            if let error = error {
                print("Upload error: \(error)")
                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("Upload successful")
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let dataDict = jsonResponse["data"] as? [String: Any],
                           let filePath = dataDict["file_path"] as? String {
                            DispatchQueue.main.async {
                                self.filePath = filePath
                                print("File path: \(filePath)")
                                // Send file path to the backend
                                self.sendFilePath(filePath: filePath)
                            }
                        }
                    } catch {
                        print("Error parsing JSON response: \(error)")
                    }
                }
            } else {
                print("Upload failed")
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("Response data: \(jsonResponse)")
                        }
                    } catch {
                        print("Error parsing JSON response: \(error)")
                    }
                }
            }
        }

        task.resume()
    }

    func sendFilePath(filePath: String) {
        let url = URL(string: "http://10.56.64.33:5656/api/evaluate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: Any] = ["url": filePath]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("Request successful")
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            DispatchQueue.main.async {
                                self.backendResponse = jsonResponse
                                print("Backend response: \(jsonResponse)")
                                // Navigate to response view on successful upload and evaluation
                                self.navigateToResponse = true
                            }
                        }
                    } catch {
                        print("Error parsing JSON response: \(error)")
                    }
                }
            } else {
                print("Request failed")
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            DispatchQueue.main.async {
                                self.backendResponse = jsonResponse
                                print("Response data: \(jsonResponse)")
                            }
                        }
                    } catch {
                        print("Error parsing JSON response: \(error)")
                    }
                }
            }
        }

        task.resume()
    }

    func createBody(boundary: String, data: Data, mimeType: String, filename: String) -> Data {
        var body = Data()

        let boundaryPrefix = "--\(boundary)\r\n"

        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
        body.append(data)
        body.append(Data("\r\n".utf8))
        body.append(Data("--\(boundary)--\r\n".utf8))

        return body
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
