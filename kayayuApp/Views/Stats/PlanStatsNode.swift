//
//  PlanStatsNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/23/21.
//

import Foundation
import AsyncDisplayKit
import Charts

class PlanStatsNode: ASDisplayNode {
	var changeMonthStats: ((Date) -> Void)?
	
	private let planPieChart: PieChartView = PieChartView()
	private let planPieChartNode: ASDisplayNode = ASDisplayNode()
	
	private let planSummaryTitle: ASTextNode = ASTextNode()
	private var needsSummary: SummaryHeader = SummaryHeader()
	private var wantsSummary: SummaryHeader = SummaryHeader()
	private var savingsSummary: SummaryHeader = SummaryHeader()
	
	private let scrollNode: ASScrollNode = ASScrollNode()
	
	private let numberHelper: NumberHelper = NumberHelper()
	
	private let viewModel: StatsViewModel
	
	init(viewModel: StatsViewModel) {
		self.viewModel = viewModel
		super.init()
		automaticallyManagesSubnodes = true
		backgroundColor = .white
		
		configureRatioTitle()
		configureScrollNode()

	}
	
	 func reloadUI(){
		self.scrollNode.setNeedsLayout()
		self.scrollNode.layoutIfNeeded()
		self.setNeedsLayout()
		self.layoutIfNeeded()
	}
	
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		configurePlanPieChartNode()
		configurePlanPieChart()

		let pieChartStack = ASStackLayoutSpec(direction: .vertical,
											  spacing: 10,
												 justifyContent: .center,
												 alignItems: .center,
												 children: [planPieChartNode])
		
		let summaryTitleSpec = ASAbsoluteLayoutSpec(children: [planSummaryTitle])
		let summaryTitleInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), child: summaryTitleSpec)
		
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 10,
										  justifyContent: .start,
										  alignItems: .center,
										  children: [pieChartStack, summaryTitleInset, scrollNode])
		
	
		return mainStack
		
	}
	
	private func configureScrollNode() {
		scrollNode.automaticallyManagesSubnodes = true
		scrollNode.automaticallyManagesContentSize = true
		scrollNode.scrollableDirections = [.up, .down]
		scrollNode.style.flexGrow = 1.0
		scrollNode.style.flexShrink = 1.0
		scrollNode.view.bounces = true
		scrollNode.view.showsVerticalScrollIndicator = true
		scrollNode.view.isScrollEnabled = true
		scrollNode.view.contentInset.bottom = 42
		scrollNode.layoutSpecBlock = { [weak self] _, constrainedSize in
			return(self?.createScrollNode(constrainedSize) ?? ASLayoutSpec())
			
		}
	}
	
	private func createScrollNode(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let ratioSummary = createRatioSummarySpec()
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 0,
										  justifyContent: .start,
										  alignItems: .stretch,
										  children: [ratioSummary])
		
		return mainStack
	}
	
	private func configurePlanPieChartNode() {
		planPieChart.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
		planPieChartNode.view.addSubview(planPieChart)
		planPieChartNode.style.preferredSize = CGSize(width: 200, height: 200)
	}
	
	private func configurePlanPieChart() {
		planPieChart.chartDescription?.enabled = false
		planPieChart.drawHoleEnabled = false
		planPieChart.rotationAngle = 0
		planPieChart.rotationEnabled = false
		
		planPieChart.legend.enabled = false
		
		guard let needsBalance = viewModel.needsTotalIncome.value,
			  let wantsBalance = viewModel.wantsTotalIncome.value,
			  let savingsBalance = viewModel.savingsTotalIncome.value else {
			return
		}

		let entries: [PieChartDataEntry] = [PieChartDataEntry(value: Double(needsBalance), label: "\(kayayuRatioTitle.needs.rawValue)"),
											PieChartDataEntry(value: Double(wantsBalance), label: "\(kayayuRatioTitle.wants.rawValue)"),
											PieChartDataEntry(value: Double(savingsBalance), label: "\(kayayuRatioTitle.savings.rawValue)")]
		
		let dataSet = PieChartDataSet(entries: entries, label: "")
		dataSet.colors = kayayuColor.pieCharArrColor
		planPieChart.data = PieChartData(dataSet: dataSet)

	}
	
	
	private func createRatioSummarySpec() -> ASLayoutSpec {
		
		configureNeedsSummary()
		configureWantsSummary()
		configureSavingsSummary()
		
		let summaryStack = ASStackLayoutSpec(direction: .vertical,
											 spacing: 10,
											 justifyContent: .start,
											 alignItems: .start,
											 children: [needsSummary, wantsSummary, savingsSummary])
		
		summaryStack.style.flexGrow = 1.0
		summaryStack.style.flexShrink = 1.0
		
		let ratioSummaryInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), child: summaryStack)
		
		return ratioSummaryInsetSpec
	}
	
	private func configureRatioTitle() {
		planSummaryTitle.attributedText = NSAttributedString.bold("This Month Goal", 16, kayayuColor.yellow)
	}
	
	private func configureNeedsSummary() {
		guard let needsBalance = viewModel.needsTotalIncome.value else {
			needsSummary = SummaryHeader(summary: .needs, subtitleText: "You haven't input any data")
			return
		}
		needsSummary = SummaryHeader(summary: .needs, subtitleText: "\(numberHelper.floatToIdFormat(beforeFormatted: needsBalance))")
	}
	
	private func configureWantsSummary() {
		guard let wantsBalance = viewModel.wantsTotalIncome.value else {
			wantsSummary  = SummaryHeader(summary: .wants, subtitleText: "You haven't input any data")
			return
		}
		wantsSummary = SummaryHeader(summary: .wants, subtitleText: "\(numberHelper.floatToIdFormat(beforeFormatted: wantsBalance))")
	}
	
	private func configureSavingsSummary() {
		guard let savingsBalance = viewModel.savingsTotalIncome.value else {
			savingsSummary  = SummaryHeader(summary: .savings, subtitleText: "You haven't input any data")
			return
		}
		savingsSummary = SummaryHeader(summary: .savings, subtitleText: "\(numberHelper.floatToIdFormat(beforeFormatted: savingsBalance))")
	}
	
	
	
	
}

