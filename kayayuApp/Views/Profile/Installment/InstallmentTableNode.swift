//
//  InstallmentTableNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/7/21.
//
import Foundation
import AsyncDisplayKit

class InstallmentTableNode: ASTableNode {
	
	init() {
		super.init(style: .plain)
		self.delegate = self
		self.dataSource = self
		automaticallyManagesSubnodes = true
		backgroundColor = .white
	}
	
}

extension InstallmentTableNode: ASTableDataSource, ASTableDelegate {
	
	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
		let cellNode = InstallmentCellNode()
		return cellNode
	}
	
}

