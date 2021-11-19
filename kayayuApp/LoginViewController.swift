//
//  LoginViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 19/11/21.
//

import Foundation
import AsyncDisplayKit

class LoginViewController: ASDKViewController<ASDisplayNode> {
	
	var onOpenHomePage: (() -> Void)?
	var onOpenRegisterPage: (() -> Void)?
	
	let mainNode: LoginNode = LoginNode()
	
	override init() {
		super.init(node: mainNode)
		configureNode()
	}
	
	private func configureNode() {
		mainNode.onOpenHomePage = { [weak self] in
			self?.onOpenHomePage?()
		}
		
		mainNode.onOpenRegisterPage = { [weak self] in
			self?.onOpenRegisterPage?()
		}

	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Private methods -
	

	override func viewDidLoad() {
		super.viewDidLoad()
		edgesForExtendedLayout = []
	}

}
