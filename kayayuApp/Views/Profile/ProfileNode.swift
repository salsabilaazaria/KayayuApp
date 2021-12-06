//
//  ProfileNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 02/12/21.
//

import Foundation
import AsyncDisplayKit

class ProfileNode: ASDisplayNode {
	var onOpenSubscriptionPage: (() -> Void)?
	var onOpenInstallmentPage: (() -> Void)?
	
	private let username: ASTextNode = ASTextNode()
	private let email: ASTextNode = ASTextNode()
	
	private var subscriptionNode: ProfileCellNode = ProfileCellNode()
	private var installmentNode: ProfileCellNode = ProfileCellNode()
	private var editProfileNode: ProfileCellNode = ProfileCellNode()
	private var logoutNode: ProfileCellNode = ProfileCellNode()
	
	private let scrollNode: ASScrollNode = ASScrollNode()
	
	override init() {
		
		super.init()

		backgroundColor = .white
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		configureUsername()
		configureEmail()
		configureScrollNode()
		
		let profileStack = ASStackLayoutSpec(direction: .vertical,
											 spacing: 10,
											 justifyContent: .start,
											 alignItems: .start,
											 children: [username, email])
		
		let profileInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16), child: profileStack)
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
											spacing: 0,
											justifyContent: .start,
											alignItems: .start,
											children: [profileInset, scrollNode])
		
		return mainSpec
	}
	
	
	
	private func configureUsername() {
		username.attributedText = NSAttributedString.bold("salsabilaazaria", 16, .black)
	}
	
	private func configureEmail() {
		email.attributedText = NSAttributedString.semibold("salsa@gmail.com", 16, .gray)
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
			return(self?.createScrollNode(constrainedSize) ?? ASLayoutSpec())
		}
	}
	
	private func createScrollNode(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		configureSubscriptionNode()
		configureInstallmentNode()
		configureEditProfileNode()
		configureLogoutNode()
		
		let listSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: 0,
										  justifyContent: .start,
										  alignItems: .stretch,
										  children: [subscriptionNode, installmentNode])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: 30,
										  justifyContent: .start,
										  alignItems: .stretch,
										  children: [listSpec, editProfileNode, logoutNode])

		return mainSpec
	}
	
	private func configureSubscriptionNode() {
		subscriptionNode = ProfileCellNode(icon: "", title: "Subscription")
		subscriptionNode.buttonNode.addTarget(self, action: #selector(subscriptionTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func subscriptionTapped(sender: ASButtonNode) {
		print("subscription tapped")
		self.onOpenSubscriptionPage?()
	}
	
	private func configureInstallmentNode() {
		installmentNode = ProfileCellNode(icon: "", title: "Installment")
		installmentNode.buttonNode.addTarget(self, action: #selector(installmentTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func installmentTapped(sender: ASButtonNode) {
		self.onOpenInstallmentPage?()
	}
	
	private func configureEditProfileNode() {
		editProfileNode = ProfileCellNode(icon: "", title: "Edit Profile")
	}
	
	private func configureLogoutNode() {
		logoutNode = ProfileCellNode(icon: "", title: "Logout")
		logoutNode.buttonNode.addTarget(self, action: #selector(installmentTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func logoutTapped(sender: ASButtonNode) {
		self.onOpenInstallmentPage?()
	}
	
	
}
