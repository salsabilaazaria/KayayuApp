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
    
    let database = Firestore.firestore()
    let calendarHelper = CalendarHelper()
    var user: BehaviorRelay<Users?> = BehaviorRelay<Users?>(value: nil)
    var recurringSubsData: BehaviorRelay<[RecurringTransactions]?> = BehaviorRelay<[RecurringTransactions]?>(value: nil)
    var recurringInstlData: BehaviorRelay<[RecurringTransactions]?> = BehaviorRelay<[RecurringTransactions]?>(value: nil)
    var detailTrans: BehaviorRelay<[TransactionDetail]?> = BehaviorRelay<[TransactionDetail]?>(value: nil)

    init() {
        self.getUserData()
        self.getRecurringSubsData()
        self.getRecurringInstlData()
        self.getTransactionDetailData()
    }
	
	//UNCOMMENT IF DATA STILL NOT SHOW IN UI
//	private func configureObserver() {
//		self.recurringData.asObservable().subscribe(onNext: {
//			self.reloadUI?()
//		})
//	}
	
    
    private func getUserId() -> String{
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
    
    private func getRecurringSubsData () {
        database.collection("recurringTransactions").whereField("user_id", isEqualTo: getUserId()).whereField("recurring_type", isEqualTo: "subscription").order(by: "start_billing_date", descending: true).getDocuments() { (documentSnapshot, errorMsg) in
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
        database.collection("recurringTransactions").whereField("user_id", isEqualTo: getUserId()).whereField("recurring_type", isEqualTo: "installment").order(by: "start_billing_date", descending: true).getDocuments() { (documentSnapshot, errorMsg) in
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

       database.collection("transactionDetails").order(by: "billing_date", descending: true).getDocuments() { (documentSnapshot, errorMsg) in
            if let errorMsg = errorMsg {
                print("Error get Subscription Data \(errorMsg)")
            }
            else {
                
                var documentArray: [TransactionDetail] = []

                for document in documentSnapshot!.documents {

                    do {
                        guard let trans = try document.data(as: TransactionDetail.self) else {
                            print("KAYAYU failed get recurring subscription data")
                            return
                        }
                        documentArray.append(trans)

                    } catch {
                        print("error")
                    }
                }
                print("subs due: \(documentArray)")

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

        print("next subs due: \(nextBillDate)")
        return nextBillDate
    }
    
    func getDueIn(recurringId: String) -> Int {
        
        guard let detailTrans = self.detailTrans.value,
              let data = detailTrans.first(where: { $0.recurring_id == recurringId })
              
               else {
            return -1
        }

        let dueIn = Calendar.current.dateComponents([.day], from: Date(), to: data.billing_date ?? Date()).day!
        
        return dueIn
    }
    
}
