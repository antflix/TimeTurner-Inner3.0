import SwiftUI

@available(iOS 17.0, *)
struct JobsView: View {
	@EnvironmentObject var dataManager: DataManager

	@State private var searchText = ""
	@State private var jobs = [[String]]()
	@State private var selectedRow: Int?
	@Environment(\.colorScheme) var colorScheme
	private let apiURL = "https://app.antflix.net/api/joblist"
	@State private var showingPopover: [Bool] = [] // Add state for showing popover
	@State private var isEmployeeViewActive = false
	private func updatePopoverArray() {
		showingPopover = Array(repeating: false, count: filteredJobs.count)
	}

	var filteredJobs: [[String]] {
		if searchText.isEmpty {
			return jobs
		} else {
			return jobs.filter { job in
				let jobName = job[1].lowercased()
				return jobName.contains(searchText.lowercased())
			}
		}
	}

	init() {
		// Initialize showingPopover in the init() method after filteredJobs is available
		let initialShowPopover = [Bool](repeating: false, count: filteredJobs.count)
		_showingPopover = State(initialValue: initialShowPopover)
	}
	var body: some View {
		VStack {
			// Header
			HStack {
				ZStack(alignment: .topTrailing) {
					Text("Job Name").font(Font.custom("Quicksand", size: 25).bold())
						.frame(maxWidth: .infinity * 0.90, alignment: .leading)
						.padding()
					Text("Job Date").font(Font.custom("Quicksand", size: 25).bold())
						.frame(maxWidth: .infinity * 0.15, alignment: .trailing)
						.padding()
				}
			}
			.background(Color.blue)
			.foregroundColor(.white)
			.font(.headline)
			ScrollView {
				ForEach(0..<filteredJobs.count, id: \.self) { index in
					let job = filteredJobs[index]
					HStack {
						Text(job[1])
							.frame(maxWidth: .infinity * 0.90, alignment: .leading)
							.lineLimit(1)
						Text(job[2])
						Spacer()
						Button(action: {
							if index < showingPopover.count {
								showingPopover[index].toggle()
							}}) {
								Image(systemName: "info.circle")
									.foregroundColor(.blue)
							}
							.popover(isPresented: $showingPopover[index]) {
								VStack {
									// Define your popover content here
									Spacer()
									Text("Job Name-").font(.largeTitle).underline(Bool(true)).foregroundStyle(Color("Color 6"))
									Text("\(job[1])").foregroundStyle(Color.blue).font(.title)

									Spacer()

									Text("Job #-").font(.largeTitle).underline(Bool(true)).foregroundStyle(Color("Color 6"))
									Text("\(job[0])").foregroundStyle(Color.blue).font(.title)
									Spacer()

									Text("Date Created").font(.largeTitle).underline(Bool(true)).foregroundStyle(Color("Color 6"))
									Text("\(job[2])").foregroundStyle(Color.blue).font(.title)
									Spacer()

								}
							}
					}
					.foregroundColor(colorScheme == .dark ? Color.white : Color.black)
					.font(colorScheme == .dark ? .headline : .headline)
					.padding(5)
					.frame(maxWidth: .infinity * 0.85, alignment: .leading)
					.background(
						selectedRow == jobs.firstIndex(of: job) ? Color.blue.opacity(0.3) : Color.clear
					)
					.onTapGesture {
						selectedRow = jobs.firstIndex(of: job)
						let selectedJobID = job[0]
						dataManager.selectedJobID = selectedJobID
						isEmployeeViewActive = true
					}
				}

				NavigationLink(destination: EmployeeView().environmentObject(dataManager), isActive: $isEmployeeViewActive) {
					EmptyView() // Empty view to prevent the navigation link from being triggered
				}
			}
			.background(Color("Color 7"))

			.foregroundColor(Color.black)
			.onAppear {
				// Initialize the showingPopover array based on the number of jobs
				fetchData()
				showingPopover = Array(repeating: false, count: jobs.count)
				resetEmployeeData() // Call the function to reset employee data when the view appears

				dataManager.selectedJobID = ""

			}.background(Color("Color 7"))

			Spacer()
			SearchBar(text: $searchText)
				.background(Color("Color 7"))

			Divider().frame(height: 2.0).background(
				Color("Color 2")
			).padding(.horizontal)
				.padding(.bottom)

			//                NavigationLink(destination: EmployeeView()) {
			//                    Text("Next")
			//                }
		}.onChange(of: searchText) { _ in
			updatePopoverArray()
		}
		.onChange(of: jobs) { _ in
			updatePopoverArray()
		}
		.toolbar {MyToolbarItems()}
		.navigationBarBackButtonHidden(true) // Hides the back button
		.navigationBarHidden(true)
		.background(Color("Color 7"))
		.onChange(of: dataManager.isDarkMode) { newValue in
			UserDefaults.standard.set(newValue, forKey: "isDarkMode")
			if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			   let window = windowScene.windows.first {
				window.rootViewController?.overrideUserInterfaceStyle = newValue ? .dark : .light
			}
		}

	}

	// Function to fetch data from API
	// Function to fetch data from API
	private func fetchData() {
		if let cachedJobs = UserDefaults.standard.array(forKey: "CachedJobs") as? [[String]] {
			if !isDataStale() {
				self.jobs = cachedJobs
				return
			}
		}

		guard let url = URL(string: apiURL) else { return }

		URLSession.shared.dataTask(with: url) { data, _, error in
			if let data = data {
				if let decodedData = try? JSONSerialization.jsonObject(with: data, options: [])
					as? [[String]] {
					DispatchQueue.main.async {
						self.jobs = decodedData  // Update jobs array with fetched data
						UserDefaults.standard.set(decodedData, forKey: "CachedJobs")
						UserDefaults.standard.set(Date(), forKey: "LastRefreshDate")
					}
				}
			} else {
				print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
			}
		}.resume()
	}
	func resetEmployeeData() {
		dataManager.employeeData = [:] // Resetting employeeData to an empty dictionary
	}
	// Function to determine background color based on color scheme
	// Function to determine background color based on color scheme

	private func isDataStale() -> Bool {
		if let lastRefreshDate = UserDefaults.standard.object(forKey: "LastRefreshDate") as? Date {
			let currentDate = Date()
			let calendar = Calendar.current
			if let difference = calendar.dateComponents([.hour], from: lastRefreshDate, to: currentDate)
				.hour, difference >= 24 {
				return true
			}
		}
		return false
	}

	// Custom Search Bar
	struct SearchBar: View {
		@Binding var text: String

		var body: some View {
			VStack {
				TextField("Search", text: $text).font(Font.custom("Quicksand", size: 25).bold())
					.textFieldStyle(DefaultTextFieldStyle())
					.submitLabel(.search)
			}          .background(Color("Color 7"))

		}

	}
}

@available(iOS 17.0, *)
struct JobsView_Previews: PreviewProvider {
  static var previews: some View {
    JobsView()
      .environmentObject(DataManager())
  }
}
