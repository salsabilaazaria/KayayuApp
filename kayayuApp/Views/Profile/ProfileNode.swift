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
	var onOpenEditProfile: (() -> Void)?
    var onLogout: (() -> Void)?
    
	private let username: ASTextNode = ASTextNode()
	private let email: ASTextNode = ASTextNode()
	private var balanceSummary: SummaryHeader = SummaryHeader()
	private var walletSummary: WalletSummaryCollectionNode
	
	private var subscriptionNode: ProfileCellNode = ProfileCellNode()
	private var installmentNode: ProfileCellNode = ProfileCellNode()
	private var editProfileNode: ProfileCellNode = ProfileCellNode()
	private var logoutNode: ProfileCellNode = ProfileCellNode()
	
	private let scrollNode: ASScrollNode = ASScrollNode()
	private let backgroundNode: ASDisplayNode = ASDisplayNode()
	
	private let authViewModel: AuthenticationViewModel
	private let profileViewModel: ProfileViewModel
	
	private let numberHelper: NumberHelper = NumberHelper()
	
	init(authViewModel: AuthenticationViewModel, profileViewModel: ProfileViewModel) {
		self.authViewModel = authViewModel
		self.profileViewModel = profileViewModel
		self.walletSummary = WalletSummaryCollectionNode(viewModel: profileViewModel)
		super.init()
		backgroundNode.backgroundColor = kayayuColor.lightYellow
		backgroundNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
		backgroundColor = .white
		automaticallyManagesSubnodes = true
	}
    
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		configureUsername()
		configureEmail()
		configureBalanceSummary()
		configureScrollNode()
		
		let backgroundSpec = ASStackLayoutSpec(direction: .vertical,
											   spacing: 0,
											   justifyContent: .end,
											   alignItems: .end,
											   children: [backgroundNode])
		
		let userInfoStack = ASStackLayoutSpec(direction: .vertical,
											 spacing: 8,
											 justifyContent: .start,
											 alignItems: .start,
											 children: [username, email])
		
		let profileStack = ASStackLayoutSpec(direction: .vertical,
											 spacing: 16,
											 justifyContent: .start,
											 alignItems: .start,
											 children: [userInfoStack, walletSummary])
		
		let profileInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), child: profileStack)
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
											spacing: 0,
											justifyContent: .start,
											alignItems: .start,
											children: [profileInset, scrollNode])
		
		let back = ASOverlayLayoutSpec(child: backgroundSpec, overlay: mainSpec)
		
		return back
	}
	
	private func configureUsername() {
		guard let usernameString = self.authViewModel.getUserData()?.displayName else {
			return
		}
		username.attributedText = NSAttributedString.bold(usernameString, 16, .black)
	}
	
	private func configureEmail() {
		guard let emailString = self.authViewModel.getUserData()?.email else {
			return
		}
		email.attributedText = NSAttributedString.semibold(emailString, 16, .gray)
	}
	
	private func configureBalanceSummary() {
		guard let balanceTotal = self.profileViewModel.user.value?.balance_total else {
			return
		}
		balanceSummary = SummaryHeader(summary: .balance, subtitleText: numberHelper.floatToIdFormat(beforeFormatted: balanceTotal))
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
		
		let mainSpecInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0), child: mainSpec)

		return mainSpecInset
	}
	
	private func configureSubscriptionNode() {
		subscriptionNode = ProfileCellNode(icon: "subscription.png", title: "Subscription")
		subscriptionNode.buttonNode.addTarget(self, action: #selector(subscriptionTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func subscriptionTapped(sender: ASButtonNode) {
		print("subscription tapped")
		self.onOpenSubscriptionPage?()
	}
	
	private func configureInstallmentNode() {
		installmentNode = ProfileCellNode(icon: "installment.png", title: "Installment")
		installmentNode.buttonNode.addTarget(self, action: #selector(installmentTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func installmentTapped(sender: ASButtonNode) {
		self.onOpenInstallmentPage?()
	}
	
	private func configureEditProfileNode() {
		editProfileNode = ProfileCellNode(icon: "editProfile.png", title: "Edit Profile")
		editProfileNode.buttonNode.addTarget(self, action: #selector(editProfileTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func editProfileTapped(sender: ASButtonNode) {
		self.onOpenEditProfile?()
	}
	
	private func configureLogoutNode() {
		logoutNode = ProfileCellNode(icon: "logout.png", title: "Logout")
		logoutNode.buttonNode.addTarget(self, action: #selector(logoutTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func logoutTapped(sender: ASButtonNode) {
        self.onLogout?()
	}
	
	
}
