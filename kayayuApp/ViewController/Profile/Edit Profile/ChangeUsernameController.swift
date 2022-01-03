//
//  ChangeUsernameController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/12/21.
//

import Foundation
import AsyncDisplayKit

class ChangeUsernameController: ASDKViewController<ASDisplayNode> {
	var onBackToEditProfilePage: (() -> Void)?
	
	private let changeUsernameNode: ChangeUsernameNode?
	let viewModel: ProfileViewModel?
	
	init(viewModel: ProfileViewModel) {
		self.changeUsernameNode = ChangeUsernameNode(viewModel: viewModel)
		self.viewModel = viewModel
		super.init(node: changeUsernameNode ?? ASDisplayNode())
		configureNode()
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.changeUsernameNode = nil
		self.viewModel = nil
		super.init(coder: aDecoder)
	}
	
	private func configureNode() {
		changeUsernameNode?.onBackToEditProfilePage = { [weak self] in
			self?.onBackToEditProfilePage?()
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.hidesBackButton = false
		self.navigationController?.navigationBar.prefersLargeTitles = false
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Change Username"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}
