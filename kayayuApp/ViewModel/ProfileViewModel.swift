//
//  ProfileViewModel.swift
//  kayayuApp
//
//  Created by angie on 10/12/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import RxCocoa
import RxSwift

class ProfileViewModel {
	var reloadUI: (() -> Void)?
	var showAlert: ((String) -> Void)?
	var onBackToEditProfilePage: (() -> Void)?
	
	let database = Firestore.firestore()
	let calendarHelper = CalendarHelper()
	
	var user: BehaviorRelay<Users?> = BehaviorRelay<Users?>(value: nil)
	var recurringData: BehaviorRelay<[RecurringTransactions]?> = BehaviorRelay<[RecurringTransactions]?>(value: nil)
	var recurringSubsData: BehaviorRelay<[RecurringTransactions]?> = BehaviorRelay<[RecurringTransactions]?>(value: nil)
	var recurringInstlData: BehaviorRelay<[RecurringTransactions]?> = BehaviorRelay<[RecurringTransactions]?>(value: nil)
	var detailTrans: BehaviorRelay<[TransactionDetails]?> = BehaviorRelay<[TransactionDetails]?>(value: nil)
	var detailTransLatest: BehaviorRelay<[TransactionDetails]?> = BehaviorRelay<[TransactionDetails]?>(value: nil)
	var transactionsData: BehaviorRelay<[Transactions]?> = BehaviorRelay<[Transactions]?>(value: nil)
	
	private let disposeBag = DisposeBag()
	
	init() {
		getUserData()
		getRecurringData()
		getRecurringSubsData()
		getRecurringInstlData()
		getTransactionDetailData()
		getTransactionData()
		configureObserver()
		
	}
	
	func getAuthUser() -> User? {
		guard let user = Auth.auth().currentUser else { return nil }
		return user
	}
	
	private func configureObserver() {
		Observable.combineLatest(recurringSubsData.asObservable(), recurringInstlData.asObservable()).subscribe(onNext: { data in
			self.reloadUI?()
		}).disposed(by: disposeBag)
		
		self.user.asObservable().subscribe(onNext: { user in
			self.reloadUI?()
		}).disposed(by: disposeBag)
	}
	
	private func getUserId() -> String {
		guard let userId = Auth.auth().currentUser?.uid else { return "" }
		print("KAYAYU USER ID \(userId)")
		return userId
	}
	
	private func getUserData() {
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
		database.collection("transactions")
			.whereField("user_id", isEqualTo: getUserId()).order(by: "transaction_date", descending: true)
			.addSnapshotListener { (documentSnapshot, errorMsg) in
				
				if let errorMsg = errorMsg {
					print("Error get Transaction Data \(errorMsg)")
				}
				else {
					var count = 0
					var documentArray: [Transactions] = []
					for document in documentSnapshot!.documents {
						count += 1
						
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
					self.transactionsData.accept(documentArray)
				}
			}
	}
	
	private func getRecurringData () {
		database.collection("recurringTransactions")
			.whereField("user_id", isEqualTo: getUserId()).order(by: "end_billing_date", descending: true)
			.whereField("end_billing_date", isGreaterThan: self.calendarHelper.getEndDay())
			.addSnapshotListener { (documentSnapshot, errorMsg) in
				
				if let errorMsg = errorMsg {
					print("Error get Recurring Data \(errorMsg)")
				}
				else {
					var documentArray: [RecurringTransactions] = []
					for document in documentSnapshot!.documents {
						do {
							guard let trans = try document.data(as: RecurringTransactions.self) else {
								print("KAYAYU failed get recurring data")
								return
								
							}
							documentArray.append(trans)
							
						} catch {
							print("error")
						}
					}
					self.recurringData.accept(documentArray)
				}
			}
	}
	
	private func getRecurringSubsData () {
		database.collection("recurringTransactions")
			.whereField("user_id", isEqualTo: getUserId()).whereField("recurring_type", isEqualTo: "subscription")
			.order(by: "end_billing_date", descending: false)
			.whereField("end_billing_date", isGreaterThan: self.calendarHelper.getEndDay())
			.addSnapshotListener { (documentSnapshot, errorMsg) in
				if let errorMsg = errorMsg {
					print("Error get Subscription Data \(errorMsg)")
				}
				else {
					var documentArray: [RecurringTransactions] = []
					for document in documentSnapshot!.documents {
						do {
							guard let trans = try document.data(as: RecurringTransactions.self) else {
								print("KAYAYU failed get recurring subscription data")
								return
								
							}
							documentArray.append(trans)
							
						} catch {
							print("error")
						}
					}
					self.recurringSubsData.accept(documentArray)
				}
			}
	}
	
	private func getRecurringInstlData () {
		database.collection("recurringTransactions").whereField("user_id", isEqualTo: getUserId())
			.whereField("recurring_type", isEqualTo: "installment")
			.order(by: "end_billing_date", descending: false)
			.whereField("end_billing_date", isGreaterThan: self.calendarHelper.getEndDay())
			.addSnapshotListener { (documentSnapshot, errorMsg) in
				if let errorMsg = errorMsg {
					print("Error get Installment Data \(errorMsg)")
				}
				else {
					var documentArray: [RecurringTransactions] = []
					for document in documentSnapshot!.documents {
						do {
							guard let trans = try document.data(as: RecurringTransactions.self) else {
								print("KAYAYU failed get recurring installment data")
								return
							}
							documentArray.append(trans)
							
						} catch {
							print("error")
						}
					}
					self.recurringInstlData.accept(documentArray)
				}
			}
	}
	
	private func getTransactionDetailData() {
		
		database.collection("transactionDetails").order(by: "billing_date", descending: true).addSnapshotListener { (documentSnapshot, errorMsg) in
			if let errorMsg = errorMsg {
				print("Error get Subscription Data \(errorMsg)")
			}
			else {
				
				var documentArray: [TransactionDetails] = []
				
				for document in documentSnapshot!.documents {
					
					do {
						guard let trans = try document.data(as: TransactionDetails.self) else {
							print("KAYAYU failed get recurring subscription data")
							return
						}
						documentArray.append(trans)
						
					} catch {
						print("error")
					}
				}
				self.detailTrans.accept(documentArray)
				
			}
		}
	}
	
	func getNextBillDate(recurringId: String) -> Date {
		
		guard let detailTrans = self.detailTrans.value,
			  let data = detailTrans.first(where: { $0.recurring_id == recurringId }),
			  let nextBillDate = data.billing_date else {
			return Date()
		}
		
		//        print("next subs due: \(nextBillDate)")
		return nextBillDate
	}
	
	func getRemainingAmount(recurringId: String) -> Float {
		
		guard let detailTrans = self.detailTrans.value,
			  let data = detailTrans.first(where: { $0.transaction_id != "a" && $0.recurring_id == recurringId }),
			  let remainingAmount = data.amount_havent_paid else {
			return 0
		}
		
		return remainingAmount
	}
	
	func getDueIn(recurringId: String) -> Int {
		
		guard let detailTrans = self.detailTrans.value,
			  let data = detailTrans.first(where: { $0.recurring_id == recurringId })
		
		else {
			return 40
		}
		
        var dueIn = Calendar.current.dateComponents([.day], from: calendarHelper.dateOnly(date: Date()), to: calendarHelper.dateOnly(date: data.billing_date ?? Date())).day!
        if(Date() > data.billing_date!) {
            dueIn = Calendar.current.dateComponents([.day], from: calendarHelper.dateOnly(date: data.billing_date ?? Date()), to: calendarHelper.dateOnly(date: Date())).day!
        }
		
		if(dueIn <= 0){
			print("add data \(data.transaction_detail_id) to trans table")
			
			//generate transaction data
			var refTrans: DocumentReference? = nil
			refTrans = database.collection("transactions").addDocument(data: ["temp": "temp"]){
				err in
				if let err = err {
					print("Error adding transaction data \(err)")
				} else {
					print("Document added with ID to transactions: \(refTrans!.documentID)")
				}
			}
			
			//get previous trans id buat ambil data category & description
			guard let prevDetailTrans = self.detailTrans.value,
				  let prevDetailTransData = prevDetailTrans.first(where: { $0.transaction_id != "a" && $0.recurring_id == recurringId }),
				  let lastTransId = prevDetailTransData.transaction_id else {
				return 50
			}
			
			//get category & description
			guard let prevTransData = self.transactionsData.value,
				  let prevData = prevTransData.first(where: { $0.transaction_id == lastTransId }),
				  let category = prevData.category,
				  let description = prevData.description
			else {
				return 60
			}
            
			let newTransData = Transactions(
				transaction_id: refTrans!.documentID,
				user_id: self.getUserId(),
				category: category,
				income_flag: false,
				transaction_date: data.billing_date,
				description: description,
				recurring_flag: true,
				amount: data.amount
			)
			
            print("document data: \(newTransData)")
            
			do {
				try database.collection("transactions").document(refTrans!.documentID).setData(from: newTransData)
			} catch {
				print("Error setting next transaction data to transactions firestore \(error)")
			}
			
			//update current detailTransaction transactionid to generated transaction data
			var recDetailTransData: DocumentReference? = nil
			recDetailTransData = database.collection("transactionDetails").document(data.transaction_detail_id)
			recDetailTransData?.updateData([ "transaction_id":refTrans?.documentID ?? "a" ]) { err in
				if let err = err {
					print("Error adding curr detail transaction data \(err)")
				} else {
					print("transaction_id updated")
				}
			}
			
			guard let recTransData = self.recurringData.value,
				  let recData = recTransData.first(where: { $0.recurring_id == recurringId }),
				  let end_billing_date = recData.end_billing_date,
				  let billing_type = recData.billing_type,
				  let recurring_type = recData.recurring_type,
				  let number_of_recurring = data.number_of_recurring,
				  let start_billing_date = recData.start_billing_date
			else {
				print("error masuk sini")
				return 70
			}
			
			if(calendarHelper.dateOnly(date: Date()) < calendarHelper.dateOnly(date: end_billing_date)) {
				
				var next_billing_date: Date?
				var dateComponent = DateComponents()
				
				if(billing_type == "weekly"){
					dateComponent.weekOfYear = 1
					
				} else if(billing_type == "monthly"){
					dateComponent.month = number_of_recurring
					
				} else if(billing_type == "yearly"){
					dateComponent.year = number_of_recurring
				}
				next_billing_date = Calendar.current.date(byAdding: dateComponent, to: start_billing_date)
				
				var final_amount_paid: Float?
				var final_amount_havent_paid: Float?
				
				if(recurring_type == "installment") {
					final_amount_paid = data.amount_paid! + data.amount!
					final_amount_havent_paid = data.amount_havent_paid! - data.amount!
					
				} else if(recurring_type == "subscription") {
					final_amount_paid = 0
					final_amount_havent_paid = 0
				}
				
				var refDetailTrans: DocumentReference? = nil
				refDetailTrans = database.collection("transactionDetails").addDocument(data: ["temp": "temp"]){
					err in
					if let err = err {
						print("Error adding transaction data \(err)")
					} else {
						print("Document added with ID to transactionDetails: \(refDetailTrans!.documentID)")
					}
				}
				
				let nextDetailTransData = TransactionDetails(
					transaction_detail_id: refDetailTrans!.documentID,
					transaction_id: "a",
					user_id: self.getUserId(),
					recurring_id: recurringId,
					billing_date: next_billing_date,
					number_of_recurring: number_of_recurring + 1,
					amount: data.amount,
					amount_paid: final_amount_paid,
					amount_havent_paid: final_amount_havent_paid
				)
				
				do {
					try database.collection("transactionDetails").document(refDetailTrans!.documentID).setData(from: nextDetailTransData)
				} catch {
					print("Error setting next transaction data to transactionDetail firestore \(error)")
				}
			}
		}
		
		return dueIn
	}
	
	
	//EDIT PROFILE
	
	private let wrongPasswordMsg = "Password is incorrect, please try again."
	
	private func validatePassword(validatePassword: String) -> Bool {
		print("ValidatePassword \(self.user.value?.password) \(validatePassword)")
		return self.user.value?.password == validatePassword
	}
	
	func updateNewUsername(newUsername: String, password: String) {
		let passIsValid = self.validatePassword(validatePassword: password)
		let oldUsername = self.user.value?.username
		
		if passIsValid == true, oldUsername != newUsername {
			
			let changeRequest = Firebase.Auth.auth().currentUser?.createProfileChangeRequest()
			changeRequest?.displayName = newUsername
			changeRequest?.commitChanges { error in
			  print("Change username request failed \(error)")
				self.showAlert?(error?.localizedDescription ?? "Failed to update your username, please try again later.")
				return
			}
			
			
			let newUsernameData = [ "username": "\(newUsername)" ]

			database.collection("users").document(getUserId()).updateData(newUsernameData) { err in
				if let err = err {
					self.showAlert?(err.localizedDescription)
					print("Kayayu error on updating document: \(err) ")
					return
				}
				else {
					
					self.onBackToEditProfilePage?()
					print("Kayayu successfully update username")
				}
			}
		} else {
			self.showAlert?(wrongPasswordMsg)
			return
		}
		
	}
	
	func updateNewEmail(newEmail: String, password: String) {
		let passIsValid = self.validatePassword(validatePassword: password)
		let oldEmail = self.user.value?.email
		
		if passIsValid == true, newEmail != oldEmail {
			
			//Ganti di authentication
			FirebaseAuth.Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { errorMsg in
				
				guard let errorMsg = errorMsg else {
					//Ganti di firestore
					
					let newEmailData = [ "email": "\(newEmail)" ]
					
					self.database.collection("users").document(self.getUserId()).updateData(newEmailData) { err in
						if let err = err {
							self.showAlert?(err.localizedDescription)
							print("Kayayu error on updating document: \(err) ")
							return
						}
						else {
							self.onBackToEditProfilePage?()
							print("Kayayu successfully update username")
						}
					}
					
					return
				}
				print("Kayayu Firebase failed to change email in authentication with errorMsg \(errorMsg)")
			})
			
		} else {
			self.showAlert?(wrongPasswordMsg)
			return
		}
	}
	
	func updateNewPassword(oldPassword: String, newPassword: String, newConfirmationPassword: String) {
		let passIsValid = self.validatePassword(validatePassword: oldPassword)
		if passIsValid == true,
		   newPassword == newConfirmationPassword,
		   oldPassword != newPassword {
	
			//Ganti di authentication
			FirebaseAuth.Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { errorMsg in
				guard let errorMsg = errorMsg else {
					
					//Ganti di firestore
					let newPasswordData = [ "password": "\(newPassword)" ]
					
					self.database.collection("users").document(self.getUserId()).updateData(newPasswordData) { err in
						if let err = err {
							self.showAlert?(err.localizedDescription)
							print("Kayayu error on updating document: \(err) ")
							return
						}
						else {
							self.onBackToEditProfilePage?()
							print("Kayayu successfully update username")
						}
					}
					
					return
				}
				print("Kayayu Firebase failed to change email in authentication with errorMsg \(errorMsg)")
			})
			
		} else {
			self.showAlert?(wrongPasswordMsg)
			return
		}
	}
}
