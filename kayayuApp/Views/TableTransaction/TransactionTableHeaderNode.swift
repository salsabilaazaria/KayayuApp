//
//  TransactionTableHeaderNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 18/11/21.
//

import Foundation
import AsyncDisplayKit

class TransactionTableHeaderNode: ASCellNode {
	var changeMonthData: ((Date) -> Void)?
	
	private let dateText: ASTextNode = ASTextNode()
	private let prevButton: ASButtonNode = ASButtonNode()
	private let nextButton: ASButtonNode = ASButtonNode()
	
	private let incomeTitle: ASTextNode = ASTextNode()
	private let incomeAmount: ASTextNode = ASTextNode()
	private let expenseTitle: ASTextNode = ASTextNode()
	private let expenseAmount: ASTextNode = ASTextNode()
	private let totalTitle: ASTextNode = ASTextNode()
	private let totalAmount: ASTextNode = ASTextNode()
	private let transactionIcon: ASImageNode = ASImageNode()
	private let backgroundSummary: ASDisplayNode = ASDisplayNode()
	
	private let viewModel: HomeViewModel
	
	private let calendarHelper: CalendarHelper = CalendarHelper()
	private let numberHelper: NumberHelper = NumberHelper()
	
	private var selectedDate: Date = Date()
	
	private let buttonSize = CGSize(width: 30, height: 30)
	
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		super.init()
		
		configurePrevBtn()
		configureNextBtn()
		configureDateText()
		configureViewModel()
		
		backgroundColor = kayayuColor.softGrey
//		style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let headerSpec = ASWrapperLayoutSpec(layoutElement: makeHeaderTitle())
		let summarySpec = makeSummarySpec()
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 10,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [headerSpec, summarySpec])
		
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16,
															   left: 16,
															   bottom: 0,
															   right: 16),
										  child: mainSpec)
		
		return mainInset
	}
	
	private func configureViewModel() {
		viewModel.reloadUI = { [weak self] in
			self?.configureIncomeText()
			self?.configureExpenseText()
			
		}
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
		let monthYear = "\(calendarHelper.monthString(date: selectedDate)) \(calendarHelper.yearString(date: selectedDate))"
	
		dateText.attributedText = NSAttributedString.bold("\(monthYear)", 17, .black)
	}
	
	private func configurePrevBtn() {
		prevButton.setImage(UIImage(named: "backArrowBtn.png"), for: .normal)
		prevButton.imageNode.style.preferredSize = buttonSize
		prevButton.style.preferredSize = buttonSize
		prevButton.addTarget(self, action: #selector(prevMonthTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func prevMonthTapped(sender: ASButtonNode) {
		selectedDate = CalendarHelper().minusMonth(date: selectedDate)
		self.changeMonthData?(selectedDate)
		configureDateText()
	}
	
	
	private func configureNextBtn() {
		nextButton.setImage(UIImage(named: "nextArrowBtn.png"), for: .normal)
		nextButton.style.preferredSize = buttonSize
		nextButton.imageNode.style.preferredSize = buttonSize
		nextButton.addTarget(self, action: #selector(nextMonthTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func nextMonthTapped(sender: ASButtonNode) {
		selectedDate = CalendarHelper().plusMonth(date: selectedDate)
		self.changeMonthData?(selectedDate)
		configureDateText()
	}
	
	private func makeSummarySpec() -> ASLayoutSpec {
		transactionIcon.image = UIImage(named: "transactionIcon.png")
		transactionIcon.style.preferredSize = CGSize(width: 80, height: 80)
		
		backgroundSummary.backgroundColor = .white
		backgroundSummary.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 110)
		
		let incomeSpec = configureIncomeText()
		let expenseSpec = configureExpenseText()
		let totalSpec = configureTotalText()
		
		let summaryInfoSpec = ASStackLayoutSpec(direction: .vertical,
											spacing: 8,
											justifyContent: .start,
											alignItems: .stretch,
											children: [incomeSpec,expenseSpec,totalSpec])
		
		summaryInfoSpec.style.flexGrow = 1
		let summarySpec = ASStackLayoutSpec(direction: .horizontal,
											spacing: 8,
											justifyContent: .center,
											alignItems: .center,
											children: [transactionIcon, summaryInfoSpec])
		
		summarySpec.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
		
		let summaryInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), child: summarySpec)
		
		let summaryOverlay = ASOverlayLayoutSpec(child: backgroundSummary, overlay: summaryInset)
		
		return summaryOverlay
		
	}
	
	private func configureIncomeText() -> ASLayoutSpec {
		let incomePerMonth = viewModel.calculateIncomePerMonth(date: selectedDate)
		let formattedIncome = numberHelper.floatToIdFormat(beforeFormatted: incomePerMonth)
		
		incomeTitle.attributedText = NSAttributedString.normal("Income", 14, .black)
		incomeAmount.attributedText = NSAttributedString.normal("Rp\(formattedIncome)", 14, .systemGreen)
		
		let incomeAmountSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .end, alignItems: .end, children: [incomeAmount])
		incomeAmountSpec.style.flexGrow = 1
		
		let incomeSpec = ASStackLayoutSpec(direction: .horizontal,
										   spacing: 5,
										   justifyContent: .start,
										   alignItems: .start,
										   children: [incomeTitle, incomeAmountSpec])
		
		return incomeSpec
	}
	
	private func configureExpenseText() -> ASLayoutSpec {
		let expensePerMonth = viewModel.calculateExpensePerMonth(date: selectedDate)
		let formattedExpense = numberHelper.floatToIdFormat(beforeFormatted: expensePerMonth)
		
		expenseTitle.attributedText = NSAttributedString.normal("Expense", 14, .black)
		expenseAmount.attributedText = NSAttributedString.normal("Rp\(formattedExpense)", 14, .systemRed)
		
		let expenseAmountSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .end, alignItems: .end, children: [expenseAmount])
		expenseAmountSpec.style.flexGrow = 1
		
		let expenseSpec = ASStackLayoutSpec(direction: .horizontal,
										   spacing: 5,
										   justifyContent: .center,
										   alignItems: .center,
										   children: [expenseTitle, expenseAmountSpec])
		
		return expenseSpec
		
	}
	
	private func configureTotalText() -> ASLayoutSpec {
		let total = viewModel.calculateTotalPerMonth(date: selectedDate)
		let formattedTotal = numberHelper.floatToIdFormat(beforeFormatted: total)
		
		totalTitle.attributedText = NSAttributedString.semibold("Total", 14, .black)
		totalAmount.attributedText = NSAttributedString.semibold("Rp\(formattedTotal)", 14, .black)
		
		let totalAmountSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .end, alignItems: .end, children: [totalAmount])
		totalAmountSpec.style.flexGrow = 1
		
		let totalSpec = ASStackLayoutSpec(direction: .horizontal,
										   spacing: 5,
										   justifyContent: .center,
										   alignItems: .center,
										   children: [totalTitle, totalAmountSpec])
		
		return totalSpec
	}
	
	
	
}
