//
//  AdminHomePageViewController.swift
//  KaiBall Athletics
//
//  Created by Vijay on 25/04/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import SDWebImage

class AdminHomePageViewController: UIViewController {
    
    var categories = Array<Category>()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        getCategoryData()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
        }
        catch {
            
        }
      
    }
    
    @IBAction func addCategoryButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "createcatseg", sender: nil)
        
    }
    
    public func getCategoryData() {
        
        Firestore.firestore().collection("Categories").addSnapshotListener { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    self.categories.removeAll()
                    for snap in snapshot.documents {
                        if let cat = try? snap.data(as: Category.self) {
                            self.categories.append(cat)
                        }
                       
                    }
                    self.tableView.reloadData()
                 
                    
                }
                
            }
            else {
                self.showError(error.debugDescription)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videosseg" {
            if let index = sender as? Int {
                if let destination = segue.destination as? AdminAllVideoController {
                    destination.cat_id = self.categories[index].id
                    destination.cat_title = self.categories[index].title
                    
                }
            }
        }
    }
    
    func deleteStorageItem(pathToFile : String, fileName : String) {
      
            let ref = Storage.storage().reference(withPath: pathToFile)
            let childRef = ref.child(fileName);
            childRef.delete()
             
    }
    
    @IBAction func pushNotificationBtnClicked(_ sender: Any) {
        sendPushNotification()
    }
    
    @objc func deleteCategory(value : MyTapGesture) {
        let id = value.id
        let alert = UIAlertController(title: "DELETE", message: "Are you sure you want to delete this category?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { actiondelete in
            self.dismiss(animated: true, completion: nil)
            Firestore.firestore().collection("Categories").document(id).delete { error in
                if error == nil {
                   
                    self.showToast(message: "Category has deleted")
                    Storage.storage().reference().child("Categories").child(id).listAll { result, error in
                        if error == nil {
                            for storage in result.items {
                                self.deleteStorageItem(pathToFile: Storage.storage().reference().child("Categories").child(id).fullPath,fileName: storage.name)
                            }
                        }
                    }
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
}

class MyTapGesture: UITapGestureRecognizer {
    var id = String()
}


extension AdminHomePageViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    

       
        performSegue(withIdentifier: "videosseg", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "admincatcell", for: indexPath) as? AdminCategoriesTableViewCell {

            let category = self.categories[indexPath.row]
            cell.title.text = category.title
            cell.desc.text = category.desc
            cell.catImg.sd_setImage(with: URL(string: category.image), completed: nil)
            cell.catImg.layer.cornerRadius = 6
            cell.totalVideos.text = String("Videos Available : \(category.totalVideos)")
            cell.myView.dropShadow()
            cell.myView.layer.cornerRadius = 6
            cell.deleteCategoryButton.roundCorners([.bottomLeft , .bottomRight], radius: 6)
            cell.deleteCategoryButton.isUserInteractionEnabled = true
            let tappy = MyTapGesture(target: self, action: #selector(deleteCategory(value:)))
            tappy.id = category.id
            cell.deleteCategoryButton.addGestureRecognizer(tappy)
            cell.clipsToBounds = true
            return cell
            
        }
       
        return AdminCategoriesTableViewCell()
    }
    

    
}
