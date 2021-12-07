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
	
	private let date: Date
	private let incomePerDay: Float
	private let expensePerDay: Float
	
	private let calendarHelper: CalendarHelper = CalendarHelper()
	
	init(date: Date = Date() , incomePerDay: Float = 0, expensePerDay: Float = 0) {
		self.date = date
		self.incomePerDay = incomePerDay
		self.expensePerDay = expensePerDay
		super.init()
		
		configureDatetext()
		configureIncomeAmount()
		configureExpenseAmount()
		borderWidth = 1
		borderColor = kayayuColor.softGrey.cgColor
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
		
		return mainSpec
	}
	
	private func configureDatetext() {
		let dayString = calendarHelper.dayOfDate(date: date)
		let monthString = calendarHelper.monthString(date: date)
		let formattedMonthString = monthString.prefix(3)

		dateText.attributedText = NSAttributedString.bold("\(dayString) \(formattedMonthString)", 15, .black)
		dateText.style.preferredSize = CGSize(width: 60, height: 20)
		dateText.style.alignSelf = .center
	}
	
	private func configureIncomeAmount() {
		totalIncomeAmount.attributedText = NSAttributedString.semibold("Rp\(incomePerDay)", 14, .systemGreen)
	}
	
	private func configureExpenseAmount() {
		totalExpenseAmount.attributedText = NSAttributedString.semibold("Rp\(expensePerDay)", 14, .systemRed)
	}
}
