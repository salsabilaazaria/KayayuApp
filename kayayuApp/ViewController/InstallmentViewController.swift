//
//  InstallmentViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/7/21.
//

import Foundation
import AsyncDisplayKit

class InstallmentViewController: ASDKViewController<ASDisplayNode> {
	
	private let installmentNode: InstallmentTableNode = InstallmentTableNode()
	
	override init() {
		super.init(node: installmentNode)
	}
	
	required init?(coder aDecoder: NSCoder) {
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

