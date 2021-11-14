//
//  HomeSummaryCollectionNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/11/21.
//

import Foundation
import AsyncDisplayKit

class HomeSummaryCollectionNode: ASCollectionNode {
	//	private let balanceSummary: SummaryHeader = SummaryHeader()
	//	private let incomeSummary: SummaryHeader = SummaryHeader()
	//	private let expenseSummary: SummaryHeader = SummaryHeader()
	private let summaryCollection: ASCollectionNode
	
	
	override init() {
	
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal

		flowLayout.itemSize = CGSize(width: 100, height:80)
		flowLayout.sectionInset = .zero
		flowLayout.minimumInteritemSpacing = 0.0
	
		
		self.summaryCollection = ASCollectionNode(collectionViewLayout: flowLayout)
		
		super.init()
		backgroundColor = .white
		summaryCollection.delegate = self
		summaryCollection.dataSource = self
//		summaryCollection.style.preferredSize = CGSize(width: UIScreen.main.bounds.width-32, height: 80)
	
//		summaryCollection.view.showsHorizontalScrollIndicator = true
//		summaryCollection.view.showsVerticalScrollIndicator = false
//		summaryCollection.isPagingEnabled = true
		print("scroll direction\(summaryCollection.scrollDirection.isEmpty)")
		summaryCollection.automaticallyRelayoutOnSafeAreaChanges = false
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0,
															   left: 0,
															   bottom: 0,
															   right: 0),
										  child: summaryCollection)
		
		return mainInset
	}
	
}
extension HomeNode: ASCollectionDataSource, ASCollectionDelegate, UICollectionViewDelegate{

//	func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
//		return 3
//	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
	}
	  
	
	func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {

		if indexPath.row == 0 {
			let balanceSummary = SummaryHeader(summary: .balance, subtitleText: "Rp10.000")
//			balanceSummary.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 80)
			return balanceSummary
		} else if indexPath.row == 1 {
			let incomeSummary = SummaryHeader(summary: .income, subtitleText: "Rp20.000")
//			incomeSummary.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 80)
			return incomeSummary
		} else if indexPath.row == 2 {
			let expenseSummary = SummaryHeader(summary: .expense, subtitleText: "Rp30.000")
//			expenseSummary.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 80)
			return expenseSummary
		} else {
			return ASCellNode()
		}
	}
	  
}

