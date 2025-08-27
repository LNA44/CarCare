//
//  ThemeViewModel.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import Foundation
import SwiftUI

final class ThemeViewModel: ObservableObject {
	@AppStorage("isDarkMode") var isDarkMode: Bool = false {
		didSet {
			applyInterfaceStyle()
		}
	}
	
	func applyInterfaceStyle() {
		if let window = UIApplication.shared.connectedScenes
			.compactMap({ $0 as? UIWindowScene })
			.first?.windows.first {
			window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
		}
	}
}
