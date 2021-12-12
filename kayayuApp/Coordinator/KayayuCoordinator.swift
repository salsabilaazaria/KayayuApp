//
//  KayayuCoordinator.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 19/11/21.
//

import Foundation
import UIKit

public final class KayayuCoordinator {
	
	private var navigationController: UINavigationController
	private let tabBarViewController: UITabBarController
	var screen: KayayuScreen?
	private let window: UIWindow
	
	// MARK: - Init
	
	init(window: UIWindow) {
		self.tabBarViewController = UITabBarController()
		self.navigationController = UINavigationController()
		self.window = window
		self.window.backgroundColor = .white
	}
	
	func makeKayayuScreen() {
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		let screen = KayayuScreen(navigationController: self.navigationController, tabBarController: tabBarViewController)
		self.screen = screen
		self.configureScreen()
		
		DispatchQueue.main.async { [weak self] in
			self?.navigationController.pushViewController(screen.make(), animated: true)
		}
	}
	
	private func configureScreen() {
		screen?.onNavigationEvent = { [weak self] (navigationEvent: KayayuScreen.NavigationEvent) in
			
			guard let self = self, let screen = self.screen else {
				return
			}
			
			switch navigationEvent {
				case .onCreateTabBar:
					DispatchQueue.main.async {
						let homeViewModel = HomeViewModel()
						let profileViewModel = ProfileViewModel()
						let controller = screen.makeTabBarViewController(homeViewModel: homeViewModel, profileViewModel: profileViewModel)
						self.navigationController.pushViewController(controller, animated: true)
					}
				case .onOpenHomePage:
					let viewModel = HomeViewModel()
					DispatchQueue.main.async {
						let controller = screen.makeHomePageViewController(viewModel: viewModel)
						self.navigationController.pushViewController(controller, animated: true)
						
					}
				case .onOpenLandingPage:
					DispatchQueue.main.async {
						let controller = screen.makeLandingPageViewController()
						self.navigationController.pushViewController(controller, animated: true)
						
					}
				case .onOpenLoginPage:
					DispatchQueue.main.async {
						let viewModel = AuthenticationViewModel()
						let controller = screen.makeLoginPageViewController(viewModel: viewModel)
						self.navigationController.pushViewController(controller, animated: true)
						
					}
				case .onOpenRegisterPage:
					DispatchQueue.main.async {
						let viewModel = AuthenticationViewModel()
						let controller = screen.makeRegisterPageViewController(viewModel: viewModel)
						self.navigationController.pushViewController(controller, animated: true)
						
					}
				case .onOpenStatsPage:
					DispatchQueue.main.async {
						let controller = screen.makeStatsPageViewController()
						self.navigationController.pushViewController(controller, animated: true)
						
					}
					
				case .onOpenAddRecordPage:
					DispatchQueue.main.async {
						let controller = screen.makeAddRecordPageViewController()
						self.navigationController.pushViewController(controller, animated: true)
						
					}
				case .onOpenProfilePage(let viewModel):
					DispatchQueue.main.async {
						let controller = screen.makeProfileViewController(viewModel: viewModel)
						self.navigationController.pushViewController(controller, animated: true)
						
					}
				case .onOpenSubscriptionPage(let viewModel):
					DispatchQueue.main.async {
						let controller = screen.makeSubscriptionPageViewController(viewModel: viewModel)
						self.navigationController.pushViewController(controller, animated: true)
						
					}
				case .onOpenInstallmentPage:
					DispatchQueue.main.async {
						let controller = screen.makeInstallmentPageViewController()
						self.navigationController.pushViewController(controller, animated: true)
						
					}
			}
		}
	}
}
