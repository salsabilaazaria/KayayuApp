//
//  TransactionTableNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 15/11/21.
//

import Foundation
import AsyncDisplayKit

class TransactionTableNode: ASTableNode {
	
	init() {
		super.init(style: .plain)
		self.delegate = self
		self.dataSource = self

		backgroundColor = .white
	}
}

extension TransactionTableNode: ASTableDataSource, ASTableDelegate {

	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
		return 30
	}
	
	func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
	 if indexPath.row % 2 == 0 {
			let cellNode = TransactionDateCellNode()
			return cellNode
		} else {
			let cellNode = TransactionCellNode(isIncomeTransaction: false)
			return cellNode
		}

	}
	
}

