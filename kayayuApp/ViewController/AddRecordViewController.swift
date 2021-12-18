//
//  AddRecordViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/11/21.
//

import Foundation
import AsyncDisplayKit

class AddRecordViewController:ASDKViewController<ASDisplayNode> {
	private let addRecordNode: AddRecordeNode?
	private let viewModel: HomeViewModel?
	
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		self.addRecordNode = AddRecordeNode(viewModel: viewModel)
		super.init(node: addRecordNode ?? ASDisplayNode())
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.viewModel = nil
		self.addRecordNode = nil
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		edgesForExtendedLayout = []
		super.viewDidLoad()
		title = "Record"
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.navigationBar.backItem?.backButtonDisplayMode = .minimal
	}
	
	
	
}

