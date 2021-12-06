//
//  StatsViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/23/21.
//

import Foundation
import AsyncDisplayKit

class StatsViewController:ASDKViewController<ASDisplayNode> {
	private let statsNode: StatsNode = StatsNode()
	
	override init() {
		super.init(node: statsNode)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.hidesBackButton = true
		self.tabBarController?.navigationItem.title = "Stats"
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Stats"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}
