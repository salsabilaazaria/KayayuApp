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
	private let calendarHelper: CalendarHelper = CalendarHelper()
	
	private let nextMonthButton: ASButtonNode = ASButtonNode()
	private let prevMonthButton: ASButtonNode = ASButtonNode()
	private let monthYearText: ASTextNode = ASTextNode()
	private var selectedDate: Date = Date()
	
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
		
		configureMonthYearString()
		configureNextMonthButton()
		configurePrevMonthButton()
		configurePlanPieChartNode()
		configurePlanPieChart()
		configurePlanTitle()
		configureRatioTitle()
		configureNeedsSummary()
		configureWantsSummary()
		configureSavingsSummary()
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let monthHeader = createMonthYearHeaderSpec()
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
												children: [monthHeader, pieChartStack, summaryStack])
	  
		
		
		return mainStack
		
	}
	
	private func createMonthYearHeaderSpec() -> ASLayoutSpec {
		
		let monthYearHeaderSize = CGSize(width: UIScreen.main.bounds.width, height: kayayuSize.kayayuBarHeight)
		let backgroundHeader = ASDisplayNode()
		backgroundHeader.backgroundColor = .white
		backgroundHeader.cornerRadius = 5
		backgroundHeader.borderWidth = kayayuSize.kayayuBorderWidth
		backgroundHeader.borderColor = UIColor.black.cgColor
		backgroundHeader.style.preferredSize = monthYearHeaderSize
		let centerText = ASStackLayoutSpec(direction: .horizontal,
											spacing: 8,
											justifyContent: .center,
											alignItems: .center,
											children: [monthYearText])
		
		let monthHeader = ASStackLayoutSpec(direction: .horizontal,
											spacing: 8,
											justifyContent: .center,
											alignItems: .center,
											children: [prevMonthButton, centerText, nextMonthButton])
		centerText.style.flexGrow = 1
		monthHeader.style.preferredSize = monthYearHeaderSize
		
		let monthHeaderSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), child: monthHeader)
		
		let monthHeaderWithBackground = ASOverlayLayoutSpec(child: backgroundHeader, overlay: monthHeaderSpec)
		
		return monthHeaderWithBackground
	}
	
	private func configureMonthYearString() {
		let monthYear = "\(calendarHelper.monthString(date: selectedDate)) \(calendarHelper.yearString(date: selectedDate))"
		monthYearText.attributedText = NSAttributedString.bold(monthYear, 14, .black)

	}
	
	private func configureNextMonthButton() {
		nextMonthButton.setAttributedTitle(NSAttributedString.bold(">", 14, .black), for: .normal)
		nextMonthButton.addTarget(self, action: #selector(nextMonthTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func nextMonthTapped(sender: ASButtonNode) {
		selectedDate = CalendarHelper().plusMonth(date: selectedDate)
		configureMonthYearString()
	}
	
	private func configurePrevMonthButton() {
		prevMonthButton.setAttributedTitle(NSAttributedString.bold("<", 14, .black), for: .normal)
		prevMonthButton.addTarget(self, action: #selector(prevMonthTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func prevMonthTapped(sender: ASButtonNode) {
		selectedDate = CalendarHelper().minusMonth(date: selectedDate)
		configureMonthYearString()
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
		dataSet.colors = [.blue,.yellow,.green]
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

