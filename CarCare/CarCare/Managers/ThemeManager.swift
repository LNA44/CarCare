//
//  ThemeManager.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import Foundation
import UIKit

struct ThemeManager {
	static let shared = ThemeManager()
	
	private init() {}
	
	func applyInterfaceStyle(_ darkMode: Bool) {
		if let window = UIApplication.shared.connectedScenes
			.compactMap({ $0 as? UIWindowScene })
			.first?.windows.first {
			window.overrideUserInterfaceStyle = darkMode ? .dark : .light
		}
	}
}
