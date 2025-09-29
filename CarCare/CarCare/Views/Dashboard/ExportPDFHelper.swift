//
//  ExportPDFVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 14/09/2025.
//

import UIKit
import SwiftUI

final class ExportPDFHelper {
	
	func sharePDF(bike: Bike, from maintenances: [Maintenance]) {
		// Générer le PDF
		let pdfData = createBikePDF(bike: bike, from: maintenances)
		
		// Créer un fichier temporaire sûr
		let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Maintenances.pdf")
		
		do {
			try pdfData.write(to: tempURL, options: .atomic)
		} catch {
			print("Erreur lors de l'écriture du PDF : \(error)")
			return
		}
		
		// Présenter UIActivityViewController sur le thread principal
		DispatchQueue.main.async {
			let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
			
			// Pour iPad : définir sourceView pour éviter crash
			if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			   let rootVC = scene.windows.first?.rootViewController {
				if let popover = activityVC.popoverPresentationController {
					popover.sourceView = rootVC.view
					popover.sourceRect = CGRect(
						x: rootVC.view.bounds.midX,
						y: rootVC.view.bounds.midY,
						width: 0,
						height: 0
					)
					popover.permittedArrowDirections = []
				}
				rootVC.present(activityVC, animated: true)
			}
		}
	}
	
	func createBikePDF(bike: Bike, from maintenances: [Maintenance]) -> Data {
		let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842)) // A4
		let margin: CGFloat = 20
		let rowHeight: CGFloat = 25
		let columnWidths: [CGFloat] = [200, 150, 100]

		return pdfRenderer.pdfData { context in
			context.beginPage()
			var yPosition: CGFloat = margin
			
			// Infos vélo
			let bikeInfo = """
			\(NSLocalizedString("bike_label", comment: "Label for Bike")) : \(bike.brand.localizedName) \(bike.model)
			\(NSLocalizedString("type_label", comment: "Label for Bike type")) : \(bike.bikeType.localizedName.capitalized)
			\(NSLocalizedString("year_label", comment: "Label for Bike year")) : \(bike.year)
			\(NSLocalizedString("identification_number_label", comment: "Label for identification number")) : \(bike.identificationNumber)
			
			"""
			bikeInfo.draw(at: CGPoint(x: margin, y: yPosition),
						  withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
			
			yPosition += rowHeight * 5
			
			// En-tête tableau
			let headers = [
				NSLocalizedString("maintenance_type_label", comment: "Table header for maintenance type"),
				NSLocalizedString("date_label", comment: "Table header for date"),
			]
			for (index, header) in headers.enumerated() {
				let rect = CGRect(x: margin + columnWidths.prefix(index).reduce(0, +),
								  y: yPosition,
								  width: columnWidths[index],
								  height: rowHeight)
				header.draw(in: rect,
							withAttributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
			}
			
			yPosition += rowHeight
			
			// Lignes tableau
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .medium
			dateFormatter.timeStyle = .short
			
			for maintenance in maintenances {
				let values = [
					"\(maintenance.maintenanceType)",
					dateFormatter.string(from: maintenance.date)
				]
				
				for (index, value) in values.enumerated() {
					let rect = CGRect(x: margin + columnWidths.prefix(index).reduce(0, +),
									  y: yPosition,
									  width: columnWidths[index],
									  height: rowHeight)
					value.draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
				}
				
				yPosition += rowHeight
				
				if yPosition + rowHeight > 842 - margin {
					context.beginPage()
					yPosition = margin
				}
			}
		}
	}
}
