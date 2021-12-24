//
//  StatsViewModel.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 24/12/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import RxCocoa
import RxSwift


class StatsViewModel {
	var reloadUI: (() -> Void)?
	
	private let database = Firestore.firestore()
	private let calendarHelper: CalendarHelper = CalendarHelper()
	
	var user: BehaviorRelay<Users?> = BehaviorRelay<Users?>(value: nil)
	
	var needsTransactionData: BehaviorRelay<[Transactions]?> = BehaviorRelay<[Transactions]?>(value: nil)
	var wantsTransactionData: BehaviorRelay<[Transactions]?> = BehaviorRelay<[Transactions]?>(value: nil)
	var savingsTransactionData: BehaviorRelay<[Transactions]?> = BehaviorRelay<[Transactions]?>(value: nil)
	
	var needsTotalTransaction: BehaviorRelay<Float?> = BehaviorRelay<Float?>(value: nil)
	var wantsTotalTransaction: BehaviorRelay<Float?> = BehaviorRelay<Float?>(value: nil)
	var savingsTotalTransaction: BehaviorRelay<Float?> = BehaviorRelay<Float?>(value: nil)
	
	private let disposeBag = DisposeBag()

	init() {
		self.getUserData()
		self.getNeedsTransDataSpecMonth(diff: calendarHelper.monthInt(date: Date()))
		self.getWantsTransDataSpecMonth(diff: calendarHelper.monthInt(date: Date()))
		self.getSavingsTransDataSpecMonth(diff: calendarHelper.monthInt(date: Date()))
		configureObserver()
	}
	
	private func configureObserver() {
//		Observable.combineLatest(needsTotalTransaction.asObservable(),
//								 wantsTotalTransaction.asObservable(),
//								 savingsTotalTransaction.asObservable()).subscribe {
//									(needs, wants, savings) in
//									self.reloadUI?()
//								}.disposed(by: DisposeBag)
		
		self.needsTotalTransaction.asObservable().subscribe(onNext: { transData in
			self.reloadUI?()
		}).disposed(by: disposeBag)

	}
	
	private func getUserId() -> String{
		guard let userId = Auth.auth().currentUser?.uid else { return "" }
		return userId
	}
	
	func getUserData() {
		database.collection("users").document(getUserId()).addSnapshotListener({ documentSnapshot, error in
			guard let document = documentSnapshot else {
				print("KAYAYU get data failed")
				return
			}
			
			do {
				guard let userData = try document.data(as: Users.self) else {
					print("KAYAYU failed get userData")
					return
				}
				self.user.accept(userData)
				
			} catch {
				print(error)
			}
		})
	}
	
	func calculateNeedsProgressBarRatio() -> Float{
		guard let needsBalance = self.user.value?.balance_needs,
			  let needsTotalTrans = self.needsTotalTransaction.value else {
			return 0
		}
		
		return needsTotalTrans/needsBalance
	}
	
	
	func calculateTotalNeedsTrans() {
		guard let needsData = self.needsTransactionData.value else {
			return
		}
		var totalNeeds:Float = 0
		
		for data in needsData {
			if let amount = data.amount,
			   let isIncome = data.income_flag,
			   !isIncome  {
				totalNeeds += amount
			}
		}
		
		self.needsTotalTransaction.accept(totalNeeds)
	}

	func getNeedsTransDataSpecMonth (diff: Int) {
		database.collection("transactions")
			.whereField("user_id", isEqualTo: getUserId())
			.whereField("transaction_date", isGreaterThan: calendarHelper.getSpecStartMonth(diff: diff))
			.whereField("transaction_date", isLessThan: calendarHelper.getSpecEndMonth(diff: diff))
			.whereField("category", isEqualTo: kayayuRatio.needs.rawValue.lowercased())
			.order(by: "transaction_date", descending: true).getDocuments() { (documentSnapshot, errorMsg) in
			if let errorMsg = errorMsg {
				print("Error Get Needs Transaction Data \(errorMsg)")
			}
			else {
				var documentArray: [Transactions] = []
				for document in documentSnapshot!.documents {
					
					do {
						guard let trans = try document.data(as: Transactions.self) else {
							print("KAYAYU failed get Needs Transaction Data")
							return
						}
						documentArray.append(trans)
						
					} catch {
						print(error)
					}
					
				}
				print("stats NEEDS DATA \(documentArray)")
				self.needsTransactionData.accept(documentArray)
				self.calculateTotalNeedsTrans()
			}
		}
	}
	
	
	func calculateWantsProgressBarRatio() -> Float {
		guard let wantsBalance = self.user.value?.balance_wants,
			  let wantsTotalTrans = self.wantsTotalTransaction.value else {
			return 0
		}
		
		return wantsTotalTrans/wantsBalance
	}
	
	func calculateTotalWantsTrans() {
		guard let wantsData = self.wantsTransactionData.value else {
			return
		}
		var totalWants:Float = 0
		
		for data in wantsData {
			
			if let amount = data.amount,
			   let isIncome = data.income_flag,
			   !isIncome  {
				totalWants += amount
				
			}
		}
		
		self.wantsTotalTransaction.accept(totalWants)
	}
	
	
	func getWantsTransDataSpecMonth (diff: Int) {
		database.collection("transactions")
			.whereField("user_id", isEqualTo: getUserId())
			.whereField("transaction_date", isGreaterThan: calendarHelper.getSpecStartMonth(diff: diff))
			.whereField("transaction_date", isLessThan: calendarHelper.getSpecEndMonth(diff: diff))
			.whereField("category", isEqualTo: kayayuRatio.wants.rawValue.lowercased())
			.order(by: "transaction_date", descending: true).getDocuments() { (documentSnapshot, errorMsg) in
			if let errorMsg = errorMsg {
				print("Error Get Wants Transaction Data \(errorMsg)")
			}
			else {
				var documentArray: [Transactions] = []
				for document in documentSnapshot!.documents {

					do {
						guard let trans = try document.data(as: Transactions.self) else {
							print("KAYAYU failed get transactionData")
							return
						}
						documentArray.append(trans)
						
					} catch {
						print(error)
					}
					
				}
				self.wantsTransactionData.accept(documentArray)
				self.calculateTotalWantsTrans()
			}
		}
	}
	
	func calculateSavingsProgressBarRatio() -> Float {
		guard let savingsBalance = self.user.value?.balance_savings,
			  let savingsTotalTrans = self.savingsTotalTransaction.value else {
			return 0
		}
		
		return savingsTotalTrans/savingsBalance
	}
	
	func calculateTotalSavingsTrans() {
		guard let savingsData = self.savingsTransactionData.value else {
			return
		}
		var totalSavings:Float = 0
		
		for data in savingsData {
			if let amount = data.amount,
			   let isIncome = data.income_flag,
			   !isIncome  {
				totalSavings += amount
			}
		}
		self.savingsTotalTransaction.accept(totalSavings)

	}

	func getSavingsTransDataSpecMonth (diff: Int) {
		database.collection("transactions")
			.whereField("user_id", isEqualTo: getUserId())
			.whereField("transaction_date", isGreaterThan: calendarHelper.getSpecStartMonth(diff: diff))
			.whereField("transaction_date", isLessThan: calendarHelper.getSpecEndMonth(diff: diff))
			.whereField("category", isEqualTo: kayayuRatio.savings.rawValue.lowercased())
			.order(by: "transaction_date", descending: true).getDocuments() { (documentSnapshot, errorMsg) in
			if let errorMsg = errorMsg {
				print("Error Get Savings Transaction Data \(errorMsg)")
			}
			else {
				var documentArray: [Transactions] = []
				for document in documentSnapshot!.documents {

					do {
						guard let trans = try document.data(as: Transactions.self) else {
							print("KAYAYU failed get transactionData")
							return
						}
						documentArray.append(trans)
						
					} catch {
						print(error)
					}
					
				}
				print("stats SAVINGS DATA \(documentArray)")
				self.savingsTransactionData.accept(documentArray)
				self.calculateTotalSavingsTrans()
			}
		}
	}
	
	
	
}
