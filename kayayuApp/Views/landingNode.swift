//
//  landingNode.swift
//  KayayuApp
//
//  Created by Salsabila Azaria on 11/8/21.
//

import Foundation
import AsyncDisplayKit

class landingNode: ASDisplayNode {
	
	private let logo: ASImageNode = ASImageNode()
	private let name: ASTextNode = ASTextNode()
	
	private let loginButton: ASButtonNode = ASButtonNode()
	private let registerButton: ASButtonNode = ASButtonNode()
	
	
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
//		let loginSpec = configureLoginButton()
		
//		let registerSpec = configureRegisterButton()
		
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
		loginButton.setAttributedTitle(NSAttributedString.semibold("LOGIN", 16, kayayuColor.yellow), for: .normal)

		loginButton.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 64, height: 60)
		loginButton.backgroundColor = .white
		loginButton.borderColor = kayayuColor.yellow.cgColor
		loginButton.borderWidth = 1.0
		loginButton.cornerRadius = 8.0
		loginButton.addTarget(self, action: #selector(loginClicked), forControlEvents: .touchUpInside)
		
	}
	
	private func configureRegisterButton(){
		registerButton.setAttributedTitle(NSAttributedString.semibold("REGISTER", 16, .white), for: .normal)
		registerButton.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 64, height: 60)
		registerButton.backgroundColor = kayayuColor.yellow
		registerButton.borderColor = kayayuColor.yellow.cgColor
		registerButton.borderWidth = 1.0
		registerButton.cornerRadius = 8.0
		registerButton.addTarget(self, action: #selector(registerClicked), forControlEvents: .touchUpInside)
		
	}
	
	
	@objc func loginClicked(sender:UIButton)
	{
		print("LOGIN CLICKED")
	}
	
	@objc func registerClicked(sender:UIButton)
	{
		print("REGISTER CLICKED")
	}
	
	
	
}
