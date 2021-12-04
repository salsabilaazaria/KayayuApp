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
	var screen: KayayuScreen?
	private let window: UIWindow
	
	// MARK: - Init
	
	init(window: UIWindow) {
		self.navigationController = UINavigationController()
		self.window = window
		self.window.backgroundColor = .white
	}
	
	func makeKayayuScreen() {
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		let screen = KayayuScreen(navigationController: self.navigationController)
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
			case .onOpenLandingPage:
				DispatchQueue.main.async {
					let controller = screen.makeLandingPageViewController()
					self.navigationController.pushViewController(controller, animated: true)
					
				}
			case .onOpenLoginPage(let authenticationViewModel):
				DispatchQueue.main.async {
					let controller = screen.makeLoginPageViewController(authenticationViewModel: authenticationViewModel)
					self.navigationController.pushViewController(controller, animated: true)
					
				}
			case .onOpenRegisterPage(let authenticationViewModel):
				DispatchQueue.main.async {
					let controller = screen.makeRegisterPageViewController(authenticationViewModel: authenticationViewModel)
					self.navigationController.pushViewController(controller, animated: true)
					
				}
			case .onOpenHomePage:
				DispatchQueue.main.async {
                    let viewModel = HomeViewModel()
					let controller = screen.makeHomePageViewController(viewModel: viewModel)
					self.navigationController.pushViewController(controller, animated: true)
					
				}
			case .onOpenStatsPage:
				DispatchQueue.main.async {
					let controller = screen.makeStatsPageViewController()
					self.navigationController.pushViewController(controller, animated: true)
					
				}
			}
		}
	}
	
}
