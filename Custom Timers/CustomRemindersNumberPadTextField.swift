import SwiftUI

struct CustomRemindersNumberPadTextField: View {
    @Binding var value: Int
    let placeholder: String
    let timerStarted: Bool  // Pass timerStarted as a parameter
    
    var onValueChange: () -> Void // Add this closure

    var body: some View {
        NumberPadTextField(value: $value, placeholder: placeholder)
            .frame(width: 70)
            .padding(.vertical, 6)
            .fixedSize()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(.primary)
            .background(Color(UIColor.systemBackground))
            .disabled(timerStarted)
            .onChange(of: value) { _ in
                            onValueChange() // Call the closure when the value changes
                        }
    }
}
