//
//  ChangePasswordNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/12/21.
//

import Foundation
import AsyncDisplayKit

class ChangePasswordNode: ASDisplayNode {
	
	var onBackToEditProfilePage: (() -> Void)?
	
	private let viewModel: ProfileViewModel
	
	private let questionText: ASTextNode = ASTextNode()
	
	private let oldPasswordTitle: ASTextNode = ASTextNode()
	private let oldPasswordTextfield: UITextField = UITextField()
	
	private let newPasswordTitle: ASTextNode = ASTextNode()
	private let newPasswordTextfield: UITextField = UITextField()
	
	private let confirmPasswordTitle: ASTextNode = ASTextNode()
	private let confirmPasswordTextfield: UITextField = UITextField()
	private var saveButton: BigButton = BigButton()
	
	private let alertText: ASTextNode = ASTextNode()
	
	private let toolBar: UIToolbar = UIToolbar()
	
	init(viewModel: ProfileViewModel) {
		self.viewModel = viewModel
		super.init()
		
		configureViewModel()
		configureQuestionText()
		configureOldPasswordTextfield()
		configureNewPasswordTextfield()
		configureConfirmPasswordTextfield()
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
											   children: [createOldPasswordTextField(),
														  createNewPasswordTextField(),
														  createConfirmPasswordTextField(),
														  alertText])
		
		let buttonSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: 10,
										   justifyContent: .end,
										   alignItems: .end,
										   children: [saveButton])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 50,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [questionText,inputTextfield, buttonSpec])
		
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 32,
															   left: 16,
															   bottom: 0,
															   right: 16),
										  child: mainSpec)
		
		return mainInset
	}
	
	private func configureViewModel() {
		viewModel.onBackToEditProfilePage = {
			self.onBackToEditProfilePage?()
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
		alertText.attributedText = NSAttributedString.semibold("Oops, Invalid password.", 14, .systemRed)
		alertText.isHidden = true
	}
	
	private func configureQuestionText() {
		questionText.attributedText = NSAttributedString.bold("Would you like to change your password?", 16, .black)
	}
	
	private func createConfirmPasswordTextField() -> ASLayoutSpec {
		let confirmPasswordTextfieldNode = ASDisplayNode()
		confirmPasswordTextfieldNode.view.addSubview(confirmPasswordTextfield)
		confirmPasswordTextfieldNode.backgroundColor = kayayuColor.softGrey
		confirmPasswordTextfieldNode.style.preferredSize = kayayuSize.bigInputTextField
		let confirmPasswordTextfieldWrap = ASWrapperLayoutSpec(layoutElements: [confirmPasswordTextfieldNode])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 6,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [confirmPasswordTitle, confirmPasswordTextfieldWrap])
		
		return mainSpec
	
	}
	
	private func configureConfirmPasswordTextfield() {
		confirmPasswordTitle.attributedText = NSAttributedString.semibold("Confirm Password", 14, .gray)
		confirmPasswordTextfield.frame = CGRect(x: 8, y: 0, width: UIScreen.main.bounds.width - 48, height: 40)
		confirmPasswordTextfield.layer.cornerRadius = 8.0
		confirmPasswordTextfield.inputAccessoryView = toolBar
		confirmPasswordTextfield.isSecureTextEntry = true
		confirmPasswordTextfield.font = UIFont.systemFont(ofSize: 12)
	}
	
	private func createOldPasswordTextField() -> ASLayoutSpec {
		let oldPasswordTextfieldNode = ASDisplayNode()
		oldPasswordTextfieldNode.view.addSubview(oldPasswordTextfield)
		oldPasswordTextfieldNode.backgroundColor = kayayuColor.softGrey
		oldPasswordTextfieldNode.style.preferredSize = kayayuSize.bigInputTextField
		
		let oldPasswordTextfieldWrap = ASWrapperLayoutSpec(layoutElements: [oldPasswordTextfieldNode])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 6,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [oldPasswordTitle, oldPasswordTextfieldWrap])
		
		return mainSpec
	
	}
	
	private func configureOldPasswordTextfield() {
		oldPasswordTitle.attributedText = NSAttributedString.semibold("Old Password", 14, .gray)
		oldPasswordTextfield.frame = CGRect(x: 8, y: 0, width: UIScreen.main.bounds.width - 48, height: 40)
		oldPasswordTextfield.layer.cornerRadius = 8.0
		oldPasswordTextfield.inputAccessoryView = toolBar
		oldPasswordTextfield.isSecureTextEntry = true
		oldPasswordTextfield.font = UIFont.systemFont(ofSize: 12)
	}
	
	private func createNewPasswordTextField() -> ASLayoutSpec {
		let newPasswordTextfieldNode = ASDisplayNode()
		newPasswordTextfieldNode.view.addSubview(newPasswordTextfield)
		newPasswordTextfieldNode.backgroundColor = kayayuColor.softGrey
		newPasswordTextfieldNode.style.preferredSize = kayayuSize.bigInputTextField
		
		let newPasswordTextfieldWrap = ASWrapperLayoutSpec(layoutElements: [newPasswordTextfieldNode])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 6,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [newPasswordTitle, newPasswordTextfieldWrap])
		
		return mainSpec
	}
	
	private func configureNewPasswordTextfield() {
		newPasswordTitle.attributedText = NSAttributedString.semibold("Password", 14, .gray)
		newPasswordTextfield.frame = CGRect(x: 8, y: 0, width: UIScreen.main.bounds.width - 48, height: 40)
		newPasswordTextfield.layer.cornerRadius = 8.0
		newPasswordTextfield.inputAccessoryView = toolBar
		newPasswordTextfield.isSecureTextEntry = true
		newPasswordTextfield.font = UIFont.systemFont(ofSize: 12)
		
	}
	
	private func configureSaveButton() {
		saveButton = BigButton(buttonText: "SAVE", buttonColor: kayayuColor.yellow, borderColor: kayayuColor.yellow)
		saveButton.addTarget(self, action: #selector(saveButtonTapped), forControlEvents: .touchUpInside)
	}

	
	@objc private func saveButtonTapped(sender: ASButtonNode) {
		guard let oldPassword = self.oldPasswordTextfield.text,
			  let newPassword = self.newPasswordTextfield.text,
			  let confirmPassword = self.confirmPasswordTextfield.text else {
			return
		}
		
		self.viewModel.updateNewPassword(oldPassword: oldPassword, newPassword: newPassword, newConfirmationPassword: confirmPassword)
	}

	
}


