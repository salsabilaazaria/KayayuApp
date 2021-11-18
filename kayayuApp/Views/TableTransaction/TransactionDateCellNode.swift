//
//  TransactionDateCellNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 18/11/21.
//

import Foundation
import AsyncDisplayKit

class TransactionDateCellNode: ASCellNode {
	private let totalIncomeAmount: ASTextNode = ASTextNode()
	private let totalExpenseAmount: ASTextNode = ASTextNode()
	private let dateText: ASTextNode = ASTextNode()
	
	override init() {
		
		super.init()
		
		configureDatetext()
		configureIncomeAmount()
		configureExpenseAmount()
		
		backgroundColor = .white
		automaticallyManagesSubnodes = true
		
		style.minHeight = ASDimension(unit: .points, value: 30)
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let incomeExpenseSpec = ASStackLayoutSpec(direction: .horizontal,
												  spacing: 8,
												  justifyContent: .end,
												  alignItems: .end,
												  children: [totalIncomeAmount, totalExpenseAmount])

		incomeExpenseSpec.style.flexGrow = 1

		let dateSpec = ASStackLayoutSpec(direction: .horizontal,
		spacing: 0,
								justifyContent: .center,
								alignItems: .center,
								children: [dateText])

		
		let mainSpec = ASStackLayoutSpec(direction: .horizontal,
										 spacing: 16,
										 justifyContent: .center,
										 alignItems: .center,
										 children: [dateSpec, incomeExpenseSpec])
		
		mainSpec.alignItems = .center
		
		mainSpec.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 24, height: 30)
		
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0,
															   left: 8,
															   bottom: 0,
															   right: 8),
										  child: mainSpec)
		
		
		return mainInset
	}
	
	private func configureDatetext() {
		dateText.attributedText = NSAttributedString.bold("01 MON", 15, .black)
		dateText.style.preferredSize = CGSize(width: 60, height: 20)
		dateText.style.alignSelf = .center
	}
	
	private func configureIncomeAmount() {
		totalIncomeAmount.attributedText = NSAttributedString.bold("Rp1.000.000.000", 14, .systemGreen)
	}
	
	private func configureExpenseAmount() {
		totalExpenseAmount.attributedText = NSAttributedString.bold("Rp1.000.000.000", 14, .systemRed)
	}
}
