//
//  RatioRealisationDetailNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 24/11/21.
//

import Foundation
import AsyncDisplayKit

class RatioRealisationDetailNode: ASDisplayNode {
	private var ratioSummary: SummaryHeader = SummaryHeader()
//	private var tableTransaction: HomeTableTransaction = HomeTableTransaction()
	
	override init() {
		super.init()
	
		backgroundColor = .white
		automaticallyManagesSubnodes = true
	
		configureRatioSummary()
	
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
	
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 10,
												justifyContent: .start,
												alignItems: .start,
												children: [ ratioSummary])
		
		let inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16), child: mainStack)
		
		
		return inset
	}
	
	
	private func configureRatioSummary() {
		ratioSummary = SummaryHeader(summary: .needs, ratio: 0.5, progressColor: .blue, baseColor: .systemPink, progressBarText: "remaining")
	}
	

}
