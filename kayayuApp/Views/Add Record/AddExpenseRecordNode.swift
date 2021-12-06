//
//  AddExpenseRecordNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/11/21.
//

import Foundation
import AsyncDisplayKit
import iOSDropDown
import RxRelay
import RxSwift

class AddExpenseRecordNode: ASDisplayNode {
	private let dateTitle: ASTextNode = ASTextNode()
	private let descTitle: ASTextNode = ASTextNode()
	private let amountTitle: ASTextNode = ASTextNode()
	private let totalAmountTitle: ASTextNode = ASTextNode()
	private let interestTitle: ASTextNode = ASTextNode()
	
	private let dateInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let descriptionInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let amountInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let totalAmountInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let interestInputTextField: ASEditableTextNode = ASEditableTextNode()
	
	private let ratioTitle: ASTextNode = ASTextNode()
	private var ratioCategory: DropDown = DropDown()
	private let paymentTypeTitle: ASTextNode = ASTextNode()
	private var paymentType: DropDown = DropDown()
	private let tenorTitle: ASTextNode = ASTextNode()
	private var tenor: DropDown = DropDown()
	private let recurringTypeTitle: ASTextNode = ASTextNode()
	private var recurringType: DropDown = DropDown()
	
	private var saveButton: BigButton = BigButton()
	
	private let toolBar: UIToolbar = UIToolbar()
	
	private let spacingTitle: CGFloat = 6
	private let datePicker = UIDatePicker()
	private let calendarHelper = CalendarHelper()
	private var paymenTypeValue: BehaviorRelay<kayayuPaymentType> = BehaviorRelay<kayayuPaymentType>(value: .oneTime)
	
	private let disposeBag = DisposeBag()

	override init() {
		
		super.init()
		
		configureToolBar()
		configureSaveButton()
		configureObserver()
		
		backgroundColor = .white
		automaticallyManagesSubnodes = true
		
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let paymentType = createPaymentTypeSpec()
		let date = createDateInputSpec()
		let desc = createDescInputSpec()
		let category = createRatioCategorySpec()
		let amount = createAmountInputSpec()
		let totalAmount = createTotalAmountInputSpec()
		let recurringType = createRecurringTypeSpec()
		let interest = createInterestInputSpec()
		let tenorSpec = createTenorTypeSpec()
		
		var elementArray: [ASLayoutElement] = [paymentType, date, desc, category]
		
		switch paymenTypeValue.value {
			case .oneTime:
				elementArray.append(amount)
			case .subscription:
				elementArray.append(amount)
				elementArray.append(recurringType)
			case .installment:
				let amountInterestSpec = ASStackLayoutSpec(direction: .horizontal,
														   spacing: 12,
														   justifyContent: .start,
														   alignItems: .start,
														   children: [totalAmount, interest])
				elementArray.append(amountInterestSpec)
				let tenorRecurringTypeSpec = ASStackLayoutSpec(direction: .horizontal,
														   spacing: 12,
														   justifyContent: .start,
														   alignItems: .center,
														   children: [tenorSpec, recurringType])

				tenorSpec.style.flexGrow = 1
				elementArray.append(tenorRecurringTypeSpec)
			default:
				break;
		}
		
	
		let inputSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 10,
										 justifyContent: .start,
										 alignItems: .start,
										 children: elementArray)
		inputSpec.style.flexGrow = 1
		
		let saveButtonSpec = ASStackLayoutSpec(direction: .vertical,
											   spacing: spacingTitle,
											   justifyContent: .end,
											   alignItems: .end,
											   children: [saveButton])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 10,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [inputSpec, saveButtonSpec])
		
		mainSpec.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
		
		let insetMainSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 16, bottom: 48, right: 16), child: mainSpec)
		
		return insetMainSpec
	}
	
	private func configureSaveButton() {
		saveButton = BigButton(buttonText: "SAVE", buttonColor: kayayuColor.yellow, borderColor: kayayuColor.yellow)
	}
	
	@objc func saveButtonTapped() {
	
	}
	
	private func configureObserver() {
		paymenTypeValue.asObservable().distinctUntilChanged().subscribe(onNext: { value in
			self.setNeedsLayout()
//			self.layoutIfNeeded()
		}).disposed(by: disposeBag)
	}
	
	private func configureToolBar() {
		toolBar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneKeyboardTapped))
		toolBar.setItems([doneButton], animated: true)
	}
	
	@objc func doneKeyboardTapped() {
		let formattedDate = calendarHelper.formatFullDate(date: datePicker.date)
		dateInputTextField.textView.text = formattedDate
		self.view.endEditing(true)
	}
	
	private func createPaymentTypeSpec() -> ASLayoutSpec{
		configurePaymentType()
		let paymentTypeNode = ASDisplayNode()
		paymentTypeNode.view.addSubview(paymentType)
		paymentTypeNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 30)
		paymentTypeNode.borderWidth = 1
		paymentTypeNode.borderColor = kayayuColor.softGrey.cgColor
		
		let paymentTypeWrap = ASWrapperLayoutSpec(layoutElements: [paymentTypeNode])
		
		let paymentTypeSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: spacingTitle,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [paymentTypeTitle, paymentTypeWrap])
		
		return paymentTypeSpec
	}
	
	private func configurePaymentType() {
		paymentTypeTitle.attributedText = NSAttributedString.bold("Payment", 16, .black)
		
		paymentType = DropDown(frame: CGRect(x: 3, y: 1, width: UIScreen.main.bounds.width - 32, height: 30))
		paymentType.optionArray = kayayuPaymentType.kayayuPaymentTypeValues
		paymentType.selectedRowColor = kayayuColor.softGrey
		paymentType.checkMarkEnabled = false
		paymentType.font = UIFont.systemFont(ofSize: 14)
		paymentType.attributedText = NSAttributedString.init(string: paymenTypeValue.value.rawValue)
		paymentType.didSelect{ [weak self] (selectedText, index, id)  in
			
			guard let self = self else {
				return
			}
		
			self.paymenTypeValue.accept(kayayuPaymentType(rawValue: selectedText) ?? .oneTime)
	
		}
	}
	
	private func createRatioCategorySpec() -> ASLayoutSpec{
		configureRatioCategory()
		let ratioCategoryNode = ASDisplayNode()
		ratioCategoryNode.view.addSubview(ratioCategory)
		ratioCategoryNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 30)
		ratioCategoryNode.borderWidth = 1
		ratioCategoryNode.borderColor = kayayuColor.softGrey.cgColor
		
		let ratioCategoryWrap = ASWrapperLayoutSpec(layoutElements: [ratioCategoryNode])
		
		let ratioSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: spacingTitle,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [ratioTitle, ratioCategoryWrap])
		
		return ratioSpec
	}
	
	private func configureRatioCategory() {
		ratioTitle.attributedText = NSAttributedString.bold("Ratio", 16, .black)
		
		ratioCategory = DropDown(frame: CGRect(x: 3, y: 1, width: UIScreen.main.bounds.width - 32, height: 30))
		ratioCategory.optionArray = kayayuRatio.ratioCategoryString
		ratioCategory.selectedRowColor = kayayuColor.softGrey
		ratioCategory.checkMarkEnabled = false
		ratioCategory.font = UIFont.systemFont(ofSize: 14)
		ratioCategory.didSelect{(selectedText, index, id) in
			//logic if dropdown is selected
		}
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
	
		dateTitle.attributedText = NSAttributedString.bold("Date", 16, .black)
	
		datePicker.datePickerMode = .date
		datePicker.sizeToFit()
		if #available(iOS 13.4, *) {
			datePicker.preferredDatePickerStyle = .wheels
		}
		
		dateInputTextField.style.preferredSize = kayayuSize.inputTextFieldSize
		dateInputTextField.textView.sizeToFit()
		dateInputTextField.textView.text = "DD/MM/YYYY"
		dateInputTextField.textView.inputView = datePicker
		dateInputTextField.textView.inputAccessoryView = toolBar
		dateInputTextField.textView.font = kayayuFont.inputTextFieldFont

	}
	
	private func createDescInputSpec() -> ASLayoutSpec {
		configureDescInputTextField()
		let descSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: spacingTitle,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [descTitle, descriptionInputTextField])
		return descSpec
	}
	
	
	private func configureDescInputTextField() {
		descTitle.attributedText = NSAttributedString.bold("Description", 16, .black)
		
		descriptionInputTextField.maximumLinesToDisplay = 3
		descriptionInputTextField.style.preferredSize = kayayuSize.bigInputTextField
		descriptionInputTextField.borderWidth = 1
		descriptionInputTextField.borderColor = kayayuColor.softGrey.cgColor
		descriptionInputTextField.textView.inputAccessoryView = toolBar
		descriptionInputTextField.textView.font = kayayuFont.inputTextFieldFont
	
	}
	
	//OPTIONAL CONFIGURATION
	
	private func createAmountInputSpec() -> ASLayoutSpec {
		configureAmountInputTextField()
		
		let currceny = ASTextNode()
		currceny.attributedText = NSAttributedString.semibold("Rp", 14, .black)
		
		let amountTextField = ASStackLayoutSpec(direction: .horizontal,
												spacing: spacingTitle,
												justifyContent: .start,
												alignItems: .start,
												children: [currceny, amountInputTextField])
		
		let amountSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: spacingTitle,
										   justifyContent: .start,
										   alignItems: .start,
										   children: [amountTitle, amountTextField])
		
		return amountSpec
	}
	
	private func configureAmountInputTextField() {
		amountTitle.attributedText = NSAttributedString.bold("Amount", 16, .black)
		
		amountInputTextField.keyboardType = .numberPad
		amountInputTextField.maximumLinesToDisplay = 1
		amountInputTextField.style.preferredSize = kayayuSize.inputTextFieldSize
		amountInputTextField.textView.inputAccessoryView = toolBar
		amountInputTextField.textView.font = kayayuFont.inputTextFieldFont
		
	}
	
	private func createTotalAmountInputSpec() -> ASLayoutSpec {
		configureTotalAmountInputTextField()
		
		let currceny = ASTextNode()
		currceny.attributedText = NSAttributedString.semibold("Rp", 14, .black)
		
		let totalAmountTextField = ASStackLayoutSpec(direction: .horizontal,
												spacing: spacingTitle,
												justifyContent: .start,
												alignItems: .start,
												children: [currceny, totalAmountInputTextField])
		
		let totalAmountSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: spacingTitle,
										   justifyContent: .start,
										   alignItems: .start,
										   children: [totalAmountTitle, totalAmountTextField])
		
		return totalAmountSpec
	}
	
	private func configureTotalAmountInputTextField() {
		totalAmountTitle.attributedText = NSAttributedString.bold("Total Amount", 16, .black)
		
		totalAmountInputTextField.keyboardType = .numberPad
		totalAmountInputTextField.maximumLinesToDisplay = 1
		totalAmountInputTextField.style.preferredSize = CGSize(width: UIScreen.main.bounds.width/2 - 60 - totalAmountTitle.style.preferredSize.width, height: kayayuSize.inputTextFieldSize.height)
		totalAmountInputTextField.textView.inputAccessoryView = toolBar
		totalAmountInputTextField.textView.font = kayayuFont.inputTextFieldFont
		
	}
	
	private func createInterestInputSpec() -> ASLayoutSpec {
		configureInterestInputTextField()
		
		let percentage = ASTextNode()
		percentage.attributedText = NSAttributedString.semibold("%", 14, .black)
		
		let interestTextField = ASStackLayoutSpec(direction: .horizontal,
												spacing: spacingTitle,
												justifyContent: .start,
												alignItems: .start,
												children: [interestInputTextField, percentage])
		
		let interestSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: spacingTitle,
										   justifyContent: .start,
										   alignItems: .start,
										   children: [interestTitle, interestTextField])
		
		return interestSpec
	}
	
	private func configureInterestInputTextField() {
		interestTitle.attributedText = NSAttributedString.bold("Interest", 16, .black)
		
		interestInputTextField.keyboardType = .numberPad
		interestInputTextField.maximumLinesToDisplay = 1
		interestInputTextField.style.preferredSize = CGSize(width: UIScreen.main.bounds.width/2 - 80 - interestTitle.calculatedSize.width, height: 40)
		interestInputTextField.textView.inputAccessoryView = toolBar
		interestInputTextField.textView.font = kayayuFont.inputTextFieldFont
	}
	
	
	private func createTenorTypeSpec() -> ASLayoutSpec{
		configureTenor()
		let tenorTypeNode = ASDisplayNode()
		tenorTypeNode.view.addSubview(tenor)
		tenorTypeNode.style.preferredSize = kayayuSize.quarterDropdownSize
		tenorTypeNode.borderWidth = 1
		tenorTypeNode.borderColor = kayayuColor.softGrey.cgColor
		
		let tenorTypeWrap = ASWrapperLayoutSpec(layoutElements: [tenorTypeNode])
		
		 
		let tenorTypeSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: spacingTitle,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [tenorTitle, tenorTypeWrap])
		
		
		return tenorTypeSpec
	}
	
	private func configureTenor() {
		tenorTitle.attributedText = NSAttributedString.bold("Tenor", 16, .black)
		tenorTitle.style.preferredLayoutSize.width = ASDimension(unit: .points, value: kayayuSize.halfInputTextFieldSize.width)
		tenor = DropDown(frame: kayayuSize.quarterDropdownRect)
		//value tenor berapa aja?
		tenor.optionArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
		tenor.optionIds = [1,2,3,4,5,6,7,8,9,10,11,12]
		tenor.selectedRowColor = kayayuColor.softGrey
		tenor.checkMarkEnabled = false
		tenor.font = UIFont.systemFont(ofSize: 14)
		tenor.didSelect{(selectedText, index, id) in
			//logic if dropdown is selected
		}
	}
	
	private func createRecurringTypeSpec() -> ASLayoutSpec{
		configureRecurringType()
		let recurringTypeNode = ASDisplayNode()
	
		recurringTypeNode.view.addSubview(recurringType)
		switch paymenTypeValue.value {
			case .oneTime,.subscription:
				recurringTypeNode.style.preferredSize = kayayuSize.dropdownSize
			case .installment:
				recurringTypeNode.style.preferredSize = kayayuSize.halfDropdownSize
		}
		recurringTypeNode.borderWidth = 1
		recurringTypeNode.borderColor = kayayuColor.softGrey.cgColor
		
		let recurringTypeWrap = ASWrapperLayoutSpec(layoutElements: [recurringTypeNode])
		
		let recurringTypeSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: spacingTitle,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [recurringTypeTitle, recurringTypeWrap])
		
		return recurringTypeSpec
	}
	
	private func configureRecurringType() {
		recurringTypeTitle.attributedText = NSAttributedString.bold("Type", 16, .black)
		
		switch paymenTypeValue.value {
			case .oneTime,.subscription:
				recurringType = DropDown(frame: kayayuSize.dropdownRect)
			case .installment:
				recurringType = DropDown(frame: kayayuSize.halfDropdownRect)
		}
		
		//value tenor berapa aja?
		recurringType.optionArray = ["Monthly", "Yearly"]
//		installmentType.optionIds = [1,2,3,4,5,6,7,8,9,10,11,12]
		recurringType.selectedRowColor = kayayuColor.softGrey
		recurringType.checkMarkEnabled = false
		recurringType.font = UIFont.systemFont(ofSize: 14)
		recurringType.didSelect{(selectedText, index, id) in
			//logic if dropdown is selected
		}
	}
	
	
}
