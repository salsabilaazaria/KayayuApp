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
	var onOpenProfilePage: (() -> Void)?
	
	private let homeNode: HomeComponentNode = HomeComponentNode()
	private let navBar: TabBar = TabBar()
	private let addRecordBtn: ASButtonNode = ASButtonNode()
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.homeNode = HomeComponentNode(viewModel: viewModel)
		super.init()
//        print(viewModel.user.value?.balance_total)
//        viewModel.getUserData()
        
     
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
		
		let homeStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [homeNode])
	
		let tabBar = ASStackLayoutSpec(direction: .vertical, spacing: 20, justifyContent: .end, alignItems: .end, children: [addRecordBtn])

		let mainSpec = ASOverlayLayoutSpec(child: homeStack, overlay: tabBar)
		
		return mainSpec
	}
	
	

	
}

