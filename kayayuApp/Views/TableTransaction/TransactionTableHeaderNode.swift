//
//  TransactionTableHeaderNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 18/11/21.
//

import Foundation
import AsyncDisplayKit

class TransactionTableHeaderNode: ASCellNode {
	private let dateText: ASTextNode = ASTextNode()
	private let prevButton: ASButtonNode = ASButtonNode()
	private let nextButton: ASButtonNode = ASButtonNode()
	
	private let incomeTitle: ASTextNode = ASTextNode()
	private let incomeAmount: ASTextNode = ASTextNode()
	private let expenseTitle: ASTextNode = ASTextNode()
	private let expenseAmount: ASTextNode = ASTextNode()
	private let totalTitle: ASTextNode = ASTextNode()
	private let totalAmount: ASTextNode = ASTextNode()
	private let backgroundSummary: ASDisplayNode = ASDisplayNode()
	
	private let buttonSize = CGSize(width: 30, height: 30)
	
	override init() {
		super.init()
		
		configurePrevBtn()
		configureNextBtn()
		configureDateText()
		
		backgroundColor = kayayuColor.softGrey
		style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let headerSpec = ASWrapperLayoutSpec(layoutElement: makeHeaderTitle())
		let summarySpec = makeSummarySpec()
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 10,
										 justifyContent: .center,
										 alignItems: .start,
										 children: [headerSpec, summarySpec])
		
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0,
															   left: 16,
															   bottom: 0,
															   right: 16),
										  child: mainSpec)
		
		return mainInset
	}
	
	private func makeHeaderTitle() -> ASLayoutSpec {
		
		let buttonStack = ASStackLayoutSpec(direction: .horizontal,
											spacing: 10,
											justifyContent: .center,
											alignItems: .end,
											children: [prevButton, nextButton])
		
		buttonStack.style.preferredSize = CGSize(width: 80, height: 30)

		dateText.style.flexGrow = 1

		let headerStack = ASStackLayoutSpec(direction: .horizontal,
											spacing: 5,
											justifyContent: .center,
											alignItems: .center,
											children: [dateText, buttonStack])
		
		headerStack.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
		
		return headerStack
	}
	
	private func configureDateText() {
		dateText.attributedText = NSAttributedString.bold("JULY 2021", 17, .black)
	}
	
	private func configurePrevBtn() {
		prevButton.setImage(UIImage(named: "backArrowBtn.png"), for: .normal)
		prevButton.imageNode.style.preferredSize = buttonSize
		prevButton.style.preferredSize = buttonSize
	}
	
	private func configureNextBtn() {
		nextButton.setImage(UIImage(named: "nextArrowBtn.png"), for: .normal)
		nextButton.style.preferredSize = buttonSize
		nextButton.imageNode.style.preferredSize = buttonSize
	}
	
	
	private func makeSummarySpec() -> ASLayoutSpec {
		backgroundSummary.backgroundColor = .white
		backgroundSummary.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
		
		let incomeSpec = configureIncomeText()
		let expenseSpec = configureExpenseText()
		let totalSpec = configureTotalText()
		
		let summarySpec = ASStackLayoutSpec(direction: .horizontal,
											spacing: 30,
											justifyContent: .center,
											alignItems: .center,
											children: [incomeSpec,expenseSpec,totalSpec])
		
		let summaryOverlay = ASOverlayLayoutSpec(child: backgroundSummary, overlay: summarySpec)
		
		return summaryOverlay
		
	}
	
	private func configureIncomeText() -> ASLayoutSpec {
		incomeTitle.attributedText = NSAttributedString.bold("Income", 14, .systemGreen)
		incomeAmount.attributedText = NSAttributedString.semibold("Rp1.000.000", 14, .systemGreen)
		
		let incomeSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: 5,
										   justifyContent: .center,
										   alignItems: .center,
										   children: [incomeTitle, incomeAmount])
		
		return incomeSpec
	}
	
	private func configureExpenseText() -> ASLayoutSpec {
		expenseTitle.attributedText = NSAttributedString.bold("Expense", 14, .systemRed)
		expenseAmount.attributedText = NSAttributedString.semibold("Rp600.000", 14, .systemRed)
		
		let expenseSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: 5,
										   justifyContent: .center,
										   alignItems: .center,
										   children: [expenseTitle, expenseAmount])
		
		return expenseSpec
		
	}
	
	private func configureTotalText() -> ASLayoutSpec {
		totalTitle.attributedText = NSAttributedString.bold("Total", 14, .black)
		totalAmount.attributedText = NSAttributedString.semibold("Rp400.000", 14, .black)
		
		let totalSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: 5,
										   justifyContent: .center,
										   alignItems: .center,
										   children: [totalTitle, totalAmount])
		
		return totalSpec
	}
	
	
	
}