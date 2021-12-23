//
//  NumberHelper.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 23/12/21.
//

import Foundation

class NumberHelper {
	
	func floatToString(beforeFormatted: Float) -> String {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = NumberFormatter.Style.decimal
		
		guard let finalNumber = numberFormatter.number(from: "\(beforeFormatted)") else {
			return "\(beforeFormatted)"
		}
		
		return String(describing: finalNumber)
	}

}
