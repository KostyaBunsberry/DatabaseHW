//
//  ToDoCoreDataVC.swift
//  hw14
//
//  Created by Kostya Bunsberry on 02.08.2020.
//

import UIKit
import CoreData

class ToDoCoreDataVC: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskDelegate {
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    var tasks: [TaskCD] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TaskCD> = TaskCD.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func edit() {
        tasksTableView.isEditing = !tasksTableView.isEditing
    }
    
    @IBAction func addTask() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "TaskCD", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! TaskCD
        
        taskObject.id = UUID().uuidString
        taskObject.text = ""
        
        do {
            try context.save()
            tasks.append(taskObject)
            print("task added")
        } catch {
            print(error.localizedDescription)
        }
        
        tasksTableView.insertRows(at: [IndexPath(row: tasks.count - 1, section: 0)], with: .automatic)
        let cell = tasksTableView.cellForRow(at: IndexPath(row: tasks.count - 1, section: 0)) as! TaskTVC
        cell.id = taskObject.id
        cell.textField.text = ""
    }
    
    func changeText(id: String, text: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskCD")
            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let results = try context.fetch(fetchRequest) as? [TaskCD]
            if results?.count != 0 {
                results![0].text = text
            }
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskTVC
        
        cell.delegate = self
        cell.id = tasks[indexPath.row].id
        cell.textField.text = tasks[indexPath.row].text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TaskTVC
        
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            var fetchRequest = NSFetchRequest<TaskCD>(entityName: "TaskCD")
            fetchRequest.predicate = NSPredicate(format: "id = %@", cell.id)
            
            do {
                let results = try context.fetch(fetchRequest) as? [TaskCD]
                if results?.count != 0 {
                    context.delete(results![0])
                }
            } catch {
                print(error.localizedDescription)
            }
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            fetchRequest = TaskCD.fetchRequest()
            
            do {
                tasks = try context.fetch(fetchRequest)
            } catch {
                print(error.localizedDescription)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
