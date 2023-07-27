import SwiftUI
import AudioToolbox


class TimerManager: ObservableObject {
    @Published var isTimerRunning = false
    @Published var remainingSeconds = 60
    @Published var timerCountdown: String = ""
    @Published var timerComplete = false;
    
    
   
    
    @State private var backgroundColor = Color.clear
    @Published var isCustomReminderTriggered = false;
    
    
   
    
    @Published var vibrate = false
    @Published var sound = false
    
    
    var customReminders: [Int] = []
    var finalSeconds = 0;
    
   
    init() {
            let settings = Settings()
            vibrate = settings.getVibrateSetting()
            sound = settings.getSoundSetting()
        }
   
    func updateTimerCountdown(remainingSeconds: Int){
           let hoursString = String(format: "%02d", remainingSeconds / 3600)
           let minutesString = String(format: "%02d", (remainingSeconds % 3600) / 60)
           let secondsString = String(format: "%02d", remainingSeconds % 60)
           timerCountdown = "\(hoursString):\(minutesString):\(secondsString)"
       }
    
    func createFirstTimerString(remainingSeconds: Int) -> String{
           let hoursString = String(format: "%02d", remainingSeconds / 3600)
           let minutesString = String(format: "%02d", (remainingSeconds % 3600) / 60)
           let secondsString = String(format: "%02d", remainingSeconds % 60)
           return "\(hoursString):\(minutesString):\(secondsString)"
       }
    
    
    func remSecs() -> String{
        
        return timerCountdown
    }

    
    
    var timer: Timer? = nil
    
    func startTimer(totalSeconds: Int) {
        timerCountdown = createFirstTimerString(remainingSeconds: totalSeconds);
        finalSeconds = totalSeconds;
        timerComplete = false
        
        print("The Custom List: " + customReminders.map { String(format: "%02d", $0) }.joined(separator: ", "))

       
        
        if !isTimerRunning {
            remainingSeconds = totalSeconds
            print("Timer Started with Total Seconds: \(totalSeconds)")
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                    self.updateTimerCountdown(remainingSeconds: remainingSeconds)
                    print("Timer Tick: \(self.remainingSeconds) sec")
                    
                    //implment the code here to check if the remaining seconds is equal to either of the custom reminders set
                    
                    if self.customReminders.contains(self.remainingSeconds) {
                        // Trigger vibratePhone() function when remaining seconds match a custom reminder
                        
                        
                        
                        
                        if vibrate && sound{
                            self.vibratePhone()
                            self.playSound()
                        }
                        else if sound {
                            self.playSound()
                        }
                        else if vibrate {
                            self.vibratePhone()
                        }
                        
                        
                        
                        self.isCustomReminderTriggered = true

                        // Reset the isCustomReminderTriggered after a short delay (e.g., 0.2 seconds)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            self.isCustomReminderTriggered = false
                        }

                        print("Custom reminder at \(self.remainingSeconds) sec")
                    }

//                    if self.remainingSeconds > 0, self.remainingSeconds == totalSeconds - self.remainingSeconds {
//                        // Perform action for custom reminder here
//                        print("Custom reminder at \(self.remainingSeconds) sec")
//
//                    }
                } else {
                    self.vibratePhone()
                    self.finalStop()
                    print("Timer Stopped")
                }
            }
            
            isTimerRunning = true
        } else {
            stopTimer()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    func finalStop() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        timerComplete = true
        timerCountdown = "Time's Up!"
    }
    
    
    func resetTimer() {
        updateTimerCountdown(remainingSeconds: finalSeconds)
        stopTimer()
        timerComplete = false
        remainingSeconds = finalSeconds
    }
    
    func pauseAndPlayTimer() {
        //print("IS TIMER ACTIVE: " + String(format: "%02d", isTimerRunning))
        
        if isTimerRunning {
            toggleIsTimerRunning()
            stopTimer()
        } else {
            //print("Remaining Seconds" + String(format: "%02d", remainingSeconds))
            startTimer(totalSeconds: remainingSeconds)
            
        }
    }

    
    private func toggleIsTimerRunning(){
        isTimerRunning = !isTimerRunning
    }
    
  
    private func vibratePhone() {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    private func playSound() {
        if let soundURL = Bundle.main.url(forResource: "bell", withExtension: "wav") {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }


    func setCustomReminders(_ reminders: [Int]) {
           customReminders = reminders
        print("The Custom List: " + customReminders.map { String(format: "%02d", $0) }.joined(separator: ", "))
       }
    
    
//    func toggleVibrate(){
//        vibrate = !vibrate
//    }
//
//    func toggleSound(){
//        sound = !sound
//    }
    
}
