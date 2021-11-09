//
//  colorHelper.swift
//  KayayuApp
//
//  Created by Salsabila Azaria on 11/8/21.
//

import Foundation
import UIKit

struct kayayuColor {
	static let yellow = colorHelper.hexToColor(hex: "#FFCC00")
	static let softGrey = colorHelper.hexToColor(hex: "#F2F2F2")
}

class colorHelper {
	
	static func hexToColor(hex: String) -> UIColor {
		var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

		 if (cString.hasPrefix("#")) {
			 cString.remove(at: cString.startIndex)
		 }

		 if ((cString.count) != 6) {
			 return UIColor.gray
		 }

		 var rgbValue:UInt64 = 0
		 Scanner(string: cString).scanHexInt64(&rgbValue)

		 return UIColor(
			 red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			 green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			 blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			 alpha: CGFloat(1.0)
		 )
	 }
}
