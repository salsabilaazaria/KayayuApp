//
//  AddRecordeNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/11/21.
//

import Foundation
import AsyncDisplayKit

class AddRecordeNode: ASDisplayNode {
	private let incomeButton: ASButtonNode = ASButtonNode()
	private let expenseButton: ASButtonNode = ASButtonNode()
	private let incomeNode: AddIncomeRecordNode = AddIncomeRecordNode()
	private let expenseNode: AddExpenseRecordNode = AddExpenseRecordNode()
	
	private let buttonSize = CGSize(width: UIScreen.main.bounds.width/2, height: kayayuSize.kayayuBarHeight)
	private var goToIncomePage: Bool = false
	private let viewModel: HomeViewModel

	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		super.init()
		let nodeSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
		incomeNode.style.preferredSize = nodeSize
		expenseNode.style.preferredSize = nodeSize
		
		configureIncomeButton()
		configureExpenseButton()

		automaticallyManagesSubnodes = true
		
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		let buttonStack = ASStackLayoutSpec(direction: .horizontal,
										  spacing: 0,
										  justifyContent: .start,
										  alignItems: .start,
										  children: [incomeButton, expenseButton])
		
		buttonStack.style.preferredSize = buttonSize
		
		var statsElementArray: [ASLayoutElement] = [buttonStack]
		
		if goToIncomePage {
			incomeButton.setAttributedTitle(NSAttributedString.semibold("INCOME", 16, .systemGreen), for: .normal)
			expenseButton.setAttributedTitle(NSAttributedString.semibold("EXPENSE", 16, .black), for: .normal)
			statsElementArray.append(incomeNode)
		} else {
			incomeButton.setAttributedTitle(NSAttributedString.semibold("INCOME", 16, .black), for: .normal)
			expenseButton.setAttributedTitle(NSAttributedString.semibold("EXPENSE", 16, .systemRed), for: .normal)
			statsElementArray.append(expenseNode)
		}
		
		let mainStack = ASStackLayoutSpec(direction: .vertical,
										  spacing: 0,
										  justifyContent: .start,
										  alignItems: .start,
										  children: statsElementArray)

		return mainStack
	}
	
	private func reloadUI(){
		self.setNeedsLayout()
		self.layoutIfNeeded()
	}

	private func configureIncomeButton() {
		incomeButton.style.preferredSize = buttonSize
		incomeButton.backgroundColor = .white
		incomeButton.cornerRadius = 5
		incomeButton.borderWidth = kayayuSize.kayayuBorderWidth
		incomeButton.borderColor = UIColor.black.cgColor
		incomeButton.addTarget(self, action: #selector(incomeButtonTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func incomeButtonTapped(sender: ASButtonNode) {
		goToIncomePage = true
		self.reloadUI()
		print("Plan")
	}
	
	private func configureExpenseButton() {
		expenseButton.style.preferredSize = buttonSize
		expenseButton.backgroundColor = .white
		expenseButton.cornerRadius = 5
		expenseButton.borderWidth = kayayuSize.kayayuBorderWidth
		expenseButton.borderColor = UIColor.black.cgColor
		expenseButton.setAttributedTitle(NSAttributedString.semibold("EXPENSE", 16, .black), for: .normal)
		expenseButton.addTarget(self, action: #selector(realisationButtonTapped), forControlEvents: .touchUpInside)
	}
	
	@objc func realisationButtonTapped(sender: ASButtonNode) {
		goToIncomePage = false
		self.reloadUI()
	}
	


	
}



