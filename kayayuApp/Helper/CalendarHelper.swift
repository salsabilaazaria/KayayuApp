//
//  CalendarHelper.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 18/11/21.
//

import Foundation
import UIKit

class CalendarHelper {
	let calendar = Calendar.current
	
	func plusMonth(date: Date) -> Date {
		return calendar.date(byAdding: .month, value: 1, to: date)!
	}
	
	func minusMonth(date: Date) -> Date {
		let calendar = Calendar.current
		return calendar.date(byAdding: .month, value: -1, to: date)!
	}
	
	func dayOfDate(date: Date) -> Int {
		//example: 30 Jan 2021 -> 30
		let component = calendar.dateComponents([.day], from: date)
		return component.day!
	}

	func monthString(date: Date) -> String {
		//example: 30 Jan 2021 -> January
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "LLLL"
		return dateFormatter.string(from: date)
	}
	
	func yearString(date: Date) -> String {
		//example: 30 Jan 2021 -> 2021
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		return dateFormatter.string(from: date)
	}


}
