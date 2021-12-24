//
//  EditProfileController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 25/12/21.
//

import Foundation
import AsyncDisplayKit

class EditProfileController: ASDKViewController<ASDisplayNode> {
	
	var onOpenChangeEmailPage: (() -> Void)?
	var onOpenChangeUsernamePage: (() -> Void)?
	var onOpenChangePasswordPage: (() -> Void)?
	
	private let editProfileNode: EditProfileNode?
	let viewModel: ProfileViewModel?
	
	init(viewModel: ProfileViewModel) {
		self.editProfileNode = EditProfileNode(viewModel: viewModel)
		self.viewModel = viewModel
		super.init(node: editProfileNode ?? ASDisplayNode())
		configureNode()
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.editProfileNode = nil
		self.viewModel = nil
		super.init(coder: aDecoder)
	}
	
	private func configureNode() {
		
		editProfileNode?.onOpenChangeUsernamePage = {
			self.onOpenChangeUsernamePage?()
		}
		
		editProfileNode?.onOpenChangeEmailPage = {
			self.onOpenChangeEmailPage?()
		}
		
		editProfileNode?.onOpenChangePasswordPage = {
			self.onOpenChangePasswordPage?()
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.hidesBackButton = false
		self.navigationController?.navigationBar.prefersLargeTitles = false
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Edit Profile"
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}
