//
//  StatsHeader.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 24/11/21.
//

import Foundation
import AsyncDisplayKit

class StatsDateHeader: ASDisplayNode {
	private let calendarHelper: CalendarHelper = CalendarHelper()
	
	private let nextMonthButton: ASButtonNode = ASButtonNode()
	private let prevMonthButton: ASButtonNode = ASButtonNode()
	private let monthYearText: ASTextNode = ASTextNode()
	var selectedDate: Date = Date()
	
	override init() {
		super.init()
		configureMonthYearString()
		configureNextMonthButton()
		configurePrevMonthButton()
		automaticallyManagesSubnodes = true
		
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let monthYearHeaderSize = CGSize(width: UIScreen.main.bounds.width, height: kayayuSize.kayayuBarHeight)
		let backgroundHeader = ASDisplayNode()
		backgroundHeader.backgroundColor = .white
		backgroundHeader.cornerRadius = 5
		backgroundHeader.borderWidth = kayayuSize.kayayuBorderWidth
		backgroundHeader.borderColor = UIColor.black.cgColor
		backgroundHeader.style.preferredSize = monthYearHeaderSize
		
		let centerText = ASCenterLayoutSpec(centeringOptions: .XY,
											sizingOptions: .minimumXY,
											child: monthYearText)
		
		let monthHeader = ASStackLayoutSpec(direction: .horizontal,
											spacing: 8,
											justifyContent: .center,
											alignItems: .center,
											children: [prevMonthButton, centerText, nextMonthButton])
		centerText.style.flexGrow = 1
		monthHeader.style.preferredSize = monthYearHeaderSize
		
		let monthHeaderSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), child: monthHeader)
		
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
}
