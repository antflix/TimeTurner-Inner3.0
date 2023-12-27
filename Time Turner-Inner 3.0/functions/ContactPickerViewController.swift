import SwiftUI
import ContactsUI

struct ContactPickerViewController: UIViewControllerRepresentable {
	@EnvironmentObject var dataManager: DataManager
	@Binding var selectedContacts: [CNContact]? // Update to accept an optional array
	
	func makeCoordinator() -> Coordinator {
		Coordinator(dataManager: dataManager, selectedContacts: $selectedContacts)
	}
	func makeUIViewController(context: Context) -> CNContactPickerViewController {
		let picker = CNContactPickerViewController()
		picker.delegate = context.coordinator
		return picker
	}
	
	func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}
	
	
	
	class Coordinator: NSObject, CNContactPickerDelegate {
		var dataManager: DataManager
		var selectedContacts: Binding<[CNContact]?> // Change the type to accept optional binding
		
		init(dataManager: DataManager, selectedContacts: Binding<[CNContact]?>) {
			self.dataManager = dataManager
			self.selectedContacts = selectedContacts // Assign the binding directly
		}
		
		func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
			if var contacts = selectedContacts.wrappedValue {
				contacts.append(contact)
				print("\(contacts)")
				selectedContacts.wrappedValue = contacts
				
				// Save the contacts immediately upon selection
				dataManager.saveSelectedContacts(contacts)
			}
		}
	}
}
