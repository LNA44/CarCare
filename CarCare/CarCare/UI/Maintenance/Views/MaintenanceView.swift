//
//  Maintenance_FollowUpView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct Maintenance_FollowUpView: View {
	@StateObject var viewModel = MaintenanceVM()
	
	//MARK: -Body
    var body: some View {
        Text("Entretiens à venir")
		List {
			ForEach(MaintenanceType.allCases.filter {$0 != .Unknown}) { type in
				MaintenanceRow(viewModel: viewModel, maintenanceType: type)
			}
		}
		.onAppear {
			viewModel.fetchAllMaintenance()
		}
    }
}

#Preview {
    Maintenance_FollowUpView()
}


/*List {
	ForEach(viewModel.categories.keys.sorted(), id: \.self) { key in
		CategoryRow(categoryName: key, items: viewModel.categories[key] ?? [], selectedProduct: $selectedProduct)
			.listRowBackground(Color.clear)
	}
	.frame(height: 390)
	.listRowSeparator(.hidden)
	.listRowInsets(EdgeInsets())
}
.background(Color("Background"))
.listStyle(PlainListStyle())
.onAppear {
	Task {
		await viewModel.fetchProducts()
	}
}
*/
