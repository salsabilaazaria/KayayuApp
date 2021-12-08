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
		contentInset.bottom = 100
	}
	
	private func configureObserver() {
		viewModel.reloadUI = {
			self.reloadData()
		}
	}
	
}

extension TransactionTableNode: ASTableDataSource, ASTableDelegate {
	// table view need to change by sections after array of data is grouped by day
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
			guard let transDate = transactionsData[indexPath.row].transaction_date else {
				return ASCellNode()
			}

			let incomePerDay = viewModel.calculateIncomePerDay(date: transDate)
			let expensePerDay = viewModel.calculateExpensePerDay(date: transDate)

			let cellNode = TransactionCellNode(isIncomeTransaction: isIncomeTransaction, data: transactionsData[indexPath.row], incomePerDay: incomePerDay, expensePerDay: expensePerDay)
			return cellNode
		} else if beforeIndex >= 0,
				let beforeDate = transactionsData[beforeIndex].transaction_date,
				beforeDate != currDate {
			
			//data beda hari
			guard let transDate = transactionsData[indexPath.row].transaction_date else {
				return ASCellNode()
			}
			
			let incomePerDay = viewModel.calculateIncomePerDay(date: transDate)
			let expensePerDay = viewModel.calculateExpensePerDay(date: transDate)
			
			let cellNode = TransactionCellNode(isIncomeTransaction: isIncomeTransaction, data: transactionsData[indexPath.row],incomePerDay: incomePerDay, expensePerDay: expensePerDay)
			return cellNode
		}
		else {
			//data dengan hari yang sama
			let cellNode = TransactionCellNode(isIncomeTransaction: isIncomeTransaction, data: transactionsData[indexPath.row])
			return cellNode
		}
		
	}
	
	func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			guard let tempTransactionsData = viewModel.transactionsData.value else {
				return
			}
//			viewModel.deleteTransactionData(transactionDelete: tempTransactionsData[indexPath.row])
//
//			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
	
}

