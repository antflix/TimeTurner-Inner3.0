////
////  modetogglebutton.swift
////  SparkList
////
////  Created by User on 12/8/23.
////
//
//// ModeToggleButton.swift
//
//import SwiftUI
//
//
//@available(iOS 17.0, *)
//struct ModeToggleButton: View {
//        @Environment(\.colorScheme) var colorScheme // Get the current color scheme
//        @State private var isSettingsViewPresented = false // State for popover presentation
//        @EnvironmentObject var dataManager: DataManager
//        @State private var isDarkMode = Bool() // Add a state variable to manage dark mode
//
//        var body: some View {
//            VStack {
//                Image(systemName: "gear") // Display a gear symbol
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 30, height: 30)
//                    .foregroundColor(.black)
//                    .onTapGesture {
//                        withAnimation {
//                            isSettingsViewPresented.toggle() // Toggle the state to show/hide popover
//                        }
//                    }
//            }
//            .popover(
//                isPresented: $isSettingsViewPresented,
//                attachmentAnchor: .rect(.bounds),
//                arrowEdge: .leading,
//                content: {
//                    // Content of the popover goes here
//                    VStack {
//        VStack{
//            VStack {
//                AlarmSettingView()
//                    .padding()
//                
//                Divider().frame(height: 1.0).background(
//                    Color("Color 1")
//                ).padding(.horizontal)
//                    .background(Color.blue)
//                
////                darkmode()
////                Divider().frame(height: 1.0).background(
////                    Color("Color 1")
////                ).padding(.horizontal)
////                    .background(Color.blue)
////                
//                HStack {
//                    
//                    Spacer()
//                    Button(action: {
//                        // Toggle between light and dark mode
//                        dataManager.clearAllSMSData()
//                    }) {
//                        Text("Clear Hours")
//                            .padding()
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }.buttonStyle(PlainButtonStyle())
//                    Spacer()
//                }            .preferredColorScheme(isDarkMode ? .dark : .light) // Apply the preferred color scheme
//                    .background(Color("Color 5"))
//                Divider().frame(height: 1.0).background(
//                    Color("Color 1")
//                ).padding(.horizontal)
//                    .background(Color.blue)
//                HStack{
////                    VStack{
////                        ContactsView(selectedPhoneNumber: $dataManager.selectedPhoneNumber)
////                        Text("\(dataManager.selectedPhoneNumber)")
////                    }
////                    VStack{
////                        ContactsView(selectedPhoneNumber: $dataManager.selectedPhoneNumber2)
////                        Text("\(dataManager.selectedPhoneNumber2)")
//                    }
//                }
//                Button("Save") {
//                    dataManager.saveSelectedNumbers()
//                }
//            }
//        }
//   
//                }
//                                .padding()
//                            }
//                        )
//                    }
//                }
//
//
////#Preview {
////    if #available(iOS 17.0, *) {
////        ModeToggleButton()
////    }
////    
////}
