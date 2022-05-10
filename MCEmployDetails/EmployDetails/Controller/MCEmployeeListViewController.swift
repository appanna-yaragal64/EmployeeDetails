//
//  MCEmployeeListViewController.swift
//  MCEmployDetails
//
//  Created by Appanna Yaragal on 17/04/22.
//

import UIKit
import CoreData

class MCEmployeeListViewController: UIViewController {

    
    @IBOutlet weak var employeeListTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var employeeList = [EmployeeList]()
    var filteredEmployeeList = [EmployeeList]()
    var isSearchActive: Bool = false
    
    //MARK: - Application Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Employee List"
        
        //Register Nib
        employeeListTableView.register(UINib(nibName: "MCEmployListTableViewCell", bundle: nil), forCellReuseIdentifier: "MCEmployListTableViewCell")
        
        errorMessageLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchEmployeeLists()
    }
    
    //Fetch User Employee Details
    func fetchEmployeeLists() {
        errorMessageLabel.isHidden = true
        let fetchRequest = NSFetchRequest<EmployeeList>(entityName: "EmployeeList")
        do {
            let fetchedResults = try AppDelegate.sharedInstance.managedObjectContext!.fetch(fetchRequest)
            employeeList = fetchedResults
            employeeList.count > 0 ? (errorMessageLabel.isHidden = true) : (errorMessageLabel.isHidden = false)
            self.employeeListTableView.reloadData()
        } catch let error as NSError {
            print(error.description)
        }
    }

    @IBAction func addEmployeeButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MCEmployeeAddEditViewController") as! MCEmployeeAddEditViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UITableView Delegate & UITableView DataSource Methods
extension MCEmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive {
            filteredEmployeeList.count > 0 ? (errorMessageLabel.isHidden = true) : (errorMessageLabel.isHidden = false)
            return filteredEmployeeList.count
        } else {
            employeeList.count > 0 ? (errorMessageLabel.isHidden = true) : (errorMessageLabel.isHidden = false)
            return employeeList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MCEmployListTableViewCell", for: indexPath) as! MCEmployListTableViewCell
        
        let data = isSearchActive == true ? (filteredEmployeeList[indexPath.row]) : (employeeList[indexPath.row])
        cell.updateEmployee(details: data)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
}

//MARK: - MCEmploy List TableViewCell Delegate Methods
extension MCEmployeeListViewController: MCEmployListTableViewCellDelegate {
    func didTapEditButton(cell: MCEmployListTableViewCell) {
        self.view.endEditing(true)
        let controller = storyboard?.instantiateViewController(withIdentifier: "MCEmployeeAddEditViewController") as! MCEmployeeAddEditViewController
        controller.isFromEdit = true
        controller.employeeDetail = cell.employeeDetail
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapDeleteButton(cell: MCEmployListTableViewCell) {
        self.view.endEditing(true)
        let context : NSManagedObjectContext = AppDelegate.sharedInstance.managedObjectContext!
        let fetchRequest = NSFetchRequest<EmployeeList>(entityName: "EmployeeList")
        
        do {
            let fetchedResults = try AppDelegate.sharedInstance.managedObjectContext!.fetch(fetchRequest)
            employeeList = fetchedResults
            if let index = cell.indexPath?.row {
                context.delete(employeeList[index])
            }
            try context.save()
            self.fetchEmployeeLists()
        } catch {
            
        }
    }
}

//MARK: - UISearchBar Delegate Method
extension MCEmployeeListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        isSearchActive = searchText.count > 0 ? true : false
        
        let firstNamePredicate = NSPredicate(format: "first_name CONTAINS[c] %@", searchText)
        let lastNamePredicate = NSPredicate(format: "last_name CONTAINS[c] %@", searchText)
        
        let compoundPredicate = NSCompoundPredicate.init(orPredicateWithSubpredicates: [firstNamePredicate, lastNamePredicate])
        
        filteredEmployeeList = employeeList.filter({
            return compoundPredicate.evaluate(with: $0)
        })
        
        employeeListTableView.reloadData()
    }
}
