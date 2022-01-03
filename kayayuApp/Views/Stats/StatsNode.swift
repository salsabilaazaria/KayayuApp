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
	private let planNode: PlanStatsNode
	private let realisationNode: RealisationStatsNode
	private let statsDateHeader = StatsDateHeader()
	
	private let buttonSize = CGSize(width: UIScreen.main.bounds.width/2, height: kayayuSize.kayayuBarHeight)
	private var goToPlanNode: Bool = false
	
	private let viewModel: StatsViewModel
	
	private let calendarHelper: CalendarHelper = CalendarHelper()

	init(viewModel: StatsViewModel) {
		self.viewModel = viewModel
		self.planNode = PlanStatsNode(viewModel: viewModel)
		self.realisationNode = RealisationStatsNode(viewModel: viewModel)
		super.init()
		
		let nodeSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - TabBar().style.preferredSize.height - 200)
		planNode.style.preferredSize = nodeSize
		realisationNode.style.preferredSize = nodeSize
		statsDateHeader.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: kayayuSize.kayayuBarHeight)
		
		configurePlanButton()
		configureRealisationButton()
		configureNode()
		
		viewModel.reloadUI = {
			self.planNode.reloadUI()
			self.realisationNode.reloadUI()
		}

		automaticallyManagesSubnodes = true
		
	}
	
	private func configureNode() {
		self.statsDateHeader.changeMonthStats = { [weak self] date in
			print("selectedMonth")
		
			guard let month = self?.calendarHelper.monthInt(date: date),
				  let year = self?.calendarHelper.yearInt(date: date),
				  let startDate = self?.calendarHelper.getSpecStartMonth(month: month, year: year),
				  let endDate = self?.calendarHelper.getSpecEndMonth(month: month, year: year) else {
				return
			}
			
			self?.viewModel.getAllIncomeData(startDate: startDate, endDate: endDate)
			self?.viewModel.getPerCategoryTransDataSpecMonth(startDate: startDate, endDate: endDate)
		}

	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		let buttonStack = ASStackLayoutSpec(direction: .horizontal,
										  spacing: 0,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [planButton, realisationButton])
		
		buttonStack.style.preferredSize = buttonSize
		
		var statsElementArray: [ASLayoutElement] = [buttonStack, statsDateHeader]
		
		if goToPlanNode {
			planButton.setAttributedTitle(NSAttributedString.semibold("PLAN", 16, .black), for: .normal)
			realisationButton.setAttributedTitle(NSAttributedString.semibold("REALISATION", 16, .gray), for: .normal)
			statsElementArray.append(planNode)
		} else {
			planButton.setAttributedTitle(NSAttributedString.semibold("PLAN", 16, .gray), for: .normal)
			realisationButton.setAttributedTitle(NSAttributedString.semibold("REALISATION", 16, .black), for: .normal)
			statsElementArray.append(realisationNode)
		}

		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 0,
										  justifyContent: .start,
										  alignItems: .start,
										  children: statsElementArray)
		


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
		planButton.borderWidth = kayayuSize.kayayuBigButtonBorderWidth
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
		realisationButton.borderWidth = kayayuSize.kayayuBigButtonBorderWidth
		realisationButton.borderColor = UIColor.black.cgColor
		realisationButton.setAttributedTitle(NSAttributedString.semibold("REALISATION", 16, .black), for: .normal)
		realisationButton.addTarget(self, action: #selector(realisationButtonTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func realisationButtonTapped(sender: ASButtonNode) {
		goToPlanNode = false
		self.reloadUI()
	}
	


	
}

