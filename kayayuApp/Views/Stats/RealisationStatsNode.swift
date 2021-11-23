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
	private let pieChart: PieChartView = PieChartView()
	
	override init() {
		super.init()
		automaticallyManagesSubnodes = true
		backgroundColor = .systemPink
	}
	
	
	
}
