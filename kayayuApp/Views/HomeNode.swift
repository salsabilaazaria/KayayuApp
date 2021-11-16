//
//  HomeNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/11/21.
//

import Foundation
import AsyncDisplayKit

class HomeNode: ASDisplayNode {
	
	private let summaryCollectionNode: ASCollectionNode
	private let transactionTableNode: TransactionTableNode = TransactionTableNode()
	
	private let lineSpacing: CGFloat = 8
	private let sidePadding: CGFloat = 28
	private let cellAspectRatio: CGFloat = 128/375
	
	override init() {
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 10)
		
		self.summaryCollectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
		self.transactionTableNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 7/10)
		
		super.init()
		
		backgroundColor = .white
		automaticallyManagesSubnodes = true
		configureSummaryCollectioNode()
		
	}
	
	private func configureSummaryCollectioNode() {
		summaryCollectionNode.delegate = self
		summaryCollectionNode.dataSource = self
		summaryCollectionNode.backgroundColor = .clear
		summaryCollectionNode.showsHorizontalScrollIndicator = false
		summaryCollectionNode.showsVerticalScrollIndicator = false

	}
	
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let cellSize = CGSize(
			width: constrainedSize.max.width - 30,
			height: constrainedSize.max.width * cellAspectRatio
		)
		
		summaryCollectionNode.style.preferredSize = cellSize

		let summaryCollectionSpec = ASStackLayoutSpec(direction: .vertical,
													   spacing: 0,
													   justifyContent: .center,
													   alignItems: .center,
													   children: [summaryCollectionNode]
		)
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 10,
												  justifyContent: .center,
												  alignItems: .center,
												  children: [summaryCollectionSpec, transactionTableNode])

		
		return mainSpec
	}
}

extension HomeNode: ASCollectionDataSource, ASCollectionDelegate {

	func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
		return 3
	}
	
	func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
		return 1
		
	}
	
	func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
		var cellNode: SummaryHeader
		
		if indexPath.section == 0 {
			cellNode = SummaryHeader(summary: .balance, subtitleText: "RpBALANCE")
		} else if indexPath.section == 1 {
			cellNode = SummaryHeader(summary: .income, subtitleText: "RpIncome")
		} else if indexPath.section == 2 {
			cellNode = SummaryHeader(summary: .expense, subtitleText: "RpExpense")
		} else {
			cellNode = SummaryHeader()
		}
		collectionNode.isPagingEnabled = false
		collectionNode.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
		collectionNode.isPagingEnabled = true
		
		
		return cellNode
	}
	
}

