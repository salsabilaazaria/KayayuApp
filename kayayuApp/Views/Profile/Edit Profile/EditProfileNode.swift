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
	
	private var changeUsername: ProfileCellNode = ProfileCellNode()
	private var changeEmail: ProfileCellNode = ProfileCellNode()
	private var changePassword: ProfileCellNode = ProfileCellNode()
	
	private let scrollNode: ASScrollNode = ASScrollNode()
	
	private let viewModel: ProfileViewModel
	
	init(viewModel: ProfileViewModel) {
		self.viewModel = viewModel
		super.init()

		backgroundColor = kayayuColor.lightYellow
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		configureScrollNode()
		
		return ASWrapperLayoutSpec(layoutElement: scrollNode)
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
										  spacing: 8,
										  justifyContent: .start,
										  alignItems: .stretch,
										  children: [changeUsername,
													 changeEmail,
													 changePassword])
		
		let insetList = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0), child: listSpec)

		return insetList
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
