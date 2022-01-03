//
//  LoginViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 19/11/21.
//

import Foundation
import AsyncDisplayKit

class LoginViewController: ASDKViewController<ASDisplayNode> {
	
	var onCreateTabBar: (() -> Void)?
	var onOpenRegisterPage: (() -> Void)?
	let mainNode: LoginNode?
	
	
	init(authenticationViewModel: AuthenticationViewModel) {
		let mainNode: LoginNode = LoginNode(viewModel: authenticationViewModel)
		self.mainNode = mainNode
	
		super.init(node: mainNode)
		configureNode()
	}
	
	private func configureNode() {
		mainNode?.onCreateTabBar = { [weak self] in
			self?.onCreateTabBar?()
		}
		
		mainNode?.onOpenRegisterPage = { [weak self] in
			self?.onOpenRegisterPage?()
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
