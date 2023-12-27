import SwiftUI
struct hoursPicker: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedHours = 0
    
    var body: some View {
      
            Picker("Hours Worked", selection: $selectedHours) {
                ForEach(0..<49, id: \.self) { index in
                    let hours = index / 2
                    let minutes = (index % 2) * 30
                    Text("\(hours) hours \(minutes) minutes")
                        .tag(index)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            
            .onChange(of: selectedHours) { newValue in
                let hours = newValue / 2
                let minutes = (newValue % 2) * 30
                let userselectedHours = "\(hours) hours \(minutes) minutes"
                dataManager.selectedHours = userselectedHours
                //            dataManager.updateHoursForEmployee(selectedEmployee, hours: selectedTimeString)
                
                
                
            }
        }
        
    }

struct hoursPicker_Previews: PreviewProvider {
    static var previews: some View {
        hoursPicker()
    }
}
