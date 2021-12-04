//
//  HomeViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 18/11/21.
//

import Foundation
import AsyncDisplayKit

class HomeViewController:ASDKViewController<ASDisplayNode> {
	private let homeNode: HomeNode = HomeNode()
	
	override init() {
		//authenticationViewModel.username -> manggil variable yang ada di AuthenticationViewModel
//		print("auth home vc \(authenticationViewModel.username)")
		super.init(node: homeNode)
	}
	
	required init?(coder aDecoder: NSCoder) {
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
