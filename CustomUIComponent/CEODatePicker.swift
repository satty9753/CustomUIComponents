//
//  CEODatePicker.swift
//  CustomUIComponent
//
//  Created by michelle on 2020/9/10.
//  Copyright © 2020 michelle. All rights reserved.
//

import UIKit

enum Component:Int{
    case year = 0
    case month
    case day
}

class CEODatePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
        var months: [Int]!
        var years: [Int]!
        var days: [Int]! = [Int](1...31)
        
        var selectedMonth:Int!

        var month = Calendar.current.component(.month, from: Date()) {
            didSet {
                selectRow(month-1, inComponent: 1, animated: false)
            }
        }
        
        var year = Calendar.current.component(.year, from: Date()) {
            didSet {
                selectRow(years.firstIndex(of: year)!, inComponent: Component.year.rawValue, animated: true)
            }
        }
    
        var day = Calendar.current.component(.day, from: Date()){
            didSet {
                selectRow(day-1, inComponent: Component.day.rawValue, animated: false)
            }
        }
    
    
       

        var onDateSelected: ((_ year: Int, _ month: Int, _ day: Int) -> Void)?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.commonSetup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.commonSetup()
        }
        
        func commonSetup() {
            
            self.backgroundColor = .systemGray
            
            // population years
            var years: [Int] = []
            if years.count == 0 {
                let year = Calendar(identifier: Calendar.Identifier.gregorian).component(.year, from: Date())
                for i in (2000...year).reversed() {
                    years.append(i)
                }
            }
            self.years = years
            self.months = generateMonth(year: year)
            
            self.delegate = self
            self.dataSource = self
            
            let currentMonth = Calendar.current.component(.month, from: Date())
            self.selectRow(currentMonth - 1, inComponent: Component.month.rawValue, animated: false)
            
            self.days = self.generateDays(year: year, month: currentMonth)
            let currentDay = Calendar.current.component(.day, from: Date())
//            print(self.days?.count)
            self.selectRow(currentDay-1, inComponent: Component.day.rawValue, animated: false)

            self.layer.cornerRadius = 5.0
            self.clipsToBounds = true
            
            
        }
        
        // Mark: UIPicker Delegate / Data Source
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 3
        }
        
        func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            let dateComponent = Component(rawValue: component) ?? Component(rawValue: 0)
            
            switch dateComponent {
            case .year:
                return NSAttributedString(string: "\(years[row])年", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .semibold)])
            case .month:
                return NSAttributedString(string: "\(months[row])月", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .semibold)])
            case .day:
                if row < days.count{
                     return NSAttributedString(string: "\(days[row])日", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .semibold)])
                }
                return nil
               
            default:
                return nil
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            
            let dateComponent = Component(rawValue: component) ?? Component(rawValue: 0)
            switch dateComponent {
            case .year:
                 return years.count
            case .month:
                return months.count
            case .day:
                return days?.count ?? 31
            default:
                return 0
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            let month = self.selectedRow(inComponent: Component.month.rawValue)+1
            let year = years[self.selectedRow(inComponent: Component.year.rawValue)]
            let day = self.selectedRow(inComponent: Component.day.rawValue)+1

            self.month = month
            self.year = year
            self.day = day
        
            if component == Component.year.rawValue{
                self.months = generateMonth(year: year)
                self.month = self.months.count
                pickerView.reloadComponent(Component.month.rawValue)
            }
            
            if component != Component.day.rawValue {
                let days = generateDays(year: year, month: self.month)
                self.days = days
                self.day = days.count
                pickerView.reloadComponent(Component.day.rawValue)
            }

            self.month = self.selectedRow(inComponent: Component.month.rawValue)+1
            self.day = self.selectedRow(inComponent: Component.day.rawValue)+1
            
            if let block = onDateSelected {
                block(year, month, day)
            }
            

        }

        func generateMonth(year:Int)->[Int]{
            var months = [Int]()
            let calendar = Calendar.current
            
            var month = 12
            
            let date = Date()
            
            let thisYear = calendar.component(.year, from: date)

            if year == thisYear{
                month = calendar.component(.month, from: date)
            }
            months = [Int](1...month)
            return months
        }
    
        func generateDays(year: Int, month: Int)->[Int]{
            
            var days = [Int]()
            
            let dateComponents = DateComponents(year: year, month: month)
            let calendar = Calendar.current
            let currentDate = Date()
            let date = calendar.date(from: dateComponents)!
            
            if calendar.isDate(date, equalTo: currentDate, toGranularity: .month) && calendar.isDate(date, equalTo: currentDate, toGranularity: .year){
                let day = calendar.component(.day, from: currentDate)
                days = [Int](1...day)
            }
            else{
                let range = calendar.range(of: .day, in: .month, for: date)!
                days = [Int]((range.first ?? 0)...(range.last ?? 0))
            }
            
            return days

        }
        
    }

