//
//  landingNode.swift
//  KayayuApp
//
//  Created by Salsabila Azaria on 11/8/21.
//

import Foundation
import AsyncDisplayKit

class LandingNode: ASDisplayNode {
	var onOpenLoginPage: (() -> Void)?
	var onOpenRegisterPage: (() -> Void)?
	
	private let logo: ASImageNode = ASImageNode()
	private let name: ASTextNode = ASTextNode()
	
	private var loginButton: BigButton = BigButton()
	private var registerButton: BigButton = BigButton()
	
	
	override init() {
		super.init()
		backgroundColor = .white
		configureLogo()
		configureName()
		configureLoginButton()
		configureRegisterButton()
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let appInfo = ASStackLayoutSpec(direction: .vertical,
											spacing: 10,
											justifyContent: .center,
											alignItems: .center,
											children: [logo, name])
		
		let buttonStack = ASStackLayoutSpec(direction: .vertical,
											spacing: 10,
											justifyContent: .center,
											alignItems: .center,
											children: [loginButton,registerButton])
		
		let mainStack = ASStackLayoutSpec(direction: .vertical,
											spacing: 50,
											justifyContent: .center,
											alignItems: .center,
											children: [appInfo, buttonStack])
		
		return mainStack
	}
	
	private func configureLogo() {
		logo.image = UIImage(named: "logo.png")
		logo.style.preferredSize = CGSize(width: 209, height: 271)
	}
	
	private func configureName() {
		//TODO: ganti jd image
		name.attributedText = NSAttributedString.bold("K A Y A Y U", 50, kayayuColor.yellow)
	}
	
	private func configureLoginButton(){
		loginButton = BigButton(buttonText: "LOGIN", buttonColor: kayayuColor.yellow, borderColor: kayayuColor.yellow)
		loginButton.addTarget(self, action: #selector(loginClicked), forControlEvents: .touchUpInside)
		
	}
	
	private func configureRegisterButton(){
		registerButton = BigButton(buttonText: "REGISTER", buttonColor: .white, borderColor: kayayuColor.yellow)
		registerButton.addTarget(self, action: #selector(registerClicked), forControlEvents: .touchUpInside)
		
	}
	
	
	@objc func loginClicked(sender:UIButton)
	{
		self.onOpenLoginPage?()
		print("Kayayu Login Button Clicked")
	}
	
	@objc func registerClicked(sender:UIButton)
	{
		self.onOpenRegisterPage?()
		print("Kayayu Register Button Clicked")
	}
	
}
