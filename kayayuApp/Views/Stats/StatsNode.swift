//
//  StatsNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/23/21.
//

import Foundation
import AsyncDisplayKit

class StatsNode: ASDisplayNode {
	private let planButton: ASButtonNode = ASButtonNode()
	private let realisationButton: ASButtonNode = ASButtonNode()
	private let planNode: PlanStatsNode = PlanStatsNode()
	private let realisationNode: RealisationStatsNode = RealisationStatsNode()
	private let tabBar: TabBar = TabBar()
	
	private let buttonSize = CGSize(width: UIScreen.main.bounds.width/2, height: kayayuSize.kayayuBarHeight)
	private var goToPlanNode: Bool = false

	override init() {
		super.init()
		let nodeSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - tabBar.style.preferredSize.height - 200)
		planNode.style.preferredSize = nodeSize
		realisationNode.style.preferredSize = nodeSize
		
		configurePlanButton()
		configureRealisationButton()

		automaticallyManagesSubnodes = true
		
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		let buttonStack = ASStackLayoutSpec(direction: .horizontal,
										  spacing: 0,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [planButton, realisationButton])
		
		buttonStack.style.preferredSize = buttonSize
		
		var statsElementArray: [ASLayoutElement] = [buttonStack]
		
		if goToPlanNode {
			statsElementArray.append(planNode)
		} else {
			statsElementArray.append(realisationNode)
		}
		
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 0,
										  justifyContent: .start,
										  alignItems: .start,
										  children: statsElementArray)
		
//		let tabBarSpec = ASStackLayoutSpec(direction: .vertical, spacing: 20, justifyContent: .end, alignItems: .end, children: [tabBar])



//		let mainSpec = ASOverlayLayoutSpec(child: mainStack, overlay: tabBarSpec)


		return mainStack
	}
	
	private func reloadUI(){
		self.setNeedsLayout()
		self.layoutIfNeeded()
	}

	private func configurePlanButton() {
		planButton.style.preferredSize = buttonSize
		planButton.backgroundColor = .white
		planButton.cornerRadius = 5
		planButton.borderWidth = kayayuSize.kayayuBorderWidth
		planButton.borderColor = UIColor.black.cgColor
		planButton.setAttributedTitle(NSAttributedString.semibold("PLAN", 16, .black), for: .normal)
		planButton.addTarget(self, action: #selector(planButtonTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func planButtonTapped(sender: ASButtonNode) {
		goToPlanNode = true
		self.reloadUI()
		print("Plan")
	}
	
	private func configureRealisationButton() {
		realisationButton.style.preferredSize = buttonSize
		realisationButton.backgroundColor = .white
		realisationButton.cornerRadius = 5
		realisationButton.borderWidth = kayayuSize.kayayuBorderWidth
		realisationButton.borderColor = UIColor.black.cgColor
		realisationButton.setAttributedTitle(NSAttributedString.semibold("REALISATION", 16, .black), for: .normal)
		realisationButton.addTarget(self, action: #selector(realisationButtonTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func realisationButtonTapped(sender: ASButtonNode) {
		goToPlanNode = false
		self.reloadUI()
	}
	


	
}

