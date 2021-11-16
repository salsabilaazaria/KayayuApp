//
//  TransactionDetailCellNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 15/11/21.
//

import Foundation
import AsyncDisplayKit

class TransactionDetailCellNode: ASCellNode {
	
	private let ratio: ASTextNode = ASTextNode()
	private let notes: ASTextNode = ASTextNode()
	private let incomeAmount: ASTextNode = ASTextNode()
	private let expenseAmount: ASTextNode = ASTextNode()
	
	override init() {
		super.init()
		configureRatio()
		configureNotes()
		configureIncomeAmount()
		configureExpenseAmount()
		backgroundColor = .white
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		print("TRANSACTION DETAIL CELL NODE")
		let incomeExpenseSpec = ASStackLayoutSpec(direction: .horizontal,
												  spacing: 8,
												  justifyContent: .center,
												  alignItems: .center,
												  children: [incomeAmount, expenseAmount])
		
		let detailTransaction = ASStackLayoutSpec(direction: .horizontal,
										 spacing: 16,
										 justifyContent: .center,
										 alignItems: .start,
										 children: [ratio, notes, incomeExpenseSpec])
		return detailTransaction
	}
	
	private func configureRatio() {
		ratio.attributedText = NSAttributedString.normal("Needs", 12, .black)
	}
	
	private func configureNotes() {
		notes.attributedText = NSAttributedString.normal("ayam bakar enak banget gaboong lalalallalalalalalalal", 12, .black)
		notes.style.preferredSize = CGSize(width: 100, height: 50)
	
	}
	
	private func configureIncomeAmount() {
		incomeAmount.attributedText = NSAttributedString.normal("Rp1.000.000.000", 12, .systemGreen)
	}
	
	private func configureExpenseAmount() {
		expenseAmount.attributedText = NSAttributedString.normal("Rp1.000.000.000", 12, .systemRed)
	}
	
}

