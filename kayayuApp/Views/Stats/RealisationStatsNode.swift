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
	
	private let numberHelper: NumberHelper = NumberHelper()
	private let viewModel: StatsViewModel
	
	init(viewModel: StatsViewModel) {
		self.viewModel = viewModel
		super.init()
		automaticallyManagesSubnodes = true
		backgroundColor = .white
		configureScrollNode()
	
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
		configurePlanPieChart()
		configurePlanPieChartNode()
		configureBalanceSummary()
		configureNeedsSummary()
		configureWantsSummary()
		configureSavingsSummary()
		
		let pieChartStack = ASStackLayoutSpec(direction: .vertical,
											  spacing: 10,
											  justifyContent: .center,
											  alignItems: .center,
											  children: [planTitle, planPieChartNode])
		
		let summaryTitle = ASStackLayoutSpec(direction: .vertical,
											 spacing: 10,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [ratioTitle])
		
		let summaryTitleSpec = ASAbsoluteLayoutSpec(children: [summaryTitle])
		let summaryTitleInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), child: summaryTitleSpec)
		
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 10,
										  justifyContent: .start,
										  alignItems: .center,
										  children: [statsDateHeader, pieChartStack, balanceSummary, summaryTitleInset, scrollNode])
		
		
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
		
		guard let needsAmount = viewModel.needsTotalTransaction.value,
			  let wantsAmount = viewModel.wantsTotalTransaction.value,
			  let savingsAmount = viewModel.savingsTotalTransaction.value else {
			return
		}
		
		let entries: [PieChartDataEntry] = [PieChartDataEntry(value: Double(needsAmount), label: "\(kayayuRatio.needs.rawValue)"),
											PieChartDataEntry(value: Double(wantsAmount), label: "\(kayayuRatio.wants.rawValue)"),
											PieChartDataEntry(value: Double(savingsAmount), label: "\(kayayuRatio.savings.rawValue)")]

		
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
												  children: [needsSummary, wantsSummary, savingsSummary])
		
		
		return summaryRatioSpec
	}
	
	private func configureRatioTitle() {
		ratioTitle.attributedText = NSAttributedString.bold("Summary", 14, kayayuColor.yellow)
	}
	
	private func configureBalanceSummary() {
		guard let totalBalance = viewModel.user.value?.balance_month else {
			return
		}
		balanceSummary = SummaryHeader(summary: .balance, subtitleText: numberHelper.idAmountFormat(beforeFormatted: totalBalance))
	}
	
	private func configureNeedsSummary() {
		let needsRatio = viewModel.calculateNeedsProgressBarRatio()
		guard let needsTransaction = viewModel.needsTotalTransaction.value,
			  let needsBalance = viewModel.user.value?.balance_needs else {
			return
		}
		
		let needsRemaining = needsBalance - needsTransaction
		needsSummary = SummaryHeader(summary: .needs, ratio: needsRatio, progressColor: kayayuColor.needsLight, baseColor: kayayuColor.needsDark, progressBarText: "Rp\(numberHelper.idAmountFormat(beforeFormatted: needsRemaining)) Remaining")
	}
	
	private func configureWantsSummary() {
		let wantsRatio = viewModel.calculateWantsProgressBarRatio()
		guard let wantsTransaction = viewModel.wantsTotalTransaction.value,
			  let wantsBalance = viewModel.user.value?.balance_wants else {
			return
		}
		
		let remainingWants = wantsBalance - wantsTransaction
		wantsSummary = SummaryHeader(summary: .wants, ratio: wantsRatio, progressColor: kayayuColor.wantsLight, baseColor: kayayuColor.wantsDark, progressBarText: "Rp\(numberHelper.idAmountFormat(beforeFormatted: remainingWants)) Remaining")
	}
	
	private func configureSavingsSummary() {
		let savingsRatio = viewModel.calculateSavingsProgressBarRatio()
		guard let savingsTransaction = viewModel.savingsTotalTransaction.value,
			  let savingsBalance = viewModel.user.value?.balance_savings else {
			return
		}
		
		let remainingSavings = savingsBalance - savingsTransaction
		savingsSummary = SummaryHeader(summary: .savings, ratio: savingsRatio, progressColor: kayayuColor.savingsLight, baseColor: kayayuColor.savingsDark, progressBarText: "Rp\(numberHelper.idAmountFormat(beforeFormatted: remainingSavings)) Remaining")
	}
	
	
	
}

