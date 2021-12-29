//
//  NumberHelper.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 23/12/21.
//

import Foundation

class NumberHelper {
	
	func floatToIdFormat(beforeFormatted: Float) -> String {
		let numberFormatter = NumberFormatter()
		
		numberFormatter.locale = Locale(identifier: "id_ID")
		numberFormatter.groupingSeparator = "."
		numberFormatter.numberStyle = .currency
		
		guard let finalNumber = numberFormatter.string(from: beforeFormatted as NSNumber) else {
			return "\(beforeFormatted)"
		}
		return finalNumber
	}
	
	func intToIdFormat(beforeFormatted: Int) -> String {
		print("intToIdFormat before\(beforeFormatted)")
		let numberFormatter = NumberFormatter()
		numberFormatter.locale = Locale(identifier: "id_ID")
		numberFormatter.groupingSeparator = "."
		numberFormatter.numberStyle = .decimal
		
		guard let finalNumber = numberFormatter.string(from: beforeFormatted as NSNumber) else {
			return "\(beforeFormatted)"
		}
		return finalNumber
	}
	

}
