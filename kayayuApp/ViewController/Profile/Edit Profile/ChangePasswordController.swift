//
//  ChangePasswordController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/12/21.
//

import Foundation
import AsyncDisplayKit

class ChangePasswordController: ASDKViewController<ASDisplayNode> {
	
	private let changePasswordNode: ChangePasswordNode?
	let viewModel: ProfileViewModel?
	
	init(viewModel: ProfileViewModel) {
		self.changePasswordNode = ChangePasswordNode(viewModel: viewModel)
		self.viewModel = viewModel
		super.init(node: changePasswordNode ?? ASDisplayNode())
		configureNode()
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.changePasswordNode = nil
		self.viewModel = nil
		super.init(coder: aDecoder)
	}
	
	private func configureNode() {

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.hidesBackButton = false
		self.navigationController?.navigationBar.prefersLargeTitles = false
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Change Password"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}
