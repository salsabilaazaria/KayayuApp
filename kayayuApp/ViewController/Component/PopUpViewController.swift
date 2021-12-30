//
//  PopUpViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 31/12/21.
//

import Foundation
import AsyncDisplayKit

class PopUpViewController:ASDKViewController<ASDisplayNode> {
	private let popUp: PopUpBackground = PopUpBackground()
	
	override init() {
		super.init(node: popUp ?? ASDisplayNode())
		modalPresentationStyle = .overFullScreen
		modalTransitionStyle = .crossDissolve
	}
	
	required init?(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)
	}
	
	override func viewWillAppear(_ animated: Bool) {
	
	}

	override func viewDidLoad() {
	

	}

}
