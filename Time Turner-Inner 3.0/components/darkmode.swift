import SwiftUI
@available(iOS 17.0, *)
struct darkmode: View {
    @Environment(\.colorScheme) var colorScheme // Get the current color scheme
    @State private var symbolAnimation = false
    @EnvironmentObject var dataManager: DataManager



        
        var body: some View {
            VStack {
                if colorScheme == .light {
                    
                    Image("Symbol 1")
                        .rotationEffect(Angle(degrees: 180))
                        .symbolRenderingMode(.multicolor)
                        .onAppear(){
                            symbolAnimation.toggle()
                        }
                        .foregroundStyle(Color.yellow, Color.orange, Color.yellow)
                    
                        .symbolEffect(.variableColor.reversing.cumulative, options: .repeat(100).speed(1), value:
                                        symbolAnimation)
                    
                        .font(.largeTitle)
                        .onTapGesture {
                            withAnimation {
                                dataManager.isDarkMode.toggle()
                                
                                
                            }
                        }
                } else { EmptyView()}
//                } else {
//                    Image("Symbol")
//                        .rotationEffect(Angle(degrees: 180))
//                        .symbolRenderingMode(.multicolor)
//                        .onAppear(){
//                            symbolAnimation.toggle()
//                        }
//                        .foregroundStyle(Color.yellow, Color.orange, Color.yellow)
//                        
//                        .symbolEffect(.variableColor.reversing.cumulative, options: .repeat(100).speed(1), value:
//                                        symbolAnimation)
//
//                        .font(.largeTitle)
//                        .onTapGesture {
//                            withAnimation {
//                                dataManager.isDarkMode.toggle()
//                                
//
//
//                            }
//                        }
//                }
            
            }.background(.random)
            .environment(\.colorScheme, dataManager.isDarkMode ? .dark : .light) // Set the environment color scheme
            .onAppear {
                dataManager.isDarkMode = (colorScheme == .light) // Set the initial state based on color scheme
            }
            .onChange(of: dataManager.isDarkMode) { newValue in
                
                
            }
                        .onAppear {
                            dataManager.isDarkMode = (colorScheme == .light) // Set the initial state based on color scheme
                        }
                        .onChange(of: dataManager.isDarkMode) { newValue in
                            // Update appearance mode when toggle changes
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {
                                window.rootViewController?.overrideUserInterfaceStyle = newValue ? .dark : .light
                            }
                        }
                }
            }
        

//
        
        struct CustomSliderToggleStyle: ToggleStyle {
            func makeBody(configuration: Configuration) -> some View {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.5)) // Customize slider background color
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white) // Customize slider color
                            .offset(x: configuration.isOn ? 25 : -25) // Adjust the sliding position
                        
                        // Customize the size of the slider
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .shadow(radius: 3)
                            .offset(x: configuration.isOn ? 25 : -25) // Adjust the sliding position
                    }
                    .frame(width: 60, height: 30) // Adjust the overall size of the slider
                    .onTapGesture { configuration.isOn.toggle() }
                    
                    configuration.label
                }
            }
        }
  

@available(iOS 17.0, *)
struct darkmode_Previews: PreviewProvider {
    static var previews: some View {
        darkmode()
            .environmentObject(DataManager())
    }
}
