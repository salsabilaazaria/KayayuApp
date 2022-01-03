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
	
	let database = Firestore.firestore()
    private let calendarHelper = CalendarHelper()
	
	var user: BehaviorRelay<Users?> = BehaviorRelay<Users?>(value: nil)
	var transactionsData: BehaviorRelay<[Transactions]?> = BehaviorRelay<[Transactions]?>(value: nil)
	var dictTransactionData: BehaviorRelay<[TransactionDateDictionary]?> = BehaviorRelay<[TransactionDateDictionary]?>(value: nil)
	
	var incomePerMonth: BehaviorRelay<Float?> = BehaviorRelay<Float?>(value: nil)
	var expensePerMonth: BehaviorRelay<Float?> = BehaviorRelay<Float?>(value: nil)
	
	var balanceTotal: BehaviorRelay<Float?> = BehaviorRelay<Float?>(value: nil)
	
	
	var userBalanceTotal: Float = 0

	private let disposeBag = DisposeBag()
	
	init() {
		
		let currStartDate = calendarHelper.getSpecStartMonth(month: calendarHelper.monthInt(date: Date()), year: calendarHelper.yearInt(date: Date()))
		let currEndDate = calendarHelper.getSpecEndMonth(month: calendarHelper.monthInt(date: Date()), year: calendarHelper.yearInt(date: Date()))
		
		self.getUserData()
		self.getTransactionDataSpecMonth(startDate: currStartDate, endDate: currEndDate)
		self.configureObserver()
		self.getBalanceTotal()
        
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
		let balanceTotalData = [ "balance_total": balanceTotal]
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
					for document in documentSnapshot!.documents {
						
						do {
							guard let trans = try document.data(as: Transactions.self) else {
								print("KAYAYU failed get transactionData")
								return
							}
							
							if trans.income_flag == true {
								incomeTotal += trans.amount ?? 0
							} else {
								expenseTotal += trans.amount ?? 0
							}
							
							
						} catch {
							print(error)
						}
						
					}
					let balanceTotal = incomeTotal - expenseTotal
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
        
        let detailRecSubsCurrData = TransactionDetail(
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
            
            let detailRecSubsNextData = TransactionDetail(
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
            dateComponent.month = 1
            dateComponentEnd.month = tenor-1
            
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
        
        let detailRecInstlCurrData = TransactionDetail(
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
            
            let detailRecInstlNextData = TransactionDetail(
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
    
    
	//DELETE
	
	func deleteTransactionData(transactionDelete: Transactions) {
		guard var tempTransactionData = self.transactionsData.value,
			  let indexDelete = tempTransactionData.firstIndex(where: { data in
				return data.transaction_id == transactionDelete.transaction_id
			  }) else {
			return
		}
		
		tempTransactionData.remove(at: indexDelete)
		
		self.transactionsData.accept(tempTransactionData)
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
