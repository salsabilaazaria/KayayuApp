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
	private let navBar: TabBar?
	
	override init() {
		print("home view controller")
		let navBar = TabBar()
		let homeNode = HomeNode()
		
		self.navBar = navBar
		self.homeNode = homeNode
		super.init(node: ASDisplayNode())


		self.node.backgroundColor = .white

		self.node.automaticallyManagesSubnodes = true
		self.node.layoutSpecBlock = {_,_ in
			let homeStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [homeNode])
			print("layout spec block")
			let navigationBar = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .end, alignItems: .end, children: [navBar])

			let mainStack = ASOverlayLayoutSpec(child: homeStack, overlay: navigationBar)
		
			return mainStack
		}
		
	
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.homeNode = nil
		self.navBar = nil
		super.init(coder: aDecoder)
	}
	
	// MARK: - Private methods -
	

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Hello!"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}
