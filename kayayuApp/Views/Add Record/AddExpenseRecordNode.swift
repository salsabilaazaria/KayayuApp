//
//  AddExpenseRecordNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/11/21.
//

import Foundation
import AsyncDisplayKit

class AddExpenseRecordNode: ASDisplayNode {


	override init() {
		super.init()
		backgroundColor = .red

		automaticallyManagesSubnodes = true
		
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {


		return ASLayoutSpec()
	}
	
}
