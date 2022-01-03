//
//  HomeNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/11/21.
//

import Foundation
import AsyncDisplayKit

class HomeNode: ASDisplayNode {
	var onOpenAddRecordPage: (() -> Void)?
	var onOpenStatsPage: (() -> Void)?
	
	private let homeTableTransaction: HomeTableTransaction
	private let addRecordBtn: ASButtonNode = ASButtonNode()
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
		self.homeTableTransaction = HomeTableTransaction(viewModel: viewModel)
		super.init()
     
		configureAddRecordBtn()
		backgroundColor = .white
		automaticallyManagesSubnodes = true
		
	}
	
	private func configureAddRecordBtn() {
		addRecordBtn.setImage(UIImage(named: "addRecordBtn.png"), for: .normal)
		addRecordBtn.style.preferredSize = CGSize(width: 80, height: 80)
		addRecordBtn.addTarget(self, action: #selector(goToAddRecord), forControlEvents: .touchUpInside)
	}
	
	@objc func goToAddRecord() {
		print("add button tapped")
		self.onOpenAddRecordPage?()
	}
	
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let homeStack = ASStackLayoutSpec(direction: .vertical, spacing: 32, justifyContent: .spaceAround, alignItems: .stretch, children: [homeTableTransaction])
	
		let addRecordBtnSpec = ASStackLayoutSpec(direction: .vertical,
									   spacing: 20,
									   justifyContent: .end,
									   alignItems: .end,
									   children: [addRecordBtn])
		
		let addRecordBtnInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 30, right: 16), child: addRecordBtnSpec)

		let mainSpec = ASOverlayLayoutSpec(child: homeStack, overlay: addRecordBtnInset)
		
		return mainSpec
	}
	
	

	
}

