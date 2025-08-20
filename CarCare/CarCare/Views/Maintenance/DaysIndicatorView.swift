//
//  RectangleColor.swift
//  CarCare
//
//  Created by Ordinateur elena on 19/08/2025.
//

import SwiftUI

struct DaysIndicatorView: View {
	let days: Int?
	let rectangleWidth: CGFloat
	let rectangleHeight: CGFloat
	let triangleWidth: CGFloat
	let triangleHeight: CGFloat
	let spacing: CGFloat
	
	var body: some View {
		VStack(spacing: spacing) {
			// Triangle
			Image(systemName: "triangle.fill")
				.resizable()
				.frame(width: triangleWidth, height: triangleHeight)
				.rotationEffect(.degrees(180))
				.foregroundColor(.black)
				.offset(x: triangleOffset())
			
			// Rectangles
			HStack(spacing: 2) {
				Rectangle()
					.fill(colorFirstRectangle(for: days))
					.frame(width: rectangleWidth, height: rectangleHeight)
				Rectangle()
					.fill(colorSecondRectangle(for: days))
					.frame(width: rectangleWidth, height: rectangleHeight)
				Rectangle()
					.fill(colorThirdRectangle(for: days))
					.frame(width: rectangleWidth, height: rectangleHeight)
			}
		}
	}
	
	func colorFirstRectangle(for days: Int?) -> Color {
		guard let days else { return .gray }
		switch days {
		case let x where x > 30: return .green
		case 1...30: return .gray
		case ..<1: return .gray
		default: return .gray
		}
	}
	
	func colorSecondRectangle(for days: Int?) -> Color {
		guard let days else { return .gray }
		switch days {
		case let x where x > 30: return .gray
		case 1...30: return .orange
		case ..<1: return .gray
		default: return .gray
		}
	}
	
	func colorThirdRectangle(for days: Int?) -> Color {
		guard let days else { return .gray }
		switch days {
		case let x where x > 30: return .gray
		case 1...30: return .gray
		case ..<1: return .red
		default: return .gray
		}
	}
	
	func triangleOffset(for days: Int?) -> CGFloat {
		guard let days else { return 0 }
		switch days {
		case let x where x > 30: return 0       // triangle au-dessus du premier rectangle
		case 1...30: return 25                  // décalage pour le deuxième rectangle
		case ..<1: return 50                   // décalage pour le troisième rectangle
		default: return 0
		}
	}
	
	func triangleOffset() -> CGFloat {
		guard let days else { return 0 }
		let totalRectangleWidth = rectangleWidth + spacing
		switch days {
		case let x where x > 30:
			return -totalRectangleWidth // premier rectangle
		case 1...30:
			return 0 // deuxième rectangle
		default:
			return totalRectangleWidth // troisième rectangle
		}
	}
}
