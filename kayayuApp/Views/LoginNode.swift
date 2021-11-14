//
//  loginNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/8/21.
//

import Foundation
import AsyncDisplayKit

class LoginNode: ASDisplayNode {
	private let greetingText: ASTextNode = ASTextNode()
	private let usernameTextfield : ASEditableTextNode = ASEditableTextNode()
	private let passwordTextfield : ASEditableTextNode = ASEditableTextNode()
	private var loginButton: BigButton = BigButton()
	private let singUpText: ASTextNode = ASTextNode()
	private let signUpButton: ASButtonNode = ASButtonNode()
	
	override init() {
		super.init()
		
		configureGreetingText()
		configureUsernameTextfield()
		configurePasswordTextfield()
		configureLoginButton()
		configureSignUpText()
		configueSignUpButton()
		
		backgroundColor = .white
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let inputTextfield = ASStackLayoutSpec(direction: .vertical,
											   spacing: 10,
											   justifyContent: .center,
											   alignItems: .center,
											   children: [usernameTextfield, passwordTextfield])
		
		let signUpTextSpec = ASStackLayoutSpec(direction: .horizontal,
											   spacing: 0,
											   justifyContent: .center,
											   alignItems: .center,
											   children: [singUpText,signUpButton])
		
		let buttonSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: 10,
										   justifyContent: .center,
										   alignItems: .center,
										   children: [loginButton, signUpTextSpec])
		
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
	
	private func configureGreetingText() {
		greetingText.attributedText = NSAttributedString.bold("Welcome back!\nWe miss you.", 30, kayayuColor.yellow)
	}
	
	private func configureUsernameTextfield() {
		usernameTextfield.backgroundColor = kayayuColor.softGrey
		usernameTextfield.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 40)
		usernameTextfield.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
		
		usernameTextfield.textView.delegate = self
		usernameTextfield.textView.text = "Username"
		usernameTextfield.textView.textColor = .gray
		usernameTextfield.textView.textContainer.maximumNumberOfLines = 1
	}
	
	private func configurePasswordTextfield() {
		passwordTextfield.backgroundColor = kayayuColor.softGrey
		passwordTextfield.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 40)
		passwordTextfield.cornerRadius = 8.0
		passwordTextfield.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
		
		passwordTextfield.textView.delegate = self
		passwordTextfield.textView.text = "Password"
		passwordTextfield.textView.textColor = .gray
		passwordTextfield.maximumLinesToDisplay = 1
		
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
	
	@objc func loginButtonTapped(sender: ASButtonNode) {
		print("GO TO HOMEPAGE")
	}
	
	@objc func signUpButtonTapped(sender: ASButtonNode) {
		print("GO TO SIGN UP")
	}

	
}

extension LoginNode: UITextViewDelegate {
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		textView.textContainerInset =  UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
		
		if textView.text == "Username" || textView.text == "Password" {
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
				if textView == self.passwordTextfield {
					textView.text = "Password"
				}
			}
		} else {
			textView.textColor = .black
		}
	}
}
