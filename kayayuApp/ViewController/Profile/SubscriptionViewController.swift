//
//  SubscriptionViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/7/21.
//


import Foundation
import AsyncDisplayKit

class SubscriptionViewController: ASDKViewController<ASDisplayNode> {

    private let subsNode: SubscriptionTableNode?
    private let viewModel: ProfileViewModel?
    
    init(viewModel: ProfileViewModel){
        self.viewModel = viewModel
        self.subsNode = SubscriptionTableNode(viewModel: viewModel)

        super.init(node: subsNode ?? ASDisplayNode())
    }

	required init?(coder aDecoder: NSCoder) {
		self.subsNode = nil
		self.viewModel = nil
		super.init(coder: aDecoder)
	}
	
	private func configureNode() {

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.navigationItem.title = "My Subscription"
	}

	override func viewDidLoad() {
		title = "My Subscription"
		edgesForExtendedLayout = []
		super.viewDidLoad()
		self.navigationController?.navigationBar.prefersLargeTitles = false
		self.navigationController?.navigationBar.backgroundColor = .white
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}

