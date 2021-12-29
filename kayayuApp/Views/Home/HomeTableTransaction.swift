//
//  HomeTableTransaction.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 18/11/21.
//

import Foundation
import AsyncDisplayKit

class HomeTableTransaction: ASDisplayNode {
	var changeMonthData: ((Date) -> Void)?
	private let transactionTableHeader: TransactionTableHeaderNode
	private let transactionTableNode: TransactionTableNode
	private let viewModel: HomeViewModel
	
	private let calendarHelper: CalendarHelper = CalendarHelper()
	
    init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		self.transactionTableNode = TransactionTableNode(viewModel: viewModel)
		self.transactionTableHeader = TransactionTableHeaderNode(viewModel: viewModel)
		
		super.init()
		
		configureNode()
		backgroundColor = kayayuColor.softGrey
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let tableTransactionInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0,
																left: 16,
																bottom: 0,
																right: 16),
										   child: transactionTableNode)
		
		let tableSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 10,
										 justifyContent: .start,
										 alignItems: .stretch,
										 children: [transactionTableHeader, tableTransactionInset])
		
		return tableSpec
	}
	
	private func configureNode() {
		transactionTableNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.55)

		transactionTableHeader.changeMonthData = { [weak self] date in
			let monthInt = self?.calendarHelper.monthInt(date: date)
			self?.viewModel.getTransactionDataSpecMonth(diff: monthInt ?? 0)
			
		}
	}
	
}
