//
//  KayayuScreen.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 19/11/21.
//

import Foundation
import UIKit

final class KayayuScreen {
	private var navigationController: UINavigationController?
	let tabBarController: UITabBarController
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	
	enum NavigationEvent {
		case onCreateTabBar
		case onOpenHomePage
		case onOpenLandingPage
		case onOpenLoginPage
		case onOpenRegisterPage
		case onOpenStatsPage
		case onOpenAddRecordPage
		case onOpenProfilePage
		case onOpenSubscriptionPage
		case onOpenInstallmentPage
	}
	
	public init(navigationController: UINavigationController, tabBarController:UITabBarController) {
		self.navigationController = navigationController
		self.tabBarController = tabBarController
	}
	
	func make() -> UIViewController {
		let controller = makeLandingPageViewController()
		return controller
	}
	
	func makeTabBarViewController(homeViewModel: HomeViewModel) -> UITabBarController {
		tabBarController.edgesForExtendedLayout = []
		
		let home = makeHomePageViewController(viewModel: homeViewModel)
		home.tabBarItem.title = "Home"
		let stats = makeStatsPageViewController()
		let profile = makeProfileViewController()
	
		tabBarController.tabBar.tintColor = kayayuColor.yellow
		tabBarController.setViewControllers([home,stats,profile], animated: true)
		tabBarController.navigationItem.hidesBackButton = true
		tabBarController.navigationItem.backButtonDisplayMode = .minimal
		
		return tabBarController
	}
	
	func makeLandingPageViewController() -> UIViewController {
		let controller = LandingViewController()
		controller.onOpenLoginPage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onOpenLoginPage)
		}
		controller.onOpenRegisterPage = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onOpenRegisterPage)
		}
		return controller
	}
	
	func makeLoginPageViewController(viewModel: AuthenticationViewModel) -> UIViewController {
		let controller = LoginViewController(authenticationViewModel: viewModel)
		controller.onOpenHomePage = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onCreateTabBar)
		}
		return controller
	}
	
	func makeRegisterPageViewController(viewModel: AuthenticationViewModel) -> UIViewController {
		let controller = RegisterViewController(authenticationViewModel: viewModel)
		controller.onOpenHomePage = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onCreateTabBar)
		}
		return controller
	}
	
	func makeHomePageViewController(viewModel: HomeViewModel) -> UIViewController {
		let controller = HomeViewController(viewModel: viewModel)
		
		controller.title = "Hello"
		controller.onOpenAddRecordPage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onOpenAddRecordPage)
		}
		return controller
	}
	
	func makeStatsPageViewController() -> UIViewController {
		let controller = StatsViewController()
		controller.title = "Stats"
		return controller
	}
	
	func makeProfileViewController() -> UIViewController {
		let controller = ProfileViewController()
		controller.title = "Profile"
		controller.onOpenSubscriptionPage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onOpenSubscriptionPage)
		}
		
		controller.onOpenInstallmentPage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onOpenInstallmentPage)
		}
		return controller
	}
	
	func makeAddRecordPageViewController() -> UIViewController {
		let controller = AddRecordViewController()
		return controller
	}
	
	func makeSubscriptionPageViewController() -> UIViewController {
		let controller = SubscriptionViewController()
		return controller
	}
	
	func makeInstallmentPageViewController() -> UIViewController {
		let controller = InstallmentViewController()
		return controller
	}
	
}

