//
//  ChangeEmailNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/12/21.
//

import Foundation
import AsyncDisplayKit

class ChangeEmailNode: ASDisplayNode {
	
	var onOpenEditProfilePage: (() -> Void)?
	
	private let viewModel: ProfileViewModel
	
	private let questionText: ASTextNode = ASTextNode()
	
	private let emailTitle: ASTextNode = ASTextNode()
	private let emailTextfield: ASEditableTextNode = ASEditableTextNode()
	private let passwordTitle: ASTextNode = ASTextNode()
	private let passwordTextfield: UITextField = UITextField()
	private var saveButton: BigButton = BigButton()
	
	private let alertText: ASTextNode = ASTextNode()
	
	private let toolBar: UIToolbar = UIToolbar()
	
	init(viewModel: ProfileViewModel) {
		self.viewModel = viewModel
		super.init()
		
		configureViewModel()
		configureQuestionText()
		configureEmailTextfield()
		configurePasswordTextfield()
		configureSaveButton()
		configureToolBar()
		configureAlertText()
		
		backgroundColor = .white
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let inputTextfield = ASStackLayoutSpec(direction: .vertical,
											   spacing: 15,
											   justifyContent: .start,
											   alignItems: .start,
											   children: [createEmailTextField(), createPasswordTextField(), alertText])
		
		let buttonSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: 10,
										   justifyContent: .end,
										   alignItems: .end,
										   children: [saveButton])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 50,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [questionText,inputTextfield ,buttonSpec])
		
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 32,
															   left: 16,
															   bottom: 0,
															   right: 16),
										  child: mainSpec)
		
		return mainInset
	}
	
	private func configureViewModel() {
		viewModel.goToEditProfilePage = {
			self.onOpenEditProfilePage?()
		}
		
		viewModel.showAlert = { message in
			self.alertText.attributedText = NSAttributedString.semibold(message, 14, .systemRed)
			self.alertText.isHidden = false
		}
	}
	
	private func configureToolBar() {
		toolBar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneKeyboardTapped))
		toolBar.setItems([doneButton], animated: true)
	}
	
	@objc func doneKeyboardTapped() {
		self.view.endEditing(true)
	}
	
	private func configureAlertText() {
		alertText.attributedText = NSAttributedString.semibold("", 14, .systemRed)
		alertText.isHidden = true
	}
	
	private func configureQuestionText() {
		questionText.attributedText = NSAttributedString.bold("Would you like to change your email?", 16, .black)
	}
	
	private func createEmailTextField() -> ASLayoutSpec {
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 6,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [emailTitle, emailTextfield])
		
		return mainSpec
	}
	
	private func configureEmailTextfield() {
		emailTitle.attributedText = NSAttributedString.semibold("Email", 14, .gray)
		
		emailTextfield.backgroundColor = kayayuColor.softGrey
		emailTextfield.style.preferredSize = kayayuSize.bigInputTextField
		emailTextfield.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
		
		emailTextfield.textView.inputAccessoryView = toolBar
		emailTextfield.textView.textContainer.maximumNumberOfLines = 1
	}
	
	private func createPasswordTextField() -> ASLayoutSpec {
		let passwordTextfieldNode = ASDisplayNode()
		passwordTextfieldNode.view.addSubview(passwordTextfield)
		passwordTextfieldNode.backgroundColor = kayayuColor.softGrey
		passwordTextfieldNode.style.preferredSize = kayayuSize.bigInputTextField
		
		let passwordTextfieldWrap = ASWrapperLayoutSpec(layoutElements: [passwordTextfieldNode])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 6,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [passwordTitle, passwordTextfieldWrap])
		
		return mainSpec
	}
	
	private func configurePasswordTextfield() {
		passwordTitle.attributedText = NSAttributedString.semibold("Password", 14, .gray)
		passwordTextfield.frame = CGRect(x: 8, y: 0, width: UIScreen.main.bounds.width - 48, height: 40)
		passwordTextfield.layer.cornerRadius = 8.0
		passwordTextfield.inputAccessoryView = toolBar
		passwordTextfield.isSecureTextEntry = true
		passwordTextfield.font = UIFont.systemFont(ofSize: 12)
		
	}
	
	private func configureSaveButton() {
		saveButton = BigButton(buttonText: "LOGIN", buttonColor: kayayuColor.yellow, borderColor: kayayuColor.yellow)
		saveButton.addTarget(self, action: #selector(saveButtonTapped), forControlEvents: .touchUpInside)
	}

	
	@objc private func saveButtonTapped(sender: ASButtonNode) {
		guard let email = self.emailTextfield.textView.text,
			  let password = self.passwordTextfield.text else {
			return
		}
		
		self.viewModel.updateNewEmail(newEmail: email, password: password)
		
	}

	
}


