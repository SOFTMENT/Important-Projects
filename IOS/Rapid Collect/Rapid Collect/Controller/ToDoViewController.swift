//
//  AboutTabViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 13/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import RealmSwift


protocol ToDoDelegate : class {
    func updateValue()
    func addValue(todoitem : Task)
}




class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   
    @IBOutlet weak var tableView: UITableView!
    var toDoItems : Results<Task>? {
        
        get {
            guard let realm  = LocalDatabase.realm else {
                return nil
            }
            return realm.objects(Task.self)
        }
    }
    
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAdd))
        
         navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEdit))
       
            
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        setEditing(false, animated: false)
    }
    
    @objc func tapAdd() {
        
        performSegue(withIdentifier: "addTask", sender: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTask" {
            if let vc = segue.destination as? ToDoAddViewController {
                vc.todoDelegate  = self
            }
        }
    }
    
    @objc func tapEdit() {
            
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            
              navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapEdit))
            
        }
        else {
              navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEdit))
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, boolValue) in
            
            guard let realm = LocalDatabase.realm else {
                return
            }
            do {
                
                try realm.write {
                    realm.delete(self.toDoItems![indexPath.row])
                }
               
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [action])

        return swipeActions
    }
       
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let toDoItem = toDoItems![toDoItems!.count - indexPath.row - 1]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath) as? ToDoViewCell {
            
            cell.selectionStyle = .none
        
            cell.title.text = toDoItem.name
   if (toDoItem.completionDate as Date) < Date() {
  
    if let realm = LocalDatabase.realm {
       do {
           try realm.write {
              toDoItem.isComplete = true
           }
       }
       catch let error as NSError {
           print(error.localizedDescription)
       }
    }
    
          
        }
            cell.completeStatus.text = toDoItem.isComplete ? "Complete" : "Incomplete"
            
           
            
            if toDoItem.isComplete {
                cell.completeStatus.textColor = UIColor(red: 16/255, green: 112/255, blue: 34/255, alpha: 1)
                
            }
            else {
                cell.completeStatus.textColor = .red
            }
            
            
             return cell
        }
        
        return UITableViewCell()
        
       
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoItems?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoList = toDoItems![toDoItems!.count - indexPath.row - 1]
        
       let alertController = self.storyboard?.instantiateViewController(withIdentifier: "ToDoDetails") as! ToDoDetails
       
       
        
  
        
       alertController.providesPresentationContextTransitionStyle = true
       alertController.definesPresentationContext = true
       alertController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
       alertController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        alertController.todopdelegate = self
        alertController.todoItem = todoList
        alertController.index = indexPath.row
        
       self.present(alertController, animated: true, completion: nil)
        

                  
        
        
    }
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        var  color = UIColor.init(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
       
        let preferences = UserDefaults.standard

             let colorKey = "colorKey"

             if preferences.object(forKey: colorKey) == nil {
             
             } else {
                 
                 let currentLevel = preferences.string(forKey: colorKey)
                 
                 switch currentLevel {
                 case "black":
                     color = UIColor.init(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
                     break;
                     
                 case "green" :
                     color = UIColor.init(red: 22/255, green: 74/255, blue: 42/255, alpha: 1)
                     
                     break
                     
                 case "red" :
            color = UIColor.init(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
                     
                     break
                 case "blue" :
                     color = UIColor.init(red: 34/255, green: 48/255, blue: 81/255, alpha: 1)
                 
                     break
                     
                 default:
                     print("")
                 }
             }
        
      
         navigationController?.navigationBar.barTintColor = color
    }
    
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ToDoViewController : ToDoDelegate {
    
    func updateValue() {
        
       
        tableView.reloadData()
        
    }
    func addValue(todoitem: Task) {
        
        guard let realm = LocalDatabase.realm else {
            return
        }
        
        do {
            try realm.write {
                realm.add(todoitem)
                 tableView.reloadData()
            }
        }
                       
       catch let error as NSError {
            print(error.localizedDescription)
       
        
    }
}
}
