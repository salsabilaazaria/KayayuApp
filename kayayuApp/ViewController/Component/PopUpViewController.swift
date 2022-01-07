//
//  PopUpViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 31/12/21.
//

import Foundation
import AsyncDisplayKit

class PopUpViewController:ASDKViewController<ASDisplayNode> {
	private let popUp: PopUpBackground?
	
	init(type: popUpType) {
		self.popUp = PopUpBackground(type: type)
		super.init(node: popUp ?? ASDisplayNode())
		modalPresentationStyle = .overFullScreen
		modalTransitionStyle = .crossDissolve
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.popUp = nil
		super.init(coder: aDecoder)
	}
	
	override func viewWillAppear(_ animated: Bool) {
	
	}

	override func viewDidLoad() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
		popUp?.view.addGestureRecognizer(tapGestureRecognizer)

	}
	
	@objc func didTapView(_ sender: UITapGestureRecognizer) {
		self.dismiss(animated: true, completion: nil)
	}

}
