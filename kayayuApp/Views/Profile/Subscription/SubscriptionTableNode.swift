//
//  SubscriptionTableNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/6/21.
//

import Foundation
import AsyncDisplayKit

class SubscriptionTableNode: ASTableNode {
	
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
		super.init(style: .plain)
		self.delegate = self
		self.dataSource = self
		
		configureObserver()
		
		automaticallyManagesSubnodes = true
		backgroundColor = .white
	}
	
	private func configureObserver() {
		viewModel.reloadUI = {
			self.reloadData()
		}
	}
	
}

extension SubscriptionTableNode: ASTableDataSource, ASTableDelegate {
	
	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
		guard let subsDataCount = viewModel.recurringData.value?.count else {
			return 0
		}
		return subsDataCount
	}
	
	func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
		guard let allSubsData = viewModel.recurringData.value else {
			return ASCellNode()
		}
		let subsData = allSubsData[indexPath.row]
		let cellNode = SubscriptionCellNode(data: subsData)
		return cellNode
	}
	
}

