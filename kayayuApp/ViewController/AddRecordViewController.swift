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
		edgesForExtendedLayout = []
		super.viewDidLoad()
		title = "Record"
		navigationItem.backButtonTitle = "Back"
		
	
		
		
		
		
	}
	
	
	
}

