//
//  RegisterViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 19/11/21.
//

import Foundation
import AsyncDisplayKit

class RegisterViewController: ASDKViewController<ASDisplayNode> {
	
	var onOpenHomePage: (() -> Void)?
	var onOpenLoginPage: (() -> Void)?
	
	let mainNode: RegisterNode?
	
	init(authenticationViewModel: AuthenticationViewModel) {
		let mainNode = RegisterNode(viewModel: authenticationViewModel)
		self.mainNode = mainNode
		super.init(node: mainNode)
		configureNode()
		
	}
	
	private func configureNode() {
		mainNode?.onOpenHomePage = { [weak self] in
			self?.onOpenHomePage?()
		}
		mainNode?.onOpenLoginPage  = { [weak self] in
			self?.onOpenLoginPage?()
		}

	}
	
	required init?(coder aDecoder: NSCoder) {
		self.mainNode = nil
		super.init(coder: aDecoder)
	}
	
	// MARK: - Private methods -
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.navigationBar.isHidden = true
		self.navigationController?.navigationItem.hidesBackButton = true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.navigationBar.isHidden = false
		self.navigationController?.navigationItem.hidesBackButton = true
	}

}

