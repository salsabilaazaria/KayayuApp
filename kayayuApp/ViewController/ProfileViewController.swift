//
//  ProfileViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/6/21.
//

import Foundation
import AsyncDisplayKit

class ProfileViewController: ASDKViewController<ASDisplayNode> {
	
	var onOpenSubscriptionPage: (() -> Void)?
	var onOpenInstallmentPage: (() -> Void)?
    var onLogout: (() -> Void)?
	
	private let profileNode: ProfileNode = ProfileNode()
	let viewModel: ProfileViewModel?
	
	init(viewModel: ProfileViewModel) {
		self.viewModel = viewModel
		super.init(node: profileNode)
		configureNode()
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.viewModel = nil
		super.init(coder: aDecoder)
	}
	
	private func configureNode() {
		profileNode.onOpenSubscriptionPage = { [weak self] in
			self?.onOpenSubscriptionPage?()
		}
		profileNode.onOpenInstallmentPage = { [weak self] in
			self?.onOpenInstallmentPage?()
		}
        profileNode.onLogout = { [weak self] in
            self?.onLogout?()
        }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.hidesBackButton = true
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.tabBarController?.navigationItem.title = "Profile"
		self.navigationController?.tabBarController?.tabBar.isTranslucent = false
		self.navigationController?.tabBarController?.tabBar.isTranslucent = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Profile"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}
