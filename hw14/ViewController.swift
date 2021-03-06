//
//  ViewController.swift
//  hw14
//
//  Created by Kostya Bunsberry on 02.08.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    
    var name = ""
    var surname = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let name = Persistance.shared.userName {
            self.name = name
            self.nameTextField.text = name
        }
        
        if let surname = Persistance.shared.userSurname {
            self.surname = surname
            self.surnameTextField.text = surname
        }
        
        nameLabel.text = "Ваше имя: \(surname) \(name)"
    }

    @IBAction func nameChanged(sender: UITextField) {
        Persistance.shared.userName = sender.text!
        name = sender.text!
        nameLabel.text = "Ваше имя: \(surname) \(name)"
    }
    
    @IBAction func surnameChanged(sender: UITextField) {
        Persistance.shared.userSurname = sender.text!
        name = sender.text!
        nameLabel.text = "Ваше имя: \(surname) \(name)"
    }

}

