//
//  MenuViewController.swift
//  Admin Oh Crepe & Waffles
//
//  Created by Vijay on 08/05/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import MBProgressHUD
import SDWebImage


class MenuViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var menus = Array<MenuModel>()

    @IBOutlet weak var addMenuItemBtn: UIImageView!
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //GETEMENUDATA
        getMenuData()
        
        addMenuItemBtn.isUserInteractionEnabled = true
        addMenuItemBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addMenuItemBtnClicked)))
    }
    
    @objc func addMenuItemBtnClicked(){
        performSegue(withIdentifier: "addmenuitemseg", sender: nil)
    }
    
    
    func getMenuData() {
        ProgressHUDShow(text: "Loading")
        Firestore.firestore().collection("Menu").order(by: "title", descending: false).addSnapshotListener { snapshot, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                if let snapshot = snapshot {
                    self.menus.removeAll()
                    for snap in snapshot.documents {
                        if let cat = try? snap.data(as: MenuModel.self) {
                            self.menus.append(cat)
                        }
                       
                    }
                    self.collectionView.reloadData()

                }
                
            }
            else {
                self.showError(error.debugDescription)
            }
        }
        
    }
    
    
    
}


extension MenuViewController : UICollectionViewDelegate {
    
}


extension MenuViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menucell", for: indexPath) as? MenuTableViewCell {
            
            cell.view.layer.cornerRadius = 6
            cell.view.dropShadow()
            cell.imageView.clipsToBounds = true
            cell.imageView.layer.cornerRadius = 4
            cell.imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            cell.titleView.clipsToBounds = true
            cell.titleView.layer.cornerRadius = 4
            cell.titleView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            let menu = menus[indexPath.row]
            
            cell.imageView.sd_setImage(with: URL(string: menu.image), completed: nil)
            cell.title.text = menu.title
          
            
            return cell
        }
        
        return MenuTableViewCell()
        
        
    }
    
    
    
}

extension MenuViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (collectionView.bounds.width - 12)/2
        let cellSize = CGSize(width: width, height: (width * (320/240)) + 27)
        return cellSize
    }



  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: 50))
        return footerView.frame.size
    }
    
    
  
    
}
