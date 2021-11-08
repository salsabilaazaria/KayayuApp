//
//  NSAttributedString+Extension.swift
//  KayayuApp
//
//  Created by Salsabila Azaria on 11/8/21.
//

import UIKit

extension NSAttributedString {
	static func bold(_ text: String, _ size: CGFloat, _ color: UIColor) -> NSAttributedString {
		let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size, weight: .bold), .foregroundColor: color]
		let boldString = NSAttributedString(string:text, attributes: attrs)
		
		return boldString
	}
	
	static func semibold(_ text: String, _ size: CGFloat, _ color: UIColor) -> NSAttributedString {
		let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size, weight: .semibold), .foregroundColor: color]
		let boldString = NSAttributedString(string:text, attributes: attrs)
		
		return boldString
	}
	
	
	static func normal(_ text: String, _ size: CGFloat, _ color: UIColor) -> NSAttributedString {
		let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size, weight: .regular), .foregroundColor: color]
		let string = NSAttributedString(string:text, attributes: attrs)
		
		return string
	}
	
	static func subtitle(_ text: String, _ size: CGFloat, _ color: UIColor) -> NSAttributedString {
		let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size, weight: .light), .foregroundColor: color]
		let string = NSAttributedString(string:text, attributes: attrs)
		
		return string
	}
}
