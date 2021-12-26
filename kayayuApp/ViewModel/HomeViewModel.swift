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
	
	
	var userBalanceTotal: Float = 0

	private let disposeBag = DisposeBag()
	
	init() {
		self.getUserData()
		self.getTransactionDataSpecMonth(diff: calendarHelper.monthInt(date: Date()))
//        self.getTransactionDataSpecMonth(diff: 11) //diff masukin month yg mo ditampilin
		self.configureObserver()
        
//        self.addTransactionData(category: "needs", income_flag: false, transaction_date: Date(), description: "makan ketoprak", recurring_flag: false, amount: 28300)
//        self.addRecurringSubsData(total_amount: 400000, billing_type: "Months", start_billing_date: Date(), tenor: 1, category: "wants", description: "hadiah box random")
        
	}
    
	private func configureObserver() {
		
		self.transactionsData.asObservable().subscribe(onNext: { transData in
			self.getDictionaryTransaction()
			self.reloadUI?()
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
    
    func getTransactionDataSpecMonth (diff: Int) {
        database.collection("transactions").whereField("user_id", isEqualTo: getUserId()).whereField("transaction_date", isGreaterThan: calendarHelper.getSpecStartMonth(diff: diff)).whereField("transaction_date", isLessThan: calendarHelper.getSpecEndMonth(diff: diff)).order(by: "transaction_date", descending: true).getDocuments() { (documentSnapshot, errorMsg) in
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
	
    func addRecurringInstData(total_amount: Float, billing_type: String, start_billing_date: Date, tenor: Int, category: String, description: String, interest: Int) {
		//feli pls helpz
		
	}
    
    
//    if(billing_type == "Weekly" || billing_type == "Weeks"){
//        final_billing_type = "weekly"
//    } else if(billing_type == "Monthly" || billing_type == "Months"){
//        final_billing_type = "monthly"
//    } else if(billing_type == "Yearly" || billing_type == "Years"){
//        final_billing_type = "yearly"
//    }
    
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
