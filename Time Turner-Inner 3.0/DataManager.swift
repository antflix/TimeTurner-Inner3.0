//
//  DataManager.swift
//  project1
//
//  Created by User on 11/24/23.
//

import Contacts
import Foundation
import SwiftUI
// Class managing global variables
class DataManager: ObservableObject {
	static let shared = DataManager()
	
	// Published variables storing various data
	@Published var selectedJobID: String = ""
	@Published var selectedHours: String = ""
	@Published var allSMSs: String = ""
	@Published var allSMSBodies: [String] = []
	@Published var selectedContacts: [CNContact]? // Define as an optional array
	@Published var selectedPhoneNumber: String = UserDefaults.standard.string(forKey: "CustomPhoneNumber") ?? ""
	@Published var selectedPhoneNumber2: String = UserDefaults.standard.string(forKey: "CustomPhoneNumber2") ?? ""
	@Published var employeeData: [String: String] = [:]
	@Published var isDarkMode: Bool
	static var selectedContactName: String = "" // Global variable to store selected contact name
	@Published var selectedContactPhoneNumber = ""
	@Published var selectedContactPhoneNumber2 = ""
	@Published var selectedContactName = ""
	@Published var selectedContactName2 = ""
	@Published var selectedContact1: CNContact?
	@Published var selectedContact2: CNContact?
	@Published var numbersList: String = ""
	@Published var persistentMode: Bool = UserDefaults.standard.bool(forKey: "persistentMode") // Retrieve persistent mode status
	@Published var selectedTime: Date {
		didSet {
			UserDefaults.standard.set(selectedTime, forKey: "selectedTime")
		}
	}
	@Published var alarmNoise: String = "customAlarm-2.mp3"
	
	@Published var isAlarmSet: Bool = UserDefaults.standard.bool(forKey: "isAlarmSet")

	
	init() {
		self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
		//         self.selectedContact = DataManager.loadContact()
		//         self.selectedPhoneNumber = DataManager.loadPhoneNumber()
//		self.selectedTime = UserDefaults.standard.object(forKey: "selectedTime") as? Date ?? Date()
		if let savedTime = UserDefaults.standard.object(forKey: "selectedTime") as? Date {
			// If selectedTime has a value, set isAlarmSet to true and schedule the alarm
			self.selectedTime = savedTime
			self.isAlarmSet = true
			print("in if statement")
			scheduleAlarm(at: selectedTime, soundName: alarmNoise)
		}
		else {
			print("in else statement")
			persistentMode = false
			self.persistentMode = false
			UserDefaults.standard.set(false, forKey: "persistentMode")
			self.isAlarmSet = false
			isAlarmSet = false
			UserDefaults.standard.set(false, forKey: "isAlarmSet")
			UserDefaults.standard.synchronize()
			self.selectedTime = Date()
			cancelAlarm()
		}
	}
	
	func toggleDarkMode() {
		isDarkMode.toggle()
		UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
	}
	// Dictionary to hold employee hours data
	
	// Method to set hours for a given employee name
	func saveEmployeeHours(name: String, hours: String) {
		employeeData[name] = hours
	}
	
	// Method to get hours for a given employee name from the dictionary
	func hoursForEmployee(_ employeeName: String) -> String {
		return employeeData[employeeName] ?? ""
	}
	
	
	func scheduleAlarm(at time: Date, soundName: String) {
		print("daily alarm function")
		print("isAlarmSet: \(isAlarmSet)")

		print(#function)
		if isAlarmSet {
		let center = UNUserNotificationCenter.current()
		UserDefaults.standard.set(time, forKey: "selectedTime")
		let content = UNMutableNotificationContent()
		content.title = "Turn In Time!!"
	content.body = "It's time to turn in time!"
		content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundName))
		let calendar = Calendar.current
		let nowComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
		let now = calendar.date(from: nowComponents)!
		let scheduledTimeComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: time)
		var scheduledTime = calendar.date(from: scheduledTimeComponents)!
		
		if now > scheduledTime {
			// If the time has already passed for today, schedule for the next day
			scheduledTime = calendar.date(byAdding: .day, value: 1, to: scheduledTime)!
		}
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: scheduledTime), repeats: true)
		
		let request = UNNotificationRequest(identifier: "dailyAlarm", content: content, trigger: trigger)
		
		center.add(request) { error in
			if let error = error {
				print("Error scheduling daily notification: \(error.localizedDescription)")
			} else {
				print("dailyAlarm scheduled for \(dataManager.selectedTime)")
			}
		}
			UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
				for request in requests {
					if request.identifier == "dailyAlarm" {
						print("dailyAlarm has been verified as activated")
					}
					
				}
			}
		}
	}
	func persistentAlarm(soundName: String) {
		print("persistent alarm function")
		print("isAlarmSet: \(isAlarmSet)")

		if isAlarmSet {
			let center = UNUserNotificationCenter.current()
			
			let content = UNMutableNotificationContent()
			content.title = "WARNING!!"
			content.body = "Alarm will continue until you turn your time in!"
			content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundName))
			let calendar = Calendar.current
			let nowComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
			let now = calendar.date(from: nowComponents)!
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
			
			let request = UNNotificationRequest(identifier: "persistentAlarm", content: content, trigger: trigger)
			
			center.add(request) { error in
				if let error = error {
					print("Error scheduling persistent notification: \(error.localizedDescription)")
				} else {
					print("Persistent notification scheduled successfully, starting at \(now)")
				}
			}
			
			UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
				for request in requests {
					if request.identifier == "persistentAlarm" {
						print("persistentAlarm has been verified as activated")
					}
					
				}
			}
		}
	}
	func stopPersistentAlarm() {
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["persistentAlarm"])
		print("cancel persistence alarm")
	}
	func cancelAlarm() {
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
		UserDefaults.standard.set(false, forKey: "isAlarmSet") 
		UserDefaults.standard.synchronize()
		print("cancel all alarms")
	}
	// Array holding employee names
	let employeeNames = [
		"Anthony",
		"Brandon",
		"Brandin",
		"Bennet",
		"Chris",
		"Chuck",
		"David",
		"Derek",
		"Dennis",
		"Jason",
		"Jesse",
		"Kevin",
		// Add other employee names here
	]
	func clearAllSMSData() {
		allSMSs = "" // Clear the string
		allSMSBodies = [] // Clear the array
		
	}
	
	
	func saveSelectedContacts(_ contacts: [CNContact]) {
		let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: contacts, requiringSecureCoding: false)
		UserDefaults.standard.set(encodedData, forKey: "selectedContactsKey")
	}
	
	func retrieveSelectedContacts() -> [CNContact]? {
		if let savedData = UserDefaults.standard.data(forKey: "selectedContactsKey"),
		   let decodedContacts = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, CNContact.self], from: savedData) as? [CNContact] {
			return decodedContacts
		}
		return nil
	}
	
	func deleteSelectedContacts() {
		UserDefaults.standard.removeObject(forKey: "selectedContactsKey")
		selectedContacts = nil // Clear the selected contacts
	}
	
}
//    
//    func saveSelectedNumbers() {
//        UserDefaults.standard.set(selectedPhoneNumber, forKey: "CustomPhoneNumber")
//        UserDefaults.standard.set(selectedPhoneNumber2, forKey: "CustomPhoneNumber2")
//    }
//    
//    func clearSelectedNumbers() {
//        selectedPhoneNumber = ""
//        selectedPhoneNumber2 = ""
//        UserDefaults.standard.removeObject(forKey: "CustomPhoneNumber")
//        UserDefaults.standard.removeObject(forKey: "CustomPhoneNumber2")
//    }
//    func clearFirstContact() {
//        selectedContactName = ""
//        selectedContactPhoneNumber = ""
//        UserDefaults.standard.removeObject(forKey: "SelectedContact1")
//    }
//    func clearSecondContact() {
//        selectedContactName2 = ""
//        selectedContactPhoneNumber2 = ""
//        UserDefaults.standard.removeObject(forKey: "SelectedContact2")
//
//        
//    }
    //
    //
    //
    //    @Published var selectedContact: CNContact {
    //           didSet {
    //               // Save to UserDefaults when selectedContact changes
    //               saveContact()
    //           }
    //       }
    //
    //       @Published var selectedPhoneNumber: String {
    //           didSet {
    //               // Save to UserDefaults when selectedPhoneNumber changes
    //               savePhoneNumber()
    //           }
    //       }
    //
    //
    //      // Function to save selectedContact to UserDefaults
    //      private func saveContact() {
    //          // Convert selectedContact to Data
    //          if let encoded = try? NSKeyedArchiver.archivedData(withRootObject: selectedContact, requiringSecureCoding: false) {
    //              UserDefaults.standard.set(encoded, forKey: "SelectedContact")
    //          }
    //      }
    //
    //      // Function to save selectedPhoneNumber to UserDefaults
    //      private func savePhoneNumber() {
    //          UserDefaults.standard.set(selectedPhoneNumber, forKey: "CustomPhoneNumber")
    //      }
    //
    //      // Function to load selectedContact from UserDefaults
    //      private static func loadContact() -> CNContact {
    //          guard let contactData = UserDefaults.standard.object(forKey: "SelectedContact") as? Data,
    //                let contact = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(contactData) as? CNContact
    //          else {
    //              return CNContact() // Return a default value if no saved data exists
    //          }
    //          return contact
    //      }
    //
    //      // Function to load selectedPhoneNumber from UserDefaults
    //      private static func loadPhoneNumber() -> String {
    //          return UserDefaults.standard.string(forKey: "CustomPhoneNumber") ?? ""
    //      }
    //  }
    

