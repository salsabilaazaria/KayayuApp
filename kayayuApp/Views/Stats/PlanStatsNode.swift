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
	
	private let ratioTitle: ASTextNode = ASTextNode()
	private var needsSummary: SummaryHeader = SummaryHeader()
	private var wantsSummary: SummaryHeader = SummaryHeader()
	private var savingsSummary: SummaryHeader = SummaryHeader()
	
	private let numberHelper: NumberHelper = NumberHelper()
	
	private let viewModel: StatsViewModel
	
	init(viewModel: StatsViewModel) {
		self.viewModel = viewModel
		super.init()
		automaticallyManagesSubnodes = true
		backgroundColor = .white
		
		configureRatioTitle()

	}
	
	 func reloadUI(){
		self.setNeedsLayout()
		self.layoutIfNeeded()
	}
	
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		configurePlanPieChartNode()
		configurePlanPieChart()
		let summaryStack = createRatioSummarySpec()

		let pieChartStack = ASStackLayoutSpec(direction: .vertical,
											  spacing: 10,
												 justifyContent: .center,
												 alignItems: .center,
												 children: [planPieChartNode])
		
		
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 10,
												justifyContent: .start,
												alignItems: .center,
												children: [pieChartStack, summaryStack])
		
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

