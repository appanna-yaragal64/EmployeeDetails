//
//  MCEmployListTableViewCell.swift
//  MCEmployDetails
//
//  Created by Appanna Yaragal on 17/04/22.
//

import UIKit
import CoreData

protocol MCEmployListTableViewCellDelegate {
    func didTapEditButton(cell: MCEmployListTableViewCell)
    func didTapDeleteButton(cell: MCEmployListTableViewCell)
}

class MCEmployListTableViewCell: UITableViewCell {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var maritalStatusLabel: UILabel!
    @IBOutlet weak var holderView: UIView!
    
    var delegate: MCEmployListTableViewCellDelegate?
    var employeeDetail : EmployeeList?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        holderView.applyRoundCorner(radius: 6.7, borderWidth: 0.3, borderColor: .gray)
//        self.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Update Employee Details
    func updateEmployee(details: EmployeeList) {
        self.employeeDetail = details
        firstNameLabel.text = details.first_name
        lastNameLabel.text = details.last_name
        dobLabel.text = details.dob
        phoneNumberLabel.text = details.phone_number
        details.marital_status == true ? (maritalStatusLabel.text = "Yes") : (maritalStatusLabel.text = "No")
    }
    
    //MARK: - ACTION BUTTONS
    @IBAction func editButtonAction(_ sender: Any) {
        delegate?.didTapEditButton(cell: self)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        delegate?.didTapDeleteButton(cell: self)
    }
    
    
}
