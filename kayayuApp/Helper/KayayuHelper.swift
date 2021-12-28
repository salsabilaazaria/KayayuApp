//
//  KayayuHelper.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 24/11/21.
//

import Foundation
import UIKit

enum kayayuRatioTitle: String, CaseIterable {
	case all = "All"
	case needs = "Needs"
	case wants = "Wants"
	case savings = "Savings"
	
	static var incomeValues: [String] {
		return kayayuRatioTitle.allCases.map { $0.rawValue }
	}
	static let ratioCategory = [needs, wants, savings]
	
	static var ratioCategoryString: [String] {
		return ratioCategory.map{$0.rawValue}
	}
	
}

enum kayayuRatioValue: Float {
	case needs = 0.5
	case wants = 0.3
	case savings = 0.2
}

enum kayayuPaymentType: String, CaseIterable {
	case oneTime = "One Time"
	case subscription = "Subscription"
	case installment = "Installment"
	
	static var kayayuPaymentTypeValues: [String] {
		return kayayuPaymentType.allCases.map { $0.rawValue }
	}
	static let paymentTypeArr = [oneTime, subscription, installment]
	
}

struct kayayuSize {
	static let kayayuTabbarImageSize: CGSize = CGSize(width: 20, height: 20)
	static let kayayuTabBarSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
	static let nodeSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width - kayayuTabBarSize.height - 200)
	
	static let kayayuBarHeight: CGFloat = 30
	static let kayayuInputTextFieldBorderWidth: CGFloat = 0.2
	static let kayayuBigButtonBorderWidth: CGFloat = 0.2
	static let kayayuBigButton: CGFloat = 40
	
	static let bigInputTextField: CGSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 40)
	static let inputTextFieldSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 20)
	static let halfInputTextFieldSize: CGSize = CGSize(width: UIScreen.main.bounds.width/2 - 32, height: 20)
	
	static let dropdownSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 30)
	static let halfDropdownSize: CGSize = CGSize(width: UIScreen.main.bounds.width/2 - 32, height: 30)
	static let quarterDropdownSize: CGSize = CGSize(width: UIScreen.main.bounds.width/4 - 32, height: 30)
	
	static let dropdownRect: CGRect = CGRect(x: 3, y: 1, width: UIScreen.main.bounds.width - 32, height: 30)
	static let halfDropdownRect: CGRect = CGRect(x: 3, y: 1, width: UIScreen.main.bounds.width/2 - 32, height: 30)
	static let quarterDropdownRect: CGRect = CGRect(x: 3, y: 1, width: UIScreen.main.bounds.width/4 - 32, height: 30)
	
	static let inputTextFieldCornerRadius:CGFloat = 8.0
}

struct kayayuFont {
	static let inputTextFieldFont: UIFont = UIFont.systemFont(ofSize: 14)
}
