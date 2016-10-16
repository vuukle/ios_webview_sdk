import Foundation
import UIKit

public class VuukleInfo {
    static var totalCommentsCount = 0
    static var commentsHeight = 0
    
//    public static func getCommentsHeight() -> Int {
//        return commentsHeight
//    }
    
    public static func getCommentsCount() -> Int {
        return self.totalCommentsCount
    }
}