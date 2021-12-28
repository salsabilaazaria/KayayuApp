//
//  ExpenseStatsNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/23/21.
//

import Foundation
import AsyncDisplayKit
import Charts

class RealisationStatsNode: ASDisplayNode {
	var changeMonthStats: ((Date) -> Void)?
	
	private let realisationPieChart: PieChartView = PieChartView()
	private let realisationPieChartNode: ASDisplayNode = ASDisplayNode()
	
	private let ratioTitle: ASTextNode = ASTextNode()
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
		configureNeedsSummary()
		configureWantsSummary()
		configureSavingsSummary()
		
		let pieChartStack = ASStackLayoutSpec(direction: .vertical,
											  spacing: 10,
											  justifyContent: .center,
											  alignItems: .center,
											  children: [realisationPieChartNode])
		
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
										  children: [pieChartStack, summaryTitleInset, scrollNode])
		
		
		return mainStack
		
	}
	
	private func configurePlanPieChartNode() {
		realisationPieChart.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
		realisationPieChartNode.view.addSubview(realisationPieChart)
		realisationPieChartNode.style.preferredSize = CGSize(width: 200, height: 200)
	}
	
	private func configurePlanPieChart() {
		realisationPieChart.chartDescription?.enabled = false
		realisationPieChart.drawHoleEnabled = false
		realisationPieChart.rotationAngle = 0
		realisationPieChart.rotationEnabled = false
		
		realisationPieChart.legend.enabled = false
		
		guard let needsAmount = viewModel.needsTotalExpense.value,
			  let wantsAmount = viewModel.wantsTotalExpense.value,
			  let savingsIncome = viewModel.savingsTotalIncome.value,
			  let savingsExpense = viewModel.savingsTotalExpense.value else {
			return
		}
		
		let savingsAmount = savingsIncome - savingsExpense
		let entries: [PieChartDataEntry] = [PieChartDataEntry(value: Double(needsAmount), label: "\(kayayuRatioTitle.needs.rawValue)"),
											PieChartDataEntry(value: Double(wantsAmount), label: "\(kayayuRatioTitle.wants.rawValue)"),
											PieChartDataEntry(value: Double(savingsAmount), label: "\(kayayuRatioTitle.savings.rawValue)")]

		
		let dataSet = PieChartDataSet(entries: entries, label: "label")
		
		dataSet.colors = kayayuColor.pieCharArrColor
		realisationPieChart.data = PieChartData(dataSet: dataSet)
		
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
	
	private func configureNeedsSummary() {
		let needsRatio = viewModel.calculateNeedsProgressBarRatio()
		guard let needsTransaction = viewModel.needsTotalExpense.value,
			  let needsBalance = viewModel.needsTotalIncome.value else {
			return
		}
		let needsRemaining = needsBalance - needsTransaction
		print("Category Needs \(needsRatio) \(needsTransaction) \(needsBalance) \(needsRemaining)")
		self.needsSummary = SummaryHeader(summary: .needs, ratio: needsRatio, progressColor: kayayuColor.needsLight, baseColor: kayayuColor.needsDark, progressBarText: "Rp\(self.numberHelper.floatToIdFormat(beforeFormatted: needsRemaining)) Remaining")
		
		
	}
	
	private func configureWantsSummary() {
		let wantsRatio = viewModel.calculateWantsProgressBarRatio()
		guard let wantsTransaction = viewModel.wantsTotalExpense.value,
			  let wantsBalance = viewModel.wantsTotalIncome.value else {
			return
		}
		
		let remainingWants = wantsBalance - wantsTransaction
		wantsSummary = SummaryHeader(summary: .wants, ratio: wantsRatio, progressColor: kayayuColor.wantsLight, baseColor: kayayuColor.wantsDark, progressBarText: "Rp\(numberHelper.floatToIdFormat(beforeFormatted: remainingWants)) Remaining")
	}
	
	private func configureSavingsSummary() {
		let savingsRatio = viewModel.calculateSavingsProgressBarRatio()
		guard let savingsTransaction = viewModel.savingsTotalExpense.value,
			  let savingsBalance = viewModel.savingsTotalIncome.value else {
			return
		}
		
		let remainingSavings = savingsBalance - savingsTransaction
		
		if savingsTransaction == 0 {
			savingsSummary = SummaryHeader(summary: .savings, ratio: savingsRatio, progressColor: kayayuColor.savingsDark, baseColor: kayayuColor.savingsLight, progressBarText: "Rp\(numberHelper.floatToIdFormat(beforeFormatted: remainingSavings)) Saved")
		} else {
			savingsSummary = SummaryHeader(summary: .savings, ratio: savingsRatio, progressColor: kayayuColor.savingsDark, baseColor: kayayuColor.savingsLight, progressBarText: "Rp\(numberHelper.floatToIdFormat(beforeFormatted: remainingSavings)) Used")
		}
	
	}
	
	
	
}

