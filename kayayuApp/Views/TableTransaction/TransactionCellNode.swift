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
	
	private let ratio: ASTextNode = ASTextNode()
	private let notes: ASTextNode = ASTextNode()
	private let transactionAmount: ASTextNode = ASTextNode()
	
	init(isIncomeTransaction: Bool) {
		
		self.isIncomeTransaction = isIncomeTransaction
		
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
		
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0,
															   left: 8,
															   bottom: 0,
															   right: 8),
										  child: detailTransaction)
		
		return mainInset
		
	}
	
	private func configureRatio() {
		ratio.attributedText = NSAttributedString.normal("Savings", 14, .black)
		ratio.style.width = ASDimension(unit: .points, value: 60)
	}
	
	private func configureNotes() {
		notes.attributedText = NSAttributedString.normal("ayam bakar enak banget gaboong lalalallala lalalalalal lalalalalal lalalalalal lalalalalal", 12, .black)
		notes.style.width = ASDimension(unit: .points, value: 120)
	}
	
	private func configureTransactionAmount(isIncomeTransaction: Bool) {
		if isIncomeTransaction {
			transactionAmount.attributedText = NSAttributedString.normal("Rp1.000", 14, .systemGreen)
		} else {
			transactionAmount.attributedText = NSAttributedString.normal("Rp500.000", 14, .systemRed)
		}
		
	}
	
	
	
}

