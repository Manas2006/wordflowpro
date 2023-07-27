import SwiftUI

struct DebateChatBotPage: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var userInput = ""
    @State private var chatMessages: [ChatMessage] = []
    @State private var currentMessage: String = ""
    @State private var isChatbotTyping = false
    let apiEndpoint = "https://api.openai.com/v1/chat/completions"
    let apiKey = "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" // Replace this with your actual API key from OpenAI
    
    @AppStorage("customAssistantRole") private var customAssistantRole = ""
    @AppStorage("isDebateAssistantSelected") private var isDebateAssistantSelected = false
    @AppStorage("isHealthAssistantSelected") private var isHealthAssistantSelected = false
    @AppStorage("isHomeworkAssistantSelected") private var isHomeworkAssistantSelected = false

    @AppStorage("isCustomAssistantSelected") private var isCustomAssistantSelected = false
    
    
    @FocusState private var isTextFieldFocused
    
    
    init() {
        let settings = Settings()
        customAssistantRole = settings.getCustom()
        isDebateAssistantSelected = settings.getDebate()
        isHealthAssistantSelected = settings.getHealth()
        isHomeworkAssistantSelected = settings.getHomework()
        isCustomAssistantSelected = settings.getCustomBool()
        isTextFieldFocused = false
        
        print("THIS IS THE CUSTOM ROLE: "+customAssistantRole)
        
        
        }
    
    
    
    
    






    
    
    struct ChatMessage: Identifiable {
        var id = UUID()
        var isUser: Bool
        var message: String
    }
    
    private func addChatMessage(_ message: String, isUser: Bool) {
        chatMessages.append(ChatMessage(isUser: isUser, message: message))
    }
    
    private func sendUserMessage() {
        if !userInput.isEmpty {
            addChatMessage(userInput, isUser: true)
            currentMessage = userInput // Store the user's current message
            getChatbotResponse(userMessage: userInput) // Get the chatbot's response
            userInput = ""
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemTeal).ignoresSafeArea()

            VStack {
                Spacer()

                ScrollViewReader { scrollViewProxy in
                                    ScrollView {
                                        VStack(alignment: .leading, spacing: 8) {
                                            ForEach(chatMessages) { message in
                                                if message.isUser {
                                                    HStack {
                                                        Spacer()
                                                        Text(message.message)
                                                            .foregroundColor(.white)
                                                            .padding(10)
                                                            .background(Color.blue)
                                                            .cornerRadius(12) // Smaller corner radius
                                                            .padding(.horizontal, 10)
                                                        
                                                    }
                                                } else {
                                                    HStack {
                                                        Text(message.message)
                                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                                            .padding(10)
                                                            .background(colorScheme == .dark ? Color(UIColor.systemGray4) : Color(UIColor.systemGray6))
                                                            .cornerRadius(12) // Smaller corner radius
                                                            .padding(.horizontal, 10)
                                                        Spacer()
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                        .padding(.bottom, 8)
                                    }
                                    .onChange(of: chatMessages.count) { _ in
                                        // Automatically scroll to the most recent message
                                        withAnimation {
                                            scrollViewProxy.scrollTo(chatMessages.last?.id, anchor: .bottom)
                                        }
                                    }
                                }
                
                if isChatbotTyping{
                    TypingIndicatorView() // Show the typing indicator on the left side
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .frame(width: 24, height: 8) // Smaller size
                        .padding(.leading, 10) // Adjust padding to align with user messages
                }

                HStack {
                    TextField("Type your message...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        
                    

                    Button(action: sendUserMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 24))
                    }
                    .padding(.horizontal)
                    

//                    Button(action: {
//                        // You can optionally add logic to handle the microphone button
//                    }) {
//                        Image(systemName: "mic.fill")
//                            .foregroundColor(.blue)
//                            .font(.system(size: 24))
//                    }
                    //.padding(.horizontal)
                }
                .padding()
                

                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("AI Assistant")
            .accentColor(colorScheme == .light ? Color(.systemTeal) : Color.white)
            .animation(.easeInOut(duration: 0.3))
        }
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial)))
    }
   
        
   

    private func getChatbotResponse(userMessage: String) {
        
        
        var content: String {
            if isDebateAssistantSelected {
                return "You are the best high school debater in the entire National Speech and Debate Circuit. You are excellent at finding credible sources and evidence to prove any argument. You are also amazing at creating speech ideas for any speech event. You are knowledgeable on every politcal problem in the world and can create arguments to justify any argument with credible evidence from credible sources. All of your evidence  "
            } else if isHealthAssistantSelected {
                return "You are a Health Assistant helping people maintain a healthy lifestyle. You have countless years of experience and have knowledge on every type of treatment from home remedies to proper medicine. You can provide advice on nutrition, exercise, and general wellness to promote a healthy lifestyle."
            } else if isHomeworkAssistantSelected {
                return "You are a Homework Assistant aiding in academic tasks and assignments. Given any problem you will be able to provide the correct answer with simple steps and if it is too difficult you will provide me the links or services that can help me get the right answer. You can assist with various subjects, help with problem-solving, and provide explanations for complex concepts."
            } else if isCustomAssistantSelected && !customAssistantRole.isEmpty {
                return customAssistantRole
            } else {
                return "You are a helpful assistant. You can answer general questions and engage in friendly conversations with users."
            }
        }


        
        print("Sending user message to the chatbot: \(userMessage)")
        
        guard let url = URL(string: apiEndpoint) else {
            print("Invalid URL")
            return
        }
        
        // Set up the API request parameters
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Construct the JSON payload for the messages
        let messageData: [[String: Any]] = [
            [
                "role": "system",
                "content": content
            ],
            [
                "role": "user",
                "content": content + userMessage
            ]
        ]
        
        
        let data: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messageData
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            return
        }
        
        // Make the API request
        print("Making API request to get chatbot response...")
        isChatbotTyping = true
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making API request: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                print("Received API response data: \(String(data: data, encoding: .utf8) ?? "No data")") // Print the response data
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let choices = jsonResponse?["choices"] as? [[String: Any]], let responseText = choices.first?["message"] as? [String: Any], let content = responseText["content"] as? String {
                        print("Received chatbot response: \(content)")
                        // Handle the chatbot's response here
                        DispatchQueue.main.async {
                            //isChatbotTyping = false
                            // Add the chatbot's response to the chatMessages array
                            self.addChatMessage(content, isUser: false) // Use 'self' to access the function correctly
                        }
                        DispatchQueue.main.async {
                            isChatbotTyping = false
                            // Add the chatbot's response to the chatMessages array
                            //self.addChatMessage(content, isUser: false) // Use 'self' to access the function correctly
                        }
                    }
                } catch {
                    print("Error parsing JSON response: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}


struct TypingIndicatorView: View {
    @State private var isAnimating = false // Step 1: Add @State variable for animation

    var body: some View {
        HStack(spacing: 10) { // Increased spacing between circles
            ForEach(0..<3) { index in
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 10, height: 10) // Increased width and height of the circles
                    .opacity(isAnimating ? 0.3 : 1.0) // Step 3: Apply opacity based on animation state
                    .animation(Animation.easeInOut(duration: 0.8).repeatForever().delay(0.2 * Double(index))) // Step 3: Add animation modifier
            }
        }
        .padding(10) // Increased padding
        .background(Color(UIColor.systemGray6)) // Grey background
        .cornerRadius(12) // Increased corner radius
        .onAppear {
            isAnimating = true // Step 2: Start the animation when the view appears
        }
    }
}


extension UIToolbar {
    convenience init(withDoneButtonFor target: Any, action: Selector) {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: action)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        self.init()
        self.items = [flexSpace, doneButton]
        self.sizeToFit()
    }
}
