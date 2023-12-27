//
//  getContact2.swift
import SwiftUI
import ContactsUI
struct GetContact2: View {
   
    @State private var customPhoneNumber2: String = UserDefaults.standard.string(forKey: "CustomPhoneNumber2") ?? ""
    @State private var selectedContact: String?
    @State private var coordinator2: Coordinator? // Coordinator instance

    var body: some View {
        VStack {
       
            
            Button("Contact #2") {
                let contactPicker = CNContactPickerViewController()
                coordinator2 = Coordinator(parent: self, customPhoneNumber2: $customPhoneNumber2)
                contactPicker.delegate = coordinator2 // Set the contactPicker's delegate
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController?.present(contactPicker, animated: true, completion: nil)
                }
            }.padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .buttonStyle(PlainButtonStyle())
            
            
        }
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        let parent: GetContact2
        @Binding var customPhoneNumber2: String // Binding to the parent's customPhoneNumber2

        init(parent: GetContact2, customPhoneNumber2: Binding<String>) {
            self.parent = parent
            _customPhoneNumber2 = customPhoneNumber2
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                customPhoneNumber2 = phoneNumber // Update the binding
                parent.selectedContact = CNContactFormatter.string(from: contact, style: .fullName)
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
#Preview {
    GetContact2()
}
