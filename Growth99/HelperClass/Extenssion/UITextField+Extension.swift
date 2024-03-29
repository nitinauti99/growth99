//
//  UITextField+Extension.swift
//  Growth99
//
//  Created by admin on 26/11/22.
//

import Foundation
import UIKit

extension CustomTextField {
    
    func setOnTextChangeListener(onTextChanged :@escaping () -> Void){
        if #available(iOS 14.0, *) {
            self.addAction(UIAction() { action in
                
            }, for: .editingChanged)
        } else {
            // Fallback on earlier versions
        }
    }

    func addInputViewDatePicker(target: Any, selector: Selector, mode: UIDatePicker.Mode) {
        let screenWidth = UIScreen.main.bounds.width
        //Add DatePicker as inputView
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        self.inputView = datePicker
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    func addInputViewDatePickerCalender(target: Any, selector: Selector, mode: UIDatePicker.Mode) {
        let screenWidth = UIScreen.main.bounds.width
        //Add DatePicker as inputView
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.minuteInterval = 30
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        self.inputView = datePicker
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        self.inputAccessoryView = toolBar
    }

    @objc func cancelPressed() {
        self.resignFirstResponder()
    }

    func addInputPicker() {
        let screenWidth = UIScreen.main.bounds.width
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        toolBar.setItems([cancelBarButton, flexibleSpace], animated: false)
        self.inputAccessoryView = toolBar
    }

    func pickerTextFieldStyle() {
        self.borderStyle = .bezel
        self.backgroundColor = .white
        self.textColor = .black
        self.tintColor = .clear
    }
}
