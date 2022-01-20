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
		case onCreateTabBar(viewModel: AuthenticationViewModel)
		case onOpenHomePage
		case onOpenLandingPage
		case onOpenLoginPage
		case onOpenRegisterPage
		case onOpenStatsPage(viewModel: StatsViewModel)
		case onOpenAddRecordPage(viewModel: HomeViewModel)
		case onOpenProfilePage(authViewModel: AuthenticationViewModel, profileViewModel: ProfileViewModel)
		case onOpenSubscriptionPage(viewModel: ProfileViewModel)
        case onOpenInstallmentPage(viewModel: ProfileViewModel)
		case onOpenEditProfile(viewModel: ProfileViewModel)
		case onOpenHelp
		case onBackToEditProfilePage
		case onOpenChangeEmail(viewModel: ProfileViewModel)
		case onOpenChangeUsername(viewModel: ProfileViewModel)
		case onOpenChangePassword(viewModel: ProfileViewModel)
	}
	
	public init(navigationController: UINavigationController, tabBarController: UITabBarController) {
		self.navigationController = navigationController
		self.tabBarController = tabBarController
	}
	
	func make() -> UIViewController {
		let controller = makeLandingPageViewController()
		return controller
	}
	
	func makeTabBarViewController(homeViewModel: HomeViewModel, statsViewModel: StatsViewModel, authViewModel: AuthenticationViewModel, profileViewModel: ProfileViewModel) -> UITabBarController {
		tabBarController.edgesForExtendedLayout = []

		let home = makeHomePageViewController(viewModel: homeViewModel)
		home.tabBarItem.image = UIImage(named: "homeSelected.png")?.scalePreservingAspectRatio(targetSize: kayayuSize.kayayuTabbarImageSize)
		home.tabBarItem.selectedImage = UIImage(named: "homeSelected.png")?.scalePreservingAspectRatio(targetSize: kayayuSize.kayayuTabbarImageSize)
		
		let stats = makeStatsPageViewController(viewModel: statsViewModel)
		stats.tabBarItem.image = UIImage(named: "statsUnselected.png")?.scalePreservingAspectRatio(targetSize: kayayuSize.kayayuTabbarImageSize)
		stats.tabBarItem.selectedImage = UIImage(named: "statsSelected.png")?.scalePreservingAspectRatio(targetSize: kayayuSize.kayayuTabbarImageSize)
		
		let profile = makeProfileViewController(authViewModel: authViewModel, profileViewModel: profileViewModel)
		profile.tabBarItem.image = UIImage(named: "accUnselected.png")?.scalePreservingAspectRatio(targetSize: kayayuSize.kayayuTabbarImageSize)
		profile.tabBarItem.selectedImage = UIImage(named: "accSelected.png")?.scalePreservingAspectRatio(targetSize: kayayuSize.kayayuTabbarImageSize)
		
		tabBarController.tabBar.tintColor = kayayuColor.yellow
		tabBarController.selectedIndex = 0
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
		controller.onCreateTabBar = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onCreateTabBar(viewModel: viewModel))
		}
		controller.onOpenRegisterPage = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onOpenRegisterPage)
			
		}
		return controller
	}
	
	func makeRegisterPageViewController(viewModel: AuthenticationViewModel) -> UIViewController {
		let controller = RegisterViewController(authenticationViewModel: viewModel)
		controller.onCreateTabBar = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onCreateTabBar(viewModel: viewModel))
		}
		controller.onOpenLoginPage = { [weak self] in
				guard let self = self else {
					return
				}
				
				self.onNavigationEvent?(.onOpenLoginPage)
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
			self.onNavigationEvent?(.onOpenAddRecordPage(viewModel: viewModel))
		}
		return controller
	}
	
	func makeAddRecordPageViewController(viewModel: HomeViewModel) -> UIViewController {
		let controller = AddRecordViewController(viewModel: viewModel)
		
		controller.onOpenHomePage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onOpenHomePage)
		}
		return controller
	}
	
	func makeStatsPageViewController(viewModel: StatsViewModel) -> UIViewController {
		let controller = StatsViewController(viewModel: viewModel)
		controller.title = "Stats"
		return controller
	}
	
	func makeProfileViewController(authViewModel: AuthenticationViewModel, profileViewModel: ProfileViewModel) -> UIViewController {
		let controller = ProfileViewController(authViewModel: authViewModel, profileViewModel: profileViewModel)
		controller.title = "Profile"
		controller.onOpenSubscriptionPage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onOpenSubscriptionPage(viewModel: profileViewModel))
		}
		
		controller.onOpenInstallmentPage = { [weak self] in
			guard let self = self else {
				return
			}
            self.onNavigationEvent?(.onOpenInstallmentPage(viewModel: profileViewModel))
		}
		
		controller.onOpenEditProfile = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onOpenEditProfile(viewModel: profileViewModel))
			
		}
		
		controller.onOpenHelp = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onOpenHelp)
			
		}
        
        controller.onLogout = { [weak self] in
            guard let self = self else {
                return
            }
			self.navigationController?.popToRootViewController(animated: true)
        }
        
		return controller
	}
	
    func makeSubscriptionPageViewController(viewModel: ProfileViewModel) -> UIViewController {
		let controller = SubscriptionViewController(viewModel: viewModel)
		return controller
	}
	
    func makeInstallmentPageViewController(viewModel: ProfileViewModel) -> UIViewController {
		let controller = InstallmentViewController(viewModel: viewModel)
		return controller
	}
	
	func makeTheoryExplanationViewController() -> UIViewController {
		let controller = TheoryExplanationController()
		return controller
	}
	
	func makeEditProfilePageViewController(viewModel: ProfileViewModel) -> UIViewController {
		let controller = EditProfileController(viewModel: viewModel)
		
		controller.onOpenChangeUsernamePage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onOpenChangeUsername(viewModel: viewModel))
		}
		
		controller.onOpenChangeEmailPage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onOpenChangeEmail(viewModel: viewModel))
		}
		
		controller.onOpenChangePasswordPage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onOpenChangePassword(viewModel: viewModel))
		}
		
		return controller
	}
	
	func makeChangeUsernamePageViewController(viewModel: ProfileViewModel) -> UIViewController {
		let controller = ChangeUsernameController(viewModel: viewModel)
		
		controller.onBackToEditProfilePage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onBackToEditProfilePage)
		}
		
		return controller
	}
	
	func makeChangeEmailPageViewController(viewModel: ProfileViewModel) -> UIViewController {
		let controller = ChangeEmailController(viewModel: viewModel)
		
		controller.onBackEditProfilePage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onBackToEditProfilePage)
		}
		
		return controller
	}
	
	func makeChangePasswordPageViewController(viewModel: ProfileViewModel) -> UIViewController {
		let controller = ChangePasswordController(viewModel: viewModel)
		
		controller.onBackToEditProfilePage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onBackToEditProfilePage)
		}
		
		return controller
	}
	
}

