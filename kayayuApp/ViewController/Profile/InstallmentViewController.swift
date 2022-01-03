//
//  InstallmentViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/7/21.
//

import Foundation
import AsyncDisplayKit

class InstallmentViewController: ASDKViewController<ASDisplayNode> {
	
	private let instlNode: InstallmentTableNode?
    private let viewModel: ProfileViewModel?
	
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self.instlNode = InstallmentTableNode(viewModel: viewModel)
        
		super.init(node: instlNode ?? ASDisplayNode())
	}
	
	required init?(coder aDecoder: NSCoder) {
        self.instlNode = nil
        self.viewModel = nil
        super.init(coder: aDecoder)
	}
	
	private func configureNode() {

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.navigationItem.title = "My Installment"
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "My Installment"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.prefersLargeTitles = false
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}

