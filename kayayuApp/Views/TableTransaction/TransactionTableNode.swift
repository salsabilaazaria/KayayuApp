//
//  TransactionTableNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 15/11/21.
//

import Foundation
import AsyncDisplayKit

class TransactionTableNode: ASTableNode {
	private let viewModel: HomeViewModel
	
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		super.init(style: .plain)
		self.delegate = self
		self.dataSource = self
		configureObserver()
		backgroundColor = .white
	}
	
	private func configureObserver() {
		viewModel.reloadUI = {
			self.reloadData()
		}
	}
	
}

extension TransactionTableNode: ASTableDataSource, ASTableDelegate {
	
	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
		guard let count = viewModel.transactionsData.value?.count else {
			return 1
		}
		return count
	}
	
	func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
		guard let transactionsData = viewModel.transactionsData.value,
			  let isIncomeTransaction = transactionsData[indexPath.row].income_flag,
			  let currDate = transactionsData[indexPath.row].transaction_date else {
			return ASCellNode()
		}
		
		let beforeIndex = indexPath.row - 1
		
		if indexPath.row == 0 {
			//data pertama
			let cellNode = TransactionCellNode(isIncomeTransaction: isIncomeTransaction, isDate: true, data: transactionsData[indexPath.row])
			return cellNode
		}
		else if  beforeIndex > 0,
			let beforeDate = transactionsData[beforeIndex].transaction_date,
			beforeDate != currDate {
			//data beda hari
			let cellNode = TransactionCellNode(isIncomeTransaction: isIncomeTransaction, isDate: true, data: transactionsData[indexPath.row])
			return cellNode
			
		}
		else {
			//data dengan hari yang sama
			let cellNode = TransactionCellNode(isIncomeTransaction: isIncomeTransaction, isDate: false, data: transactionsData[indexPath.row])
			return cellNode
		}
		
	
	
		
	}
	
}

