import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let message: String
    let isUser: Bool
}

struct ChatbotView: View {
    @State private var messages: [ChatMessage] = [
        ChatMessage(message: "Hello! How can I help you today?", isUser: false)
    ]
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isUser {
                                Spacer()
                                Text(message.message)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(15)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                            } else {
                                Text(message.message)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 10)
                                Spacer()
                            }
                        }
                    }
                }
            }
            
            HStack {
                TextField("Type a message...", text: $inputText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .padding(.horizontal)
                
                Button(action: sendMessage) {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding(.trailing)
                }
            }
            .padding(.bottom)
        }
    }
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        messages.append(ChatMessage(message: inputText, isUser: true))
        inputText = ""
        
        // Simulate a chatbot response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            messages.append(ChatMessage(message: "This is a response from the chatbot.", isUser: false))
        }
    }
}

struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView()
    }
}
