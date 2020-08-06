//
//  ToDoRealmVC.swift
//  hw14
//
//  Created by Kostya Bunsberry on 02.08.2020.
//

import UIKit
import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var text: String = ""
}

class ToDoRealmVC: UIViewController, TaskDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    private let realm = try! Realm()
    
    var tasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = realm.objects(Task.self)
    }
    
    @IBAction func edit() {
        tasksTableView.isEditing = !tasksTableView.isEditing
    }
    
    @IBAction func create() {
        let newTask = Task()
        newTask.text = ""
        
        try! realm.write {
            realm.add(newTask)
        }
        
        tasks = realm.objects(Task.self)
        tasksTableView.insertRows(at: [IndexPath(row: tasks.count - 1, section: 0)], with: .automatic)
    }
    
    func changeText(id: String, text: String) {
        try! realm.write {
            for object in realm.objects(Task.self) {
                if object.id == id {
                    object.text = text
                    print(object)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskTVC
        
        cell.id = tasks[indexPath.row].id
        cell.textField.text = tasks[indexPath.row].text
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let rt = realm.objects(Task.self)
            
            for task in rt {
                if task.id == tasks[indexPath.row].id {
                    try! realm.write {
                        realm.delete(task)
                    }
                    break
                }
            }
            
            tasks = realm.objects(Task.self)
            tasksTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
