//
//  loginNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/8/21.
//

import Foundation
import AsyncDisplayKit

class LoginNode: ASDisplayNode {
	
	var onOpenHomePage: (() -> Void)?
	var onOpenRegisterPage: (() -> Void)?
	
	private let viewModel: AuthenticationViewModel
	
	private let greetingText: ASTextNode = ASTextNode()
	
	private let emailTitle: ASTextNode = ASTextNode()
	private let emailTextfield: ASEditableTextNode = ASEditableTextNode()
	private let passwordTitle: ASTextNode = ASTextNode()
	private let passwordTextfield: UITextField = UITextField()
	private var loginButton: BigButton = BigButton()
	
	private let alertText: ASTextNode = ASTextNode()
	
	private let singUpText: ASTextNode = ASTextNode()
	private let signUpButton: ASButtonNode = ASButtonNode()
	
	private let toolBar: UIToolbar = UIToolbar()
	
	init(viewModel: AuthenticationViewModel) {
		self.viewModel = viewModel
		super.init()
        
        configureViewModel()
		configureGreetingText()
		configureEmailTextfield()
		configurePasswordTextfield()
		configureLoginButton()
		configureSignUpText()
		configueSignUpButton()
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
		
		let signUpTextSpec = ASStackLayoutSpec(direction: .horizontal,
											   spacing: 4,
											   justifyContent: .center,
											   alignItems: .center,
											   children: [singUpText,signUpButton])
		
		let buttonSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: 10,
										   justifyContent: .center,
										   alignItems: .center,
										   children: [loginButton, signUpTextSpec])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 50,
										 justifyContent: .center,
										 alignItems: .start,
										 children: [greetingText,inputTextfield ,buttonSpec])
		
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0,
															   left: 16,
															   bottom: 0,
															   right: 16),
										  child: mainSpec)
		
		return mainInset
	}
    
    private func configureViewModel() {
        viewModel.onOpenHomePage = {
            self.onOpenHomePage?()
        }
		
		viewModel.showAlert = { errorMsg in
			self.alertText.attributedText = NSAttributedString.semibold(errorMsg, 14, .systemRed)
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
		alertText.attributedText = NSAttributedString.semibold("Oops, Invalid email or password.", 14, .systemRed)
		alertText.isHidden = true
	}
	
	private func configureGreetingText() {
		greetingText.attributedText = NSAttributedString.bold("Welcome back!\nWe miss you.", 30, kayayuColor.yellow)
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
	
	private func configureLoginButton() {
		loginButton = BigButton(buttonText: "LOGIN", buttonColor: kayayuColor.yellow, borderColor: kayayuColor.yellow)
		loginButton.addTarget(self, action: #selector(loginButtonTapped), forControlEvents: .touchUpInside)
	}
	
	private func configureSignUpText() {
		singUpText.attributedText = NSAttributedString.normal("Didn't Have Any Account?", 12, .gray)
	}
	
	private func configueSignUpButton() {
		signUpButton.setAttributedTitle(NSAttributedString.normal("Register", 12, .black), for: .normal)
		signUpButton.addTarget(self, action: #selector(signUpButtonTapped), forControlEvents: .touchUpInside)
	}
	
	@objc private func loginButtonTapped(sender: ASButtonNode) {
		guard let email = self.emailTextfield.textView.text,
			  let password = self.passwordTextfield.text else {
			return
		}
		
		self.viewModel.validateLoginData(email: "test@gmail.com", password: "Password")
		
	}
	
	@objc func signUpButtonTapped(sender: ASButtonNode) {
		self.onOpenRegisterPage?()
	}

	
}

