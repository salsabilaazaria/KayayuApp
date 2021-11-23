//
//  StatsNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/23/21.
//

import Foundation
import AsyncDisplayKit

class StatsNode: ASDisplayNode {
	private let homeNode: HomeComponentNode = HomeComponentNode()
	private let navBar: TabBar = TabBar()
	private let addRecordBtn: ASButtonNode = ASButtonNode()
	
	override init() {
		super.init()
		configureAddRecordBtn()
		backgroundColor = .white
		automaticallyManagesSubnodes = true
		
	}
	
	private func configureAddRecordBtn() {
		addRecordBtn.setImage(UIImage(named: "addRecordBtn.png"), for: .normal)
		addRecordBtn.style.preferredSize = CGSize(width: 80, height: 80)
	}
	
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let homeStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [homeNode])
	
		let navigationBar = ASStackLayoutSpec(direction: .vertical, spacing: 20, justifyContent: .end, alignItems: .end, children: [addRecordBtn,navBar])

		let mainSpec = ASOverlayLayoutSpec(child: homeStack, overlay: navigationBar)
		
		
		return mainSpec
	}
	
	

	
}

