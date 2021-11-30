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
	var onOpenAddRecordPage: (() -> Void)?
	
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
	
	private func configureHomeNode() {
		homeNode.onOpenAddRecordPage = { [weak self] in
			self?.onOpenAddRecordPage?()
		}
	}
	
	// MARK: - Private methods -
	

	override func viewDidLoad() {
		edgesForExtendedLayout = []
		super.viewDidLoad()
		title = "Hello!"
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white
		self.navigationController?.navigationItem.largeTitleDisplayMode = .always
	
	
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationItem.backButtonTitle = "Back"
	}

}
