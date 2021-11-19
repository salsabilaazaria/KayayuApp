//
//  HomeNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/11/21.
//

import Foundation
import AsyncDisplayKit

class HomeNode: ASDisplayNode {
	
	private let tableTransaction: HomeTableTransaction = HomeTableTransaction()
	private var summaryBalanceNode: SummaryHeader = SummaryHeader()

	private let lineSpacing: CGFloat = 8
	private let sidePadding: CGFloat = 28
	private let cellAspectRatio: CGFloat = 128/375
	
	override init() {
		print("home node")
		super.init()
		configureTableTransaction()
		configureSummaryBalance()
		
		backgroundColor = .white
		automaticallyManagesSubnodes = true
		
	}
	
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let summaryCollectionSpec = ASStackLayoutSpec(direction: .vertical,
													  spacing: 0,
													  justifyContent: .center,
													  alignItems: .center,
													  children: [summaryBalanceNode])
		
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 10,
										 justifyContent: .center,
										 alignItems: .center,
										 children: [summaryCollectionSpec, tableTransaction])
		
		
		return mainSpec
	}
	
	
	
	private func configureTableTransaction() {
//		tableTransaction.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 3/4)
	}
	
	private func configureSummaryBalance() {
		summaryBalanceNode = SummaryHeader(summary: .balance, subtitleText: "RpBALANCE")
	}
	
}

