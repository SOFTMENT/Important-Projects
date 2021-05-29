//
//  PushNotificationSender.swift
//  Admin Oh Crepe & Waffles
//
//  Created by Vijay on 08/05/21.
//

import UIKit

class PushNotificationSender {
    func sendPushNotification(title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : "/topics/SOFTMENT",
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAce3q7Tw:APA91bF6tpOAPoUbATnY6pxZd2szxC91_YLByJ-7ViZZ3o9ujSFlZ06nq9hlvvZPgWIOC0qPmj8EtJxMaiJw_k7Z7t3aXF16jwDMM7dIJUY_JrQsDimqqrXIN7pI7PeZED9qOSHEAiFC", forHTTPHeaderField: "Authorization")

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
