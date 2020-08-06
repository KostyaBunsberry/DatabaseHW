//
//  TaskRealmTVC.swift
//  hw14
//
//  Created by Kostya Bunsberry on 02.08.2020.
//

import UIKit

protocol TaskDelegate {
    func changeText(id: String, text: String)
}

class TaskTVC: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    var delegate: TaskDelegate?
    var id: String!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    @IBAction func textChanged(sender: UITextField) {
        textField.delegate = self
        
        delegate?.changeText(id: id, text: sender.text!)
    }

}
