//
//  EmployeeList+CoreDataProperties.swift
//  MCEmployDetails
//
//  Created by Appanna Yaragal on 17/04/22.
//
//

import Foundation
import CoreData


extension EmployeeList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeList> {
        return NSFetchRequest<EmployeeList>(entityName: "EmployeeList")
    }

    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var dob: String?
    @NSManaged public var phone_number: String?
    @NSManaged public var marital_status: Bool

}

extension EmployeeList : Identifiable {

}
