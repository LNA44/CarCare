//
//  DoneMaintenanceRow.swift
//  CarCare
//
//  Created by Ordinateur elena on 30/08/2025.
//

import SwiftUI

struct DoneMaintenanceRow: View {
	let maintenance: Maintenance
	let formatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium
		df.timeStyle = .none
		df.locale = Locale.current  
		return df
	}()
	
    var body: some View {
		HStack {
			Text("\(maintenance.maintenanceType.localizedName)")
				.bold()
			Spacer()
			Text("\(formatter.string(from: maintenance.date))")
		}
		.padding(.trailing, 20)
		.foregroundColor(Color("TextColor"))
    }
}

/*#Preview {
    DoneMaintenanceRow()
}*/
