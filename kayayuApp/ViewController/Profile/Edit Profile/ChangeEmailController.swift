//
//  ChangeEmailController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/12/21.
//

import Foundation
import AsyncDisplayKit

class ChangeEmailController: ASDKViewController<ASDisplayNode> {
	
	private let changeEmailNode: ChangeEmailNode?
	let viewModel: ProfileViewModel?
	
	init(viewModel: ProfileViewModel) {
		self.changeEmailNode = ChangeEmailNode(viewModel: viewModel)
		self.viewModel = viewModel
		super.init(node: changeEmailNode ?? ASDisplayNode())
		configureNode()
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.changeEmailNode = nil
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
		title = "Change Email"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}
