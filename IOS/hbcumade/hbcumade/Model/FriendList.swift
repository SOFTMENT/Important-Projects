import Foundation

final class FriendList : NSObject, Codable{
    var name : String?
    var image : String?
    var time : Date?
    var uid : String?
    static var friendList : FriendList?
    
    static var sharedInstance : FriendList {
        set(userdata) {
            self.friendList = userdata
        }
        get {
            return friendList!
        }
    }
    private override init() {}

}
