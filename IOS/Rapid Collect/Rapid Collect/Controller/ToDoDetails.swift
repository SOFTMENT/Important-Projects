//
//  ToDoDetails.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 08/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit


class ToDoDetails: UIViewController {

    @IBOutlet weak var todoDetailsView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet var backView: UIView!
    
    @IBOutlet weak var backbackView: UIView!
    var todoItem : Task!
    var index : Int!
    var todopdelegate : ToDoDelegate?
    override func viewDidLoad() {
        todoDetailsView.layer.cornerRadius = 8
        backbackView.layer.cornerRadius = 8
       
        
        
        name.text = todoItem.name
        details.text = todoItem.details
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "E dd MMMM, hh:mm a"
        completionDate.text = dateFormatter.string(from: todoItem.completionDate as Date)
        if todoItem.isComplete {
          disableButton()
        }
        
                
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewTapped)))
    }
    
    @objc func backViewTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTap(_ sender: Any) {
        if !todoItem.isComplete {
            

            guard let realm = LocalDatabase.realm else {
                return
            }
            
            do {
                try realm.write {
                    todoItem.isComplete = true
                }
                
            }
            catch let error as NSError{
                print(error.localizedDescription)
            }
        disableButton()
        
        todopdelegate?.updateValue()
        
        dismiss(animated: true, completion: nil)
        }
    
    }
    
    func disableButton() {
        completeButton.backgroundColor = .gray
        completeButton.isSelected = false
        completeButton.setTitle("Completed", for: .normal)
    }
    
}
