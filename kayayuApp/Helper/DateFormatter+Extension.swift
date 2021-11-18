//
//  DateFormatter+Extension.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 18/11/21.
//

import Foundation

extension DateFormatter {
	static let monthFormatter: DateFormatter = {
		let dateFormtter = DateFormatter()
		dateFormtter.dateFormat = "MM"

		return dateFormtter
	}()

	static let shortMonthFormatter: DateFormatter = {
		let dateFormtter = DateFormatter()
		dateFormtter.dateFormat = "MMM"

		return dateFormtter
	}()

	static let shortYearFormatter: DateFormatter = {
		let dateFormtter = DateFormatter()
		dateFormtter.dateFormat = "yy"

		return dateFormtter
	}()

	static let fullDateFormatter: DateFormatter = {
		var formatter = DateFormatter()
		formatter.dateFormat = "y-MM-dd"

		return formatter
	}()
}
