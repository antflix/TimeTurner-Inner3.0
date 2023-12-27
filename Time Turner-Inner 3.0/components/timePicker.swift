import SwiftUI

@available(iOS 17.0, *)
struct timePicker: View {
    
    
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTimeIndex = 0
    // Helper function to convert index to time string (assuming starting from 8:00 AM)
    func timeString(for index: Int) -> String {
        let hours = index / 2 + 8 // Starting hour (8 AM)
        let minutes = index % 2 * 30 // 0 or 30 minutes
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let date = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: Date()) ?? Date()
        return formatter.string(from: date)
    }
    
    var body: some View {
        Text("Jobs View for ")
            .navigationTitle("timeer")
        
        NavigationView {
            NavigationLink(destination: EmployeesViews() ){
                Text("Go to employees")
                
                VStack(spacing: 0) {
                    Picker("Select Time", selection: $selectedTimeIndex) {
                        ForEach(0..<32, id: \.self) { index in
                            Text(timeString(for: index))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                    
                    
                    
                }
                .tabItem {
                    Image(systemName: "clock")
                    Text("Time Selection")
                }
            }
        }
    }
}
@available(iOS 17.0, *)
struct timePicker_Previews: PreviewProvider {
        static var previews: some View {
            timePicker()
        }
    }

