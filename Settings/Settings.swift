import SwiftUI

struct Settings: View {
    @AppStorage("vibrateOnCustomReminder") private var vibrate = false
    @AppStorage("soundOnCustomReminder") private var sound = false
    @AppStorage("customAssistantRole") private var customAssistantRole = "" // Define the key here
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("isCustomAssistantSelected") private var isCustomAssistantSelected = false
    @AppStorage("isDebateAssistantSelected") private var isDebateAssistantSelected = false
    @AppStorage("isHealthAssistantSelected") private var isHealthAssistantSelected = false
    @AppStorage("isHomeworkAssistantSelected") private var isHomeworkAssistantSelected = false
    
    
    
    
    var body: some View {
        
        ZStack {
            Color(.systemTeal).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "bell")
                            .font(.title)
                            .foregroundColor(.yellow) // Icon color set to yellow
                        Text("Custom Reminder Settings")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(textColor) // Text color based on user appearance mode
                    }
                    .padding(.top, 20)
                    
                    Toggle("Vibrate on Custom Reminder", isOn: $vibrate)
                        .foregroundColor(textColor)
                        .toggleStyle(SwitchToggleStyle(tint: .green)) // Set toggle tint color to white
                        .padding(.horizontal)
                    
                    Toggle("Sound on Custom Reminder", isOn: $sound)
                        .foregroundColor(textColor)
                        .toggleStyle(SwitchToggleStyle(tint: .green)) // Set toggle tint color to white
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Image(systemName: "gearshape.2")
                                .font(.title)
                                .foregroundColor(.green) // Icon color set to green
                            Text("Custom Assistants")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(textColor) // Set the title text color
                                .padding(.leading) // Add left padding to match the format of "Custom Reminders"
                        }
                        .padding(.top, 20)
                        
                        
                        Toggle("Debate Assistant", isOn: $isDebateAssistantSelected)
                            .disabled(isCustomAssistantSelected)
                            .disabled(isHealthAssistantSelected)
                            .disabled(isHomeworkAssistantSelected)
                            .foregroundColor(textColor) // Text color based on user appearance mode
                            .toggleStyle(SwitchToggleStyle(tint: .green)) // Set toggle tint color to green
                            .padding(.horizontal)
                        Toggle("Health Assistant", isOn: $isHealthAssistantSelected)
                            .disabled(isDebateAssistantSelected)
                            .disabled(isHomeworkAssistantSelected)
                            .disabled(isCustomAssistantSelected)
                            .foregroundColor(textColor) // Text color based on user appearance mode
                            .toggleStyle(SwitchToggleStyle(tint: .green)) // Set toggle tint color to green
                            .padding(.horizontal)
                        Toggle("Homework Assistant", isOn: $isHomeworkAssistantSelected)
                            .disabled(isDebateAssistantSelected)
                            .disabled(isHealthAssistantSelected)
                            .disabled(isCustomAssistantSelected)
                            .foregroundColor(textColor) // Text color based on user appearance mode
                            .toggleStyle(SwitchToggleStyle(tint: .green)) // Set toggle tint color to green
                            .padding(.horizontal)
                        Toggle("Custom Assistant", isOn: $isCustomAssistantSelected)
                            .disabled(isDebateAssistantSelected)
                            .disabled(isHealthAssistantSelected)
                            .disabled(isHomeworkAssistantSelected)
                            .foregroundColor(textColor) // Text color based on user appearance mode
                            .toggleStyle(SwitchToggleStyle(tint: .green)) // Set toggle tint color to green
                            .padding(.horizontal)
                        
                        if isCustomAssistantSelected {
                            VStack {
                                    TextEditor(text: $customAssistantRole)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.horizontal)
                                        .frame(minHeight: 37) // Set the minimum height
                                    
                                    // Other views in your VStack
                                }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Examples:")
                                    .foregroundColor(textColor) // Text color based on user appearance mode
                                    .fontWeight(.bold)
                                
                                Text("1. Act as a QA (Quality Assurance) Assistant in a software development team. Your role involves testing software applications, identifying and reporting bugs, and ensuring the quality and functionality of the products. You must remain thorough, detail-oriented, and have strong problem-solving skills.")
                                    .foregroundColor(textColor) // Text color based on user appearance mode
                                Text("2. As a Design Consultant, you are responsible for providing expert advice and creative solutions to clients' design challenges. Whether it's interior design, graphic design, or web design, you will offer valuable insights and guide clients towards making aesthetically pleasing and functional decisions.")
                                    .foregroundColor(textColor) // Text color based on user appearance mode
                                Text("3. As a Language Translator, you play a crucial role in bridging communication gaps between individuals or businesses that speak different languages. You must accurately and fluently translate written or spoken content while preserving its intended meaning and cultural nuances.")
                                    .foregroundColor(textColor) // Text color based on user appearance mode
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding()
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Settings")
            
            
        }
        
    }

    var textColor: Color {
        if colorScheme == .dark{
            
            return Color.black
            
        }else{return Color.white}
    
    }



    func getVibrateSetting() -> Bool {
        return vibrate
    }

    func getSoundSetting() -> Bool {
        return sound
    }
    func getDebate() -> Bool {
        return isDebateAssistantSelected
    }

    func getHealth() -> Bool {
        return isHealthAssistantSelected
    }
    func getHomework() -> Bool {
        return isHomeworkAssistantSelected
    }

    func getCustom() -> String {
        return customAssistantRole
    }
    func getCustomBool() -> Bool {
        return isCustomAssistantSelected
    }
}
