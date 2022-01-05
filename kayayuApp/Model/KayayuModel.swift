//
//  KayayuModel.swift
//  kayayuApp
//
//  Created by angie on 04/12/21.
//

import Foundation

struct Users: Codable {
    var user_id:String = UUID().uuidString
    var username: String?
    var email: String?
    var password: String?
    var balance_total: Float?
    var balance_needs: Float?
    var balance_wants: Float?
    var balance_savings: Float?
}

struct Transactions: Codable {
    var transaction_id:String = UUID().uuidString
    var user_id: String?
    var category: String?
    var income_flag: Bool?
    var transaction_date: Date?
    var description: String?
    var recurring_flag: Bool?
    var amount: Float?
}

struct TransactionDateDictionary {
	var date: DateComponents?
	var transaction: [Transactions]?
}

struct RecurringTransactions: Codable {
    var recurring_id:String = UUID().uuidString
    var user_id:String?
    var description: String?
    var recurring_type:String?
    var total_amount: Float?
    var billing_type: String?
    var start_billing_date: Date?
    var end_billing_date: Date?
    var tenor: Int?
    var interest: Float?
}

struct TransactionDetail: Codable {
    var transaction_detail_id:String = UUID().uuidString
    var transaction_id:String?
    var user_id:String?
    var recurring_id: String?
    var billing_date: Date?
    var number_of_recurring: Int?
    var amount: Float?
    var amount_paid: Float?
    var amount_havent_paid: Float?
}
