//
//  SignUpNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/9/21.
//

import Foundation
import AsyncDisplayKit

class SignUpNode: ASDisplayNode {
	private let greetingText: ASTextNode = ASTextNode()
	private let usernameTextfield : ASEditableTextNode = ASEditableTextNode()
	private let emailTextfield : ASEditableTextNode = ASEditableTextNode()
	private let passwordTextfield : ASEditableTextNode = ASEditableTextNode()
	private let confirmPassTextfield : ASEditableTextNode = ASEditableTextNode()
	private var signUpButton: BigButton = BigButton()
	private let loginText: ASTextNode = ASTextNode()
	private let loginButton: ASButtonNode = ASButtonNode()
	
	override init() {
		super.init()
		
		configureGreetingText()
		configureUsernameTextfield()
		configureEmailTextfield()
		configurePasswordTextfield()
		configureConfirmPassTextfield()
		configureSignUpButton()
		configureLoginText()
		configureLoginButton()
		
		backgroundColor = .white
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let inputTextfield = ASStackLayoutSpec(direction: .vertical,
											   spacing: 10,
											   justifyContent: .center,
											   alignItems: .center,
											   children: [usernameTextfield, emailTextfield, passwordTextfield, confirmPassTextfield])
		
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
	
	private func configureGreetingText() {
		greetingText.attributedText = NSAttributedString.bold("Hello!\nGlad you're joining us!", 30, kayayuColor.yellow)
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
	
	private func configureEmailTextfield() {
		emailTextfield.backgroundColor = kayayuColor.softGrey
		emailTextfield.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 40)
		emailTextfield.cornerRadius = 8.0
		emailTextfield.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
		
		emailTextfield.textView.delegate = self
		emailTextfield.textView.text = "Email"
		emailTextfield.textView.textColor = .gray
		emailTextfield.maximumLinesToDisplay = 1
		
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
	
	private func configureConfirmPassTextfield() {
		confirmPassTextfield.backgroundColor = kayayuColor.softGrey
		confirmPassTextfield.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 40)
		confirmPassTextfield.cornerRadius = 8.0
		confirmPassTextfield.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
		
		confirmPassTextfield.textView.delegate = self
		confirmPassTextfield.textView.text = "Confirm Password"
		confirmPassTextfield.textView.textColor = .gray
		confirmPassTextfield.maximumLinesToDisplay = 1
		
	}
	
	private func configureSignUpButton() {
		signUpButton = BigButton(buttonText: "SIGN UP", buttonColor: kayayuColor.yellow, borderColor: kayayuColor.yellow)
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
		print("GO TO LOGIN")
	}
	
	@objc func signUpButtonTapped(sender: ASButtonNode) {
		print("GO TO HOMEPAGE")
	}

	
}

extension SignUpNode: UITextViewDelegate {
	
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
