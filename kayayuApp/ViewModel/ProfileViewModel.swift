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

class ProfileViewModel{
    var reloadUI: (() -> Void)?
    
    let database = Firestore.firestore()
    let calendarHelper = CalendarHelper()
    var user: BehaviorRelay<Users?> = BehaviorRelay<Users?>(value: nil)
    var RecurringData: BehaviorRelay<[RecurringTransactions]?> = BehaviorRelay<[RecurringTransactions]?>(value: nil)
    
    init() {
        self.getUserData()
        self.getRecurringSubsData()
        self.getRecurringInstlData()
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
    
    func getRecurringSubsData () {
        database.collection("reccuringTransactions").whereField("user_id", isEqualTo: getUserId()).whereField("recurring", isEqualTo: "subscription").order(by: "start_billing_date", descending: true).getDocuments() { (documentSnapshot, errorMsg) in
            if let errorMsg = errorMsg {
                print("Error get Subscription Data \(errorMsg)")
            }
            else {
                var count = 0
                var docummentArray: [RecurringTransactions] = []
                for document in documentSnapshot!.documents {
                    count += 1
                    
                    do {
                        guard let trans = try document.data(as: RecurringTransactions.self) else {
                            print("KAYAYU failed get recurring subscription data")
                            return
                        }
                        docummentArray.append(trans)
                        
                    } catch {
                        print(error)
                    }
                    
                    print("\(document.data())")
                    
                }
                self.RecurringData.accept(docummentArray)
            }
        }
    }
    
    func getRecurringInstlData () {
        database.collection("reccuringTransactions").whereField("user_id", isEqualTo: getUserId()).whereField("recurring", isEqualTo: "installment").order(by: "start_billing_date", descending: true).getDocuments() { (documentSnapshot, errorMsg) in
            if let errorMsg = errorMsg {
                print("Error get Installment Data \(errorMsg)")
            }
            else {
                var count = 0
                var docummentArray: [RecurringTransactions] = []
                for document in documentSnapshot!.documents {
                    count += 1
                    
                    do {
                        guard let trans = try document.data(as: RecurringTransactions.self) else {
                            print("KAYAYU failed get recurring installment data")
                            return
                        }
                        docummentArray.append(trans)
                        
                    } catch {
                        print(error)
                    }
                    
                    print("\(document.data())")
                    
                }
                self.RecurringData.accept(docummentArray)
            }
        }
    }
}
