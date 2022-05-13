//
//  DateHelpers.swift
//  Softgames Test
//
//  Created by ibrahim beltagy on 13/05/2022.
//

import Foundation

func yearsBetweenDates(startDate: Date, endDate: Date) -> Int? {
    let calendar = NSCalendar.current

    let components = calendar.dateComponents([.year], from: startDate, to: endDate)

    return components.year
}

func getDateFromString(dateStr: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Constants.DateFormats.yearMonthDay
    return dateFormatter.date(from: dateStr) 
}
