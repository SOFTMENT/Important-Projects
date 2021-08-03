//
//  CategorisModel.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 20/07/21.
//

import UIKit

class CategorisModel : NSObject, Codable  {

    var categoryName : String?
    var cat_image : String?
    
    private static var categorisModel : CategorisModel?
   
    static var data : CategorisModel? {
        set(categorisModel) {
            self.categorisModel = categorisModel
        }
        get {
            return categorisModel
        }
    }


    override init() {
        
    }
}
