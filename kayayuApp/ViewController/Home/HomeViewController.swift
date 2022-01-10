//
//  HomeViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 18/11/21.
//

import Foundation
import AsyncDisplayKit

class HomeViewController:ASDKViewController<ASDisplayNode> {
	var onOpenAddRecordPage: (() -> Void)?
	var onDeleteData: ((Transactions) -> Void)?
	
	private let homeNode: HomeNode?
    private let viewModel: HomeViewModel?
	
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.homeNode = HomeNode(viewModel: viewModel)
	
        super.init(node: homeNode ?? ASDisplayNode())
		
		configureHomeNode()
	}
	
	required init?(coder aDecoder: NSCoder) {
        self.viewModel = nil
        self.homeNode = nil
		super.init(coder: aDecoder)
	}
	
	private func configureHomeNode() {
		homeNode?.onOpenAddRecordPage = { [weak self] in
			self?.onOpenAddRecordPage?()
		}
		homeNode?.onDeleteData = { [weak self] transData in
			
			let alert = UIAlertController(title: "Delete Data", message: "Are you sure want to delete '\(transData.description ?? "this data")'?", preferredStyle: UIAlertController.Style.alert)
			
			alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {_ in
				self?.dismiss(animated: true, completion: nil)
			}))
			
			alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: {_ in
				self?.viewModel?.deleteTransactionData(transactionDelete: transData)
			
			}))
			
			self?.present(alert, animated: true, completion: nil)
			
		}
	}
	

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.tintColor = kayayuColor.yellow
		self.tabBarController?.navigationItem.title = "Hello!"
		self.tabBarController?.selectedIndex = 0
	}

	override func viewDidLoad() {
		edgesForExtendedLayout = []
		super.viewDidLoad()
		self.navigationController?.navigationBar.tintColor = kayayuColor.yellow
		self.navigationController?.navigationBar.backgroundColor = .white
		self.navigationController?.navigationItem.largeTitleDisplayMode = .always
		self.navigationController?.navigationBar.isTranslucent = false
		self.tabBarController?.selectedIndex = 0
		let customTabBarItem:UITabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeSelected.png")?.scalePreservingAspectRatio(targetSize: kayayuSize.kayayuTabbarImageSize), selectedImage: UIImage(named: "homeSelected.png")?.scalePreservingAspectRatio(targetSize: kayayuSize.kayayuTabbarImageSize))
		self.tabBarItem = customTabBarItem
	}
	


}
