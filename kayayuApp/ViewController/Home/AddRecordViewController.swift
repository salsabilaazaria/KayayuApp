//
//  AddRecordViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/11/21.
//

import Foundation
import AsyncDisplayKit

class AddRecordViewController:ASDKViewController<ASDisplayNode> {
	var onOpenHomePage: (() -> Void)?
	
	private let addRecordNode: AddRecordeNode?
	private let viewModel: HomeViewModel?
	
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		self.addRecordNode = AddRecordeNode(viewModel: viewModel)
		super.init(node: addRecordNode ?? ASDisplayNode())
		configureNode()
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.viewModel = nil
		self.addRecordNode = nil
		super.init(coder: aDecoder)
	}
	
	private func configureNode() {
		addRecordNode?.onOpenHomePage = { [weak self] in
			self?.onOpenHomePage?()
			
		}
		
		addRecordNode?.onErrorData = { [weak self] in
			let controller = PopUpViewController(type: .invalidData)
			self?.present(controller, animated: true, completion: nil)
		}
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

