//
//  HomeViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 18/11/21.
//

import Foundation
import AsyncDisplayKit

class HomeViewController:ASDKViewController<ASDisplayNode> {
	private let homeNode: HomeNode?
    private let viewModel: HomeViewModel?
	
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.homeNode = HomeNode(viewModel: viewModel)
	
        super.init(node: homeNode ?? ASDisplayNode())
	}
	
	required init?(coder aDecoder: NSCoder) {
        self.viewModel = nil
        self.homeNode = nil
		super.init(coder: aDecoder)
	}
	
	// MARK: - Private methods -
	

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Hello!"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.isHidden = false
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}
