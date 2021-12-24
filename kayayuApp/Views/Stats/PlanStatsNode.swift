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
	
	private let numberHelper: NumberHelper = NumberHelper()
	
	private let viewModel: StatsViewModel
	
	init(viewModel: StatsViewModel) {
		self.viewModel = viewModel
		super.init()
		automaticallyManagesSubnodes = true
		backgroundColor = .white
		
		configurePlanTitle()
		configureRatioTitle()
		configureViewModel()

	}
	
	private func configureViewModel() {
		viewModel.reloadUI = {
			self.reloadUI()
		}
	}
	
	private func reloadUI(){
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
		
		guard let needsBalance = viewModel.user.value?.balance_needs,
			  let wantsBalance = viewModel.user.value?.balance_wants,
			  let savingsBalance = viewModel.user.value?.balance_savings else {
			return
		}

		let entries: [PieChartDataEntry] = [PieChartDataEntry(value: Double(needsBalance), label: "\(kayayuRatio.needs.rawValue)"),
											PieChartDataEntry(value: Double(wantsBalance), label: "\(kayayuRatio.wants.rawValue)"),
											PieChartDataEntry(value: Double(savingsBalance), label: "\(kayayuRatio.savings.rawValue)")]
		
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
		guard let needsBalance = viewModel.user.value?.balance_needs else {
			return
		}
		needsSummary = SummaryHeader(summary: .needs, subtitleText: "Rp\(numberHelper.idAmountFormat(beforeFormatted: needsBalance))")
	}
	
	private func configureWantsSummary() {
		guard let wantsBalance = viewModel.user.value?.balance_wants else {
			return
		}
		wantsSummary = SummaryHeader(summary: .wants, subtitleText: "Rp\(numberHelper.idAmountFormat(beforeFormatted: wantsBalance))")
	}
	
	private func configureSavingsSummary() {
		guard let savingsBalance = viewModel.user.value?.balance_savings else {
			return
		}
		savingsSummary = SummaryHeader(summary: .savings, subtitleText: "Rp\(numberHelper.idAmountFormat(beforeFormatted: savingsBalance))")
	}
	
	
	
	
}

