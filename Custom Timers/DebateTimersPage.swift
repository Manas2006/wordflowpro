import SwiftUI

struct DebateTimersPage: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("hours") private var hours = 0
    @AppStorage("minutes") private var minutes = 1
    @AppStorage("seconds") private var seconds = 0
    @State private var customReminders: [Int] = [] {
            didSet {
                saveCustomReminders()
                timerManager.setCustomReminders(customReminders)
            }
        }
    
    
    init() {
           loadCustomReminders()
       }
    
    //@State private var isCustomReminderTriggered = false

    @State private var timerStarted = false;
    @State private var showHourPicker = false
    @State private var showMinutePicker = false
    @State private var showSecondPicker = false
    @State private var customReminderBindings: [[ReminderComponent: Binding<Int>]] = []
    @State private var customReminderEditing: [[ReminderComponent: Bool]] = []

    @State private var buttonState: ButtonState = .start
    
    
    
    @StateObject private var timerManager = TimerManager()
        
       
    private func saveCustomReminders() {
            UserDefaults.standard.set(customReminders, forKey: "customReminders")
        }
    
    private func customRemindersDidChange() {
            saveCustomReminders()
            timerManager.setCustomReminders(customReminders)
        }
    

        private func loadCustomReminders() {
            if let savedCustomReminders = UserDefaults.standard.array(forKey: "customReminders") as? [Int] {
                customReminders = savedCustomReminders
            }
        }


    
    private var formattedHours: String {
           String(format: "%02d", hours)
       }
       
    private var formattedMinutes: String {
           String(format: "%02d", minutes)
       }
       
    private var formattedSeconds: String {
           String(format: "%02d", seconds)
       }

    enum ButtonState {
        case start, pause, resume, timerComplete
    }
    
    var body: some View {
        ZStack {
            // Default background color (systemTeal)
            Color(.systemTeal).ignoresSafeArea()
            
            
            
            ScrollView {
                
                
                
                //.animation(.easeInOut(duration: 0.8))
                
                VStack(spacing: 20) {
                    //Spacer()
                    Text(timerCountdown)
                        .font(.system(size: 60, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(20)
                        .background(timerManager.isCustomReminderTriggered ? Color.red.opacity(0.8) : Color.blue.opacity(0.8))
                        .cornerRadius(15)
                        .padding(.top, 30)
                    
                    //Spacer()
                    
                    VStack(spacing: 20) {
                        // Timer controls: Start, Pause, Reset buttons
                        HStack(spacing: 30) {
                            Button(action: {
                                if timerStarted {
                                    if buttonState == .pause {
                                        timerManager.pauseAndPlayTimer()
                                        buttonState = .resume
                                        
                                    }
                                    
                                    else if timerManager.timerComplete {
                                        buttonState = .start
                                        timerManager.resetTimer()
                                        timerStarted = false
                                        
                                    }
                                    
                                    else{
                                        timerManager.pauseAndPlayTimer()
                                        buttonState = .pause
                                    }
                                    
                                }  else {
                                    let totalSeconds = getTotalSeconds(hours: hours, minutes: minutes, seconds: seconds)
                                    timerManager.startTimer(totalSeconds: totalSeconds)
                                    //timerManager.setCustomReminders(customReminders)
                                    timerStarted = true
                                    buttonState = .pause
                                }
                                
                                
                            }) {
                                Text(buttonState == .start ? "Start" : (buttonState == .pause ? "Pause" : (buttonState == .timerComplete ? "Done" : "Resume")))
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(buttonState == .start ? Color.green : (buttonState == .timerComplete ? Color.blue : (buttonState == .pause ? Color.orange : Color.green)))
                                    .background(timerManager.isCustomReminderTriggered ? Color.red.opacity(0.8) : Color.orange.opacity(0.8))
                                    .cornerRadius(10)
                            }
                            .padding(.trailing, 20)
                            
                            Button(action: {
                                self.timerManager.resetTimer()
                                timerStarted = false
                                buttonState = .start
                                
                                
                            }){
                                Text("Reset")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                            .disabled(!timerManager.isTimerRunning && timerManager.remainingSeconds == getTotalSeconds(hours: hours, minutes: minutes, seconds: seconds))
                            
                            
                            
                            
                            .padding(.leading, 20)
                        }
                        .ignoresSafeArea(edges: .bottom)
                        .padding(.top, 0)
                        
                        // Timer settings: Input fields for hours, minutes, and seconds
                        // Timer settings: Input fields for hours, minutes, and seconds
                        VStack(spacing: 10) {
                            Text("Timer Length")
                                .font(.headline)
                                .foregroundColor(.white)
                            HStack(spacing: 10) {
                                // Hours Text Field
                                NumberPadTextField(value: $hours, placeholder: "H")
                                    .frame(width: 70)
                                    .padding(.vertical, 6)
                                    .fixedSize()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .background(colorScheme == .light ? Color.white : Color.black)
                                    .disabled(timerStarted)
                                
                                Text(":")
                                    .foregroundColor(.white)
                                    .bold()
                                
                                // Minutes Text Field
                                NumberPadTextField(value: $minutes, placeholder: "M")
                                    .frame(width: 70)
                                    .padding(.vertical, 6)
                                    .fixedSize()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .background(colorScheme == .light ? Color.white : Color.black)
                                    .disabled(timerStarted)
                                
                                Text(":")
                                    .foregroundColor(.white)
                                    .bold()
                                
                                // Seconds Text Field
                                NumberPadTextField(value: $seconds, placeholder: "S")
                                    .frame(width: 70)
                                    .padding(.vertical, 6)
                                    .fixedSize()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .background(colorScheme == .light ? Color.white : Color.black)
                                    .disabled(timerStarted)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                        }
                        .ignoresSafeArea(edges: .bottom)
                        .padding(.top, 0)
                        
                        // Custom reminders: Input fields for adding custom reminders
                        VStack(spacing: 10) {
                            HStack {
                                Text("Custom Reminders")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    //.multilineTextAlignment(.center)
                                Spacer()
                                Button(action: {
                                    // Add a new custom reminder when the plus button is pressed
                                    customReminders.append(0)
                                    //timerManager.setCustomReminders(customReminders)
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            //.frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 30)
                            
                            ScrollView {
                                VStack(spacing: 10) {
                                    ForEach(customReminders.indices, id: \.self) { index in
                                        // In the parent view where CustomReminderRowView is used:
                                        CustomReminderRowView(
                                            hoursBinding: bindingForCustomReminder(index, component: .hours),
                                            minutesBinding: bindingForCustomReminder(index, component: .minutes),
                                            secondsBinding: bindingForCustomReminder(index, component: .seconds),
                                            onValueChange: customRemindersDidChange,
                                            colorScheme: colorScheme,
                                            timerStarted: timerStarted,
                                            onDelete: {
                                                customReminders.remove(at: index)
                                            }
                                            
                                        )
                                        
                                        
                                    }
                                    
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        
                    }
                    
                    Spacer()
                }
                //.padding(.top, 40) // Adjust the top padding of the main VStack to move everything down
                .ignoresSafeArea(.keyboard, edges: .bottom) // Prevent safe area from showing up with the number pad
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Custom Timers")
                
                //.accentColor(Color(.systemTeal))
                .padding(.horizontal, 20)
            }
            .onChange(of: timerManager.timerComplete) { newValue in
                if newValue {
                    buttonState = .timerComplete
                }
            }
            //.background(VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial)))
            .background(
                        Color(timerManager.isCustomReminderTriggered ? .red : .systemTeal).ignoresSafeArea()
                    )

            .onDisappear {
                timerManager.stopTimer() // Invalidate the Timer when the view disappears
            }
            .onAppear {
                loadCustomReminders()
            }
        }
    }
    private func bindingForCustomReminder(_ index: Int, component: ReminderComponent) -> Binding<Int> {
        Binding(
            get: {
                switch component {
                case .hours:
                    return customReminders[index] / 3600
                case .minutes:
                    return (customReminders[index] % 3600) / 60
                case .seconds:
                    return customReminders[index] % 60
                }
            },
            set: { newValue in
                var totalSeconds = 0
                let hours = (component == .hours) ? Optional(newValue) : customReminders[index] / 3600
                let minutes = (component == .minutes) ? Optional(newValue) : (customReminders[index] % 3600) / 60
                let seconds = (component == .seconds) ? Optional(newValue) : customReminders[index] % 60
                
                if let hours = hours, let minutes = minutes, let seconds = seconds {
                    totalSeconds = (hours * 3600) + (minutes * 60) + seconds
                }
                customReminders[index] = totalSeconds
            }
        )
    }
    
    private func getTotalSeconds(hours: Int, minutes: Int, seconds: Int) -> Int {
        (hours * 3600) + (minutes * 60) + seconds
    }
    
    
    func updateTimerCountdown(remainingSeconds: Int) -> String {
           let hoursString = String(format: "%02d", remainingSeconds / 3600)
           let minutesString = String(format: "%02d", (remainingSeconds % 3600) / 60)
           let secondsString = String(format: "%02d", remainingSeconds % 60)
           return "\(hoursString):\(minutesString):\(secondsString)"
       }
    
    private var timerCountdown: String {
        
        if(!timerStarted){
            let hoursString = String(format: "%02d", hours)
            let minutesString = String(format: "%02d", minutes)
            let secondsString = String(format: "%02d", seconds)
            return "\(hoursString):\(minutesString):\(secondsString)"
            
        }
        else{
            return timerManager.remSecs()
        }
        

        }

  

}
