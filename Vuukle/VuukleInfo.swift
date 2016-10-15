import Foundation
import UIKit

public class VuukleInfo {
    static var totalCommentsCount = 0
    static var commentsHeight: CGFloat = 0.0
    
    public static func getCommentsHeight() -> CGFloat {
        return commentsHeight
    }
    
    public static func getCommentsCount() -> Int {
        return self.totalCommentsCount
    }
}
