//
//  Time_Turner_Inner_3_0App.swift
//  Time Turner-Inner 3.0
//
//  Created by User on 12/26/23.
//
import SwiftUI
import UserNotifications
import ContactsUI
class AppDelegate: NSObject, UIApplicationDelegate {
	// Implement the app lifecycle methods as needed
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		// Perform any setup tasks here
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if granted {
				print("Notification permission granted")
			} else {
				print("Notification permission denied")
			}
		}
		return true
	}
}
let dataManager = DataManager()

@available(iOS 17.0, *)
@main
struct Time_Turner_Inner_3_0App: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@State private var showSplash = true // Flag to control splash screen visibility
	
	var body: some Scene {
		WindowGroup {
			if showSplash {
				LaunchScreen()
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Adjust the duration (e.g., 2 seconds)
							withAnimation {
								showSplash = false // Hide the splash screen after delay
							}
						}
					}
			} else {
				ContentView()
					.environmentObject(dataManager) // Inject the EnvironmentObject
			}
		}
	}
}
