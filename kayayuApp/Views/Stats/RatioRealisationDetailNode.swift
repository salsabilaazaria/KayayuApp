//
//  RatioRealisationDetailNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 24/11/21.
//

import Foundation
import AsyncDisplayKit

class RatioRealisationDetailNode: ASDisplayNode {
	private let dateSummary: ASTextNode = ASTextNode()
	private var ratioSummary: SummaryHeader = SummaryHeader()
//	private let ratioDetailTransaction: TransactionTableNode = TransactionTableNode()
	
	override init() {
		super.init()
		//comment transaction table node untill its ready
		backgroundColor = .white
		automaticallyManagesSubnodes = true
		
		configureDateSummary()
		configureRatioSummary()
//		configureRatioDetailTransaction()
		
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
	
//		let mainStack = ASStackLayoutSpec(direction: .vertical,
//										  spacing: 10,
//												justifyContent: .start,
//												alignItems: .start,
//												children: [dateSummary, ratioSummary, ratioDetailTransaction])
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 10,
												justifyContent: .start,
												alignItems: .start,
												children: [dateSummary, ratioSummary])
		
		let inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16), child: mainStack)
		
		
		return inset
	}
	
	private func configureDateSummary() {
		dateSummary.attributedText = NSAttributedString.bold("JULY 2021", 16, .black)
	}
	
	private func configureRatioSummary() {
		ratioSummary = SummaryHeader(summary: .needs, ratio: 0.5, progressColor: .blue, baseColor: .systemPink, progressBarText: "remaining")
	}
	
//	private func configureRatioDetailTransaction() {
//		ratioDetailTransaction.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 7/10)
//	}
}
