//
//  CalendarHelper.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 18/11/21.
//

import Foundation
import UIKit

class CalendarHelper {
    let calendar = Calendar(identifier: .gregorian)

   
    func getCurrStartMonth() -> Date {
        
        var components:DateComponents = calendar.dateComponents([.year, .month], from: Date())
        components.hour = 7 //ini harus di +7 soalny current time ambil di greenwich jd kurang 7 jem
        
        print("asd CurrStart: \(calendar.date(from: components)!)")
        return calendar.date(from: components)!
    }
    
    func getCurrEndMonth() -> Date {
        var components:DateComponents = calendar.dateComponents([.year, .month], from: Date())
        components.month! += 1
        components.hour = 6
        components.minute = 59
        components.second = 59
        
        print("asd CurrEnd: \(calendar.date(from: components)!)")
        return calendar.date(from: components)!
    }
    
    
    func getSpecStartMonth(diff: Int) -> Date {
        var components:DateComponents = calendar.dateComponents([.year, .month], from: Date())
        components.month = diff
        components.hour = 7
        
        print("asd SpecStart: \(calendar.date(from: components)!)")
        return calendar.date(from: components as DateComponents)!
    }
    
    
    func getSpecStartMonth(diff: Int) -> Date {
        let components:NSDateComponents = calendar.dateComponents([.year, .month], from: Date()) as NSDateComponents
        components.month = diff
        components.hour = 7
        
//        print("SpecStart: \(calendar.date(from: components as DateComponents)!)")
        return calendar.date(from: components as DateComponents)!
    }
    
    func getSpecEndMonth(diff: Int) -> Date {
        let components:NSDateComponents = calendar.dateComponents([.year, .month], from: Date()) as NSDateComponents
        components.month = diff+1
        components.hour = 6
        components.minute = 59
        components.second = 59
        
//        print("SpecEnd: \(calendar.date(from: components as DateComponents)!)")
        return calendar.date(from: components as DateComponents)!
    }
    
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
	
	func dayString(date: Date) -> String {
		// monday tuesday
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE"
		return dateFormatter.string(from: date)
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
	
	func formatFullDate(date: Date) -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		dateFormatter.calendar = Calendar(identifier: .gregorian)
		
		return dateFormatter.string(from: date)
	}

	func formatDayDate(date: Date) -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "E d"
		dateFormatter.calendar = Calendar(identifier: .gregorian)
		
		return dateFormatter.string(from: date)
	}

}
