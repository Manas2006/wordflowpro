import SwiftUI

struct NumberPadTextField: UIViewRepresentable {
    @Binding var value: Int
    var placeholder: String
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NumberPadTextField
        var textField: UITextField?
        
        init(_ textField: NumberPadTextField) {
            self.parent = textField
        }
        
        // Allow only numeric input and handle changes
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Remove any leading 0 before updating the value
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Check if the updated text is empty, in which case, set the value to 0
            if updatedText.isEmpty {
                parent.value = 0
                return true
            }
            
            // Limit the input to a maximum of 2 characters
            if updatedText.count <= 2, Int(updatedText) != nil {
                parent.value = Int(updatedText) ?? 0
                return true
            }
            
            return false
        }
        
        @objc func doneButtonTapped() {
            parent.value = Int(textField?.text ?? "") ?? 0
            textField?.resignFirstResponder() // Dismiss the number pad
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if value == 0 {
            uiView.text = nil
            uiView.placeholder = placeholder
        } else {
            uiView.text = String(value)
        }
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        context.coordinator.textField = textField
        
        // Add "Done" button on the UIToolBar
        let doneToolbar = UIToolbar()
        doneToolbar.barStyle = .default
        doneToolbar.isTranslucent = true
        doneToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        doneToolbar.items = [flexibleSpace, doneButton]
        textField.inputAccessoryView = doneToolbar
        
        
        
        return textField
    }
}
