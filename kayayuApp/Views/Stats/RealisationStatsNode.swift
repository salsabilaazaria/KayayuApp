//
//  RealisationStatsNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/23/21.
//

import Foundation
import AsyncDisplayKit
import Charts

class RealisationStatsNode: ASDisplayNode {

	private let statsDateHeader = StatsDateHeader()
	
	private let planPieChart: PieChartView = PieChartView()
	private let planPieChartNode: ASDisplayNode = ASDisplayNode()
	private let planTitle: ASTextNode = ASTextNode()
	
	private let ratioTitle: ASTextNode = ASTextNode()
	private var balanceSummary: SummaryHeader = SummaryHeader()
	private var needsSummary: SummaryHeader = SummaryHeader()
	private var wantsSummary: SummaryHeader = SummaryHeader()
	private var savingsSummary: SummaryHeader = SummaryHeader()
	
	private var scrollNode: ASScrollNode = ASScrollNode()
	
	override init() {
		
		super.init()
		automaticallyManagesSubnodes = true
		backgroundColor = .white
		configureScrollNode()
		configurePlanPieChartNode()
		configurePlanPieChart()
		configurePlanTitle()
		configureRatioTitle()
		configureBalanceSummary()
		configureNeedsSummary()
		configureWantsSummary()
		configureSavingsSummary()
		
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let pieChartStack = ASStackLayoutSpec(direction: .vertical,
											  spacing: 10,
											  justifyContent: .center,
											  alignItems: .center,
											  children: [planTitle, planPieChartNode])
		
		
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 10,
										  justifyContent: .start,
										  alignItems: .center,
										  children: [statsDateHeader, pieChartStack, balanceSummary, scrollNode])
		
		
		
		return mainStack
		
	}
	
	private func configurePlanTitle() {
		planTitle.attributedText = NSAttributedString.bold("REALISATION", 16, .black)
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
	
	
	private func configureScrollNode() {
		scrollNode.automaticallyManagesSubnodes = true
		scrollNode.automaticallyManagesContentSize = true
		scrollNode.scrollableDirections = [.up, .down]
		scrollNode.style.flexGrow = 1.0
		scrollNode.style.flexShrink = 1.0
		scrollNode.view.bounces = true
		scrollNode.view.showsVerticalScrollIndicator = false
		scrollNode.view.isScrollEnabled = true
		scrollNode.layoutSpecBlock = { [weak self] _, constrainedSize in
			print("scrollnode")
			return(self?.createScrollNode(constrainedSize) ?? ASLayoutSpec())
			
		}
	}
	
	private func createScrollNode(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let ratioSummary = createRatioSummarySpec()
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 0,
										  justifyContent: .center,
										  alignItems: .stretch,
										  children: [ratioSummary])
		
		let inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), child: mainStack)
		return inset
	}
	
	private func createRatioSummarySpec() -> ASLayoutSpec {
		
		let summaryRatioSpec = ASStackLayoutSpec(direction: .vertical,
												  spacing: 10,
												  justifyContent: .start,
												  alignItems: .start,
												  children: [ratioTitle, needsSummary, wantsSummary, savingsSummary])
		
		
		return summaryRatioSpec
	}
	
	private func configureRatioTitle() {
		ratioTitle.attributedText = NSAttributedString.bold("Summary", 14, kayayuColor.yellow)
	}
	
	private func configureBalanceSummary() {
		balanceSummary = SummaryHeader(summary: .balance, subtitleText: "Rp1.000.000")
	}
	
	private func configureNeedsSummary() {
		needsSummary = SummaryHeader(summary: .needs, ratio: 0.3, progressColor: kayayuColor.needsLight, baseColor: kayayuColor.needsDark, progressBarText: "RpXX.XXX.XXX Remaining")
	}
	
	private func configureWantsSummary() {
		wantsSummary = SummaryHeader(summary: .wants, ratio: 0.3, progressColor: kayayuColor.wantsLight, baseColor: kayayuColor.wantsDark, progressBarText: "RpXX.XXX.XXX Remaining")
	}
	
	private func configureSavingsSummary() {
		savingsSummary = SummaryHeader(summary: .savings, ratio: 0.3, progressColor: kayayuColor.savingsLight, baseColor: kayayuColor.savingsDark, progressBarText: "RpXX.XXX.XXX Remaining")
	}
	
	
	
}

