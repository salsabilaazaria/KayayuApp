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
	var onOpenHomePage: (() -> Void)?
	var reloadUI: (() -> Void)?
	
    let profViewModel = ProfileViewModel()
	let database = Firestore.firestore()
    private let calendarHelper = CalendarHelper()
	
	var user: BehaviorRelay<Users?> = BehaviorRelay<Users?>(value: nil)
	var transactionsData: BehaviorRelay<[Transactions]?> = BehaviorRelay<[Transactions]?>(value: nil)
	var dictTransactionData: BehaviorRelay<[TransactionDateDictionary]?> = BehaviorRelay<[TransactionDateDictionary]?>(value: nil)
	
	var detailTrans: BehaviorRelay<[TransactionDetails]?> = BehaviorRelay<[TransactionDetails]?>(value: nil)
	
	var incomePerMonth: BehaviorRelay<Float?> = BehaviorRelay<Float?>(value: nil)
	var expensePerMonth: BehaviorRelay<Float?> = BehaviorRelay<Float?>(value: nil)
	
	var balanceTotal: BehaviorRelay<Float?> = BehaviorRelay<Float?>(value: nil)
	var needsTotal: Float = 0
	var wantsTotal: Float = 0
	var savingsTotal: Float = 0
  
	var userBalanceTotal: Float = 0

	private let disposeBag = DisposeBag()
	
	init() {
		
		let currStartDate = calendarHelper.getSpecStartMonth(month: calendarHelper.monthInt(date: Date()), year: calendarHelper.yearInt(date: Date()))
		let currEndDate = calendarHelper.getSpecEndMonth(month: calendarHelper.monthInt(date: Date()), year: calendarHelper.yearInt(date: Date()))
		
		self.getUserData()
		self.getTransactionDataSpecMonth(startDate: currStartDate, endDate: currEndDate)
		self.configureObserver()
		self.getBalanceTotal()
        self.getRecurringIds()
        
        self.getTransactionDetailData()
	}
    
	private func configureObserver() {
		self.transactionsData.asObservable().subscribe(onNext: { transData in
			self.getDictionaryTransaction()
			self.updateBalanceTotal()
			self.reloadUI?()
		}).disposed(by: disposeBag)
		
		self.balanceTotal.asObservable().subscribe(onNext: { balanceTotal in
			self.updateBalanceTotal()
		}).disposed(by: disposeBag)
	}
	
	private func getUserId() -> String{
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
	
	private func updateBalanceTotal() {
		let balanceTotal = self.balanceTotal.value
		let balanceTotalData = [ "balance_total": balanceTotal,
								 "balance_needs": needsTotal,
								 "balance_wants": wantsTotal,
								 "balance_savings": savingsTotal]
		database.collection("users").document(self.getUserId()).updateData(balanceTotalData as [AnyHashable : Any]) { err in
			if let err = err {
				print("Kayayu error on updating document: \(err) ")
				return
			}
			else {
				print("Kayayu successfully update balance_total")
			}
		}
	}

	
	private func getBalanceTotal() {
		database.collection("transactions")
			.whereField("user_id", isEqualTo: getUserId())
			.addSnapshotListener { (documentSnapshot, errorMsg) in
				
				if let errorMsg = errorMsg {
					print("Error get Transaction Data \(errorMsg)")
				}
				else {
					var incomeTotal: Float = 0
					var expenseTotal: Float = 0
					
					var needsIncome: Float = 0
					var needsExpense: Float = 0
					
					var wantsIncome: Float = 0
					var wantsExpense: Float = 0
					
					var savingsIncome: Float = 0
					var savingsExpense: Float = 0
					for document in documentSnapshot!.documents {
						
						do {
							guard let trans = try document.data(as: Transactions.self) else {
								print("KAYAYU failed get transactionData")
								return
							}
							
							guard let amount = trans.amount else {
								return
							}
							if trans.income_flag == true {
								incomeTotal += amount
								if trans.category == kayayuRatioTitle.all.rawValue.lowercased() {
									
									let needsAmount = amount * kayayuRatioValue.needs.rawValue
									let wantsAmount = amount * kayayuRatioValue.wants.rawValue
									let savingsAmount = amount * kayayuRatioValue.savings.rawValue
									
									needsIncome += needsAmount
									wantsIncome += wantsAmount
									savingsIncome += savingsAmount
									
								} else if trans.category == kayayuRatioTitle.needs.rawValue.lowercased() {
									needsIncome += amount
								} else if trans.category == kayayuRatioTitle.wants.rawValue.lowercased() {
									wantsIncome += amount
								} else if trans.category == kayayuRatioTitle.savings.rawValue.lowercased() {
									savingsIncome += amount
								}
							} else {
								expenseTotal += amount
								
								if trans.category == kayayuRatioTitle.all.rawValue.lowercased() {
									
									let needsAmount = amount * kayayuRatioValue.needs.rawValue
									let wantsAmount = amount * kayayuRatioValue.wants.rawValue
									let savingsAmount = amount * kayayuRatioValue.savings.rawValue
									
									needsExpense += needsAmount
									wantsExpense += wantsAmount
									savingsExpense += savingsAmount
									
								} else if trans.category == kayayuRatioTitle.needs.rawValue.lowercased() {
									needsExpense += amount
								} else if trans.category == kayayuRatioTitle.wants.rawValue.lowercased() {
									wantsExpense += amount
								} else if trans.category == kayayuRatioTitle.savings.rawValue.lowercased() {
									savingsExpense += amount
								}
							}
							
							
						} catch {
							print(error)
						}
						
					}
					let balanceTotal = incomeTotal - expenseTotal
					self.needsTotal = needsIncome - needsExpense
					self.wantsTotal = wantsIncome - wantsExpense
					self.savingsTotal = savingsIncome - savingsExpense
					self.balanceTotal.accept(balanceTotal)
				}
			}
	}
    
	func getTransactionDataSpecMonth(startDate: Date, endDate: Date) {
        database.collection("transactions")
			.whereField("user_id", isEqualTo: getUserId())
			.whereField("transaction_date", isGreaterThan: startDate)
			.whereField("transaction_date", isLessThan: endDate)
			.order(by: "transaction_date", descending: true)
			.addSnapshotListener { (documentSnapshot, errorMsg) in
				
            if let errorMsg = errorMsg {
                print("Error get Transaction Data \(errorMsg)")
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
                    print("Transaction Data Specific Month \(documentArray)")
                }
                self.transactionsData.accept(documentArray)
            }
        }
    }
	
	private func getDictionaryTransaction() {
		guard let transDatas = transactionsData.value else {
			return
		}
		let groupedDictionary = Dictionary(grouping: transDatas) { (transData) -> DateComponents in

			let date = Calendar.current.dateComponents([.day, .year, .month], from: (transData.transaction_date)!)
			
			return date
		}
		
		let arrayOfDictionary = groupedDictionary.map { (date, trans) in
			return TransactionDateDictionary(date: date, transaction: trans)
		}
		print("DATA DICTIONARY \(arrayOfDictionary)")

		let sortedDateDictionary = arrayOfDictionary.sorted {
			guard let firstDate = calendarHelper.calendar.date(from: $0.date!),
			   let secondDate = calendarHelper.calendar.date(from: $1.date!) else  {
				return false
			}
		
			return firstDate > secondDate

		}
		self.dictTransactionData.accept(sortedDateDictionary)
	}
    
    private func getRecurringIds() {
        database.collection("recurringTransactions")
            .whereField("user_id", isEqualTo: getUserId())
            .addSnapshotListener { (documentSnapshot, errorMsg) in
                
                if let errorMsg = errorMsg {
                    print("Error getting Recurring Transactions data \(errorMsg)")
                }
                else {
                    var documentArray: [String] = []
                    var dueNum: Int = 0
                    for document in documentSnapshot!.documents {
                        
                        do {
                            guard let trans = try document.data(as: RecurringTransactions.self) else {
                                print("KAYAYU failed get recurringTransactions")
                                return
                            }
                            documentArray.append(trans.recurring_id)
                            
                            print("rec id: \(trans.recurring_id)")
                            
                            dueNum = self.profViewModel.getDueIn(recurringId: trans.recurring_id)
                            print("due in: \(dueNum)")
                            
                        } catch {
                            print(error)
                        }
                    }
                }
            }
    }
    
	
	//ADD DATA
    
    func addTransactionData(category: String, income_flag: Bool, transaction_date: Date, description: String, recurring_flag: Bool, amount: Float) {
        var ref: DocumentReference? = nil
		
        ref = database.collection("transactions").addDocument(data: ["temp": "temp"]){
            err in
            if let err = err {
                print("Error adding transaction data \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        let data = Transactions(
            transaction_id: ref!.documentID,
            user_id: self.getUserId(),
            category: category,
            income_flag: income_flag,
            transaction_date: transaction_date,
            description: description,
            recurring_flag: recurring_flag,
            amount: amount
        )
        
        do {
            try database.collection("transactions").document(ref!.documentID).setData(from: data)
			self.onOpenHomePage?()
        } catch {
            print("Error setting data to transactions firestore \(error)")
        }
    }

    func addRecurringSubsData(total_amount: Float, billing_type: String, start_billing_date: Date, tenor: Int, category: String, description: String) {
        
        var final_billing_type: String?
        var next_billing_date: Date?
        var end_billing_date: Date?
        
        var dateComponent = DateComponents()
        var dateComponentEnd = DateComponents()
        
        var refRecSubs: DocumentReference? = nil
        refRecSubs = database.collection("recurringTransactions").addDocument(data: ["temp": "temp"]){
            err in
            if let err = err {
                print("Error adding recurring transaction data \(err)")
            } else {
                print("Document added with ID to recurringTransactions: \(refRecSubs!.documentID)")
            }
        }
        
        var refTransRecSubs: DocumentReference? = nil
        refTransRecSubs = database.collection("transactions").addDocument(data: ["temp": "temp"]){
            err in
            if let err = err {
                print("Error adding transaction data \(err)")
            } else {
                print("Document added with ID to transactions: \(refTransRecSubs!.documentID)")
            }
        }
        
        var refDetailRecSubsCurr: DocumentReference? = nil
        refDetailRecSubsCurr = database.collection("transactionDetails").addDocument(data: ["temp": "temp"]){
            err in
            if let err = err {
                print("Error adding curr detail transaction data \(err)")
            } else {
                print("Document added with ID to transactionDetails: \(refDetailRecSubsCurr!.documentID)")
            }
        }
        
        if(billing_type == "Weeks"){
            final_billing_type = "weekly"
            dateComponent.weekOfYear = 1
            dateComponentEnd.weekOfYear = tenor-1
            
        } else if(billing_type == "Months"){
            final_billing_type = "monthly"
            dateComponent.month = 1
            dateComponentEnd.month = tenor-1
            
        } else if(billing_type == "Years"){
            final_billing_type = "yearly"
            dateComponent.year = 1
            dateComponentEnd.year = tenor-1
        }
        
        if(tenor == 1){
            end_billing_date = start_billing_date
        }
        else {
            next_billing_date = Calendar.current.date(byAdding: dateComponent, to: start_billing_date)
            end_billing_date = Calendar.current.date(byAdding: dateComponentEnd, to: start_billing_date)
        }
        
        let recSubsData = RecurringTransactions(
            recurring_id: refRecSubs!.documentID,
            user_id: self.getUserId(),
            description: description,
            recurring_type: "subscription",
            total_amount: total_amount,
            billing_type: final_billing_type,
            start_billing_date: start_billing_date,
            end_billing_date: end_billing_date,
            tenor: tenor,
            interest: 0
        )
        
        let transRecSubsData = Transactions(
            transaction_id: refTransRecSubs!.documentID,
            user_id: self.getUserId(),
            category: category,
            income_flag: false,
            transaction_date: start_billing_date,
            description: description,
            recurring_flag: true,
            amount: total_amount
        )
        
        let detailRecSubsCurrData = TransactionDetails(
            transaction_detail_id: refDetailRecSubsCurr!.documentID,
            transaction_id: refTransRecSubs!.documentID,
            user_id: self.getUserId(),
            recurring_id: refRecSubs!.documentID,
            billing_date: start_billing_date,
            number_of_recurring: 1,
            amount: total_amount,
            amount_paid: 0,
            amount_havent_paid: 0
        )
        
        do {
            try database.collection("recurringTransactions").document(refRecSubs!.documentID).setData(from: recSubsData)
        } catch {
            print("Error setting recurring data to recurringTransactions firestore \(error)")
        }
        
        do {
            try database.collection("transactions").document(refTransRecSubs!.documentID).setData(from: transRecSubsData)
        } catch {
            print("Error setting transaction data to transactions firestore \(error)")
        }
        
        do {
            try database.collection("transactionDetails").document(refDetailRecSubsCurr!.documentID).setData(from: detailRecSubsCurrData)
        } catch {
            print("Error setting curr transaction data to transactionDetail firestore \(error)")
        }
        
        if(tenor > 1) {
            var refDetailRecSubsNext: DocumentReference? = nil
            refDetailRecSubsNext = database.collection("transactionDetails").addDocument(data: ["temp": "temp"]){
                err in
                if let err = err {
                    print("Error adding next detail transaction data \(err)")
                } else {
                    print("Document added with ID to transactionDetails: \(refDetailRecSubsNext!.documentID)")
                }
            }
            
            let detailRecSubsNextData = TransactionDetails(
                transaction_detail_id: refDetailRecSubsNext!.documentID,
                transaction_id: "a",
                user_id: self.getUserId(),
                recurring_id: refRecSubs!.documentID,
                billing_date: next_billing_date,
                number_of_recurring: 2,
                amount: total_amount,
                amount_paid: 0,
                amount_havent_paid: 0
            )
            
            do {
                try database.collection("transactionDetails").document(refDetailRecSubsNext!.documentID).setData(from: detailRecSubsNextData)
            } catch {
                print("Error setting next transaction data to transactionDetail firestore \(error)")
            }
        }
		
		self.onOpenHomePage?()
    }
	
    func addRecurringInstData(total_amount: Float, billing_type: String, start_billing_date: Date, tenor: Int, category: String, description: String, interest: Float) {
        
        var final_billing_type: String?
        var next_billing_date: Date?
        var end_billing_date: Date?
        var total_amount_interest: Float?
        var amount_per_billing: Float?
        var interest_percentage: Float?
        
        var dateComponent = DateComponents()
        var dateComponentEnd = DateComponents()
        
        var refRecInstl: DocumentReference? = nil
        refRecInstl = database.collection("recurringTransactions").addDocument(data: ["temp":"temp"]){
            err in
            if let err = err {
                print("Error adding recurring installment transaction data \(err)")
            } else {
                print("Document added with ID to recurringTransactions: \(refRecInstl!.documentID)")
            }
        }
        
        var refTransRecInstl: DocumentReference? = nil
        refTransRecInstl = database.collection("transactions").addDocument(data: ["temp":"temp"]){
            err in
            if let err = err {
                print("Error adding transaction data \(err)")
            } else {
                print("Document added with ID to transactions: \(refTransRecInstl!.documentID)")
            }
        }
        
        var refDetailRecInstlCurr: DocumentReference? = nil
        refDetailRecInstlCurr = database.collection("transactionDetails").addDocument(data: ["temp":"temp"]){
            err in
            if let err = err {
                print("Error adding curr detail transaction data \(err)")
            } else {
                print("Document added with ID to transactionDetails: \(refDetailRecInstlCurr!.documentID)")
            }
        }
        
        if(billing_type == "Weekly"){
            final_billing_type = "weekly"
            dateComponent.weekOfYear = 1
            dateComponentEnd.weekOfYear = tenor-1
            
        } else if(billing_type == "Monthly"){
            final_billing_type = "monthly"
			
			if calendarHelper.dayOfDate(date: start_billing_date) > 28 {
				dateComponent.day = 30
				dateComponentEnd.day = (tenor-1)*30
			} else {
				dateComponent.month = 1
				dateComponentEnd.month = tenor-1
			}
            
        } else if(billing_type == "Yearly"){
            final_billing_type = "yearly"
            dateComponent.year = 1
            dateComponentEnd.year = tenor-1
        }
        
        if(tenor == 1){
            end_billing_date = start_billing_date
        }
        else {
            next_billing_date = Calendar.current.date(byAdding: dateComponent, to: start_billing_date)
            end_billing_date = Calendar.current.date(byAdding: dateComponentEnd, to: start_billing_date)
        }
        
        interest_percentage = interest / 100
        total_amount_interest = total_amount + (total_amount * interest_percentage!)
        amount_per_billing = total_amount_interest! / Float(tenor)
        
        print("interest: \(interest_percentage), total: \(total_amount_interest), per billing: \(amount_per_billing), endbill: \(end_billing_date), finalbiltype: \(final_billing_type)")
        
        let recInstlData = RecurringTransactions(
            recurring_id: refRecInstl!.documentID,
            user_id: self.getUserId(),
            description: description,
            recurring_type: "installment",
            total_amount: total_amount_interest,
            billing_type: final_billing_type,
            start_billing_date: start_billing_date,
            end_billing_date: end_billing_date,
            tenor: tenor,
            interest: interest
        )
        
        let transRecInstlData = Transactions(
            transaction_id: refTransRecInstl!.documentID,
            user_id: self.getUserId(),
            category: category,
            income_flag: false,
            transaction_date: start_billing_date,
            description: description,
            recurring_flag: true,
            amount: amount_per_billing
        )
        
        let detailRecInstlCurrData = TransactionDetails(
            transaction_detail_id: refDetailRecInstlCurr!.documentID,
            transaction_id: refTransRecInstl!.documentID,
            user_id: self.getUserId(),
            recurring_id: refRecInstl!.documentID,
            billing_date: start_billing_date,
            number_of_recurring: 1,
            amount: amount_per_billing,
            amount_paid: amount_per_billing,
            amount_havent_paid: total_amount_interest! - amount_per_billing!
        )
        
        do {
            try database.collection("recurringTransactions").document(refRecInstl!.documentID).setData(from: recInstlData)
        } catch {
            print("Error setting installment data to recurringTransactions firestore \(error)")
        }
        
        do {
            try database.collection("transactions").document(refTransRecInstl!.documentID).setData(from: transRecInstlData)
        } catch {
            print("Error setting transaction data to transactions firestore \(error)")
        }
        
        do {
            try database.collection("transactionDetails").document(refDetailRecInstlCurr!.documentID).setData(from: detailRecInstlCurrData)
        } catch {
            print("Error setting curr transaction data to transactionDetail firestore \(error)")
        }
        
        if(tenor > 1){
            var refDetailRecInstlNext: DocumentReference? = nil
            refDetailRecInstlNext = database.collection("transactionDetails").addDocument(data: ["temp":"temp"]){
                err in
                if let err = err {
                    print("Error adding next detail transaction data \(err)")
                } else {
                    print("Document added with ID to transactionDetails: \(refDetailRecInstlNext!.documentID)")
                }
            }
            
            let detailRecInstlNextData = TransactionDetails(
                transaction_detail_id: refDetailRecInstlNext!.documentID,
                transaction_id: "a",
                user_id: self.getUserId(),
                recurring_id: refRecInstl!.documentID,
                billing_date: next_billing_date,
                number_of_recurring: 2,
                amount: amount_per_billing,
                amount_paid: amount_per_billing! + amount_per_billing!,
                amount_havent_paid: total_amount_interest! - (amount_per_billing! + amount_per_billing!)
            )
            
            do {
                try database.collection("transactionDetails").document(refDetailRecInstlNext!.documentID).setData(from: detailRecInstlNextData)
            } catch {
                print("Error setting next transaction data to transactionDetail firestore \(error)")
            }
        }
        
        self.onOpenHomePage?()
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
    
    
	//DELETE
	
	func deleteTransactionData(transactionDelete: Transactions) {
        
        print("deleted data: \(transactionDelete)")
        
        if(transactionDelete.recurring_flag == false) {
            print("delete data sekali")
            
            database.collection("transactions").document(transactionDelete.transaction_id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed")
                }
            }
        }
        else {
            print("delete data recurring")
            
            guard let detailTrans = self.detailTrans.value,
                  let detailTransData = detailTrans.first(where: { $0.transaction_id == transactionDelete.transaction_id }),
                  let recurringId = detailTransData.recurring_id else {
                print("detailTrans data unfetched")
                return
            }
            
            print("recurring id to be deleted: \(recurringId)")
            
            database.collection("transactionDetails").whereField("recurring_id", isEqualTo: recurringId).addSnapshotListener { (documentSnapshot, errorMsg) in
                if let errorMsg = errorMsg {
                    print("Error getting detail trans data with rec id \(recurringId) with error \(errorMsg)")
                }
                else {
                    for document in documentSnapshot!.documents {
                        do {
                            guard let detTrans = try document.data(as: TransactionDetails.self) else {
                                print("fail to fetch detail trans data")
                                return
                            }
                            print("transaction_id to delete: \(detTrans.transaction_id), detail_trans_id to delete: \(detTrans.transaction_detail_id)")
                            
                            if(detTrans.transaction_id != "a") {
                                self.database.collection("transactions").document(detTrans.transaction_id!).delete() { err in
                                    if let err = err {
                                        print("Error removing from transactions: \(err)")
                                    } else {
                                        print("Document \(detTrans.transaction_id ?? "NOT FOUND") successfully removed from transactions")
                                    }
                                }
                            }
                            
                            self.database.collection("transactionDetails").document(detTrans.transaction_detail_id).delete() { err in
                                if let err = err {
                                    print("Error removing from transactionDetails: \(err)")
                                } else {
                                    print("Document \(detTrans.transaction_detail_id) successfully removed from transactionDetails")
                                }
                            }
                            
                        } catch {
                            print("error")
                        }
                    }
                }
            }
            
            database.collection("recurringTransactions").document(recurringId).delete() { err in
                if let err = err {
                    print("Error removing from recurringTransaction: \(err)")
                } else {
                    print("Document \(recurringId) successfully removed from recurringTransactions")
                }
            }
        }
	}
	
	//EXTRAS
	
	func calculateIncomePerMonth(date: Date) -> Float {
		guard let transactionsData = self.transactionsData.value else {
			return 0
		}
		
		var incomeTotal: Float = 0
		
		for transData in transactionsData {
			if let transDate = transData.transaction_date,
			   calendarHelper.monthString(date: date) == calendarHelper.monthString(date: transDate),
			   calendarHelper.yearInt(date: date) == calendarHelper.yearInt(date: transDate),
			   let incomeFlag = transData.income_flag, incomeFlag == true,
			   let amount = transData.amount {
				incomeTotal += amount
			}
			
		}
		self.incomePerMonth.accept(incomeTotal)
		return incomeTotal
	}
	
	
	func calculateIncomePerDay(date: Date) -> Float{
		guard let transactionsDict = self.dictTransactionData.value else {
			return 0
		}
		
		var incomeTotal: Float = 0
		
		for transDict in transactionsDict {
			if let transactionsData = transDict.transaction,
			   let dateComponents = transDict.date,
			   let formattedDateComponent = Calendar.current.date(from: dateComponents),
			   calendarHelper.formatFullDate(date: date) == calendarHelper.formatFullDate(date: formattedDateComponent)  {
				for transData in transactionsData {
					if let incomeFlag = transData.income_flag, incomeFlag == true,
					   let amount = transData.amount,
					   let transDataDate = transData.transaction_date,
					   calendarHelper.formatDayDate(date: transDataDate) == calendarHelper.formatDayDate(date: date) {
						
						incomeTotal += amount
					}
					
				}
			}
			
		}
		
		return incomeTotal
	}
	
	func calculateExpensePerMonth(date: Date) -> Float{
		guard let transactionsData = self.transactionsData.value else {
			return 0
		}
		
		var expenseTotal: Float = 0
		
		for transData in transactionsData {
			if let transDate = transData.transaction_date,
			   calendarHelper.monthString(date: date) == calendarHelper.monthString(date: transDate),
			   let incomeFlag = transData.income_flag, incomeFlag == false,
			   let amount = transData.amount {
				expenseTotal += amount
			}
			
		}
		self.expensePerMonth.accept(expenseTotal)
		
		return expenseTotal
	}
	
	func calculateExpensePerDay(date: Date) -> Float{
		guard let transactionsDict = self.dictTransactionData.value  else {
			return 0
		}
		
		var expenseTotal: Float = 0
		for transDict in transactionsDict {
			if let transactionsData = transDict.transaction,
			   let dateComponents = transDict.date,
			   let formattedDateComponent = Calendar.current.date(from: dateComponents),
			   calendarHelper.formatFullDate(date: date) == calendarHelper.formatFullDate(date: formattedDateComponent)  {
				for transData in transactionsData {
					if let incomeFlag = transData.income_flag, incomeFlag == false,
					   let amount = transData.amount,
					   let transDataDate = transData.transaction_date,
					   calendarHelper.formatDayDate(date: transDataDate) == calendarHelper.formatDayDate(date: date) {
						expenseTotal += amount
					}
					
				}
			}
			
		}
		return expenseTotal
	}
	
	func calculateTotalPerMonth(date: Date) -> Float{
		let total = self.calculateIncomePerMonth(date: date) - self.calculateExpensePerMonth(date: date)
		return total
	}
}
