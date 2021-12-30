//
//  AddIncomeRecord.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/11/21.
//
import Foundation
import AsyncDisplayKit
import iOSDropDown

class AddIncomeRecordNode: ASDisplayNode {
	var onOpenHomePage: (() -> Void)?
	
	private let dateTitle: ASTextNode = ASTextNode()
	private let descTitle: ASTextNode = ASTextNode()
	private let amountTitle: ASTextNode = ASTextNode()
	
	private let dateInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let descriptionInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let amountInputTextField: ASEditableTextNode = ASEditableTextNode()
	
	private let ratioTitle: ASTextNode = ASTextNode()
	private var ratioCategory: DropDown = DropDown()
	private let ratioDescription: ASTextNode = ASTextNode()
	
	private var saveButton: BigButton = BigButton()
	private let toolBar: UIToolbar = UIToolbar()
	private let datePicker = UIDatePicker()
	
	private let spacingTitle: CGFloat = 8

	private let calendarHelper = CalendarHelper()
	private let numberHelper = NumberHelper()
	
	private let viewModel: HomeViewModel
	
	private var ratio: String?
	
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		super.init()
		automaticallyManagesSubnodes = true
		configureToolBar()
		configureSaveButton()
		configureViewModel()
		configureDateInputTextField()
	}

	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let date = createDateInputSpec()
		let desc = createDescInputSpec()
		let amount = createAmountInputSpec()
		let ratio = createRatioCategorySpec()
		
		let inputDataSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 10,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [date, ratio, desc, amount])
		
		let inputSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: 20,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [inputDataSpec, createIncomeDesc()])
		
		inputSpec.style.flexGrow = 1
		
		let saveButtonSpec = ASStackLayoutSpec(direction: .vertical,
											   spacing: 8,
											   justifyContent: .end,
											   alignItems: .center,
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
	
	private func configureViewModel() {
		viewModel.onOpenHomePage = { [weak self] in
			self?.onOpenHomePage?()
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
	
	private func configureSaveButton() {
		saveButton = BigButton(buttonText: "SAVE", buttonColor: kayayuColor.yellow, borderColor: kayayuColor.yellow)
		saveButton.addTarget(self, action: #selector(saveButtonTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func saveButtonTapped() {
		guard let category = ratio,
			  let date = self.dateInputTextField.textView.text,
			  let desc = self.descriptionInputTextField.textView.text,
			  let amount = Float(self.amountInputTextField.textView.text) else {
			return
		}

		let timeInputted = calendarHelper.stringToDateAndTime(dateString: "\(date) \(calendarHelper.getCurrentTimeString())")
		self.viewModel.addTransactionData(category: category,
										  income_flag: true,
										  transaction_date: timeInputted,
										  description: desc,
										  recurring_flag: false,
										  amount: amount)
	}
	
	private func createRatioCategorySpec() -> ASLayoutSpec{
		configureRatioCategory()
		let ratioCategoryNode = ASDisplayNode()
		ratioCategoryNode.view.addSubview(ratioCategory)
		ratioCategoryNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 30)
		ratioCategoryNode.borderWidth = kayayuSize.kayayuInputTextFieldBorderWidth
		ratioCategoryNode.borderColor = kayayuColor.borderInputTextField.cgColor
		ratioCategoryNode.layer.cornerRadius = kayayuSize.inputTextFieldCornerRadius
		
		let ratioCategoryWrap = ASWrapperLayoutSpec(layoutElements: [ratioCategoryNode])
		
		var elementArray: [ASLayoutElement] = [ratioTitle, ratioCategoryWrap]
		
		if ratio == kayayuRatioTitle.all.rawValue {
			ratioDescription.attributedText = NSAttributedString.normal("Income amount will be automatically calculated based on The Balance Money Formula (50:30:20 Ratio)", 12, .black)
			ratioDescription.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 16, height: 40)
			elementArray.append(ratioDescription)
		}
		
		let ratioSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: spacingTitle,
										  justifyContent: .start,
										  alignItems: .start,
										  children: elementArray)
		
		return ratioSpec
	}
	
	private func configureRatioCategory() {
		ratioTitle.attributedText = NSAttributedString.bold("Ratio", 16, .black)
		
		ratioCategory = DropDown(frame: CGRect(x: 3, y: 1, width: UIScreen.main.bounds.width - 32, height: 30))
		ratioCategory.optionArray = kayayuRatioTitle.incomeValues
		ratioCategory.selectedRowColor = kayayuColor.softGrey
		ratioCategory.checkMarkEnabled = false
		ratioCategory.font = UIFont.systemFont(ofSize: 14)
		ratioCategory.text = ratio
		ratioCategory.didSelect{(selectedText, index, id) in
			self.ratio = selectedText
			self.reloadUI()
		}
	}
	
	private func createDateInputSpec() -> ASLayoutSpec {
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
		descriptionInputTextField.borderWidth = kayayuSize.kayayuInputTextFieldBorderWidth
		descriptionInputTextField.borderColor = kayayuColor.borderInputTextField.cgColor
		descriptionInputTextField.layer.cornerRadius = kayayuSize.inputTextFieldCornerRadius
		descriptionInputTextField.textView.inputAccessoryView = toolBar
		descriptionInputTextField.textView.font = kayayuFont.inputTextFieldFont
		descriptionInputTextField.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
	}
	
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
		amountInputTextField.textView.delegate = self
		
		amountInputTextField.textView.text = "0"
	}
	
	private func createIncomeDesc() -> ASLayoutSpec {
		let incomeDescription: ASTextNode = ASTextNode()
		let infoIcon: ASImageNode = ASImageNode()
		let backgroundNode: ASDisplayNode = ASDisplayNode()
		
		incomeDescription.attributedText = NSAttributedString.normal("Your income will be allocated for the inputted month budget", 12, .black)
		infoIcon.image = UIImage(named: "infoIconBlack.png")
		infoIcon.style.preferredSize =  CGSize(width: 20, height: 20)
		
		let contentSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 4, justifyContent: .center, alignItems: .center, children: [infoIcon,incomeDescription])
		
		backgroundNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width-32, height: 40)
		
		let incomeDescSpec = ASOverlayLayoutSpec(child: backgroundNode, overlay: contentSpec)
		
		return incomeDescSpec
	}
	

	
	private func reloadUI() {
		self.setNeedsLayout()
		self.layoutIfNeeded()
	}
	
}

extension AddIncomeRecordNode: UITextViewDelegate {
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if textView == amountInputTextField.textView,
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
		if textView == amountInputTextField.textView {
			if textView.text == "0" {
				textView.text = ""
			}
		}
	}
	
}
