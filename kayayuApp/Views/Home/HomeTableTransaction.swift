//
//  HomeTableTransaction.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 18/11/21.
//

import Foundation
import AsyncDisplayKit

class HomeTableTransaction: ASDisplayNode {
	
	private let transactionTableHeader: TransactionTableHeaderNode
	private let transactionTableNode: TransactionTableNode
	private let viewModel: HomeViewModel
	
    init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		self.transactionTableNode = TransactionTableNode(viewModel: viewModel)
		self.transactionTableHeader = TransactionTableHeaderNode(viewModel: viewModel)
		super.init()
		
		transactionTableNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
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
										 alignItems: .start,
										 children: [transactionTableHeader, tableTransactionInset])
		
		return tableSpec
	}
	
}
