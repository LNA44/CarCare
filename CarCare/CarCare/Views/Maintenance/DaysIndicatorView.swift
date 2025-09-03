//
//  RectangleColor.swift
//  CarCare
//
//  Created by Ordinateur elena on 19/08/2025.
//

import SwiftUI

struct DaysIndicatorView: View {
	let days: Int
	let frequency: Int
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
				.foregroundColor(Color("TextColor"))
				.offset(x: triangleOffset())
			
			// Rectangles
			HStack(spacing: 2) {
				Rectangle()
					.fill(colorForRectangle(index: 0))
					.frame(width: rectangleWidth, height: rectangleHeight)
				Rectangle()
					.fill(colorForRectangle(index: 1))
					.frame(width: rectangleWidth, height: rectangleHeight)
				Rectangle()
					.fill(colorForRectangle(index: 2))
					.frame(width: rectangleWidth, height: rectangleHeight)
			}
		}
	}
	
	private func colorForRectangle(index: Int) -> Color {
		let proportion = min(max(Double(days) / Double(frequency), 0), 1)
		
		switch index {
		case 0: // premier rectangle
			return proportion >= 2/3 ? Color("DoneColor") : Color("EmptyColor")
		case 1: // deuxième rectangle
			return proportion >= 1/3 && proportion < 2/3 ? Color("InProgressColor") : Color("EmptyColor")
		case 2: // troisième rectangle
			return proportion < 1/3 ? Color("ToDoColor") : Color("EmptyColor")
		default:
			return Color("EmptyColor")
		}
	}

	private func triangleOffset() -> CGFloat {
		let proportion = min(max(Double(days) / Double(frequency), 0), 1)
		
		let step = rectangleWidth + spacing
		let index: Int
		
		switch proportion {
		case 0..<1/3:
			index = 2 // triangle sur le dernier rectangle
		case 1/3..<2/3:
			index = 1 // triangle sur le deuxième rectangle
		default:
			index = 0 // triangle sur le premier rectangle
		}
		
		// centrage du triangle
		let totalWidth = 3 * rectangleWidth + 2 * spacing
		let offset = CGFloat(index) * step + rectangleWidth / 2 - totalWidth / 2
		return offset
	}
}
