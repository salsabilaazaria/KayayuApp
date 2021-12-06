//
//  ProfileViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/6/21.
//

import Foundation
import AsyncDisplayKit

class ProfileViewController:ASDKViewController<ASDisplayNode> {
	private let profileNode: ProfileNode = ProfileNode()
	
	override init() {
		super.init(node: profileNode)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.hidesBackButton = true
		self.tabBarController?.navigationItem.title = "Profile"
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Profile"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}
