//
//  LandingViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 19/11/21.
//

import Foundation
import AsyncDisplayKit

class LandingViewController:ASDKViewController<ASDisplayNode> {
	
	var onOpenLoginPage: (() -> Void)?
	var onOpenRegisterPage: (() -> Void)?
	
	private let landingPage: LandingNode?
	private let navBar: TabBar?
	
	override init() {
		print("landing view controller")
		let navBar = TabBar()
		let landingPage = LandingNode()
		
		self.navBar = navBar
		self.landingPage = landingPage
		super.init(node: landingPage)
		configureNode()
		
	}
	
	private func configureNode() {
		landingPage?.onOpenLoginPage = { [weak self] in
			self?.onOpenLoginPage?()
		}
		
		landingPage?.onOpenRegisterPage = { [weak self] in
			self?.onOpenRegisterPage?()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.landingPage = nil
		self.navBar = nil
		super.init(coder: aDecoder)
	}
	
	// MARK: - Private methods -
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.navigationBar.isHidden = true
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.isHidden = true
	}

}
