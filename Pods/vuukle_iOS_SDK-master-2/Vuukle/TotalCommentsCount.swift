

import Foundation

class TotalCommentsCount {
    var comments : Int?
    
    static func getTotalCommentsCount(pDict : NSDictionary) -> TotalCommentsCount {
        
        let lTotalCommentsCount = TotalCommentsCount()
            lTotalCommentsCount.comments = pDict["comments"] as? Int ?? Int("")
        return lTotalCommentsCount
    }
    
}