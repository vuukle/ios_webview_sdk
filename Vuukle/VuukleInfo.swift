import Foundation
import UIKit

open class VuukleInfo {
    static var totalCommentsCount = 0
    static var commentsHeight: CGFloat = 0.0
    
    public static func getCommentsHeight() -> CGFloat {
        return CGFloat(CommentViewController.shared!.getHeight())
    }
    
    public static func getCommentsCount() -> Int {
        return self.totalCommentsCount
    }
}
