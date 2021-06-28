//
//  PushNotificationSender.swift
//  hbcumade
//
//  Created by Vijay Rathore on 02/06/21.
//

import UIKit

class PushNotificationSender {
    func sendPushNotification(title: String, body: String, token : String,badge : Int) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body,"badge": badge],
                                           "data" : ["user" : "test_id"]
        ]

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAQzOQ26g:APA91bGQhoeRbCRZoEadmL4w-m4cdYnMr7pMPeDx71qjs8wd4QtNhYJrD0zJwkJoWxFTPRxgyZLdZggO5Xd7StTsooSg0ddURUpdcRTVNkX_xmH30ffliSbYg-qHaWP44kTRWISNg78M", forHTTPHeaderField: "Authorization")

        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                        
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
