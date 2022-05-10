//
//  MCEmployeeModel.swift
//  MCEmployDetails
//
//  Created by Appanna Yaragal on 17/04/22.
//

import Foundation

class MCEmployeeModel {
    var firstName: String?
    var lastName: String?
    var dob: String?
    var phoneNumber: String?
    var maritalStatus: Bool?
    
    init(dictionary: [String: AnyObject]) {
        if let firstName = dictionary["first_name"] as? String {
            self.firstName = firstName
        }
        if let lastName = dictionary["last_name"] as? String {
            self.lastName = lastName
        }
        if let dob = dictionary["dob"] as? String {
            self.dob = dob
        }
        if let phoneNumber = dictionary["phone_number"] as? String {
            self.phoneNumber = phoneNumber
        }
        if let maritalStatus = dictionary["marital_status"] as? Bool {
            self.maritalStatus = maritalStatus
        }
    }
}
