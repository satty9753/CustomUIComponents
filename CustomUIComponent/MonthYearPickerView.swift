//
//  MonthYearPicker.swift
//
//  Created by Ben Dodson on 15/04/2015.
//  Modified by Jiayang Miao on 24/10/2016 to support Swift 3
//  Modified by David Luque on 24/01/2018 to get default date
//

import UIKit

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var months: [Int]!
    var years: [Int]!
    var date = Date()
    
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month-1, inComponent: Component.month.rawValue, animated: false)
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.firstIndex(of: year)!, inComponent: Component.year.rawValue, animated: true)
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            let year = Calendar.current.component(.year, from: NSDate() as Date)
            for i in (2000...year).reversed() {
                years.append(i)
//                year += 1
            }
        }
        self.years = years
        
        // population months with localized names
//        var months: [String] = []
//        var month = 0
//        for _ in 1...12 {
//            months.append(DateFormatter().monthSymbols[month].capitalized)
//            month += 1
//        }
        self.months = self.generateMonth(year: year)
        
        self.delegate = self
        self.dataSource = self
        
        let currentMonth = Calendar.current.component(.month, from: Date() as Date)
        self.selectRow(currentMonth - 1, inComponent: Component.month.rawValue, animated: false)
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        
//        self.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let dateComponent = Component(rawValue: component) ?? Component(rawValue: 0)
        
        switch dateComponent {
        case .month:
            return NSAttributedString(string: "\(months[row])月", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .semibold)])
        case .year:
            return NSAttributedString(string: "\(years[row])年", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .semibold)])
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let dateComponent = Component(rawValue: component) ?? Component(rawValue: 0)
        
        switch dateComponent {
        case .month:
            return months.count
        case .year:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: Component.month.rawValue)+1
        let year = years[self.selectedRow(inComponent:  Component.year.rawValue)]
        
        self.month = month
        self.year = year
        
        
        if let block = onDateSelected {
            block(month, year)
        }
        
        if component == Component.year.rawValue{
            self.months = self.generateMonth(year: year)
            if self.months.count < 12{
                self.month = self.months.count
            }
            self.reloadComponent(Component.month.rawValue)
        }
        
        let dateComponents = DateComponents(year: self.year, month: self.month)
        self.date = dateComponents.date ?? Date()
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
    
}
