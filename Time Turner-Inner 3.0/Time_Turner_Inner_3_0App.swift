//
//  Time_Turner_Inner_3_0App.swift
//  Time Turner-Inner 3.0
//
//  Created by User on 12/26/23.
//
import SwiftUI
import UserNotifications
import ContactsUI
import AVFoundation

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	let dataManager = DataManager.shared // Change this line
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
			for request in requests {
				print("Activating: \(request.identifier)")
			}
		}
		// Request notification permissions
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
			if granted {
				print("Notification permission granted")
			} else {
				print("Notification permission denied")
			}
		}

		// Configure audio session
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
			try AVAudioSession.sharedInstance().setActive(true)
		} catch {
			print("Failed to configure AVAudioSession: \(error.localizedDescription)")
		}

		// Set the AppDelegate as the delegate for UNUserNotificationCenter
		UNUserNotificationCenter.current().delegate = self

		return true
	}

	// Handle the notification when the app is in the foreground
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		print(" \(notification.request.identifier) triggered")
		if notification.request.identifier == "dailyAlarm" {
			handleDailyAlarmResponse()

		}
		completionHandler([.banner, .sound]) // Customize as needed
	}

	// Handle the user's interaction with the notification
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		print("\(response.notification.request.identifier) notification has been clicked")
		if response.notification.request.identifier == "dailyAlarm" {
			handleDailyAlarmResponse()
		}
		completionHandler()
	}

	// Logic to handle the response to the daily alarm
	func handleDailyAlarmResponse() {
		// Handle the response to the daily alarm
		// Access the shared instance of your DataManager
		// Check if persistent mode is enabled and trigger a persistent alarm
		print("\(dataManager.persistentMode)")
		print("Daily Alarm Triggered")
		// Check if persistent mode is enabled
		if dataManager.persistentMode == true {
			print("persistent mode active and persistent alarm has started ")
			// Trigger the persistent alarm to start immediately and repeat every 60 seconds
			dataManager.persistentAlarm(soundName: "customAlarm-2.mp3")

		}
	}
}

let dataManager = DataManager.shared // Change this line
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
