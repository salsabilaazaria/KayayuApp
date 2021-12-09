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
	private let statsDateHeader = StatsDateHeader()
	
	private let planPieChart: PieChartView = PieChartView()
	private let planPieChartNode: ASDisplayNode = ASDisplayNode()
	private let planTitle: ASTextNode = ASTextNode()
	
	private let ratioTitle: ASTextNode = ASTextNode()
	private var needsSummary: SummaryHeader = SummaryHeader()
	private var wantsSummary: SummaryHeader = SummaryHeader()
	private var savingsSummary: SummaryHeader = SummaryHeader()
	
	override init() {
		
		super.init()
		automaticallyManagesSubnodes = true
		backgroundColor = .white
		
		configurePlanPieChartNode()
		configurePlanPieChart()
		configurePlanTitle()
		configureRatioTitle()
		configureNeedsSummary()
		configureWantsSummary()
		configureSavingsSummary()
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let summaryStack = createRatioSummarySpec()

		let pieChartStack = ASStackLayoutSpec(direction: .vertical,
											  spacing: 10,
												 justifyContent: .center,
												 alignItems: .center,
												 children: [planTitle, planPieChartNode])
		
		
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 10,
												justifyContent: .start,
												alignItems: .center,
												children: [statsDateHeader, pieChartStack, summaryStack])
		
		return mainStack
		
	}
	
	private func configurePlanTitle() {
		planTitle.attributedText = NSAttributedString.bold("PLAN", 16, .black)
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
		
		//data dummy
		let entries: [PieChartDataEntry] = [PieChartDataEntry(value: 10000, label: "First"),
											PieChartDataEntry(value: 2000, label: "second"),
											PieChartDataEntry(value: 30000, label: "third")]
		
		
		let dataSet = PieChartDataSet(entries: entries, label: "label")
		dataSet.colors = kayayuColor.pieCharArrColor
		planPieChart.data = PieChartData(dataSet: dataSet)
		
	}
	
	
	private func createRatioSummarySpec() -> ASLayoutSpec {
		let summaryStack = ASStackLayoutSpec(direction: .vertical,
											 spacing: 10,
											 justifyContent: .center,
											 alignItems: .center,
											 children: [needsSummary, wantsSummary, savingsSummary])
		
		let summaryTitleStack = ASStackLayoutSpec(direction: .vertical,
												  spacing: 10,
												  justifyContent: .start,
												  alignItems: .start,
												  children: [ratioTitle, summaryStack])
		return summaryTitleStack
	}
	
	private func configureRatioTitle() {
		ratioTitle.attributedText = NSAttributedString.bold("This Month Goal", 14, kayayuColor.yellow)
	}
	
	private func configureNeedsSummary() {
		needsSummary = SummaryHeader(summary: .needs, subtitleText: "RpNEEDS")
	}
	
	private func configureWantsSummary() {
		wantsSummary = SummaryHeader(summary: .wants, subtitleText: "RpWANTS")
	}
	
	private func configureSavingsSummary() {
		savingsSummary = SummaryHeader(summary: .savings, subtitleText: "RpSAVINGS")
	}
	
	
	
	
}

