import SwiftUI

struct CustomReminderRowView: View {
    @Binding var hoursBinding: Int
    @Binding var minutesBinding: Int
    @Binding var secondsBinding: Int
    
    var onValueChange: () -> Void // Add this closure
    
    
    
    
    var colorScheme: ColorScheme
    var timerStarted: Bool
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            CustomRemindersNumberPadTextField(value: $hoursBinding, placeholder: "H", timerStarted: timerStarted, onValueChange: onValueChange)
            Text(":")
                .foregroundColor(.white)
                .bold()
            CustomRemindersNumberPadTextField(value: $minutesBinding, placeholder: "M", timerStarted: timerStarted, onValueChange: onValueChange)
            Text(":")
                .foregroundColor(.white)
                .bold()
            CustomRemindersNumberPadTextField(value: $secondsBinding, placeholder: "S", timerStarted: timerStarted, onValueChange: onValueChange)

            Button(action: onDelete) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 30)
    }
}
