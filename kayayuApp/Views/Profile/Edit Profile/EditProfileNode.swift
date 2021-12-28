//
//  EditProfileNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/12/21.
//

import Foundation
import AsyncDisplayKit

class EditProfileNode: ASDisplayNode {
	var onOpenChangeEmailPage: (() -> Void)?
	var onOpenChangeUsernamePage: (() -> Void)?
	var onOpenChangePasswordPage: (() -> Void)?
	
	private let username: ASTextNode = ASTextNode()
	private let email: ASTextNode = ASTextNode()
	
	private var changeUsername: ProfileCellNode = ProfileCellNode()
	private var changeEmail: ProfileCellNode = ProfileCellNode()
	private var changePassword: ProfileCellNode = ProfileCellNode()
	
	private let scrollNode: ASScrollNode = ASScrollNode()
	
	private let viewModel: ProfileViewModel
	
	init(viewModel: ProfileViewModel) {
		self.viewModel = viewModel
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
		guard let usernameString = self.viewModel.user.value?.username else {
			return
		}
		username.attributedText = NSAttributedString.bold(usernameString, 16, .black)
	}
	
	private func configureEmail() {
		guard let emailString = self.viewModel.user.value?.email else {
			return
		}
		email.attributedText = NSAttributedString.semibold(emailString, 16, .gray)
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
		configureChangeUsernameNode()
		configureChangeEmailNode()
		configureChangePasswordNode()
		
		let listSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: 0,
										  justifyContent: .start,
										  alignItems: .stretch,
										  children: [changeUsername,
													 changeEmail,
													 changePassword])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										  spacing: 30,
										  justifyContent: .start,
										  alignItems: .stretch,
										  children: [listSpec])

		return mainSpec
	}
	
	private func configureChangeUsernameNode() {
		changeUsername = ProfileCellNode(icon: "", title: "Change Username")
		changeUsername.buttonNode.addTarget(self, action: #selector(changeUsernameTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func changeUsernameTapped(sender: ASButtonNode) {
		self.onOpenChangeUsernamePage?()
	}
	
	private func configureChangeEmailNode() {
		changeEmail = ProfileCellNode(icon: "", title: "Change Email")
		changeEmail.buttonNode.addTarget(self, action: #selector(changeEmailTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func changeEmailTapped(sender: ASButtonNode) {
		self.onOpenChangeEmailPage?()
	}
	
	private func configureChangePasswordNode() {
		changePassword = ProfileCellNode(icon: "", title: "Change Password")
		changePassword.buttonNode.addTarget(self, action: #selector(changePasswordTapped), forControlEvents: .touchUpInside)
	}
	
	
	@objc func changePasswordTapped(sender: ASButtonNode) {
		self.onOpenChangePasswordPage?()
	}

	
	
}
