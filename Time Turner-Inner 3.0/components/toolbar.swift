//
//  toolbar.swift
//  SparkList
//
//  Created by User on 12/16/23.
//

import SwiftUI
import Contacts

@available(iOS 17.0, *)
struct MyToolbarItems: ToolbarContent {
	@EnvironmentObject var dataManager: DataManager
	@Environment(\.colorScheme) var colorScheme // Get the current color scheme
	@State private var showConfirmation = false
	@State private var showJobs = false
	@State private var isPopoverPresented = false
	@State private var isContactsPresented = false
	@State private var symbolAnimation = false
	@State private var selectedContacts: [CNContact]? = []
	// make the default setting darkmode
	// Your toolbar items go here
	var body: some ToolbarContent {
		ToolbarItemGroup(placement: .bottomBar) {
			VStack {
				HStack {
					HStack {
						Button(action: {
							isContactsPresented.toggle()
						}) {
							if let contacts = selectedContacts, !contacts.isEmpty {
								Image(systemName: "person.fill.badge.plus")
									.font(Font.custom("Quicksand", size: 24).bold())
									.aspectRatio(contentMode: .fit)
									.symbolRenderingMode(.palette)
									.foregroundStyle(Color.green, Color.blue)
									.popover(isPresented: $isContactsPresented, arrowEdge: .top) {
										ContactsSelectionView().environmentObject(DataManager())                    .environmentObject(dataManager)
									}
							} else {
								Image(systemName: "person.fill.questionmark")
									.font(Font.custom("Quicksand", size: 24).bold())
									.symbolRenderingMode(.palette)
									.onAppear {
										symbolAnimation.toggle()
									}

									.foregroundStyle(Color.red, Color.blue)
									.symbolEffect(.variableColor.reversing.cumulative, options: .repeat(100).speed(1), value: symbolAnimation)
									.popover(isPresented: $isContactsPresented, arrowEdge: .top) {
										ContactsSelectionView().environmentObject(DataManager())                    .environmentObject(dataManager)
									}
							}

						}
					}.onAppear {
						// Retrieve saved contacts from UserDefaults
						if let savedContacts = dataManager.retrieveSelectedContacts() {
							self.selectedContacts = savedContacts
						}
					}
					//            }
					Spacer()
					HStack {
						Button(action: {
							isPopoverPresented.toggle()
						}) {
							Image(systemName: "clock.arrow.2.circlepath")
								.foregroundStyle(Color("Color 6"), Color.blue)
								.font(Font.custom("Quicksand", size: 24).bold())
						}
						.popover(isPresented: $isPopoverPresented, arrowEdge: .top) {
							AlarmSettingView()
						}
					}
					Spacer()
					// Add an onTapGesture to the arrow.up.trash symbol
					HStack {
						Image(systemName: "arrow.up.trash")
							.foregroundStyle(Color("Color 6"), Color.blue)
							.mask(Circle())
							.font(Font.custom("Quicksand", size: 24).bold())
							.onTapGesture {
								showConfirmation = true
							}
						
							.confirmationDialog(
								"Clear SMS Data",
								isPresented: $showConfirmation,
								titleVisibility: .visible
							) {
								Button("Clear it") {
									dataManager.clearAllSMSData()
									showJobs = true
								}
								Button("Cancel", role: .cancel) {}
							}
							.background(
								NavigationLink(
									destination: JobsView())
								{
									EmptyView()
								}
							)
					}
						
						NavigationLink(destination: PreViews()) {
							HStack {
								Text("Next")
									.foregroundColor(Color.green)
									.background(Color.clear)
									.font(.title)
								
								Image(systemName: "arrow.right")
									.foregroundColor(Color.green)
									.font(.title)
									.background(Color.clear)
									.font(.title)
								
							}
					}
					Spacer()
					HStack {
						if colorScheme == .light {
							Image("moonsun")
								.symbolRenderingMode(.multicolor)
								.onAppear {
									symbolAnimation.toggle()
								}
								.font(.title2)

								.foregroundStyle(Color.blue.opacity(0.9), Color.blue.opacity(0.9))
								.onTapGesture {
									withAnimation {
										dataManager.isDarkMode.toggle()                           }
								}
						} else {
							Image("sunmoon")
								.symbolRenderingMode(.palette)
								.onAppear {
									symbolAnimation.toggle()
								}
								.foregroundStyle(Color.blue, Color.white)
								.font(.title2)
								.onTapGesture {
									withAnimation {
										dataManager.isDarkMode.toggle()
									}
								}
						}
					}
				}
			}.ignoresSafeArea(edges: .bottom)
		}
	}
}

@available(iOS 17.0, *)

#Preview {

		ContentView()
			.environmentObject(DataManager())

}

//        // Create a placeholder view for the preview
//        Text("Placeholder View")
//            // Use the toolbar with MyToolbarItems for preview
//            .toolbar {
//                MyToolbarItems()
//            }
//    }
// }
