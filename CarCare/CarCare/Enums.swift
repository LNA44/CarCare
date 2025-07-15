//
//  Enums.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

//Vehicle
enum Brand {
	case Renault, Peugot, Citroen, Dacia, Volkswagen, Toyota, Tesla, Ford, BMW, MercedesBenz, Audi, Kia, Hyundai, Nissan, Opel, Fiat, Seat, Skoda, Dsautomobiles, Volvo
}

enum Model {
	case Clio, Mégane, Captur, Twingo, Scenic, Kadjar, Zoe, peugeot208, peugeot308, peugeot3008, peugeot508, peugeot2008, peugeot5008, C3, C4, C5Aircross, C1, CElysée, Berlingo, Sandero, Duster, Logan, Lodgy, Dokker, Golf, Passat, Polo, Tiguan, Touareg, Up, Corolla, Yaris, RAV4, Prius, CHR, Hilux, ModelS, Model3, ModelX, ModelY, Fiesta, Focus, Mustang, Kuga, EcoSport, Mondeo, Série1, Série3, Série5, X3, X5, i3, ClasseA, ClasseC, ClasseE, GLC, GLE, CLA, A3, A4, A6, Q3, Q5, Q7, Ceed, Sportage, Sorento, Rio, Stonic, i10, i20, Tucson, Kona, SantaFe, Micra, Qashqai, Juke, Leaf, XTrail, Corsa, Astra, Mokka, Insignia, Crossland, fiat500, Panda, Tipo, Punto, Doblo, Ibiza, Leon, Ateca, Arona, Tarraco, Fabia, Octavia, Kodiaq, Superb, Kamiq, DS3, DS4, DS7, DS9, XC40, XC60, XC90, S60, V60
}

enum Fuel {
	case essence, diesel, electricite, hybrideEssenceElectrique, hybrideDieselElectrique, gpl, gnv, hydrogene
}

//Maintenance
enum MaintenanceType {
	case Tires, BrakePads, BrakeDiscsAndPads, EngineOil, Coolant, Battery, VehicleInspection, AirConditioning
}

//Mileage
enum MonthMileage {
	case January, February, March, April, May, June, July, August, September, October, November, December
}
