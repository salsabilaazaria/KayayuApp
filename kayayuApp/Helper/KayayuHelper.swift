//
//  KayayuHelper.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 24/11/21.
//

import Foundation
import UIKit

enum kayayuRatio: String, CaseIterable {
	case all = "All"
	case needs = "Needs"
	case wants = "Wants"
	case savings = "Savings"
	
	static var incomeValues: [String] {
		return kayayuRatio.allCases.map { $0.rawValue }
}
	static let ratioCategory = [needs, wants, savings]
	
}

struct kayayuSize {
	static let kayayuBarHeight: CGFloat = 30
	static let kayayuBorderWidth: CGFloat = 0.2
	static let kayayuBigButton: CGFloat = 40
	static let bigInputTextField: CGSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 40)
	static let inputTextFieldSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 20)
}

struct kayayuFont {
	static let inputTextFieldFont: UIFont = UIFont.systemFont(ofSize: 14)
}
