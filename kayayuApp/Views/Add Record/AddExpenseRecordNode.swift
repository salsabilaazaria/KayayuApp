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
	var onOpenHomePage: (() -> Void)?
	var onErrorData: (() -> Void)?
	var showPaymentTypeHelper: (() -> Void)?
	
	private let dateTitle: ASTextNode = ASTextNode()
	private let descTitle: ASTextNode = ASTextNode()
	private let amountTitle: ASTextNode = ASTextNode()
	private let totalAmountTitle: ASTextNode = ASTextNode()
	private let interestTitle: ASTextNode = ASTextNode()
	private let durationTitle: ASTextNode = ASTextNode()
	
	private let dateInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let descriptionInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let amountInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let totalAmountInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let interestInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let durationInputTextField: ASEditableTextNode = ASEditableTextNode()
	
	private let ratioTitle: ASTextNode = ASTextNode()
	private var ratioCategory: DropDown = DropDown()
	private let paymentTypeTitle: ASTextNode = ASTextNode()
	private var paymentType: DropDown = DropDown()
	private var durationInputTextfield: ASEditableTextNode = ASEditableTextNode()
	private let billingTypeTitle: ASTextNode = ASTextNode()
	private var billingType: DropDown = DropDown()
	
	private let dateDescription: ASTextNode = ASTextNode()
	private let paymenTypeHelperIcon: ASButtonNode = ASButtonNode()
	
	private var saveButton: BigButton = BigButton()
	
	private let toolBar: UIToolbar = UIToolbar()
	
	private let scrollNode: ASScrollNode = ASScrollNode()
	
	private let spacingTitle: CGFloat = 8
	private let horizontalSpace: CGFloat = 12
	private let textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
	
	private let datePicker = UIDatePicker()
	private let calendarHelper = CalendarHelper()
	private var paymenTypeValue: BehaviorRelay<kayayuPaymentType> = BehaviorRelay<kayayuPaymentType>(value: .oneTime)
	private var ratio: String?
	private var billingTypeString: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
	
	private let numberHelper: NumberHelper = NumberHelper()
	private let disposeBag = DisposeBag()
	private let viewModel: HomeViewModel

	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		
		super.init()
		
		configureToolBar()
		configureSaveButton()
		configureObserver()
		configureViewModel()
		configureDateInputTextField()
		configureRatioCategory()
		configureAmountInputTextField()
		configureTenor()
		configureInterestInputTextField()
		
		backgroundColor = .white
		automaticallyManagesSubnodes = true
		
	}
	
	private func reloadUI() {
		self.setNeedsLayout()
		self.layoutIfNeeded()
		self.scrollNode.setNeedsLayout()
		self.scrollNode.layoutIfNeeded()
	}
	
	private func configureObserver() {
		paymenTypeValue.asObservable().distinctUntilChanged().subscribe(onNext: { value in
			self.billingTypeString.accept(nil)
			self.reloadUI()
		}).disposed(by: disposeBag)
		
		billingTypeString.asObservable().distinctUntilChanged().subscribe(onNext: { value in
			self.reloadUI()
		}).disposed(by: disposeBag)
	}
	
	
	private func configureViewModel() {
		viewModel.onOpenHomePage = { [weak self] in
			self?.onOpenHomePage?()
		}
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		configureScrollNode()
		return ASInsetLayoutSpec(insets: UIEdgeInsets.zero, child: scrollNode)
	}
	
	private func configureScrollNode() {
		scrollNode.automaticallyManagesSubnodes = true
		scrollNode.automaticallyManagesContentSize = true
		scrollNode.scrollableDirections = [.up, .down]
		scrollNode.style.flexGrow = 1.0
		scrollNode.style.flexShrink = 1.0
		scrollNode.view.bounces = true
		scrollNode.view.showsVerticalScrollIndicator = true
		scrollNode.view.isScrollEnabled = true
		scrollNode.layoutSpecBlock = { [weak self] _, constrainedSize in
			return (self?.createInputSpec(constrainedSize) ?? ASLayoutSpec())
		}
	}
	
	private func createInputSpec(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let paymentType = createPaymentTypeSpec()
		let date = createDateInputSpec()
		let desc = createDescInputSpec()
		let category = createRatioCategorySpec()
		let amount = createAmountInputSpec()
		let totalAmount = createTotalAmountInputSpec()
		let recurringType = createBillingTypeSpec()
		let interest = createInterestInputSpec()
		let tenorSpec = createDurationTypeSpec()
		
		var elementArray: [ASLayoutElement] = [date, paymentType, desc, category]

		switch paymenTypeValue.value {
			case .oneTime:
				elementArray.append(amount)
			case .subscription:
				elementArray.append(recurringType)
				elementArray.append(tenorSpec)
				elementArray.append(amount)
			case .installment:
				elementArray.append(recurringType)
				elementArray.append(tenorSpec)
				let amountInterestSpec = ASStackLayoutSpec(direction: .horizontal,
														   spacing: horizontalSpace,
														   justifyContent: .start,
														   alignItems: .start,
														   children: [totalAmount, interest])
				elementArray.append(amountInterestSpec)
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
										 spacing: 32,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [inputSpec, saveButtonSpec])
		
		let insetMainSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), child: mainSpec)
		
		return insetMainSpec
	}
	
	private func configureSaveButton() {
		saveButton = BigButton(buttonText: "SAVE", buttonColor: kayayuColor.yellow, borderColor: kayayuColor.yellow)
		saveButton.addTarget(self, action: #selector(saveButtonTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func saveButtonTapped() {
		let paymentType = self.paymenTypeValue.value
			
		guard let category = ratio?.lowercased(),
			  let date = self.dateInputTextField.textView.text,
			  let desc = self.descriptionInputTextField.textView.text else {
			self.onErrorData?()
			return
		}
		
		let timeInputted = calendarHelper.stringToDateAndTime(dateString: "\(date) \(calendarHelper.getCurrentTimeString())")
		
		switch  paymentType {
		case .oneTime:
			guard let amountString = self.amountInputTextField.textView.text,
				  let amount = Float(amountString.replacingOccurrences(of: ".", with: "")) else {
				self.onErrorData?()
				return
			}
			self.viewModel.addTransactionData(category: category,
											  income_flag: false,
											  transaction_date: timeInputted,
											  description: desc,
											  recurring_flag: false,
											  amount: amount)
		case .subscription:
			guard let subsDuration = Int(self.durationInputTextfield.textView.text),
				  let recurringType = self.billingTypeString.value,
				  let amountString = self.amountInputTextField.textView.text,
				  let amount = Float(amountString.replacingOccurrences(of: ".", with: "")) else {
				self.onErrorData?()
				return
			}
			
			self.viewModel.addRecurringSubsData(total_amount: amount,
												billing_type: recurringType,
												start_billing_date: timeInputted,
												tenor: subsDuration,
												category: category,
												description: desc)
		case .installment:
			guard let totalAmountString = self.totalAmountInputTextField.textView.text,
				  let totalAmount = Float(totalAmountString.replacingOccurrences(of: ".", with: "")),
				  let interestString = self.interestInputTextField.textView.text,
				  let interest = Float(interestString.replacingOccurrences(of: ",", with: ".")),
				  let tenor = Int(self.durationInputTextfield.textView.text),
				  let recurringType = self.billingTypeString.value else {
				self.onErrorData?()
				return
			}
            
			self.viewModel.addRecurringInstData(total_amount: totalAmount,
												billing_type: recurringType,
												start_billing_date: timeInputted,
												tenor: tenor,
												category: category,
												description: desc,
                                                interest: interest)
		default:
			break
			
		}

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
		paymentTypeNode.borderWidth = kayayuSize.kayayuInputTextFieldBorderWidth
		paymentTypeNode.borderColor = kayayuColor.borderInputTextField.cgColor
		paymentTypeNode.layer.cornerRadius = kayayuSize.inputTextFieldCornerRadius
		
		let paymentTitleSpec = ASStackLayoutSpec(direction: .horizontal,
										  spacing: spacingTitle/2,
										  justifyContent: .start,
										  alignItems: .center,
										  children: [paymentTypeTitle, paymenTypeHelperIcon])
		
		let paymentTypeWrap = ASWrapperLayoutSpec(layoutElements: [paymentTypeNode])
		
		let paymentTypeSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: spacingTitle,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [paymentTitleSpec, paymentTypeWrap])
		
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
	
		paymenTypeHelperIcon.setImage( UIImage(named: "InfoIconBlack.png"), for: .normal)
		paymenTypeHelperIcon.style.preferredSize = CGSize(width: 15, height: 15)
		paymenTypeHelperIcon.imageNode.contentMode = .scaleAspectFit
		paymenTypeHelperIcon.addTarget(self, action: #selector(paymentTypeHelperTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func paymentTypeHelperTapped() {
		self.showPaymentTypeHelper?()
	}
	
	private func createRatioCategorySpec() -> ASLayoutSpec{
		let ratioCategoryNode = ASDisplayNode()
		ratioCategoryNode.view.addSubview(ratioCategory)
		ratioCategoryNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 30)
		ratioCategoryNode.borderWidth = kayayuSize.kayayuInputTextFieldBorderWidth
		ratioCategoryNode.borderColor = kayayuColor.borderInputTextField.cgColor
		ratioCategoryNode.layer.cornerRadius = kayayuSize.inputTextFieldCornerRadius
		
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
		ratioCategory.optionArray = kayayuRatioTitle.ratioCategoryString
		ratioCategory.selectedRowColor = kayayuColor.softGrey
		ratioCategory.checkMarkEnabled = false
		ratioCategory.font = UIFont.systemFont(ofSize: 14)
		ratioCategory.didSelect{ [weak self] (selectedText, index, id) in
			self?.ratio = selectedText
		}
	}
	
	private func createDateInputSpec() -> ASLayoutSpec {
		let paymentType = self.paymenTypeValue.value
		var dateElement: [ASLayoutElement] = []
		switch paymentType {
		case .subscription:
			dateDescription.attributedText = NSAttributedString.normal("Subscription billing date", 12, .black)
			let dateTitleSpec = ASStackLayoutSpec(direction: .vertical,
												  spacing: spacingTitle/2,
												  justifyContent: .start,
												  alignItems: .start,
												  children: [dateTitle, dateDescription])
			dateElement.append(dateTitleSpec)

		case .installment:
			dateDescription.attributedText = NSAttributedString.normal("Installment billing date", 12, .black)
			let dateTitleSpec = ASStackLayoutSpec(direction: .vertical,
												  spacing: spacingTitle/2,
												  justifyContent: .start,
												  alignItems: .start,
												  children: [dateTitle, dateDescription])
			dateElement.append(dateTitleSpec)
		default:
			dateElement.append(dateTitle)
		}
		dateElement.append(dateInputTextField)
		let dateSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: spacingTitle,
										 justifyContent: .start,
										 alignItems: .start,
										 children: dateElement)
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
		descriptionInputTextField.borderWidth = kayayuSize.kayayuInputTextFieldBorderWidth
		descriptionInputTextField.borderColor = kayayuColor.borderInputTextField.cgColor
		descriptionInputTextField.layer.cornerRadius = kayayuSize.inputTextFieldCornerRadius
		descriptionInputTextField.textView.inputAccessoryView = toolBar
		descriptionInputTextField.textView.font = kayayuFont.inputTextFieldFont
		descriptionInputTextField.textContainerInset = textContainerInset
	
	}
	
	//OPTIONAL CONFIGURATION
	
	private func createAmountInputSpec() -> ASLayoutSpec {
		
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
		amountInputTextField.textView.inputAccessoryView = toolBar
		amountInputTextField.textView.font = kayayuFont.inputTextFieldFont
		amountInputTextField.textView.text = "0"
		amountInputTextField.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 28 - 32, height: 30)
		amountInputTextField.borderColor = kayayuColor.borderInputTextField.cgColor
		amountInputTextField.layer.cornerRadius = kayayuSize.inputTextFieldCornerRadius
		amountInputTextField.borderWidth = kayayuSize.kayayuInputTextFieldBorderWidth
		amountInputTextField.textContainerInset = textContainerInset
		amountInputTextField.textView.delegate = self
		
	}
	
	private func createTotalAmountInputSpec() -> ASLayoutSpec {
		configureTotalAmountInputTextField()
		
		let currceny = ASTextNode()
		currceny.attributedText = NSAttributedString.semibold("Rp", 14, .black)
		let description = ASTextNode()
		description.attributedText = NSAttributedString.normal("Total amount before interest", 12, .black)
		
		let totalAmountTitleSpec = ASStackLayoutSpec(direction: .vertical,
												spacing: spacingTitle/2,
												justifyContent: .start,
												alignItems: .start,
												children: [totalAmountTitle, description])
		
		let totalAmountTextField = ASStackLayoutSpec(direction: .horizontal,
												spacing: spacingTitle,
												justifyContent: .start,
												alignItems: .start,
												children: [currceny, totalAmountInputTextField])
		
		let totalAmountSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: spacingTitle,
										   justifyContent: .start,
										   alignItems: .start,
										   children: [totalAmountTitleSpec, totalAmountTextField])
		
		return totalAmountSpec
	}
	
	private func configureTotalAmountInputTextField() {
		totalAmountTitle.attributedText = NSAttributedString.bold("Total Amount", 16, .black)
		
		totalAmountInputTextField.keyboardType = .numberPad
		totalAmountInputTextField.maximumLinesToDisplay = 1
		totalAmountInputTextField.style.preferredSize = CGSize(width: UIScreen.main.bounds.width/2 - 60 - totalAmountTitle.style.preferredSize.width, height: 30)
		totalAmountInputTextField.textView.inputAccessoryView = toolBar
		totalAmountInputTextField.textView.font = kayayuFont.inputTextFieldFont
		totalAmountInputTextField.textView.text = "0"
		totalAmountInputTextField.borderColor = kayayuColor.borderInputTextField.cgColor
		totalAmountInputTextField.layer.cornerRadius = kayayuSize.inputTextFieldCornerRadius
		totalAmountInputTextField.borderWidth = kayayuSize.kayayuInputTextFieldBorderWidth
		totalAmountInputTextField.textContainerInset = textContainerInset
		totalAmountInputTextField.textView.delegate = self
		
	}
	
	private func createInterestInputSpec() -> ASLayoutSpec {
		let percentage = ASTextNode()
		percentage.attributedText = NSAttributedString.semibold("%", 14, .black)
		
		let description = ASTextNode()
		description.attributedText = NSAttributedString.normal("Fixed-Interest Payment", 12, .black)
		
		let interestTitleSpec = ASStackLayoutSpec(direction: .vertical,
												  spacing: spacingTitle/2,
												  justifyContent: .start,
												  alignItems: .start,
												  children: [interestTitle, description])
		
		let interestTextField = ASStackLayoutSpec(direction: .horizontal,
												spacing: spacingTitle,
												justifyContent: .start,
												alignItems: .start,
												children: [interestInputTextField, percentage])
		
		let interestSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: spacingTitle,
										   justifyContent: .start,
										   alignItems: .start,
										   children: [interestTitleSpec, interestTextField])
		
		return interestSpec
	}
	
	private func configureInterestInputTextField() {
		interestTitle.attributedText = NSAttributedString.bold("Interest", 16, .black)
		
		interestInputTextField.keyboardType = .numberPad
		interestInputTextField.maximumLinesToDisplay = 1
		interestInputTextField.style.preferredSize = CGSize(width: UIScreen.main.bounds.width/2 - 54, height: 30)
		interestInputTextField.textView.inputAccessoryView = toolBar
		interestInputTextField.textView.font = kayayuFont.inputTextFieldFont
		interestInputTextField.borderColor = kayayuColor.borderInputTextField.cgColor
		interestInputTextField.layer.cornerRadius = kayayuSize.inputTextFieldCornerRadius
		interestInputTextField.borderWidth = kayayuSize.kayayuInputTextFieldBorderWidth
		interestInputTextField.textContainerInset = textContainerInset
	}
	
	
	private func createDurationTypeSpec() -> ASLayoutSpec{
		let durationDesc: ASTextNode = ASTextNode()
		
		let paymentType = self.paymenTypeValue.value
		
		if let recurringType = self.billingTypeString.value {
			switch paymentType {
			case .subscription, .installment:
				if recurringType == kayayuBillingType.weekly.rawValue {
					durationDesc.attributedText = NSAttributedString.normal(kayayuDurationType.weeks.rawValue, 14, .black)
				} else 	if recurringType == kayayuBillingType.monthly.rawValue {
					durationDesc.attributedText = NSAttributedString.normal(kayayuDurationType.months.rawValue, 14, .black)
				} else {
					durationDesc.attributedText = NSAttributedString.normal(kayayuDurationType.years.rawValue, 14, .black)
				}
			default:
				break
			}
		}
		
		let durationInputSpec = ASStackLayoutSpec(direction: .horizontal,
												   spacing: spacingTitle,
											 justifyContent: .center,
											 alignItems: .center,
											 children: [durationInputTextfield, durationDesc])
		   
		let durationTypeSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: spacingTitle,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [durationTitle, durationInputSpec])
		
		
		return durationTypeSpec
	}
	
	private func configureTenor() {
		durationTitle.attributedText = NSAttributedString.bold("Duration", 16, .black)
		durationTitle.style.preferredLayoutSize.width = ASDimension(unit: .points, value: kayayuSize.halfInputTextFieldSize.width)
		
		durationInputTextfield.keyboardType = .numberPad
		durationInputTextfield.maximumLinesToDisplay = 1
		durationInputTextfield.style.preferredSize = CGSize(width: UIScreen.main.bounds.width/2 - 32, height: 30)
		durationInputTextfield.textView.inputAccessoryView = toolBar
		durationInputTextfield.textView.font = kayayuFont.inputTextFieldFont
		durationInputTextfield.borderColor = kayayuColor.borderInputTextField.cgColor
		durationInputTextfield.layer.cornerRadius = kayayuSize.inputTextFieldCornerRadius
		durationInputTextfield.borderWidth = kayayuSize.kayayuInputTextFieldBorderWidth
		durationInputTextfield.textContainerInset = textContainerInset
	}
	
	private func createBillingTypeSpec() -> ASLayoutSpec{
		configureBillingType()
		let billingTypeNode = ASDisplayNode()
	
		billingTypeNode.view.addSubview(billingType)
		billingTypeNode.borderWidth = kayayuSize.kayayuInputTextFieldBorderWidth
		billingTypeNode.borderColor = kayayuColor.borderInputTextField.cgColor
		billingTypeNode.layer.cornerRadius = kayayuSize.inputTextFieldCornerRadius
		
		let billingTypeWrap = ASWrapperLayoutSpec(layoutElements: [billingTypeNode])
		
		billingTypeNode.style.preferredSize = kayayuSize.dropdownSize

		let billingTypeSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: spacingTitle,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [billingTypeTitle, billingTypeWrap])
		
		return billingTypeSpec
	}
	
	private func configureBillingType() {
		billingTypeTitle.attributedText = NSAttributedString.bold("Billing Type", 16, .black)
		
		let billingTypeArray = kayayuBillingType.kayayuBillingTypeValues
		billingType = DropDown(frame: kayayuSize.dropdownRect)
		billingType.optionArray = billingTypeArray
		
		billingType.selectedRowColor = kayayuColor.softGrey
		billingType.checkMarkEnabled = false
		billingType.font = UIFont.systemFont(ofSize: 14)
		billingType.attributedText = NSAttributedString.init(string: billingTypeString.value ?? "")
		billingType.didSelect{(selectedText, index, id) in
			self.billingTypeString.accept(selectedText)
		}
	}
	
	private func createDurationSpec() -> ASLayoutSpec {
		durationTitle.attributedText = NSAttributedString.bold("Duration", 14, .black)
		
		durationInputTextField.style.preferredSize = CGSize(width: UIScreen.main.bounds.width/2, height: kayayuSize.dropdownSize.height)
		durationInputTextField.keyboardType = .numberPad
		durationInputTextField.maximumLinesToDisplay = 1
		durationInputTextField.textView.inputAccessoryView = toolBar
		durationInputTextField.textView.font = kayayuFont.inputTextFieldFont
		durationInputTextField.borderWidth = kayayuSize.kayayuInputTextFieldBorderWidth
		durationInputTextField.borderColor = kayayuColor.borderInputTextField.cgColor
		durationInputTextField.layer.cornerRadius = kayayuSize.inputTextFieldCornerRadius
		durationInputTextField.textContainerInset = textContainerInset
		
		let recurring = createBillingTypeSpec()
		
		let inputSpec = ASStackLayoutSpec(direction: .horizontal,
											 spacing: 0,
											 justifyContent: .start,
											 alignItems: .start,
											 children: [durationInputTextField, recurring])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
											 spacing: spacingTitle,
											 justifyContent: .start,
											 alignItems: .start,
											 children: [durationTitle, inputSpec])
		
		return mainSpec
	}
	
	
}



extension AddExpenseRecordNode: UITextViewDelegate {
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if textView == amountInputTextField.textView || textView == totalAmountInputTextField.textView,
		   let currText = textView.text {
			
			let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
			var nsCurrtext = (currText as NSString).replacingCharacters(in: range, with: text)

			if nsCurrtext.contains(".") {
				nsCurrtext = nsCurrtext.replacingOccurrences(of: ".", with: "")
			}
			
			if nsCurrtext.count > 3,
				let beforeFormatted = Int(nsCurrtext) {
				let formattedInput = numberHelper.intToIdFormat(beforeFormatted: beforeFormatted)
				nsCurrtext = formattedInput
				textView.text = formattedInput
				return false
			}
		
			return (text.rangeOfCharacter(from: invalidCharacters) == nil)
		}
		
		return false
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView == amountInputTextField.textView || textView == totalAmountInputTextField.textView {
			if textView.text == "0" {
				textView.text = ""
			}
		}
	}
	
}
	
