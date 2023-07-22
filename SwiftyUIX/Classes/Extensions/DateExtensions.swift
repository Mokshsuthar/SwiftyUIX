//
//  DateExtensions.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 22/07/23.
//

import Foundation
public extension Date {
    
    
    
    
    // This function, getReadableTime(), takes a Date object as input and returns a formatted time string in a 12-hour format with AM/PM indicator.
    // The function first extracts the hour and minute components from the provided Date using the current calendar.
    // It then calculates the hour in a 12-hour format and ensures that it always has two digits with leading zeros if needed.
    // The minute is also formatted to have two digits with leading zeros if necessary.
    // The AM/PM indicator is determined based on whether the hour is greater than or equal to 12 (PM) or less than 12 (AM).
    // The formatted hour, minute, and AM/PM indicator are then combined to form the final readable time string.
    // Example output: "03:30 PM" or "11:45 AM".
    func getReadableTime() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)

        let formattedHour = String(format: "%02d", hour % 12 == 0 ? 12 : hour % 12)
        let formattedMinute = String(format: "%02d", minute)
        let amPm = hour >= 12 ? "PM" : "AM"

        return "\(formattedHour):\(formattedMinute) \(amPm)"
    }
    
    
    // The function getReadableDate() takes a Date object as input and returns a formatted date string in a human-readable format.
    // It extracts the day, month, and year components from the provided Date using the current calendar.
    // The day and month are formatted to ensure they always have two digits with leading zeros if necessary.
    // The year is represented in four digits.
    // The formatted day, month, and year are then combined to form the final readable date string in the format "MM/DD/YYYY".
    // Example output: "07/22/2023" or "01/05/2024".
    
    func getReadableDate() -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)

        let formattedDay = String(format: "%02d", day)
        let formattedMonth = String(format: "%02d", month)
        let formattedYear = String(format: "%04d", year)

        return "\(formattedMonth)/\(formattedDay)/\(formattedYear)"
    }
    
    // The function getReadableDateTime() returns a formatted date and time string in a human-readable format.
    // It uses the current calendar to extract the individual components: day, month, year, hour, and minute from the provided Date.
    // Each component is formatted to ensure it always has two digits with leading zeros if necessary.
    // The hour is formatted in a 12-hour format, and the AM/PM indicator is determined based on whether the hour is greater than or equal to 12 (PM) or less than 12 (AM).
    // The formatted day, month, year, hour, minute, and AM/PM indicator are then combined to form the final readable date and time string.
    // Example output: "07/22/2023 03:30 PM" or "01/05/2024 11:45 AM".
    func getReadableDateTime() -> String {
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)


        let formattedDay = String(format: "%02d", day)
        let formattedMonth = String(format: "%02d", month)
        let formattedYear = String(format: "%04d", year)
        let formattedHour = String(format: "%02d", hour % 12 == 0 ? 12 : hour % 12)
        let formattedMinute = String(format: "%02d", minute)
        let amPm = hour >= 12 ? "PM" : "AM"

        return "\(formattedMonth)/\(formattedDay)/\(formattedYear) \(formattedHour):\(formattedMinute) \(amPm)"
    }
    
    //provide a unique timestamp according on given time
    func TimeStemp(format: String = "yyyyMMdd'T'HHmmssSSS") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    //get month name from date like January, Fabruary ...
    func getMonthName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    //get month name from date like Jan, Fab ...
    func getShortMonthName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: self)
    }
    
    //get day name from date like Sunday,Monday....
    func getDayName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    //get day short name from date like Sun,Mon ....
    func getShortDayName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    // Returns the value of a specific component from a given Date object using the provided Calendar (defaults to the current calendar).
    // The function takes a Calendar.Component enum as input, representing the desired component (e.g., day, month, year, hour, minute, etc.).
    // Optionally, you can pass a specific Calendar instance as the second parameter. If not provided, it defaults to Calendar.current.
    // Example usage: let day = getDateComponent(.day)
    // Example output: Returns the day value from the given Date object.
    func getDateComponent(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
