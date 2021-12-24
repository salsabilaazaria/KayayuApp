//
//  NumberHelper.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 23/12/21.
//

import Foundation

class NumberHelper {
	
	func idAmountFormat(beforeFormatted: Float) -> String {
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
