//
//  TheoryExplanationController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/01/22.
//

import Foundation
import AsyncDisplayKit

class TheoryExplanationController: ASDKViewController<ASDisplayNode> {
	
	private let mainNode: TheoryExplanationNode?
	
	override init() {
		self.mainNode = TheoryExplanationNode()
		
		super.init(node: mainNode ?? ASDisplayNode())
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.mainNode = nil
		super.init(coder: aDecoder)
	}
	

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.navigationItem.title = "Help"
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Help"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.prefersLargeTitles = false
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}

