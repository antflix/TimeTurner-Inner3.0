import MessageUI
import SwiftUI

struct Job: Codable {
  let jobId: String
  let jobName: String
  let jobDate: String
}
@available(iOS 17.0, *)
struct ContentView: View {
    @StateObject var dataManager = DataManager()
//    @StateObject var darkModeSettings = DataManager() // Use observed object for dark mode

    @State private var selectedJobID: String?
    @Environment(\.colorScheme) var colorScheme
    @State private var isSettingsOpen = false // Add this line to declare isSettingsOpen
    @State private var symbolName = "gear"
    @State private var isSettingsViewPresented = false
    @State private var isPopoverPresented = false
    @State private var isContactsPresented = false

    @State private var settingsPopoverAnchor: Anchor<CGRect>?

    enum Tab {
        case jobs, employee, employees, preview
    }

    @State private var selectedTab: Tab = .jobs  // Track selected tab
    var body: some View {
          NavigationStack {
              ZStack(alignment: .topTrailing) {
                  switch selectedTab {
                  case .jobs:
                      JobsView()
                  case .employee:
                      EmployeeView()
//                          .toolbar{MyToolbarItems()}
                          .environmentObject(dataManager)
                  case .employees:
                      EmployeesViews()
//                          .toolbar{MyToolbarItems()}
                          .environmentObject(dataManager)
                  case .preview:
                      PreViews()
//                          .toolbar{MyToolbarItems()}
                          .environmentObject(dataManager)
                  }

              }
          }
      }

  }

//            if isSettingsViewPresented {
//                GeometryReader { geometry in
//                    VStack {
//                        Spacer()
//                        Image(systemName: "gear")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1) // Adjust icon size dynamically
//                            .foregroundColor(.blue)
//                            .onTapGesture {
//                                withAnimation {
//                                    isSettingsViewPresented.toggle()
//                                }
//                            }
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading, geometry.size.width * 0.1) // Adjust padding dynamically
//                    .anchorPreference(key: MyPopoverKey.self, value: .bounds) { anchor in
//                        settingsPopoverAnchor = anchor
//                        return anchor
//                    }
//                }
//                .padding(.top, 50)
//            }
//        }.background(
//                    Color.clear // Ensure this stack is transparent to allow tap through
//                        .popover(
//                            isPresented: $isSettingsViewPresented,
//                            arrowEdge: .leading,
//                            content: {
//                                SettingsView()
//                            }
//                        )
//                )
//        }
//    
//
//    struct SettingsHandleView: View {
//        @Binding var isSettingsViewPresented: Bool
//        
//        var body: some View {
//            VStack {
//                Spacer()
//                Image(systemName: "gear")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 40, height: 40)
//                    .foregroundColor(.blue)
//                    .onTapGesture {
//                        withAnimation {
//                            isSettingsViewPresented.toggle()
//                        }
//                    }
//                Spacer()
//            }
//            .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
//            .padding(.leading, 100) // Add padding from the left
//        }
//    }
// }
//    struct SettingsView: View {
//        var body: some View {
//            ModeToggleButton().background(Color("Color 5"))
//        }
//    }
//    // Custom key to hold popover anchor
//    struct MyPopoverKey: PreferenceKey {
//        static var defaultValue: Anchor<CGRect>? = nil
//        static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {}
//    }
//
////
// struct SettingsHandleView: View {
//    @Binding var isSettingsViewPresented: Bool
//
//    var body: some View {
//        VStack {
//            Spacer()
//            Image(systemName: "gear")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 40, height: 40)
//                .foregroundColor(.blue)
//                .onTapGesture {
//                    withAnimation {
//                        isSettingsViewPresented.toggle()
//                    }
//                }
//            Spacer()
//        }
//        .frame(maxWidth: .infinity, alignment: .trailing)
//        .padding(.trailing)
//    }
// }
//
// struct SettingsView: View {
//    var body: some View {
//        ModeToggleButton().background(Color("Color 5"))
//
//       
//    }
// }

@available(iOS 17.0, *)
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(DataManager())
      .background(Color("Color 2"))

    EmployeeView()
      .environmentObject(DataManager())
      .background(Color("Color 2"))
      EmployeesViews()
        .environmentObject(DataManager())
        .background(Color("Color 2"))
      PreViews()
        .environmentObject(DataManager())
        .background(Color("Color 2"))

//      SettingsView()
//          .environmentObject(DataManager())

  }
}
