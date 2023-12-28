//
//  BackButton.swift
//  Time Turner-Inner 3.0
//
//  Created by User on 12/27/23.
//

import SwiftUI

struct BackButton<Destination: View>: View {
	let destination: Destination
	@Binding var isActive: Bool
	init(destination: Destination, isActive: Binding<Bool>) {
		self.destination = destination
		self._isActive = isActive
	}

	var body: some View {
		NavigationLink(destination: destination, isActive: $isActive) {
			Button(action: {
				isActive = true
			}) {
				Image(systemName: "arrow.left")
					.foregroundColor(.white)
			}

		}

	}
}
