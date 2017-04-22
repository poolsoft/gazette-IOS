//
//  DateUtil.swift
//  app
//
//  Created by alireza ghias on 7/4/16.
//  Copyright © 2016 iccima. All rights reserved.
//

import Foundation
@objc class DateUtil: NSObject {
	static var sdfTime: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		return formatter
	}
	
	static let weeks: [String] = [
		"یکشنبه", "دوشنبه", "سه شنبه",
		"چهار شنبه", "پنجشنبه", "جمعه", "شنبه"
	]
	static let months: [String] = [
		"فروردین", "اردیبهشت", "خرداد",
		"تیر", "مرداد", "شهریور",
		"مهر", "آبان", "آذر",
		"دی", "بهمن", "اسفند"
	]
	static var monthMap: [String: Int] {
		var tmp = [String: Int]()
		var c = 0
		for m in months {
			tmp[m] = c + 1
			c += 1
		}
		return tmp
	}
	
	
	/**
	* it will convert a persian date string to NSDate
	*
	* @return NSDate of persian date string
	*/
	static func toDate(_ persianYear: Int, persianMonth: Int, persianDay: Int) -> Date? {
		let calendar = Calendar(identifier: Calendar.Identifier.persian)
		
		var components = DateComponents()
		components.year = persianYear
		components.month = persianMonth
		components.day = persianDay
		return calendar.date(from: components)
	}
	
	
	
	static func toPersianDayOfWeek(_ date: Date) -> String {
		let calendar = Calendar(identifier: Calendar.Identifier.persian)
		return weeks[((calendar as NSCalendar?)?.component(NSCalendar.Unit.weekday, from: date))! - 1]
		
	}
	
	/**
	* convert a new NSDate() to a persian date String
	*
	* @return converted new Date() as a persian date String
	*/
	static func toPersian() -> String {
		return toPersian(Date());
	}
	
	/**
	* convert a java.util.date to a persian date String
	*
	* @param date a java.util.date which we want to convert as a persian date string
	* @return converted date as a persian date String
	*/
	static func toPersian(_ date: Date) -> String {
		let calendar = Calendar(identifier: Calendar.Identifier.persian)
		let day = (calendar as NSCalendar?)?.component(NSCalendar.Unit.day, from: date)
		let month = (calendar as NSCalendar?)?.component(.month, from: date)
		let year = (calendar as NSCalendar?)?.component(.year, from: date)
		let time = sdfTime.string(from: date)
		let m = months[month! - 1]
		return String(day!) + " " + m + " " + String(year!) + "-" + time
	}
	
	static func toPersianOnlyDateLong(_ date: Date) -> String {
		let calendar = Calendar(identifier: Calendar.Identifier.persian)
		let day = (calendar as NSCalendar?)?.component(NSCalendar.Unit.day, from: date)
		let month = (calendar as NSCalendar?)?.component(.month, from: date)
		let year = (calendar as NSCalendar?)?.component(.year, from: date)
		let m = months[month! - 1]
		return String(day!) + " " + m + " " + String(year!)
	}
	
	static func toPersianOnlyDate(_ date: Date) -> String {
		let calendar = Calendar(identifier: Calendar.Identifier.persian)
		let day = (calendar as NSCalendar?)?.component(NSCalendar.Unit.day, from: date)
		let month = (calendar as NSCalendar?)?.component(.month, from: date)
		let year = (calendar as NSCalendar?)?.component(.year, from: date)
		let m = month!
		return String(year!) + "/" + String(m) + "/" + String(day!);
	}
	
	
	static func toPersianMonthAndDate(_ date: Date) -> String {
		let calendar = Calendar(identifier: Calendar.Identifier.persian)
		let day = (calendar as NSCalendar?)?.component(NSCalendar.Unit.day, from: date)
		let month = (calendar as NSCalendar?)?.component(.month, from: date)
		let m = months[month! - 1]
		return String(day!) + " " + m;
	}
	
	static func toPersianDay(_ date: Date) -> String {
		let calendar = Calendar(identifier: Calendar.Identifier.persian)
		let day = (calendar as NSCalendar?)?.component(NSCalendar.Unit.day, from: date)
		return String(day!);
	}
	
	static func toTimeOnly(_ date: Date) -> String {
		return sdfTime.string(from: date);
	}
	
	static func toPersianYearMonthDate(_ value: Double) -> (Int, Int, Int)? {
		return toPersianYearMonthDate(Date(timeIntervalSince1970: value/1000.0))
	}
	static func toPersianYearMonthDate(_ date: Date) -> (Int, Int, Int)? {
		let calendar = Calendar(identifier: Calendar.Identifier.persian)
		let year = (calendar as NSCalendar?)?.component(.year, from: date)
		let month = (calendar as NSCalendar?)?.component(.month, from: date)
		let day = (calendar as NSCalendar?)?.component(.day, from: date)
		return (year!, month!, day!)
	}
	static func militaryTimeConversion(_ time: Int) -> String {
		let hour = time / 100;
		let minute = time % 100;
		return String(hour) + ":" + (minute > 9 ? String(minute): "0" + String(minute));
	}
	
	static func militaryTimeConversion(_ time: String) -> (Int?, Int?)? {
		if time.contains(":") {
			let data = time.characters.split(separator: ":").map(String.init)
			return (Int(data[0]), Int(data[1]))
		}
		return nil
	}
	
	static func militaryTimeFromDate(_ date: Date) -> Int {
		let calendar = Calendar(identifier: Calendar.Identifier.persian)
		let unitFlags: NSCalendar.Unit = [.hour, .minute]
		let comps = (calendar as NSCalendar).components(unitFlags, from: date)
		return comps.hour! * 100 + comps.minute!
	}
	
	static func relativeDiffFromNowInDetail(_ date: Date) -> String {
		
		
		let now = Date()
		let diffSeconds = (now.timeIntervalSince1970 - date.timeIntervalSince1970);
		let diffMinutes = Int(diffSeconds / (60));
		let diffHours = Int(diffSeconds / (60 * 60));
		let diffDays = Int(diffSeconds / (24 * 60 * 60));
		var relativeTime = "";
		if diffDays > 90 {
			relativeTime = "\u{200f}" + toPersianOnlyDate(date) + " " + toTimeOnly(date) + "\u{200f}";
		} else if diffDays > 6 {
			relativeTime = "\u{200f}" + toPersianMonthAndDate(date) + " " + toTimeOnly(date) + "\u{200f}";
		} else if diffDays > 1 {
			relativeTime = "\u{200f}" + toPersianDayOfWeek(date) + " " + toTimeOnly(date) + "\u{200f}";
		} else if diffDays > 0 {
			relativeTime = "\u{200f}" + "دیروز" + toTimeOnly(date) + "\u{200f}";
		} else if diffHours > 4 {
			let calendar = Calendar.current
			let unitFlags: NSCalendar.Unit = [.day]
			let nowComponents = (calendar as NSCalendar).components(unitFlags, from: now)
			let dateComponents = (calendar as NSCalendar).components(unitFlags, from: date)
			if dateComponents.day != nowComponents.day {
				relativeTime = "\u{200f}" + "دیروز" + toTimeOnly(date) + "\u{200f}";
			} else {
				relativeTime = toTimeOnly(date);
			}
		} else if diffMinutes > 59 {
			relativeTime = "\u{200f}" + String(diffHours) + "ساعت قبل" + "\u{200f}";
		} else if diffMinutes > 4 {
			relativeTime = "\u{200f}" + String(diffMinutes) + "دقیقه قبل" + "\u{200f}";
		} else {
			relativeTime = "چند لحظه پیش";
		}
		return relativeTime;
		
	}
	static func relativeDiffFromNow(_ date: Date) -> String {
		let now = Date()
		let diffSeconds = (now.timeIntervalSince1970 - date.timeIntervalSince1970);
		//        let diffMinutes = diffSeconds / (60);
		//        let diffHours = diffSeconds / (60 * 60);
		let diffDays = Int(diffSeconds / (24 * 60 * 60));
		var relativeTime = "";
		if  diffDays > 90 {
			relativeTime = toPersianOnlyDate(date)
		} else if diffDays > 6 {
			relativeTime = toPersianMonthAndDate(date)
		} else if diffDays > 1 {
			relativeTime = toPersianDayOfWeek(date)
		} else if diffDays > 0 {
			relativeTime = "دیروز";
		} else {
			let calendar = Calendar.current
			let unitFlags: NSCalendar.Unit = [.day]
			let nowComponents = (calendar as NSCalendar).components(unitFlags, from: now)
			let dateComponents = (calendar as NSCalendar).components(unitFlags, from: date)
			if dateComponents.day != nowComponents.day {
				relativeTime = "دیروز"
			} else {
				relativeTime = toTimeOnly(date);
			}
		}
		return relativeTime
	}
	
	static func getJalaliDateRangeForEvent(_ start: Date, end: Date) -> String {
		let calendar = Calendar(identifier: Calendar.Identifier.persian)
		
		var endFormatted = toPersianOnlyDateLong(end)
		let unitFlags: NSCalendar.Unit = [.month, .year]
		let endComponents = (calendar as NSCalendar).components(unitFlags, from: end)
		let currentComponents = (calendar as NSCalendar).components(unitFlags, from: Date())
		
		if endComponents.year == currentComponents.year {
			endFormatted = toPersianMonthAndDate(end)
		}
		
		var startFormatted = toPersianOnlyDateLong(start)
		let startComponents = (calendar as NSCalendar).components(unitFlags, from: start)
		if endComponents.year == startComponents.year {
			if endComponents.month == startComponents.month {
				startFormatted = toPersianDay(start)
			} else {
				startFormatted = toPersianMonthAndDate(start)
			}
		}
		
		if (calendar as NSCalendar).compare(start, to: end, toUnitGranularity: .day) == .orderedSame {
			return endFormatted
		}
		
		return startFormatted + " " + "الی".localized + " " + endFormatted
		
	}
	
	static func getJalaliTimeRangeForEvent(_ start: Int, end: Int) -> String {
		return militaryTimeConversion(start) + " " + "الی".localized + " " + militaryTimeConversion(end)
	}
	
	static func toTransactionStyle(_ date: Date, withYear: Bool = false, withTime: Bool = false) -> String {
		let calendar = Calendar(identifier: Calendar.Identifier.persian)
		let year = (calendar as NSCalendar?)?.component(.year, from: date)
		let month = (calendar as NSCalendar?)?.component(.month, from: date)
		let day = (calendar as NSCalendar?)?.component(.day, from: date)
		return (withYear ? (String(year ?? 0) + "/") : "") + String(format: "%02d", month ?? 0) + "/" + String(format: "%02d", day ?? 0) + (withTime ? " " + sdfTime.string(from: date) : "")
		
	}
}
