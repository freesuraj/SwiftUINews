//
//  FoundationExtension.swift
//  News
//
//  Created by Suraj Pathak on 23/2/17.
//  Copyright © 2017 Suraj Pathak. All rights reserved.
//

import Foundation

extension String {
    
    func date(fromFormat format: String = "yyyy-MM-dd HH:mm:ss", timezone: TimeZone? = TimeZone(abbreviation: "AEDT")) -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        dateformatter.timeZone = timezone
        guard let date = dateformatter.date(from: self) else { return Date() }
        return date
    }
    
}

extension Date {
    
    func formatted(using format: String = "MMM dd, yyyy hh:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
