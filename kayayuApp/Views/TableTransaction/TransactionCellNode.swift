//
//  TransactionDetailCellNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 15/11/21.
//

import Foundation
import AsyncDisplayKit

//enum transactionCellType {
//	case dateTransaction
//	case detailTransaction
//}

class TransactionCellNode: ASCellNode {
	private let isIncomeTransaction: Bool
	private let isDate: Bool
	
	private let dateCellNode: TransactionDateCellNode = TransactionDateCellNode()
	private let ratio: ASTextNode = ASTextNode()
	private let notes: ASTextNode = ASTextNode()
	private let transactionAmount: ASTextNode = ASTextNode()
	private let transactionData: Transactions
	
	init(isIncomeTransaction: Bool, isDate: Bool, data: Transactions) {
		
		self.isIncomeTransaction = isIncomeTransaction
		self.transactionData = data
		self.isDate = isDate
		
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
		
		let detailTransaction = ASStackLayoutSpec(direction: .horizontal,
												  spacing: 16,
												  justifyContent: .center,
												  alignItems: .start,
												  children: [ratio, notes, transactionSpec])
		
		detailTransaction.alignItems = .center
		
		detailTransaction.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 24, height: 60)
		
		var mainArray: [ASLayoutElement]
		
		if isDate {
			mainArray = [dateCellNode, detailTransaction]
		} else {
			mainArray = [detailTransaction]
		}
		
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 0,
										  justifyContent: .center,
										  alignItems: .center,
										  children: mainArray)
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0,
															   left: 8,
															   bottom: 0,
															   right: 8),
										  child: mainStack)
		
		return mainInset
		
	}
	
	private func configureRatio() {
		guard let ratioString = transactionData.category else {
			return
		}
		ratio.attributedText = NSAttributedString.normal(ratioString, 14, .black)
		ratio.style.width = ASDimension(unit: .points, value: 60)
	}
	
	private func configureNotes() {
		notes.attributedText = NSAttributedString.normal("ayam bakar enak banget gaboong lala", 12, .black)
		notes.style.width = ASDimension(unit: .points, value: 120)
	}
	
	private func configureTransactionAmount(isIncomeTransaction: Bool) {
		guard let amount = transactionData.amount else {
			return
		}
		if isIncomeTransaction {
			transactionAmount.attributedText = NSAttributedString.normal("Rp\(amount)", 14, .systemGreen)
		} else {
			transactionAmount.attributedText = NSAttributedString.normal("Rp\(amount)", 14, .systemRed)
		}
		
	}
	
	
	
}

