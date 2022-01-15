//
//  TheoryExplanationNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/01/22.
//

import Foundation
import AsyncDisplayKit

class TheoryExplanationNode: ASDisplayNode {
	private let title: ASTextNode = ASTextNode()
	private let theoryDesc: ASTextNode = ASTextNode()
	private let closingDesc: ASTextNode = ASTextNode()
	
	private let needsIcon: ASImageNode = ASImageNode()
	private let wantsIcon: ASImageNode = ASImageNode()
	private let savingsIcon: ASImageNode = ASImageNode()
	
	private let needsTitle: ASTextNode = ASTextNode()
	private let wantsTitle: ASTextNode = ASTextNode()
	private let savingsTitle: ASTextNode = ASTextNode()
	
	private let needsDesc: ASTextNode = ASTextNode()
	private let wantsDesc: ASTextNode = ASTextNode()
	private let savingsDesc: ASTextNode = ASTextNode()
	
	override init() {
		
		super.init()
		backgroundColor = .white
		configureNode()
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		
		let needsDescription = createRatioDesc(iconName: "needsIcon.png", titleString: "\(kayayuRatioTitle.needs.rawValue) (50%)", descString: "Needs are things you must pay no matter what: housing, food, transportation, insurance and etc.")
		let wantsDescription = createRatioDesc(iconName: "wantsIcon.png", titleString: "\(kayayuRatioTitle.wants.rawValue) (30%)", descString: "Wants are things that is nice to have: exclusive clothes, restaurant meals, streaming subscriptions, and etc.")
		let savingsDescription = createRatioDesc(iconName: "savingsIcon.png", titleString: "\(kayayuRatioTitle.savings.rawValue) (20%)", descString: "Savings is everything left after you take care of Needs and Wants, set aside for the future. ")
		
		let ratioSpec =  ASStackLayoutSpec(direction: .vertical,
										   spacing: 8,
										   justifyContent: .start, alignItems: .start,
										   children: [needsDescription, wantsDescription, savingsDescription])
		
		let titleSpec = ASStackLayoutSpec(direction: .vertical,
										   spacing: 20,
										   justifyContent: .center, alignItems: .center,
										   children: [title, theoryDesc])
		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 16,
										 justifyContent: .start, alignItems: .start,
										 children: [titleSpec, ratioSpec, closingDesc])
		
		let mainSpecInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), child: mainSpec)
		
		
		return mainSpecInset
	}
	
	
	private func createRatioDesc(iconName: String, titleString: String, descString: String) -> ASLayoutSpec {
		let ratioTitle: ASTextNode = ASTextNode()
		ratioTitle.attributedText = NSAttributedString.semibold(titleString, 16, .black)
	
		let ratioDesc: ASTextNode = ASTextNode()
		ratioDesc.maximumNumberOfLines = 4
		ratioDesc.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 100, height: 50)
		ratioDesc.attributedText = NSAttributedString.normal(descString, 12, .black)
		
		let icon: ASImageNode = ASImageNode()
		icon.style.preferredSize = CGSize(width: 60, height: 60)
		icon.image = UIImage(named: "\(iconName).png")
		
		let textSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 8,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [ratioTitle, ratioDesc])
		
		let ratioSpec = ASStackLayoutSpec(direction: .horizontal,
										  spacing: 8,
										  justifyContent: .start,
										  alignItems: .center,
										  children: [icon, textSpec])
		
		
		return ratioSpec
	}
	
	private func configureNode() {
		title.attributedText = NSAttributedString.bold("The Balanced Money Formula", 20, .black)
		theoryDesc.attributedText = NSAttributedString.normal("The Balance Money Formula is a budgeting formula based on your net income (your income after taxes). It divides expenses into three categories: Needs, Wants, and Savings.", 14, .black)
		closingDesc.attributedText = NSAttributedString.normal("If you want to know more about The Balance Money Formula you can read it from All Your Worth Book by Elizabeth Warren and Amelia Warren Tyagi", 14, .black)
	}
}
