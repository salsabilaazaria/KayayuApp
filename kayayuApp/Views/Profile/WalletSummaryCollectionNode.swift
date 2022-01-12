//
//  WalletSummaryCollectionNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 05/01/22.
//


import Foundation
import AsyncDisplayKit
import RxCocoa
import RxSwift

class WalletSummaryCollectionNode: ASDisplayNode {
	
	private let summaryCollectionNode: ASCollectionNode
	
	private let lineSpacing: CGFloat = 8
	private let sidePadding: CGFloat = 28
	private let cellAspectRatio: CGFloat = 128/375
	
	private let viewModel: ProfileViewModel
	
	private let numberHelper: NumberHelper = NumberHelper()
	
	init(viewModel: ProfileViewModel) {
		self.viewModel = viewModel
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		
		self.summaryCollectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
		
		super.init()
		configureViewModel()
		backgroundColor = .clear
		automaticallyManagesSubnodes = true
		configureSummaryCollectioNode()
		
	}
	
	private func configureSummaryCollectioNode() {
		summaryCollectionNode.delegate = self
		summaryCollectionNode.dataSource = self
		summaryCollectionNode.backgroundColor = .clear
		summaryCollectionNode.showsHorizontalScrollIndicator = false
	}
	
	private func configureViewModel() {
		viewModel.reloadUI = { 
			print("summaryCollectionNode reload ui")
			self.summaryCollectionNode.reloadData()
			self.summaryCollectionNode.relayoutItems()
		}
	}
	
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let cellSize = CGSize(
			width: constrainedSize.max.width,
			height: 100
		)
		
		summaryCollectionNode.style.preferredSize = cellSize

		let summaryCollectionSpec = ASStackLayoutSpec(direction: .vertical,
													   spacing: 0,
													   justifyContent: .center,
													   alignItems: .center,
													   children: [summaryCollectionNode]
		)

		
		return summaryCollectionSpec
	}
}

extension WalletSummaryCollectionNode: ASCollectionDataSource, ASCollectionDelegate {

	func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
		return 4
	}
	
	func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
		return 1
		
	}
	
	func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
		var cellNode: SummaryHeader
		
		if indexPath.section == 0 {
			
			guard let balanceTotal = viewModel.user.value?.balance_total else {
				return ASCellNode()
			}
			cellNode = SummaryHeader(summary: .balance, subtitleText: numberHelper.floatToIdFormat(beforeFormatted: balanceTotal))
			
		} else if indexPath.section == 1 {
			
			guard let needsTotal = viewModel.user.value?.balance_needs else {
				return ASCellNode()
			}
			cellNode = SummaryHeader(summary: .needs, subtitleText: numberHelper.floatToIdFormat(beforeFormatted: needsTotal))
			
		} else if indexPath.section == 2 {
			
			guard let wantsTotal = viewModel.user.value?.balance_wants else {
				return ASCellNode()
			}
			cellNode = SummaryHeader(summary: .wants, subtitleText: numberHelper.floatToIdFormat(beforeFormatted: wantsTotal))
			
		} else if indexPath.section == 3 {
			
			guard let savingsTotal = viewModel.user.value?.balance_savings else {
				return ASCellNode()
			}
			cellNode = SummaryHeader(summary: .savings, subtitleText: numberHelper.floatToIdFormat(beforeFormatted: savingsTotal))
			
		} else {
			cellNode = SummaryHeader()
		}
		collectionNode.isPagingEnabled = false
		collectionNode.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
		collectionNode.isPagingEnabled = true
		
		
		return cellNode
	}
	
}

