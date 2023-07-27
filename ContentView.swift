import SwiftUI

struct HomeView: View {
    
    
    
    @Environment(\.colorScheme) var colorSchemess
    var textColor: Color {
        return Color.white
        
    }
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemTeal)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer() // Moved spacer to the top
                    
                    Text("WordFlowPro")
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .foregroundColor(textColor)
                        .padding(.top, 50) // Adjusted top padding
                    
                    Spacer()
                    
                    VStack(spacing: 70) {
                        Button(action: {
                           
                        }) {
                            NavigationLink(destination: DebateChatBotPage()) {
                                Text("AI Assistant")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(textColor)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        
                        Button(action: {
                            // Action for Debate Timers button (optional, you can leave it empty if you don't need an action here)
                        }) {
                            NavigationLink(destination: DebateTimersPage()) {
                                Text("Custom Timers")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(textColor)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }

                        
                        Button(action: {
                            // Action for Contact Support button
                        }) {
                            NavigationLink(destination: Settings()) { // Step 3: Use NavigationLink to link to the Settings view
                                Text("Settings")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(textColor)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            
                        }
                    }
                    .padding()
                    
                    Spacer() // Moved spacer to the bottom
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
