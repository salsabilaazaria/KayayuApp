//
//  RegisterNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/9/21.
//

import Foundation
import AsyncDisplayKit

class RegisterNode: ASDisplayNode {
	
	var onCreateTabBar: (() -> Void)?
	var onOpenLoginPage: (() -> Void)?
	
	private let viewModel: AuthenticationViewModel
	
	private let greetingText: ASTextNode = ASTextNode()
	
	private let usernameTitle: ASTextNode = ASTextNode()
	private let usernameTextfield : ASEditableTextNode = ASEditableTextNode()
	private let emailTitle: ASTextNode = ASTextNode()
	private let emailTextfield : ASEditableTextNode = ASEditableTextNode()
	private let passwordTitle: ASTextNode = ASTextNode()
	private let passwordTextfield : UITextField = UITextField()
	private let confirmPasswordTitle: ASTextNode = ASTextNode()
	private let confirmPassTextfield : UITextField = UITextField()
	
	private var signUpButton: BigButton = BigButton()
	private let loginText: ASTextNode = ASTextNode()
	private let loginButton: ASButtonNode = ASButtonNode()
	
	private let alertText: ASTextNode = ASTextNode()
	
	private let toolBar: UIToolbar = UIToolbar()
	
	private let inputTextFieldSize = kayayuSize.bigInputTextField
	
	init(viewModel: AuthenticationViewModel) {
		self.viewModel = viewModel
		super.init()
		
		configureViewModel()
		configureToolBar()
		
		configureGreetingText()
		configureUsernameTextfield()
		configureEmailTextfield()
		configurePasswordTextfield()
		configureConfirmPassTextfield()
		configureSignUpButton()
		configureLoginText()
		configureLoginButton()
		configureAlertText()
		
		backgroundColor = .white
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let inputTextfield = ASStackLayoutSpec(direction: .vertical,
											   spacing: 10,
											   justifyContent: .start,
											   alignItems: .start,
											   children: [createUsernameTextField(), createEmailTextField(), createPasswordTextField(), createConfirmPasswordTextField(), alertText])
		
		let loginTextSpec = ASStackLayoutSpec(direction: .horizontal,
											   spacing: 0,
											   justifyContent: .center,
											   alignItems: .center,
											   children: [loginText,loginButton])
		
		let buttonSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: 10,
										   justifyContent: .center,
										   alignItems: .center,
										   children: [signUpButton, loginTextSpec])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 40,
										 justifyContent: .center,
										 alignItems: .start,
										 children: [greetingText,inputTextfield, buttonSpec])
		
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0,
															   left: 16,
															   bottom: 0,
															   right: 16),
										  child: mainSpec)
		
		return mainInset
	}
	
	private func configureViewModel() {
		viewModel.onCreateTabBar = {
			self.onCreateTabBar?()
		}
		
		viewModel.showAlert = { errorMsg in
			print("SHOW ALERT")
			self.alertText.attributedText = NSAttributedString.semibold(errorMsg, 14, .systemRed)
			self.alertText.isHidden = false
		}
	}
	
	private func configureAlertText() {
		alertText.attributedText = NSAttributedString.semibold("There is invalid data, please try again.", 14, .systemRed)
		alertText.isHidden = true
	}
	
	private func configureToolBar() {
		toolBar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneKeyboardTapped))
		toolBar.setItems([doneButton], animated: true)
	}
	
	@objc func doneKeyboardTapped() {
		self.view.endEditing(true)
	}
	
	private func configureGreetingText() {
		greetingText.attributedText = NSAttributedString.bold("Hello!\nGlad you're joining us!", 28, kayayuColor.yellow)
	}
	
	private func createUsernameTextField() -> ASLayoutSpec {
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 6,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [usernameTitle, usernameTextfield])
		
		return mainSpec
	}
	
	private func configureUsernameTextfield() {
		usernameTitle.attributedText = NSAttributedString.semibold("Username", 15, .gray)
		
		usernameTextfield.backgroundColor = kayayuColor.softGrey
		usernameTextfield.style.preferredSize = inputTextFieldSize
		usernameTextfield.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
		usernameTextfield.textView.textContainer.maximumNumberOfLines = 1
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
	
	private func createConfirmPasswordTextField() -> ASLayoutSpec {
		let confirmPassTextfieldNode = ASDisplayNode()
		confirmPassTextfieldNode.view.addSubview(confirmPassTextfield)
		confirmPassTextfieldNode.backgroundColor = kayayuColor.softGrey
		confirmPassTextfieldNode.style.preferredSize = kayayuSize.bigInputTextField
		
		let confirmPassWrap = ASWrapperLayoutSpec(layoutElements: [confirmPassTextfieldNode])
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 6,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [confirmPasswordTitle, confirmPassWrap])
		
		return mainSpec
	}
	
	private func configureConfirmPassTextfield() {
		confirmPasswordTitle.attributedText = NSAttributedString.semibold("Confirm Password", 14, .gray)
		
		confirmPassTextfield.frame = CGRect(x: 8, y: 0, width: UIScreen.main.bounds.width - 48, height: 40)
		confirmPassTextfield.layer.cornerRadius = 8.0
		confirmPassTextfield.inputAccessoryView = toolBar
		confirmPassTextfield.isSecureTextEntry = true
		confirmPassTextfield.font = UIFont.systemFont(ofSize: 12)
		
	}
	
	private func configureSignUpButton() {
		signUpButton = BigButton(buttonText: "REGISTER", buttonColor: kayayuColor.yellow, borderColor: kayayuColor.yellow)
		//NEED TO CONFIRM: setelah sign up mau ke home apa ke login?
		signUpButton.addTarget(self, action: #selector(signUpButtonTapped), forControlEvents: .touchUpInside)
	}
	
	private func configureLoginText() {
		loginText.attributedText = NSAttributedString.normal("Already Have an Account? ", 12, .gray)
	}
	
	private func configureLoginButton() {
		loginButton.setAttributedTitle(NSAttributedString.normal("Login", 12, .black), for: .normal)
		loginButton.addTarget(self, action: #selector(loginButtonTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func loginButtonTapped(sender: ASButtonNode) {
		self.onOpenLoginPage?()
	}
	
	@objc func signUpButtonTapped(sender: ASButtonNode) {
		guard let username = self.usernameTextfield.textView.text,
			  let email = self.emailTextfield.textView.text,
			  let password = self.passwordTextfield.text,
			  let confirmPassword = self.confirmPassTextfield.text else {
			return
		}
		
		self.viewModel.validateRegisterData(username: username, email: email, password: password, confirmPassword: confirmPassword)
	
	}
	
}

extension RegisterNode: UITextViewDelegate {
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		textView.textContainerInset =  UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
		
		if textView.text == "Username" || textView.text == "Password" || textView.text == "Email" || textView.text == "Confirm Password" {
			textView.textColor = .black
			textView.text = nil
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		textView.textContainerInset =  UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
		if textView.text.isEmpty {
			DispatchQueue.main.async {
				textView.textColor = kayayuColor.softGrey
				if textView == self.usernameTextfield {
					textView.text = "Username"
				}
				else if textView == self.passwordTextfield {
					textView.text = "Password"
				}
				else if textView == self.emailTextfield {
					textView.text = "Email"
				}
				else if textView == self.confirmPassTextfield {
					textView.text = "Confirm Password"
				}
			}
		} else {
			textView.textColor = .black
		}
	}
}
