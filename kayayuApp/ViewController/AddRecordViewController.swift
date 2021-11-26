//
//  AddRecordViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/11/21.
//

import Foundation
import AsyncDisplayKit

class AddRecordViewController:ASDKViewController<ASDisplayNode> {
	private let addRecordNode: AddRecordeNode = AddRecordeNode()
	
	override init() {
		super.init(node: addRecordNode)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Record"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.isHidden = false
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white
		self.navigationController?.navigationItem.hidesBackButton = false

	}

}

