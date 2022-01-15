//
//  ProfileViewController.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/6/21.
//

import Foundation
import AsyncDisplayKit

class ProfileViewController: ASDKViewController<ASDisplayNode> {
	
	var onOpenSubscriptionPage: (() -> Void)?
	var onOpenInstallmentPage: (() -> Void)?
	var onOpenEditProfile: (() -> Void)?
	var onOpenHelp: (() -> Void)?
    var onLogout: (() -> Void)?
	
	private let profileNode: ProfileNode?
	let authViewModel: AuthenticationViewModel?
	let profileViewModel: ProfileViewModel?
	
	init(authViewModel: AuthenticationViewModel, profileViewModel: ProfileViewModel) {
		self.authViewModel = authViewModel
		self.profileViewModel = profileViewModel
		self.profileNode = ProfileNode(authViewModel: authViewModel, profileViewModel: profileViewModel)
		super.init(node: profileNode ?? ASDisplayNode())
		configureNode()
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.authViewModel = nil
		self.profileViewModel = nil
		self.profileNode = nil
		super.init(coder: aDecoder)
	}
	
	private func configureNode() {
		
		profileNode?.onOpenSubscriptionPage = { [weak self] in
			self?.onOpenSubscriptionPage?()
		}
		
		profileNode?.onOpenInstallmentPage = { [weak self] in
			self?.onOpenInstallmentPage?()
		}
		
		profileNode?.onLogout = { [weak self] in
			
			let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
			
			alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {_ in
				self?.dismiss(animated: true, completion: nil)
			}))
			
			alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: {_ in
				
				self?.authViewModel?.logout()
				self?.onLogout?()
			
			}))
			
			self?.present(alert, animated: true, completion: nil)
			
		}
		
		profileNode?.onOpenEditProfile = { [weak self] in
			self?.onOpenEditProfile?()
		}
		
		profileNode?.onOpenHelp = { [weak self] in
			self?.onOpenHelp?()
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.hidesBackButton = true
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.tabBarController?.navigationItem.title = "Profile"
		self.navigationController?.tabBarController?.tabBar.isTranslucent = false
		self.navigationController?.tabBarController?.tabBar.isTranslucent = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Profile"
	
		edgesForExtendedLayout = []
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .white

	}

}
