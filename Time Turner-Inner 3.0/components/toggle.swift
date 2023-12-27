//import SwiftUI
//
//struct toggle: ToggleStyle {
//    @State private var isDarkMode = true // Add a state variable to manage dark mode
//
//    func makeBody(configuration: Configuration) -> some View {
//        HStack {
//            configuration.label
//            Spacer()
//            Rectangle()
//                .foregroundColor(configuration.isOn ? .gray : .yellow)
//                .frame(width: 51, height: 31, alignment: .center)
//                .overlay(
//                    Circle()
//                        .foregroundColor(.white)
//                        .padding(.all, 3)
//                        .overlay(
//                            Image(systemName: configuration.isOn ? "moon.fill" : "sun.max.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .font(Font.title.weight(.black))
//                                .frame(width: 18, height: 18, alignment: .center)
//                                .foregroundColor(configuration.isOn ? .black : .black)
//                        )
//                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
//                )
//                .cornerRadius(20)
//                .onTapGesture {
//                    withAnimation(Animation.linear(duration: 0.1)) {
//                        configuration.isOn.toggle()
//                    }
//                }
//        }
//    }
//}
//struct previewbutton: View {
//    @Environment(\.colorScheme) var colorScheme // Get the current color scheme
//    @EnvironmentObject var dataManager: DataManager
//
//    
//    
//    var body: some View {
//        
//        Toggle("", isOn: $dataManager.isDarkMode)
//            .toggleStyle(toggle()
//            )
//    }
//}
////                            
//#Preview{
//    previewbutton()
//}
