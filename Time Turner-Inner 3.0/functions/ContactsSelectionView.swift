import SwiftUI
import ContactsUI

struct ContactsSelectionView: View {
	@EnvironmentObject var dataManager: DataManager
	@State private var selectedContacts: [CNContact]? = []
	@State private var isContact1PickerPresented = false

	var body: some View {
		VStack {
			Capsule()
				.frame(width: 40, height: 6)
				.foregroundColor(.secondary)
				.padding(.top, 5)
			if let contacts = selectedContacts, !contacts.isEmpty {
				List {
					ForEach(contacts, id: \.self) { contact in
						ContactRow(contact: contact) {
							// Pass the contact to be deleted to the onDelete action
							deleteContact(contact)
						}
					}
				}
			} else {
				Text("No contacts selected")
			}
			Button(action: {
				self.isContact1PickerPresented = true
			}) {
				HStack {
					Image(systemName: "person.fill.questionmark")
						.symbolRenderingMode(.palette)
						.foregroundStyle(Color.red, Color.green)

					Text("Add Contacts")

				}.padding()
					.foregroundColor(.white)
					.background(Color.blue)
					.cornerRadius(8)
			}
			.sheet(isPresented: $isContact1PickerPresented) {

				ContactPickerViewController(selectedContacts: $selectedContacts)

			}

			//
		}.frame(maxWidth: .infinity)
			.background(Color("Color 7"))
			.onAppear {
				// Retrieve saved contacts from UserDefaults
				if let savedContacts = dataManager.retrieveSelectedContacts() {
					self.selectedContacts = savedContacts
				}
			}

	}
	func deleteContact(_ contact: CNContact) {
		if let index = selectedContacts?.firstIndex(of: contact) {
			selectedContacts?.remove(at: index)
			dataManager.saveSelectedContacts(selectedContacts ?? [])
		}
	}
}

struct ContactRow: View {
	let contact: CNContact
	let onDelete: () -> Void // No need for onDelete in this context

	var body: some View {
		HStack {
			Text("\(contact.givenName) \(contact.familyName)")
			Spacer()
			Button(action: onDelete) {
				Image(systemName: "trash")
					.foregroundColor(.red)
					.onTapGesture {
						// Perform the delete action for this specific contact
						onDelete()
					}
			}
		}
	}
}
#Preview {
	ContactsSelectionView()
		.environmentObject(DataManager())
}
