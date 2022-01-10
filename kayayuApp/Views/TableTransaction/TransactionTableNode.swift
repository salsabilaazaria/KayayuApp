//
//  TransactionTableNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 15/11/21.
//

import Foundation
import AsyncDisplayKit
import RxCocoa
import RxSwift

class TransactionTableNode: ASTableNode {
	var onDeleteData: ((Transactions) -> Void)?
	private let viewModel: HomeViewModel
	private let calendarHelper: CalendarHelper = CalendarHelper()
	
	private let disposeBag = DisposeBag()
	
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		super.init(style: .plain)
		self.delegate = self
		self.dataSource = self
		configureObserver()
		backgroundColor = .white
		contentInset.bottom = 200
	}
	
	private func configureObserver() {
		self.viewModel.dictTransactionData.asObservable().subscribe(onNext: { _ in
			self.reloadData()
		}).disposed(by: disposeBag)
	}
	
}

extension TransactionTableNode: ASTableDataSource, ASTableDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		guard let count = viewModel.dictTransactionData.value?.count else {
			return 1
		}
		return count
	}

	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
		guard let transData = viewModel.dictTransactionData.value,
			  let count = transData[section].transaction?.count else {
			return 1
		}
		return count
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let allData = viewModel.dictTransactionData.value else {
			return UIView()
		}
		let sectionData = allData[section]
		
		guard let dateComponents = sectionData.date,
			  let date = Calendar.current.date(from: dateComponents) else {
			return UIView()
		}
		
		let incomePerDay = viewModel.calculateIncomePerDay(date: date)
		let expensePerDay = viewModel.calculateExpensePerDay(date: date)
		
		let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40)
		let view = UIView(frame: rect)
		
		let cell = TransactionDateCellNode(date: date, incomePerDay: incomePerDay, expensePerDay: expensePerDay)
		cell.view.frame = rect
		view.addSubview(cell.view)
		
		cell.setNeedsLayout()
		cell.layoutIfNeeded()
		view.setNeedsLayout()
		view.layoutIfNeeded()
		return view
	}
	
	func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
		guard let allData = viewModel.dictTransactionData.value else {
			return ASCellNode()
		}
		
		let sectionData = allData[indexPath.section]
		
		guard let transactionsData = sectionData.transaction?[indexPath.row],
			  let isIncomeTransaction = transactionsData.income_flag else {
			return ASCellNode()
		}
		
		let cell = TransactionCellNode(isIncomeTransaction: isIncomeTransaction, data: transactionsData)
		
		return cell
	}
	
	func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        var numOfIndex: Int = 0
        
        if(indexPath.section == 0){
            numOfIndex = indexPath.row
        }
        else {
            for i in 0...(indexPath.section-1) {
                numOfIndex += numberOfRows(inSection: i)
            }
            
            numOfIndex += indexPath.row
        }
            
        print("get rownum delete: \(indexPath), \(numOfIndex)")
        
		if editingStyle == .delete {
		
			
			guard let tempTransactionsData = viewModel.transactionsData.value else {
				return
			}
			print("get data delete: \(tempTransactionsData[numOfIndex])")
			self.onDeleteData?(tempTransactionsData[numOfIndex])
//			viewModel.deleteTransactionData(transactionDelete: tempTransactionsData[numOfIndex])

		}
	}
	
}

