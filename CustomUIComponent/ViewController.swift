//
//  ViewController.swift
//  CustomUIComponent
//
//  Created by michelle on 2020/9/10.
//  Copyright © 2020 michelle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    let myView = UIView()
    
//    var datePicker: CEODatePicker!
    
    @IBOutlet weak var datePicker: CEODatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let currentDay = Calendar.current.component(.day, from: Date())
        datePicker.selectRow(100, inComponent: 2, animated: false)
       
    }
}

