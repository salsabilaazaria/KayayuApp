//
//  ViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/8/21.
//

import UIKit
import AsyncDisplayKit

class ViewController: ASDKViewController<ASDisplayNode> {
	
	override init() {
		let mainNode = LandingNode()
//		let mainNode = LoginNode()
		super.init(node: mainNode)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


}

