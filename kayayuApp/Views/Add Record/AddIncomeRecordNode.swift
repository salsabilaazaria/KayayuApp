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
	private let datePicker = UIDatePicker()
	override init() {
		super.init()
		automaticallyManagesSubnodes = true
		
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		let date = createDateInputSpec()
		let desc = configureDescInputTextField()
		let amount = configureAmountInputTextField()
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 10,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [date])
		
		let insetMainSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), child: mainSpec)
		return insetMainSpec
	}
	
	private func createDateInputSpec() -> ASLayoutSpec {
		configureDateInputTextField()
		let dateSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: spacingTitle,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [dateTitle, dateInputTextField])
		
		return dateSpec
	}
	
	private func configureDateInputTextField() {
	
		dateTitle.attributedText = NSAttributedString.bold("Date", 14, .black)
	
		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneKeyboardTapped))
		toolbar.setItems([doneButton], animated: true)
	
		datePicker.datePickerMode = .date
		datePicker.sizeToFit()
		if #available(iOS 13.4, *) {
			datePicker.preferredDatePickerStyle = .wheels
		}
		
		dateInputTextField.style.preferredSize = kayayuSize.inputTextFieldSize
		dateInputTextField.textView.text = "DD/MM/YYYY"
		dateInputTextField.textView.inputView = datePicker
		dateInputTextField.textView.inputAccessoryView = toolbar
		
	}
	
	@objc func doneKeyboardTapped() {
		dateInputTextField.textView.text = "\(datePicker.date)"
		self.dateInputTextField.view.endEditing(true)
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


