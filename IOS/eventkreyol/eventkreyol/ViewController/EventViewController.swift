//
//  EventViewController.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 21/07/21.
//


import UIKit

class EventViewController: UIViewController {

    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var myPageView: UIPageControl!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var eventDateCollectionView: UICollectionView!
    @IBOutlet weak var followBtn: UIView!
    @IBOutlet weak var topProfileImage: UIImageView!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var ticketBtn: UIButton!
    
    //Recommended
    @IBOutlet weak var recommendedAgeView: UIView!
    @IBOutlet weak var recommendedGenderView: UIView!
    @IBOutlet weak var recommendedTimeView: UIView!
    @IBOutlet weak var recommendedJoinedView: UIView!
    @IBOutlet weak var recommendedGenderImgView: UIView!
    @IBOutlet weak var recommendedTimeImgView: UIView!
    @IBOutlet weak var recommendedAgeImgView: UIView!
    @IBOutlet weak var recommendedJoinedImgView: UIView!
    
    
    
    var imgArr = [  UIImage(named:"party"),
                     UIImage(named:"festival-image-2") ,
                     UIImage(named:"party"),
                     UIImage(named:"festival-image-2"),
                   
                     ]
    
    var timer = Timer()
    var counter = 0
    override func viewDidLoad() {
      
       
        
        
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        myPageView.numberOfPages = imgArr.count
        myPageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
        //EVENTDATECOLLECTIONVIEW
        eventDateCollectionView.dataSource = self
        eventDateCollectionView.delegate = self
        
        
        //TAGSCOLELCTIONVIEW
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        
        followBtn.layer.cornerRadius = 12
        topProfileImage.makeRounded()
        ticketBtn.layer.cornerRadius = 8
        
        
        //RECOMMENDEDVIEW
      
        
        recommendedGenderView.layer.cornerRadius = 12
        recommendedGenderView.dropShadow()
        
        recommendedAgeView.layer.cornerRadius = 12
        recommendedAgeView.dropShadow()
        
        recommendedTimeView.layer.cornerRadius = 12
        recommendedTimeView.dropShadow()
        
        recommendedJoinedView.layer.cornerRadius = 12
        recommendedJoinedView.dropShadow()
    
        recommendedGenderImgView.layer.cornerRadius = 12
        recommendedAgeImgView.layer.cornerRadius = 12
        recommendedTimeImgView.layer.cornerRadius = 12
        recommendedJoinedImgView.layer.cornerRadius = 12
        
        navigationBar.installBlurEffect(isTop: true)
        bottomBarView.installBlurEffect(isTop: false)

    }
    
    
    @objc func changeImage() {
      
      if counter < imgArr.count {
          let index = IndexPath.init(item: counter, section: 0)
          self.headerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
          myPageView.currentPage = counter
          counter += 1
      } else {
          counter = 0
          let index = IndexPath.init(item: counter, section: 0)
          self.headerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
         myPageView.currentPage = counter
          counter = 1
      }
          
      }
    
  
    
}



extension EventViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == eventDateCollectionView {
            return 7
        }
        else if collectionView == tagsCollectionView {
            return 5
        }
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if collectionView == eventDateCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventdatecell", for: indexPath) as? Event_DateandTime_Cell {
                
            
                cell.mView.layer.cornerRadius = 12
                cell.mView.layer.borderWidth = 2
                cell.mView.layer.borderColor = UIColor.init(red: 112/225, green: 101/255, blue: 228/255, alpha: 1).cgColor
                
                cell.dayView.layer.cornerRadius = cell.dayView.layer.bounds.width / 2
                return cell
            }
            return Event_DateandTime_Cell()
            
        }
        else if  collectionView == tagsCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagcell", for: indexPath) as? Tag_Cell {
                
                cell.tagBtn.layer.cornerRadius = 8
                return cell
            }
            return Tag_Cell()
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headercell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                vc.image = imgArr[indexPath.row]
                
              
            }
            return cell
        }
    
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let visibleIndex = Int(targetContentOffset.pointee.x / headerCollectionView.frame.width)
        myPageView.currentPage = visibleIndex
        counter = visibleIndex
    }
    
    
    
    
}


extension EventViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            let size = headerCollectionView.frame.size
            return CGSize(width: size.width, height: size.height)
        }
        else if collectionView == tagsCollectionView {
            let size = tagsCollectionView.frame.size
            return CGSize(width: size.width, height: size.height)
        }
        else {
            let size = eventDateCollectionView.frame.size
            return CGSize(width: size.width, height: size.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
   
}
