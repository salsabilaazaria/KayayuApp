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
	static let lightYellow = ColorHelper.hexToColor(hex: "#FFF7D9")
	static let softGrey = ColorHelper.hexToColor(hex: "#F2F2F2")
	static let borderInputTextField: UIColor = .darkGray
	
	static let needsLight = ColorHelper.hexToColor(hex: "#CFDDEA")
	static let needsDark = ColorHelper.hexToColor(hex: "#1977CD")
	
	static let wantsLight = ColorHelper.hexToColor(hex: "#E5CFE2")
	static let wantsDark = ColorHelper.hexToColor(hex: "#B01898")
	
	static let savingsLight = ColorHelper.hexToColor(hex: "#CDE4D8")
	static let savingsDark = ColorHelper.hexToColor(hex: "#0FA958")
	
	static let pieCharArrColor = [kayayuColor.needsDark,kayayuColor.wantsDark,kayayuColor.savingsDark]

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

		 var rgbValue:UInt32 = 0
		 Scanner(string: cString).scanHexInt32(&rgbValue)

		 return UIColor(
			 red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			 green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			 blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			 alpha: CGFloat(1.0)
		 )
	 }
}
