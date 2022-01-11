//
//  InstallmentTableNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/7/21.
//
import Foundation
import AsyncDisplayKit

class InstallmentTableNode: ASTableNode {
	
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

extension InstallmentTableNode: ASTableDataSource, ASTableDelegate {
	
	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        guard let instlDataCount = viewModel.recurringInstlData.value?.count else {
            return 0
        }
        return instlDataCount
	}
	
	func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        guard let allInstlData = viewModel.recurringInstlData.value,
			  let instlData = allInstlData[indexPath.row].recurringTransaction,
			  let dueIn = allInstlData[indexPath.row].dueIn  else {
            return ASCellNode()
        }
        
        let nextBillDate = self.viewModel.getNextBillDate(recurringId: instlData.recurring_id)
        let remainingAmount = self.viewModel.getRemainingAmount(recurringId: instlData.recurring_id)
        
        let cellNode = InstallmentCellNode(data: instlData, nextBillDate: nextBillDate, remainingAmount: remainingAmount, dueIn: dueIn)
		return cellNode
	}
	
}

