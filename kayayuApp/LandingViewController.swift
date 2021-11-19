//
//  LandingViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 19/11/21.
//

import Foundation
import AsyncDisplayKit

class LandingViewController:ASDKViewController<ASDisplayNode> {
	private let landingPage: LandingNode?
	private let navBar: TabBar?
	
	override init() {
		print("home view controller")
		let navBar = TabBar()
		let landingPage = LandingNode()
		
		self.navBar = navBar
		self.landingPage = landingPage
		super.init(node: landingPage)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.landingPage = nil
		self.navBar = nil
		super.init(coder: aDecoder)
	}
	
	// MARK: - Private methods -
	

	override func viewDidLoad() {
		super.viewDidLoad()
		edgesForExtendedLayout = []
	}

}
