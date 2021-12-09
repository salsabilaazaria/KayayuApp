//
//  colorHelper.swift
//  KayayuApp
//
//  Created by Salsabila Azaria on 11/8/21.
//

import Foundation
import UIKit

struct kayayuColor {
	static let yellow = ColorHelper.hexToColor(hex: "#FFCC00")
	static let softGrey = ColorHelper.hexToColor(hex: "#F2F2F2")
	
	static let needsLight = ColorHelper.hexToColor(hex: "#bedaed")
	static let needsDark = ColorHelper.hexToColor(hex: "#4081ad")
	
	
	static let wantsLight = ColorHelper.hexToColor(hex: "#ffa8f0")
	static let wantsDark = ColorHelper.hexToColor(hex: "#a63f94")
	
	
	static let savingsLight = ColorHelper.hexToColor(hex: "#f6f781")
	static let savingsDark = ColorHelper.hexToColor(hex: "#8a8a2f")
	
	static let pieCharArrColor = [kayayuColor.needsLight,kayayuColor.wantsLight,kayayuColor.savingsLight]

}

class ColorHelper {
	
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
