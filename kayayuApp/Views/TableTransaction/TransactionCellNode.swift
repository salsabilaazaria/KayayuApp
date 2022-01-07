//
//  TransactionDetailCellNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 15/11/21.
//

import Foundation
import AsyncDisplayKit

class TransactionCellNode: ASCellNode {
	private var isIncomeTransaction: Bool
	
	private let ratio: ASTextNode = ASTextNode()
	private let notes: ASTextNode = ASTextNode()
	private let recurringDesc: ASTextNode = ASTextNode()
	private let transactionAmount: ASTextNode = ASTextNode()
	private let transactionData: Transactions
	
	private let numberHelper: NumberHelper = NumberHelper()
	
	init(isIncomeTransaction: Bool, data: Transactions) {
		self.isIncomeTransaction = isIncomeTransaction
		self.transactionData = data
		
		super.init()
		
		configureRatio()
		configureNotes()
		configureTransactionAmount(isIncomeTransaction: self.isIncomeTransaction)
		
		backgroundColor = .white
		automaticallyManagesSubnodes = true
		
		style.minHeight = ASDimension(unit: .points, value: 30)
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let transactionSpec = ASStackLayoutSpec(direction: .horizontal,
												spacing: 8,
												justifyContent: .end,
												alignItems: .end,
												children: [transactionAmount])
		
		transactionSpec.style.flexGrow = 1
		notes.style.flexGrow = 1
		
		
		var detailTransElement: [ASLayoutElement] = [ratio]
		
		if let isRecurring = transactionData.recurring_flag, isRecurring {
			recurringDesc.attributedText = NSAttributedString.normal("Recurring", 11, .darkGray)
			
			let transactionSpec = ASStackLayoutSpec(direction: .vertical,
													spacing: 4,
													justifyContent: .start,
													alignItems: .stretch,
													children: [recurringDesc, notes])
			detailTransElement.append(transactionSpec)
		} else {
			detailTransElement.append(notes)
		}
		detailTransElement.append(transactionSpec)
		
		let detailTransaction = ASStackLayoutSpec(direction: .horizontal,
												  spacing: 16,
												  justifyContent: .center,
												  alignItems: .start,
												  children: detailTransElement)
		
		detailTransaction.alignItems = .center
		
		detailTransaction.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 24, height: 60)
		
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 0,
										  justifyContent: .center,
										  alignItems: .center,
										  children: [detailTransaction])
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0,
															   left: 8,
															   bottom: 0,
															   right: 8),
										  child: mainStack)
		
		return mainInset
		
	}
	
	private func configureRatio() {
		guard let ratioString = transactionData.category?.capitalized else {
			return
		}
		ratio.attributedText = NSAttributedString.normal(ratioString, 14, .black)
		ratio.style.width = ASDimension(unit: .points, value: 60)
	}
	
	private func configureNotes() {
		guard let notesString = transactionData.description else {
			return
		}
		
		notes.attributedText = NSAttributedString.normal(notesString, 12, .black)
		notes.style.width = ASDimension(unit: .points, value: 120)
	}
	
	private func configureTransactionAmount(isIncomeTransaction: Bool) {
		guard let amount = transactionData.amount else {
			return
		}
		
		let formattedAmount = numberHelper.floatToIdFormat(beforeFormatted: amount)
        
		if isIncomeTransaction {
            transactionAmount.attributedText = NSAttributedString.normal("\(formattedAmount)", 14, .systemGreen)
		} else {
            transactionAmount.attributedText = NSAttributedString.normal("\(formattedAmount)", 14, .systemRed)
		}
		
	}
	
	
	
}

