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
	
	let mainNode: RegisterNode = RegisterNode()
	
	override init() {
		super.init(node: mainNode)
		configureNode()
		
	}
	
	private func configureNode() {
		mainNode.onOpenHomePage = { [weak self] in
			self?.onOpenHomePage?()
		}
		mainNode.onOpenLoginPage  = { [weak self] in
			self?.onOpenLoginPage?()
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

