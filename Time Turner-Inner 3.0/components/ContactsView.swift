import ContactsUI
import SwiftUI
@available(iOS 17.0, *)
struct ContactsView: View {
    @State private var symbolAnimation = false
    @State private var hasSavedContacts = false
    @State private var isContact1PickerPresented = false
    @State private var isContact2PickerPresented = false

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Time Contact?").font(Font.custom("Quicksand", size: 30).bold())
                        .frame(alignment: .center)

                    Text("Who do you need to turn time into?").font(Font.custom("Quicksand", size: 12).bold())
                        .frame(maxWidth: .infinity * 0.90, alignment: .center)
                        .foregroundStyle(Color.black)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .font(.headline)
            }

            // 1 is empty
            // 2 is empty
            if dataManager.selectedContactName.isEmpty && dataManager.selectedContactName2.isEmpty {
                Text("No Contacts Selected. ")
                    .foregroundStyle(Color.red)
                    .font(Font.custom("Quicksand", size: 20).bold())
                    .frame(maxWidth: .infinity * 0.90, alignment: .center)
                    .padding()
                Image(systemName: "person.crop.circle.badge.xmark")
                    .aspectRatio(contentMode: .fit)
                    .padding(/*@START_MENU_TOKEN@*/ .all/*@END_MENU_TOKEN@*/)
                    .font(Font.custom("Quicksand", size: 86).bold())
                    .symbolRenderingMode(.palette)
                    .onAppear {
                        symbolAnimation.toggle()
                    }
                    .foregroundStyle(Color.red, Color.yellow)

                    .symbolEffect(.variableColor.reversing.cumulative, options: .repeat(100).speed(1), value:
                        symbolAnimation)
                Text("Please choose 1 or 2 contacts to send your time to.")
                Spacer()

                // add contact 1
                Button(action: { self.isContact1PickerPresented = true }) {
                    HStack {
                        Image(systemName: "person.fill.questionmark")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.red, Color.green)

                        Text("Select Contact 1")

                    }.padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $isContact1PickerPresented) {
//                    ContactPickerViewController()
                }
                .padding()
//                if let contact1 = dataManager.selectedContact1 {
//                    ContactCardView(contact: contact1)
//                }
                // add contact2
                Button(action: {
                    self.isContact2PickerPresented = true
                }) { HStack {
                    Image(systemName: "person.fill.questionmark")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.red, Color.green)

                    Text("Select Contact 2")

                }.padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .sheet(isPresented: $isContact2PickerPresented) {
//                    ContactPickerViewController()
                }
                .padding()
            }
            //  1 is not empty
            // 2 is empty
            if !dataManager.selectedContactName.isEmpty || !dataManager.selectedContactName2.isEmpty {
                //                Text("Selected Contact 1: \(dataManager.selectedContactName)")
                //                                   Text("Phone Number 1: \(dataManager.selectedContactPhoneNumber)").padding()
                VStack {
                    VStack {
                        if let contact1 = dataManager.selectedContact1 {
                            ContactCardView(contact: contact1)
                        }
                        HStack {
                            Button(action: {
                                self.isContact1PickerPresented = true
                            }) { HStack {
                                Image(systemName: "person.fill.questionmark")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.red, Color.green)

                                Text("Select Contact 1")

                            }.padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                            }
                            .sheet(isPresented: $isContact1PickerPresented) {
//                                ContactPickerViewController()
                            }
                            .padding()
                            if let _ = dataManager.selectedContact1 {
                                Button("Clear Contact 1") {
//                                    dataManager.clearSecondContact()
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(8)
                                .padding()
                            }
                        } // contact 1 HStack
                    } // contact 1 vstack
                    .padding()
                    //   1 clear button
                    VStack {
                        Spacer()
                        Divider().frame(height: 2.0).background(
                            Color("Color 2")
                        ).padding(.horizontal)
                        Spacer()
                    }

                    // 2 add contact button
                    VStack {
                        if let contact2 = dataManager.selectedContact2 {
                            ContactCardView(contact: contact2)
                        }
                        HStack {
                            Button(action: {
                                self.isContact2PickerPresented = true
                            }) { HStack {
                                Image(systemName: "person.fill.questionmark")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.red, Color.green)

                                Text("Select Contact 2")

                            }.padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                            }
                            .sheet(isPresented: $isContact2PickerPresented) {
//                                ContactPickerViewController()
                            }
                            .padding()
                            if let _ = dataManager.selectedContact2 {
                                Button("Clear Contact 2") {
//                                    dataManager.clearSecondContact()
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(8)
                                .padding()
                            }
                        } // 2nd contack hstack

                    }.padding() // 2nd contact vstack
                } // vstack wrapped around both contacts code
            } // if statement for both contacts
        } // vstack wrapped
        .background(EllipticalGradient(colors: [Color("Color 7"), Color("Color 8")], center: .top, startRadiusFraction: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, endRadiusFraction: 0.8))
        .onAppear {
            // Check if there are saved contacts
//            if dataManager.hasSavedContacts() {
            // Update the state to indicate saved contacts are present
            hasSavedContacts = true

            // Add logic to show existing saved contacts if available
            if let savedContact1Data = UserDefaults.standard.data(forKey: "SelectedContact1"),
               let savedContact2Data = UserDefaults.standard.data(forKey: "SelectedContact2") {
                if let savedContact1 = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CNContact.self, from: savedContact1Data) {
                    dataManager.selectedContact1 = savedContact1
                } else {
                    print("Error decoding savedContact1: Unable to decode CNContact from data")
                }

                if let savedContact2 = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CNContact.self, from: savedContact2Data) {
                    dataManager.selectedContact2 = savedContact2
                } else {
                    print("Error decoding savedContact2: Unable to decode CNContact from data")
                }
            }
        }
    }
}

struct ProfileInfoView: View {
    var contact: CNContact // Directly using CNContact from DataManager

    var body: some View {
        VStack {
            // Display detailed contact information
            Text("\(contact.givenName) \(contact.familyName)")
                .font(.title)
                .foregroundColor(.black)

            // Display additional contact details...
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

struct ContactCardView: View {
    var contact: CNContact // Assuming you have a CNContact object passed to this view

    var body: some View {
        VStack {
            if let imageData = contact.thumbnailImageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                    .padding()
            } else {
                // Placeholder image when contact has no picture
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                    .padding()
                    .foregroundColor(.gray) // Adjust placeholder color as needed
            }

            Text("\(contact.givenName) \(contact.familyName)")
                .font(.title)
                .foregroundColor(.black)

            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                Text("Phone Number: \(phoneNumber)")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }

            // Add more contact information if needed
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

@available(iOS 17.0, *)
struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
            .environmentObject(DataManager())
    }
}
