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
        guard let subsDataCount = viewModel.recurringSubsData.value?.count else {
			return 0
		}
		return subsDataCount
	}
	
	func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
		guard let allSubsData = viewModel.recurringSubsData.value,
			  let subsData = allSubsData[indexPath.row].recurringTransaction,
			  let dueIn = allSubsData[indexPath.row].dueIn else {
			return ASCellNode()
		}

        let nextBillDate = self.viewModel.getNextBillDate(recurringId: subsData.recurring_id)
    
        let cellNode = SubscriptionCellNode(data: subsData, nextBillDate: nextBillDate, dueIn: dueIn)
		return cellNode
	}
    
}

