//
//  ToDoDetailsViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 07/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class ToDoDetailsViewController: UIViewController {

    var toDoItem : ToDoItemModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(toDoItem.name)
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
