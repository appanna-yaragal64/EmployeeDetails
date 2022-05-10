//
//  MCEmployeeAddEditViewController.swift
//  MCEmployDetails
//
//  Created by Appanna Yaragal on 17/04/22.
//

import UIKit
import CoreData

class MCEmployeeAddEditViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var maritalStatusSwitchButton: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    var maritalStatus: Bool = false
    var isFromEdit: Bool = false
    var employeeDetail : EmployeeList?
    
    //MARK: - Application Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        saveButton.applyRoundCorner(radius: 5.0, borderWidth: 1.0, borderColor: .gray)
        firstNameTextField.applyRoundCorner(radius: 5.0, borderWidth: 0.5, borderColor: .gray)
        lastNameTextField.applyRoundCorner(radius: 5.0, borderWidth: 0.5, borderColor: .gray)
        dobTextField.applyRoundCorner(radius: 5.0, borderWidth: 0.5, borderColor: .gray)
        phoneNumberTextField.applyRoundCorner(radius: 5.0, borderWidth: 0.5, borderColor: .gray)
        
        if isFromEdit == true {
            updateDetails()
            title = "Update Employee Details"
        } else {
            title = "Add New Employee"
        }
    }
    
    func updateDetails() {
        firstNameTextField.text = employeeDetail?.first_name
        lastNameTextField.text = employeeDetail?.last_name
        dobTextField.text = employeeDetail?.dob
        phoneNumberTextField.text = employeeDetail?.phone_number
        if let maritallStatus = employeeDetail?.marital_status {
            maritalStatusSwitchButton.isOn = maritallStatus
            maritalStatus = maritallStatus
        }
    }

    //Save Employee Details
    func saveEmployeeDetails() {
        let context : NSManagedObjectContext = AppDelegate.sharedInstance.managedObjectContext!
        let fetchRequest = NSFetchRequest<EmployeeList>(entityName: "EmployeeList")
        
        do {
            let _ = try context.fetch(fetchRequest)
            var employeeList : EmployeeList? = nil
            
            employeeList = NSEntityDescription.insertNewObject(forEntityName: "EmployeeList", into: context) as? EmployeeList
            employeeList?.first_name = firstNameTextField.text
            employeeList?.last_name = lastNameTextField.text
            employeeList?.dob = dobTextField.text
            employeeList?.phone_number = phoneNumberTextField.text
            employeeList?.marital_status = maritalStatus
            
            try AppDelegate.sharedInstance.managedObjectContext!.save()
            
            self.showAlert("Success", "Employee Details Saved!")
            self.view.endEditing(true)
        } catch {
            print("Failed to save data request.")
        }
    }
    
    //Update Employee Details
    func updateEmployeeDetails() {
        let context : NSManagedObjectContext = AppDelegate.sharedInstance.managedObjectContext!
        let fetchRequest = NSFetchRequest<EmployeeList>(entityName: "EmployeeList")
        do {
            let _ = try context.fetch(fetchRequest)
            let employeeList = employeeDetail
            
            employeeList?.setValue(firstNameTextField.text, forKey: "first_name")
            employeeList?.setValue(lastNameTextField.text, forKey: "last_name")
            employeeList?.setValue(dobTextField.text, forKey: "dob")
            employeeList?.setValue(phoneNumberTextField.text, forKey: "phone_number")
            employeeList?.setValue(maritalStatus, forKey: "marital_status")
            
            try context.save()
            self.showAlert("Success", "Employee Details Updated!")
            self.view.endEditing(true)
        } catch {
            print("Failed to update data request.")
        }
    }
    
    //TextFields Validations
    func employeeDetailsValidation() -> Bool {
        var message = ""
        if firstNameTextField.text?.count == 0 {
            message = message + "Please enter a First Name.\n"
        } else if lastNameTextField.text?.count == 0 {
            message = message + "Please enter a Last Name.\n"
        } else if dobTextField.text?.count == 0 {
            message = message + "Please select a DOB.\n"
        } else if phoneNumberTextField.text?.count != 10 {
            message = message + "Please enter a valid Phone Number.\n"
        }
        
        if message.count > 0 {
            let AppName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
            showValidationAlert(AppName, message)
            return false
        } else {
            return true
        }
    }
    
    //Clear Text Fields
    func clearTextFields() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        dobTextField.text = ""
        phoneNumberTextField.text = ""
        maritalStatusSwitchButton.isOn = false
    }
    
    //Alert View Controller
    @objc func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title,message: message,preferredStyle: UIAlertController.Style.alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
            self.clearTextFields()
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        })
    }
    
    @objc func showValidationAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title,message: message,preferredStyle: UIAlertController.Style.alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        })
    }
    
    //Dismiss Alert Controller
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - ACTION BUTTONS
    @IBAction func maritalSwitchButtonAction(_ sender: Any) {
        if maritalStatusSwitchButton.isOn {
            maritalStatus = true
        } else {
            maritalStatus = false
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if employeeDetailsValidation() {
            if isFromEdit {
                updateEmployeeDetails()
            } else {
                saveEmployeeDetails()
            }
        }
    }
    
    @IBAction func presentDatePicker(_ sender: AnyObject) {
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        if let date = employeeDetail?.dob {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let selectedDate = dateFormatter.date(from: date) {
                datePickerView.date = selectedDate
            }
        }
        (sender as? UITextField)?.inputView = datePickerView
        (sender as? UITextField)?.addToolBar()
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        dobTextField.text = sender.date.formattedDateString("d/MM/yyyy")
    }

}

//MARK: - UITextField Delegate
extension MCEmployeeAddEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            let currentTextField = textField.text! + string
            if currentTextField.count >= 11 {
                showValidationAlert("Error", "Please add upto 10 numbers only.")
                return false
            }
        }
        return true
    }
}
