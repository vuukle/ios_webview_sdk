

import Foundation

class CellConstraintsConstructor {
    static let sharedInstance = CellConstraintsConstructor()
    
    func setEmoticonCellConstraint (_ cell : EmoticonCell) ->  EmoticonCell{
        cell.viewHeight.constant = 0
        cell.titleHeight.constant = 0
        cell.firstEmoticonImageHeight.constant = 0
        cell.secondEmoticonImageHeight.constant = 0
        cell.thirdEmoticonImageHeight.constant = 0
        cell.fourthEmoticonImageHeight.constant = 0
        cell.fifthEmoticonImageHeight.constant = 0
        cell.sixthEmoticonImageHeight.constant = 0
    
        return cell
    }
    
    func setCommentCellConstraints (_ cell : CommentCell) ->  CommentCell{
        
        cell.imageLeftCostraint.constant = CGFloat(Global.leftConstrainCommentSize)
        cell.totalCountLeftConstraint.constant = CGFloat(Global.leftConstrainCommentSize)
        cell.upvoteButtonLeftConstraint.constant = CGFloat(Global.leftConstrainCommentSize)
        cell.initialsLabelLeftConstraints.constant = CGFloat(Global.leftConstrainCommentSize)
        
        return cell
    }
    
    func setAddCommentCellConstraints (_ cell : AddCommentCell) ->  AddCommentCell{
        cell.leftConstrainSize.constant = 5
        cell.totalCountHeight.constant = 21
        cell.logOutButtonHeight.constant = 26
        
        return cell
    }
    
    func setAddCommentCellForReplyConstraints (_ cell : AddCommentCell) ->  AddCommentCell{
        cell.leftConstrainSize.constant = 5
        cell.totalCountHeight.constant = 5
        cell.logOutButtonHeight.constant = 5
        cell.totalCount.isHidden = true
        
        return cell
    }

}
