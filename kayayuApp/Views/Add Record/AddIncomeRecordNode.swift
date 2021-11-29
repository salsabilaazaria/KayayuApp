//
//  AddIncomeRecord.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/11/21.
//
import Foundation
import AsyncDisplayKit

class AddIncomeRecordNode: ASDisplayNode {
	private let dateTitle: ASTextNode = ASTextNode()
	private let descTitle: ASTextNode = ASTextNode()
	private let amountTitle: ASTextNode = ASTextNode()
	
	private let dateInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let descriptionInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let amountInputTextField: ASEditableTextNode = ASEditableTextNode()
	
	private let spacingTitle: CGFloat = 6
	
	override init() {
		super.init()
		backgroundColor = .blue

		automaticallyManagesSubnodes = true
		
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		let date = configureDateInputTextField()
		let desc = configureDescInputTextField()
		let amount = configureAmountInputTextField()
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 10,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [date,desc,amount])
		return mainSpec
	}
	
	private func configureDateInputTextField() -> ASLayoutSpec {
		dateTitle.attributedText = NSAttributedString.bold("Date", 14, .black)
		
		dateInputTextField.maximumLinesToDisplay = 1
		dateInputTextField.style.preferredSize = kayayuSize.inputTextFieldSize
		
		let dateSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: spacingTitle,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [dateTitle, dateInputTextField])
		
		return dateSpec
	}
	
	private func configureDescInputTextField() -> ASLayoutSpec {
		descTitle.attributedText = NSAttributedString.bold("Description", 14, .black)
		
		descriptionInputTextField.maximumLinesToDisplay = 3
		descriptionInputTextField.style.preferredSize = kayayuSize.inputTextFieldSize
		
		let descSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: spacingTitle,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [descTitle, descriptionInputTextField])
		
		return descSpec
	}
	
	private func configureAmountInputTextField() -> ASLayoutSpec {
		amountTitle.attributedText = NSAttributedString.bold("Amount", 14, .black)
		
		amountInputTextField.maximumLinesToDisplay = 1
		amountInputTextField.style.preferredSize = kayayuSize.inputTextFieldSize
		
		let amountSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: spacingTitle,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [amountTitle, amountInputTextField])
		
		return amountSpec
		
	}
	
}


