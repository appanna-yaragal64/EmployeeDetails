//
//  UIView.swift
//  MCEmployDetails
//
//  Created by Appanna Yaragal on 17/04/22.
//

import UIKit

extension UIView {
    
    func applyRoundCorner(radius : Float, borderWidth : Float, borderColor : UIColor?) {
        self.layer.masksToBounds = true
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor?.cgColor
        self.layer.cornerRadius = CGFloat(radius)
    }
    
    func addShadow() {
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
}

extension Date {
    public func formattedDateString(_ format : String) -> String  {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format //"dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
    
}

extension UITextField {
    func addToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.lightGray
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(UITextField.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        self.endEditing(true)
    }
    
    func cancelPressed() {
        self.endEditing(true)
    }
}
