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
	private var needsSummary: ASLayoutSpec = ASLayoutSpec()
	private var wantsSummary: ASLayoutSpec = ASLayoutSpec()
	private var savingsSummary: ASLayoutSpec = ASLayoutSpec()
	
	private var scrollNode: ASScrollNode = ASScrollNode()
	
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
		self.setNeedsLayout()
		self.layoutIfNeeded()
		self.scrollNode.setNeedsLayout()
		self.scrollNode.layoutIfNeeded()
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		configurePlanPieChart()
		configurePlanPieChartNode()
		
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
		let ratioSummary = createAllRatioSummarySpec()
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 0,
										  justifyContent: .center,
										  alignItems: .stretch,
										  children: [ratioSummary])
		
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
	
	private func configureRatioTitle() {
		ratioTitle.attributedText = NSAttributedString.bold("Summary", 16, kayayuColor.yellow)
	}
	
	private func configureNeedsSummary() {
		let needsRatio = viewModel.calculateNeedsProgressBarRatio()
		guard let needsTransaction = viewModel.needsTotalExpense.value,
			  let needsBalance = viewModel.needsTotalIncome.value else {
			return
		}
		let needsRemaining = needsBalance - needsTransaction
		let needsText = "\(self.numberHelper.floatToIdFormat(beforeFormatted: needsRemaining)) Remaining"
		
		needsSummary =  createRatioSummarySpec(category: kayayuRatioTitle.needs.rawValue, text: needsText, ratio: needsRatio, progressColor: kayayuColor.needsLight, baseColor: kayayuColor.needsDark)

	}
	
	private func configureWantsSummary() {
		
		guard let wantsTransaction = viewModel.wantsTotalExpense.value,
			  let wantsBalance = viewModel.wantsTotalIncome.value else {
			return
		}
		
		let wantsRatio = wantsTransaction/wantsBalance
		let remainingWants = wantsBalance - wantsTransaction
		let wantsText = "\(numberHelper.floatToIdFormat(beforeFormatted: remainingWants)) Remaining"

		wantsSummary =  createRatioSummarySpec(category: kayayuRatioTitle.wants.rawValue, text: wantsText, ratio: wantsRatio, progressColor: kayayuColor.wantsLight, baseColor: kayayuColor.wantsDark)
	}
	
	private func configureSavingsSummary() {
	
		guard let savingsTransaction = viewModel.savingsTotalExpense.value,
			  let savingsBalance = viewModel.savingsTotalIncome.value else {
			return
		}
		
		let savingsRatio = 1 - savingsTransaction/savingsBalance
		
		var savingsText: String
		if savingsTransaction == 0 {
			savingsText = "\(numberHelper.floatToIdFormat(beforeFormatted: savingsBalance)) Saved"
		} else {
			savingsText = "\(numberHelper.floatToIdFormat(beforeFormatted: savingsTransaction)) Used"
		}
		
		savingsSummary = createRatioSummarySpec(category: kayayuRatioTitle.savings.rawValue, text: savingsText, ratio: savingsRatio, progressColor: kayayuColor.savingsLight, baseColor: kayayuColor.savingsDark)
	
	
	}
	
	private func createAllRatioSummarySpec() -> ASLayoutSpec {
		configureNeedsSummary()
		configureWantsSummary()
		configureSavingsSummary()
		let summaryRatioSpec = ASStackLayoutSpec(direction: .vertical,
												  spacing: 10,
												  justifyContent: .start,
												  alignItems: .start,
												  children: [needsSummary,wantsSummary,savingsSummary])
		
		summaryRatioSpec.style.flexGrow = 1.0
		summaryRatioSpec.style.flexShrink = 1.0


		return summaryRatioSpec
	
	}
	
	private func createRatioSummarySpec(category: String, text: String, ratio: Float, progressColor: UIColor, baseColor: UIColor) -> ASLayoutSpec {
		let progressBarText = ASTextNode()
		progressBarText.attributedText = NSAttributedString.normal(text, 9, .black)
		
		let progressBarNode = configureProgressBar(ratio: ratio, progressColor: progressColor, baseColor: baseColor)
		let text = ASCenterLayoutSpec(centeringOptions: .X, sizingOptions: .minimumXY, child: progressBarText)
		let progressBarOverlayText = ASOverlayLayoutSpec(child: progressBarNode, overlay: text)
		
		let icon: ASImageNode = ASImageNode()
		icon.image = UIImage(named: "\(category.lowercased())Icon.png")
		icon.style.preferredSize = CGSize(width: 40, height: 40)
		
		let title: ASTextNode = ASTextNode()
		title.attributedText = NSAttributedString.bold("\(category.uppercased())", 16, .black)
		
		let elementArray: [ASLayoutElement] = [title,progressBarOverlayText]
		
		
		let elementSpec = ASStackLayoutSpec(direction: .vertical,
											spacing: 6,
											justifyContent: .center,
											alignItems: .start,
											children: elementArray)
		
		
		let elementSpecCenter = ASCenterLayoutSpec(centeringOptions: .Y,
												  sizingOptions: .minimumXY,
												  child: elementSpec)
		
		let horizontalSpec = ASStackLayoutSpec(direction: .horizontal,
											   spacing: 8,
											   justifyContent: .start,
											   alignItems: .center,
											   children: [icon, elementSpecCenter])
		let horizontalSpecInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), child: horizontalSpec)
		
		
		
		let backgroundNode = ASDisplayNode()
		backgroundNode.backgroundColor = .white
		backgroundNode.layer.borderWidth = 0.5
		backgroundNode.borderColor = UIColor.gray.cgColor
		backgroundNode.cornerRadius = 12.0
		backgroundNode.style.preferredSize =  CGSize(width: UIScreen.main.bounds.width, height: 80)
		
		let ratioSummarySpec = ASOverlayLayoutSpec(child: backgroundNode, overlay: horizontalSpecInset)
		ratioSummarySpec.style.preferredSize =  CGSize(width: UIScreen.main.bounds.width, height: 80)
		
		let ratioSummaryInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), child: ratioSummarySpec)
	
		return ratioSummaryInsetSpec
		
	}
	

	private func configureProgressBar(ratio: Float, progressColor: UIColor, baseColor: UIColor) -> ASDisplayNode {
		
		let progressBarHeight: CGFloat = 20
		let progressBarWidth: CGFloat = UIScreen.main.bounds.width - 110
		
		let progressBarNode: ASDisplayNode = ASDisplayNode()
		let progressBar: UIProgressView = UIProgressView()
		progressBar.frame = CGRect(x: 0, y: 3, width:progressBarWidth, height: progressBarHeight)
		progressBar.layer.cornerRadius = 20.0
		progressBar.progressTintColor = progressColor
		progressBar.trackTintColor = baseColor
		progressBar.progress = ratio
		progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
		
		progressBarNode.view.addSubview(progressBar)
		progressBarNode.style.preferredSize = CGSize(width: progressBarWidth, height: progressBarHeight)
		
		return progressBarNode
		
		
	}
	
}

