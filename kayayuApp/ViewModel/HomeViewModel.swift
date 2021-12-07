//
//  HomeViewModel.swift
//  kayayuApp
//
//  Created by angie on 04/12/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import RxCocoa
import RxSwift


class HomeViewModel {
	let database = Firestore.firestore()
	var user: BehaviorRelay<Users?> = BehaviorRelay<Users?>(value: nil)
	var transactionsData: BehaviorRelay<[Transactions]?> = BehaviorRelay<[Transactions]?>(value: nil)
	
	var userBalanceTotal: Float = 0
	
	init() {
		self.getUserData()
		self.getTransactionData()
	}
	
	func getUserId() -> String{
		guard let userId = Auth.auth().currentUser?.uid else { return "" }
		print("KAYAYU USER ID \(userId)")
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
	
	func getTransactionData () {
		database.collection("transactions").whereField("user_id", isEqualTo: getUserId()).getDocuments() { (documentSnapshot, errorMsg) in
			if let errorMsg = errorMsg {
				print("Error get Transaction Data \(errorMsg)")
			}
			else {
				var count = 0
				var docummentArray: [Transactions] = []
				for document in documentSnapshot!.documents {
					count += 1
					
					do {
						guard let trans = try document.data(as: Transactions.self) else {
							print("KAYAYU failed get transactionData")
							return
						}
						docummentArray.append(trans)
						
					} catch {
						print(error)
					}
					
				}
				self.transactionsData.accept(docummentArray)
			}
			
		}
	}

}
