//
//  AddIncomeRecord.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/11/21.
//
import Foundation
import AsyncDisplayKit

class AddIncomeRecordNode: ASDisplayNode {
	private let dateInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let descriptionInputTextField: ASEditableTextNode = ASEditableTextNode()
	private let amountInputTextField: ASEditableTextNode = ASEditableTextNode()
	

	override init() {
		super.init()
		backgroundColor = .blue

		automaticallyManagesSubnodes = true
		
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {


		return ASLayoutSpec()
	}
	
	private func configureDateInputTextField() {
	
	}
	
}


