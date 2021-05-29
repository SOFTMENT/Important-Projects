//
//  PusNotificationSender.swift
//  Holli
//
//  Created by Vijay on 11/04/21.
//  Copyright © 2021 OriginalDevelopment. All rights reserved.
//
import UIKit

class PushNotificationSender {
    func sendPushNotification(title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : "/topics/holli",
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAzqhrqJ4:APA91bFrk_1sdG5tfXVLjH_0cGO0XFQr3eDsAaen6-Q5uTqdKtVbMyk4jldLpLF_fbnyWbH-D-zO5FgLkRBCrmjL9kYfSs4nsYovBb50ijau6WYJ6D7DXs47eWCNsRj6OEeg_C34uc6T", forHTTPHeaderField: "Authorization")

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
