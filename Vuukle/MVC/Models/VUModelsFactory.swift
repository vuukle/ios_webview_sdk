//
//  VUObjectsForCellsFactory.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit


class VUModelsFactory {
  
  private init() { }
  
  static var modelsArray = [Any]()
  static var isUpdatingUI = false
  
  static var lastCommentIndex = 0
  static var lastReplyFromIndex = -1
  
  static var currentLoginAction: VULoginActionType = .none
  static var currentCommentCell: VUCommentCell?
  
  static var commentsInProgress = [VUCommentCell]()
  
  
  // MARK: - FIRST LAUNCH
  static func generateObjectsForCells(_ isReload: Bool, contentView: UIView?) {
    
    if isReload {
      
      modelsArray.removeAll()
      lastCommentIndex = 0
      
      if let tableView = VUCommentsVC.sharedInstance.tableView {
        tableView.reloadData()
      }
    }
    
    insertHeaderCells()
    loadFirstComments() { isSuccess in
      
      if isSuccess && VUGlobals.isTopArticlesHiden == false {
        loadTopArticles()
      }
    }
  }
  
  
  private static func loadFirstComments(_ completion: @escaping (Bool) -> Void) {
    
    let newLastIndex = lastCommentIndex + VUGlobals.commentsPagination
    
    VUServerManager.getComments(from: lastCommentIndex,
                                to: newLastIndex) { responceCommentsArray, error in
                                  
      if let responceCommentsArray = responceCommentsArray {
      
        insertFirstComments(responceCommentsArray,
                            toIndex: newLastIndex) {
          completion(true)
        }
      } else {
        completion(false)
      }
    }
  }
  
  
  static func generateEmojiModel() {
    
    requestLoadEmojiRating()
  }
  
  static func generateTopArticleModel() {
    
//    requestLoadEmojiRating()
  }

  // TODO: • Insert emoji voting, new comment model
  private static func insertHeaderCells() {
    
    if VUGlobals.isVuukleAdsHiden == false {
      modelsArray.append(VUAdvertisingModel())
    }
    
    if VUGlobals.isEmojiVotingHidden == false {
      
      let emojiVotingModel = VUEmojiVotingModel(VUGlobals.requestParametes.articleID)
      modelsArray.append(emojiVotingModel)
      
      requestLoadEmojiRating()
    }
    
    modelsArray.append(VUNewCommentModel())
  }
  
  // TODO: • Insert first comments
  private static func insertFirstComments(_ responceArray: [Any],
                                          toIndex: Int,
                                          completion:  @escaping () -> Void) {
    
    lastCommentIndex = toIndex
    
    VUGlobals.loadedCommetsCount = responceArray.count
    
    var startCount = 1
   
    if VUGlobals.isVuukleAdsHiden == false {
      startCount += 1
    }
    
    if VUGlobals.isEmojiVotingHidden == false {
      startCount += 1
    }
    
    if modelsArray.count != startCount {
      
      modelsArray.removeAll()
      insertHeaderCells()
    }
    
    modelsArray.append(contentsOf: responceArray)
    modelsArray.append(VULoadMoreModel(commentsCount: responceArray.count))
    
    if let tableView = VUCommentsVC.sharedInstance.tableView {
      tableView.reloadData()
    }
    
    VUCommentsBuilderModel.updateTableViewHeight()
    completion()
  }
  
  
  // MARK: - SHOW/HIDE REPLIES
  static func showHideReplies(_ index: Int, cell: VUCommentCell) {
    
    DispatchQueue.main.async {
      
      if let commentModel = modelsArray[index] as? VUCommentModel,
        commentModel.commentID != nil {
        
        if commentsInProgress.contains(cell) == false {
          
          commentsInProgress.append(cell)
          
          hideNewReplyForm()
          hideLoginForm()
          
          if commentModel.isRepliesHiden {
            loadRepliesFor(cell, model: commentModel)

          } else {
            hideRepliesFor(cell, model: commentModel)
          }
        }
      }
    }
  }
  
  // TODO: • Show replies
  private static func loadRepliesFor(_ commentCell: VUCommentCell,
                                     model: VUCommentModel) {
    
    commentCell.showProgress()
    
    if let commentID = model.commentID {
      
      VUServerManager.getReplies(commentID,
                                 parentID: model.parentID,
                                 parentNestingLevel: model.nestingLevel) { (responceRepliesArray, error) in
        
        if let responceRepliesArray = responceRepliesArray {
          
          if isUpdatingUI == false {
          
            insertRepliesFor(commentCell,
                             model: model,
                             repliesArray: responceRepliesArray)
          } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
              
              if isUpdatingUI == false {
                
                insertRepliesFor(commentCell,
                                 model: model,
                                 repliesArray: responceRepliesArray)
              } else {
                commentCell.hideProgress()
              }
            }
          }
        } else {
          commentCell.hideProgress()
        }
      }
    }
  }

  private static func insertRepliesFor(_ commentCell: VUCommentCell,
                                       model: VUCommentModel,
                                       repliesArray: [Any],
                                       isLocalReply: Bool = false) {
    
    isUpdatingUI = true
    
    if let indexPath = VUCommentsVC.sharedInstance.tableView.indexPath(for: commentCell),
      let commentModel = modelsArray[indexPath.row] as? VUCommentModel,
      commentModel.commentID == commentModel.commentID,
      repliesArray.count > 0 {
      
      commentModel.isRepliesHiden = false
     
      if isLocalReply {
        commentModel.repliesCount += 1
        
      } else {
        commentModel.repliesCount = repliesArray.count
      }
      
      modelsArray.insert(contentsOf: repliesArray,
                         at: indexPath.row + 1)
      
      VUGlobals.loadedCommetsCount += repliesArray.count
    
      VUTableViewManager.insertReplyRows(rowCount: repliesArray.count,
                                         from: indexPath.row,
                                         commentCell: commentCell)
    } else {
      
      isUpdatingUI = false
      commentCell.hideProgress()
    }
  }
  
  // TODO: • Hide replies
  private static func hideRepliesFor(_ commentCell: VUCommentCell,
                                     model: VUCommentModel) {
    
    isUpdatingUI = true
    
    if let indexPath = VUCommentsVC.sharedInstance.tableView.indexPath(for: commentCell),
      let commentModel = modelsArray[indexPath.row] as? VUCommentModel,
      commentModel.commentID == model.commentID {
      
      let commentIndex = indexPath.row
      
      let repliesCount = findRepliesFrom(commentIndex + 1,
                                         parentModel: model)
  
      commentModel.isRepliesHiden = true
      
      if repliesCount > 1 {
        
        let range = ClosedRange(uncheckedBounds: (lower: commentIndex + 1,
                                                  upper: commentIndex + repliesCount))
        modelsArray.removeSubrange(range)
        VUGlobals.loadedCommetsCount -= repliesCount
        
      } else if repliesCount == 1 {
      
        modelsArray.remove(at: commentIndex + 1)
        VUGlobals.loadedCommetsCount -= 1
      }
      
      VUTableViewManager.deleteReplyRows(rowCount: repliesCount,
                                         from: commentIndex,
                                         commentCell: commentCell)
    } else {
      isUpdatingUI = false
    }
  }
  
  private static func findRepliesFrom(_ index: Int,
                                      parentModel: VUCommentModel) -> Int {
    
    var repliesCount = 0
    var lastIndex = index
    
    var isFinished = true
    
    while isFinished {
      
      if let commentModel = modelsArray[lastIndex] as? VUCommentModel, commentModel.nestingLevel > parentModel.nestingLevel {
        
        repliesCount += 1
        lastIndex += 1
        
      } else {
        
        isFinished = false
        return repliesCount
      }
    }
  }
  
  
  // MARK: - EMOJI VOTING
  static func requestLoadEmojiRating() {
    
    VUServerManager.getEmojiRating { (emojiVotingModel, error) in
     
      if let emojiVotingModel = emojiVotingModel {
        if let index = modelsArray.index(where: { $0 is VUEmojiVotingModel }) {
          
          modelsArray[index] = emojiVotingModel
        }
        NotificationCenter.default.post(name: VUGlobals.nEmojiUpdateModels,
                                        object: emojiVotingModel)
      }
    }
  }
  
  // TODO: • Vote for emoji
  static func voteForEmoji(_ atIndex: Int,
                           emojiVotingCell: VUEmojiVotingCell) {
   
    if let modelIndex = modelsArray.index(where: { $0 is VUEmojiVotingModel }),
      let emojiVotingModel = modelsArray[modelIndex] as? VUEmojiVotingModel {
      
      if let votedIndex = emojiVotingModel.votedIndex {
        VUAlertsHub.showAlert("📊 Duplicate vote",
                              message: "You have already voted for \(VUGlobals.emojiStrings[votedIndex]), you can't vote twice.")
      } else {
      
        emojiVotingModel.setVotedIndex(atIndex)
        emojiVotingCell.showProgress()

        VUServerManager.voteForEmoji(atIndex) { (isVoted, vuukleError) in
          
          if isVoted {
            successToVoteForEmoji(emojiIndex: atIndex,
                                  emojiVotingCell: emojiVotingCell)
          } else {
            errorActionWithComment(error: vuukleError)
            emojiVotingCell.hideProgress()
          }
        }
      }
    }
  }
  
  static func voteForEmoji(_ atIndex: Int,
                           emojiVotingModel: VUEmojiVotingModel,
                           emojiVotingView: VUEmojiVoitingView) {

    if let votedIndex = emojiVotingModel.votedIndex {
      VUAlertsHub.showAlert("📊 Duplicate vote",
                            message: "You have already voted for \(VUGlobals.emojiStrings[votedIndex]), you can't vote twice.")
    } else {
    
      emojiVotingModel.setVotedIndex(atIndex)
      emojiVotingView.showProgress()
      
      VUServerManager.voteForEmoji(atIndex) { (isVoted, vuukleError) in
        
        if isVoted {
          successToVoteForEmoji(emojiIndex: atIndex,
                                emojiVotingModel: emojiVotingModel,
                                emojiVotingView: emojiVotingView)
        
        } else {
          errorActionWithComment(error: vuukleError)
          emojiVotingView.hideProgress()
        }
      }
    }
  }


  private static func successToVoteForEmoji(emojiIndex: Int,
                                            emojiVotingCell: VUEmojiVotingCell) {
    
    if let modelIndex = modelsArray.index(where: { $0 is VUEmojiVotingModel }),
      let emojiVotingModel = modelsArray[modelIndex] as? VUEmojiVotingModel {
      
      VUAlertsHub.showHUD("Successfully voted for: \(VUGlobals.emojiStrings[emojiIndex])",
                          image: .hudSuccessIcon)
    
      emojiVotingModel.totalVotes += 1
      emojiVotingModel.emojiArray[emojiIndex].votesCount += 1
      emojiVotingModel.setVotedIndex(emojiIndex, isUpdate: true)
      
      NotificationCenter.default.post(name: VUGlobals.nEmojiUpdateModels,
                                      object: emojiVotingModel)
      emojiVotingCell.hideProgress()
    }
  }
  
  private static func successToVoteForEmoji(emojiIndex: Int,
                                            emojiVotingModel: VUEmojiVotingModel,
                                            emojiVotingView: VUEmojiVoitingView) {
    
    VUAlertsHub.showHUD("Successfully voted for: \(VUGlobals.emojiStrings[emojiIndex])",
      image: .hudSuccessIcon)
    
    emojiVotingModel.totalVotes += 1
    emojiVotingModel.emojiArray[emojiIndex].votesCount += 1
    emojiVotingModel.setVotedIndex(emojiIndex, isUpdate: true)
    
    NotificationCenter.default.post(name: VUGlobals.nEmojiUpdateModels,
                                    object: emojiVotingModel)
    emojiVotingView.hideProgress()
  }
  
  // MARK: - TOP ARTICLES
  private static func loadTopArticles() {
    
    VUServerManager.getTopArticles() { (responceArray, error) in
      
      if let articlesArray = responceArray, articlesArray.count > 0 {
        
        if isUpdatingUI == false {
          insertTopArticles(articlesArray)
        
        } else {
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
           
            if isUpdatingUI == false {
              insertTopArticles(articlesArray)
            }
          }
        }
        
      }
    }
  }
  
  private static func insertTopArticles(_ articlesArray: [Any]) {

    if let index = modelsArray.index(where: { $0 is VULoadMoreModel}) {
      
      if index == modelsArray.count - 1 {
        
        modelsArray.append(contentsOf: articlesArray)
        VUCommentsVC.sharedInstance.tableView.reloadData()
        
      } else {
      
        while !(modelsArray.last is VULoadMoreModel) {
          modelsArray.removeLast()
        }
        
        modelsArray.append(contentsOf: articlesArray)
        VUCommentsVC.sharedInstance.tableView.reloadData()
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        VUCommentsBuilderModel.updateTableViewHeight()
      }
      
    }
  }

  
  // TODO: • Top Article Delegate
  static func openTopArticle(_ index: Int) {
    
    if let topArticleModel = modelsArray[index] as? VUTopArticleModel {
      
      guard let apiKey = topArticleModel.apiKey,
        let articleHost = topArticleModel.host,
        let articleID = topArticleModel.articleID,
        let articleURL = topArticleModel.articleURL else {
          return
      }
      
      VUCommentsBuilder.delegate?.openArticle(title: topArticleModel.articleTitle,
                                              apiKey: apiKey,
                                              articleHost: articleHost,
                                              articleID: articleID,
                                              articleURL: articleURL)
    }
  }
  
  static func openTopArticle(_ topArticleModel: VUTopArticleModel) {
    
    guard let apiKey = topArticleModel.apiKey,
      let articleHost = topArticleModel.host,
      let articleID = topArticleModel.articleID,
      let articleURL = topArticleModel.articleURL else {
        return
    }
    
    VUCommentsBuilder.delegate?.openArticle(title: topArticleModel.articleTitle,
                                            apiKey: apiKey,
                                            articleHost: articleHost,
                                            articleID: articleID,
                                            articleURL: articleURL)
  }
  
  
  // MARK: - LOAD MORE COMMENTS
  static func loadMoreComments(_ loadMoreCell: VULoadMoreCell) {
    
    let newLastIndex = lastCommentIndex + VUGlobals.commentsPagination
    
    VUServerManager.getComments(from: lastCommentIndex,
                                to: newLastIndex) { responceCommentsArray, error in
      
      if let responceCommentsArray = responceCommentsArray {
        
        if isUpdatingUI == false {
          
          insertComments(loadMoreCell,
                         lastIndex: newLastIndex,
                         commentsArray: responceCommentsArray)
          
        } else {
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            if isUpdatingUI == false {
              insertComments(loadMoreCell,
                             lastIndex: newLastIndex,
                             commentsArray: responceCommentsArray)
              
            } else {
              
              loadMoreCell.hideProgress()
              VUCommentsBuilderModel.updateTableViewHeight()
            }
          }
        }
      } else {
        loadMoreCell.hideProgress()
      }
    }
  }
  
  private static func insertComments(_ loadMoreCell: VULoadMoreCell,
                                     lastIndex: Int,
                                     commentsArray: [Any]) {
    
    isUpdatingUI = true
    lastCommentIndex = lastIndex
    
    if let loadMoreIndex = modelsArray.index(where: { $0 is VULoadMoreModel }) {
      
      let loadMoreModel = modelsArray[loadMoreIndex] as! VULoadMoreModel
      loadMoreModel.setCommentsCount(commentsArray.count)
      
      if commentsArray.count == 0 {
      
        VUTableViewManager.reloadRows([IndexPath(row: loadMoreIndex, section: 0)])
        
      } else {
        
        VUGlobals.loadedCommetsCount += commentsArray.count
        
        modelsArray.insert(contentsOf: commentsArray,
                           at: loadMoreIndex)
        
        VUTableViewManager.insertRows(rowCount: commentsArray.count,
                                      from: loadMoreIndex,
                                      animation: .top)
      }
      
      loadMoreCell.hideProgress()
    } else {
      
      isUpdatingUI = false
      loadMoreCell.hideProgress()
    }
  }
  
  
  // MARK: - SHOW/HIDE NEW REPLY FORM
  static func showHideReplyForm(_ index: Int,
                                commentCell: VUCommentCell) {
    
    DispatchQueue.main.async {
      
      if let commentModel = modelsArray[index] as? VUCommentModel,
        commentModel.commentID != nil,
        commentsInProgress.contains(commentCell) == false {
        
        commentsInProgress.append(commentCell)
        
        if let currentIndex = modelsArray.index(where: { $0 is VUNewReplyModel }),
          currentIndex == index + 1 {
          
          hideNewReplyForm(commentCell)
       
        } else {

          hideNewReplyForm()
          hideLoginForm()
          
          guard let newIndexPath = VUCommentsVC.sharedInstance.tableView.indexPath(for: commentCell) else {
            return
          }
          
          showNewReplyForm(at: newIndexPath.row,
                           cell: commentCell)
        }
      }
    }
  }
  
  // TODO: • Show new reply form
  private static func showNewReplyForm(at: Int,
                                       cell: VUCommentCell) {
    
    if isUpdatingUI == false {
      
      isUpdatingUI = true
      modelsArray.insert(VUNewReplyModel(), at: at + 1)
      
      VUTableViewManager.insertRows(rowCount: 1,
                                    from: at + 1,
                                    animation: .right,
                                    commentCell: cell)
    }
  }
  
  // TODO: • Hide new reply form
  private static func hideNewReplyForm(_ commentCell: VUCommentCell? = nil) {
    
    if isUpdatingUI == false,
      let newReplyIndex = modelsArray.index(where: { $0 is VUNewReplyModel }) {
      
      isUpdatingUI = true
      modelsArray.remove(at: newReplyIndex)
      
      VUTableViewManager.deleteRows(deleteIndex: newReplyIndex,
                                    animation: .left,
                                    commentCell: commentCell)
    } else {
      isUpdatingUI = false
    }
  }
  
  
  // MARK: - SHOW/HIDE LOGIN FORM
  static func showHideLoginForm(_ index: Int,
                                commentCell: VUCommentCell,
                                actionType: VULoginActionType) {
    
    DispatchQueue.main.async {
      
      if let commentModel = modelsArray[index] as? VUCommentModel,
        commentModel.commentID != nil,
        commentsInProgress.contains(commentCell) == false {
        
        commentsInProgress.append(commentCell)
        
        if let currentIndex = modelsArray.index(where: { $0 is VULoginFormModel }),
          currentIndex == index + 1 {
          
          hideLoginForm(commentCell)
          
        } else {

          hideNewReplyForm()
          hideLoginForm()
          
          currentLoginAction = actionType
          currentCommentCell = commentCell
          
          guard let newIndexPath = VUCommentsVC.sharedInstance.tableView.indexPath(for: commentCell) else {
            return
          }
          
          showLoginForm(at: newIndexPath.row,
                        cell: commentCell)
        }
      }
    }
  }
  
  // TODO: • Show login form
  private static func showLoginForm(at: Int,
                                    cell: VUCommentCell) {
    
    if isUpdatingUI == false {
 
      isUpdatingUI = true
      modelsArray.insert(VULoginFormModel(), at: at + 1)
      
      VUTableViewManager.insertRows(rowCount: 1,
                                    from: at + 1,
                                    animation: .right,
                                    commentCell: cell)
    }
  }
  
  // TODO: • Hide login form
  private static func hideLoginForm(_ commentCell: VUCommentCell? = nil) {
    
    if isUpdatingUI == false,
      let loginIndex = modelsArray.index(where: { $0 is VULoginFormModel }) {
      
      isUpdatingUI = true
      modelsArray.remove(at: loginIndex)
      
      currentLoginAction = .none
      currentCommentCell = nil
      
      VUTableViewManager.deleteRows(deleteIndex: loginIndex,
                                    animation: .left,
                                    commentCell: commentCell)
    } else {
      isUpdatingUI = false
    }
  }
  
  
  // MARK: - LOG IN/OUT USER
  static func loginUser(name: String, email: String) {
    
    VUCurrentUser.setInfo(name: name, email: email)
    isUpdatingUI = true
    
    if let newCommentIndex = modelsArray.index(where: { $0 is VUNewCommentModel }) {
      
      var indexPathArray = [IndexPath(row: newCommentIndex, section: 0)]
      
      if let newReplyIndex = modelsArray.index(where: { $0 is VUNewReplyModel }) {
        indexPathArray.append(IndexPath(row: newReplyIndex, section: 0))
      }
      
      NotificationCenter.default.post(name: VUGlobals.nLoginShowFlags,
                                      object: nil)

      VUTableViewManager.reloadRows(indexPathArray)
      
      if let currentCommentCell = currentCommentCell {
        continueLastAction(currentLoginAction, commentCell: currentCommentCell)
      }
      hideLoginForm()
      
    } else {
      isUpdatingUI = false
    }
  }
  
  static func logoutUser(_ newCommentCell: VUNewCommentCell) {
    
    newCommentCell.showProgress()
      
    isUpdatingUI = true
 
    VUServerManager.logoutCurrentUser() { (isSuccess, vuukleError) in
      
      if isSuccess,
        let newCommentIndex = modelsArray.index(where: { $0 is VUNewCommentModel }) {
        
        var indexPathArray = [IndexPath(row: newCommentIndex, section: 0)]
        
        if let newReplyIndex = modelsArray.index(where: { $0 is VUNewReplyModel }) {
          indexPathArray.append(IndexPath(row: newReplyIndex, section: 0))
        }
        
        VUCurrentUser.deleteUser()
        newCommentCell.hideProgress()
        
        NotificationCenter.default.post(name: VUGlobals.nLogoutRemoveFlags,
                                        object: nil)
        
        VUAlertsHub.showHUD("Looking forward to seeing",
                            image: .hudLogoutIcon,
                            details:"you again!")
        
        VUTableViewManager.reloadRows(indexPathArray)

      } else {
  
        errorActionWithComment(error: vuukleError)
        
        newCommentCell.hideProgress()
        isUpdatingUI = false
      }
    }
  }
  
  
  // MARK: - POST NEW COMMENT
  static func loginAndPostComment(_ comment: String,
                                  name: String,
                                  email: String,
                                  index: Int,
                                  cell: VUNewCommentCell) {
    
    loginUser(name: name, email: email)
    
    let notificationInfo = ["comment": comment, "index": index] as [String : Any]
    
    NotificationCenter.default.post(name: VUGlobals.nNewCommentShowProgress,
                                    object: notificationInfo)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      
      cell.showProgress()
      postNewComment(comment: comment, index: index, newCommentCell: cell)
    }
  }
  
  
  static func postNewComment(comment: String, index: Int, newCommentCell: VUNewCommentCell) {
    
    newCommentCell.showProgress()
    
    DispatchQueue.main.async {
      
      if let userName = VUCurrentUser.name,
        let userEmail = VUCurrentUser.email {
        
        var parentID = "-1"
        let mainParentID = getMainParentID(index)
        var parentCommentCell: VUCommentCell?
        var parentCommentModel: VUCommentModel?
        
        if index > 0, let commentModel = modelsArray[index - 1] as? VUCommentModel,
          let lID = commentModel.commentID {
          
          parentCommentModel = commentModel
          parentID = lID
        }
        
        if let tempCell = VUCommentsVC.sharedInstance.tableView.cellForRow(at: IndexPath(row: index - 1, section: 0)) as? VUCommentCell {
          
          parentCommentCell = tempCell
        }
        
        if parentID == "-1" {
          
          VUServerManager.postComment(comment: comment,
                                      name: userName,
                                      email: userEmail,
                                      parentID: parentID) { (responceModel) in
                                        
          responceModel.comment = comment
          responceModel.name = userName
          responceModel.email = userEmail
                                        
          responceToPostComment(responceModel: responceModel,
                                parentID: parentID,
                                mainParentID: mainParentID,
                                newCommentCell: newCommentCell)
          }
        } else {
          
          VUServerManager.postReply(comment: comment,
                                    name: userName,
                                    email: userEmail,
                                    parentID: parentID) { (responceModel) in
          
          responceModel.comment = comment
          responceModel.name = userName
          responceModel.email = userEmail
                                      
          responceToPostComment(responceModel: responceModel,
                                parentID: parentID,
                                mainParentID: mainParentID,
                                newCommentCell: newCommentCell,
                                parentCommentModel: parentCommentModel,
                                parentCommentCell: parentCommentCell)
          }
        }
      }
    }
  }
  
  private static func getMainParentID(_ index: Int) -> String {
    
    var isContinue = true
    var tempIndex = index
    
    while isContinue  {
      
      if index > 0,
        let commentModel = modelsArray[tempIndex - 1] as? VUCommentModel {
        
         if commentModel.nestingLevel == 0,
          var mainParent = commentModel.commentID {
          
          mainParent = mainParent.replacingOccurrences(of: "R", with: "")
          isContinue = false
          return mainParent
          
        } else {
          tempIndex -= 1
        }
      } else {
        isContinue = false
      }
    }
    return "-1"
  }
  
  // TODO: • Responce for post comment
  private static func responceToPostComment(responceModel: VUPostResponceModel,
                                            parentID: String,
                                            mainParentID: String,
                                            newCommentCell: VUNewCommentCell,
                                            parentCommentModel: VUCommentModel? = nil,
                                            parentCommentCell: VUCommentCell? = nil) {
    
    if responceModel.commentID != nil {
      
      if isUpdatingUI == false {
        
        successToPostComment(responceModel: responceModel,
                             newCommentCell: newCommentCell,
                             mainParentID: mainParentID,
                             parentCommentModel: parentCommentModel,
                             parentCommentCell: parentCommentCell)
      } else {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          
          if isUpdatingUI == false {
            
            successToPostComment(responceModel: responceModel,
                                 newCommentCell: newCommentCell,
                                 mainParentID: mainParentID,
                                 parentCommentModel: parentCommentModel,
                                 parentCommentCell: parentCommentCell)
          } else {
            newCommentCell.hideProgress()
          }
        }
      }
    } else {
      errorToPostComment(responceModel, parentID: parentID)
      newCommentCell.hideProgress()
    }
  }
  
  // TODO: • Success result for post comment
  private static func successToPostComment(responceModel: VUPostResponceModel,
                                           newCommentCell: VUNewCommentCell,
                                           mainParentID: String,
                                           parentCommentModel: VUCommentModel? = nil,
                                           parentCommentCell: VUCommentCell? = nil) {
    
    hideNewReplyForm()
    
    if responceModel.isUnderModeration {
      
      if mainParentID == "-1" {
        
        VUAlertsHub.showHUD("Comment has been submitted",
                            image: .hudModerationIcon,
                            details: "and is under moderation")
      } else {
        
        VUAlertsHub.showHUD("Reply has been submitted",
                            image: .hudModerationIcon,
                            details: "and is under moderation")
      }
    } else {
      
      if mainParentID == "-1" {
        
        VUAlertsHub.showHUD("Comment has been published",
                            image: .hudSuccessIcon)
        
        if let commentID = responceModel.commentID {
          
          let commentModel = VUCommentModel(comment: responceModel.comment,
                                            commentID: commentID,
                                            name: responceModel.name,
                                            email: responceModel.email)
          
          insertNewComment(commentModel,
                           newCommentCell: newCommentCell)
        }
      } else {
        
        VUAlertsHub.showHUD("Reply has been published",
                            image: .hudSuccessIcon)
        
        if let commentID = responceModel.commentID,
          let parentModel = parentCommentModel,
          let parentCommentCell = parentCommentCell {
          
          let replyModel = VUCommentModel(comment: responceModel.comment,
                                          commentID: commentID,
                                          name: responceModel.name,
                                          email: responceModel.email,
                                          nestingLevel: parentModel.nestingLevel + 1)
          
          replyModel.parentID = mainParentID
         
          insertRepliesFor(parentCommentCell,
                           model: parentModel,
                           repliesArray: [replyModel],
                           isLocalReply: true)
        }
      }
    }
    
    NotificationCenter.default.post(name: VUGlobals.nNewCommentHideProgress,
                                    object: nil)
  }
  
  
  private static func insertNewComment(_ commentModel: VUCommentModel,
                                       newCommentCell: VUNewCommentCell) {
    
    isUpdatingUI = true
    
    if let newCommentIndex = modelsArray.index(where: { $0 is VUNewCommentModel }) {
      
      modelsArray.insert(commentModel, at: newCommentIndex + 1)
      
      VUGlobals.loadedCommetsCount += 1
      VUGlobals.totalCommentsCount += 1
      
      VUTableViewManager.insertRows(rowCount: 1,
                                    from: newCommentIndex + 1,
                                    animation: .top)
      newCommentCell.hideProgress()
      
    } else {
      isUpdatingUI = false
    }
  }
  
  // TODO: • Error result for post comment
  private static func errorToPostComment(_ responceModel: VUPostResponceModel, parentID: String) {
    
    if responceModel.isRepeatComment == true {
      
      if parentID == "-1" {
        VUAlertsHub.showAlert("📝 Repeat comment",
                              message: "Please, try not to repeat yourself.")
        return
        
      } else {
        VUAlertsHub.showAlert("📝 Repeat reply",
                              message: "Please, try not to repeat yourself.")
        return
      }
    }
    
    if VUInternetChecker.isOnline == false {
      VUAlertsHub.showAlert("🔌😐 Comments is offline",
                            message: "Please, check your device Wi-Fi and Cellural Data settings.")
      return
    }
    
    if parentID == "-1" {
      VUBugReportsFactory.showSendReportBUG(.errorPostComment,
                                            responceModel: responceModel)
    } else {
      VUBugReportsFactory.showSendReportBUG(.errorPostReply,
                                            responceModel: responceModel)
    }
  }
  
  
  // MARK: - REPORT COMMENT
  static func reportComment(_ index: Int, commentCell: VUCommentCell) {
    
    DispatchQueue.main.async {
      
      if let commentModel = modelsArray[index] as? VUCommentModel,
        commentModel.commentID != nil {
        
        if commentsInProgress.contains(commentCell) == false,
          let commentModel = modelsArray[index] as? VUCommentModel,
          let commentID = commentModel.commentID {
          
          commentCell.showProgress()
          commentsInProgress.append(commentCell)
          
          if let name = VUCurrentUser.name,
            let email = VUCurrentUser.email,
            VUParametersChecker.compare(name: commentModel.userName ,
                                        currentName: name,
                                        email: commentModel.userEmail,
                                        currentEmail: email) {
            
            VUAlertsHub.showAlert("😐 Trying to report yourself",
                                  message: "Please, don't try to report your own comments.")
            
            stopProgressFor(commentCell)
            return
          }
          
          if commentModel.isReported {
            
            VUAlertsHub.showAlert("⚠️ Duplicate report",
                                  message: "Please, don't try to report same comment more than once.")
            
            stopProgressFor(commentCell)
            return
          }
          
          askToReportComment(commentModel,
                             commentID: commentID,
                             commentCell: commentCell)
        } else {
          commentCell.hideProgress()
        }
      }
    }
  }
  
  // TODO: • Show alert to report
  private static func askToReportComment(_ commentModel: VUCommentModel,
                                         commentID: String,
                                         commentCell: VUCommentCell) {
    
    if let baseVC = VUCommentsBuilderModel.vBaseVC {
      
      baseVC.showQuestionAlert("📮 Report comment?",
                               message: "Moderator will check this comment.",
                               trueButtonText: "Report",
                               falseButtonText: "Cancel") { isReport in
        
        if isReport {
          requestToReportComment(commentModel,
                                 commentID: commentID,
                                 commentCell: commentCell)
        } else {
          stopProgressFor(commentCell)
        }
      }
    } else {
      stopProgressFor(commentCell)
    }
  }

  private static func requestToReportComment(_ commentModel: VUCommentModel,
                                             commentID: String,
                                             commentCell: VUCommentCell) {
    
    VUServerManager.reportComment(commentID: commentID,
                                  name: VUCurrentUser.name!,
                                  email: VUCurrentUser.email!) { (isReported, vuukleError)  in
      
      if isReported {
        
        successToReportComment(commentModel: commentModel,
                               commentID: commentID,
                               commentCell: commentCell)
      } else {
        errorActionWithComment(error: vuukleError,
                               commentCell: commentCell)
      }
    }
  }
  
  
  // TODO: • Success to report comment
  private static func successToReportComment(commentModel: VUCommentModel,
                                             commentID: String,
                                             commentCell: VUCommentCell) {
    
    commentModel.isReported = true
    
    if let indexPath = VUCommentsVC.sharedInstance.tableView.indexPath(for: commentCell) {
      VUTableViewManager.reloadRows([indexPath])
    }
    
    if let currentName = VUCurrentUser.name, let currentEmail = VUCurrentUser.email {
      
      let reportedKey = "\(currentName)\(currentEmail)reported\(commentID)"
      UserDefaults.standard.set("REPORTED", forKey: reportedKey)
    }
    
    stopProgressFor(commentCell)
    
    VUAlertsHub.showHUD("Comment has been reported",
                        image: .hudReportedIcon)
  }
  
  
  // MARK: - REPORT COMMENT
  static func voteForComment(_ index: Int,
                             voteType: VUCommentVoteType,
                             commentCell: VUCommentCell) {
    
    DispatchQueue.main.async {
      
      if let commentModel = modelsArray[index] as? VUCommentModel {
        
        if commentsInProgress.contains(commentCell) == false,
          let commentID = commentModel.commentID {
          
          commentCell.showProgress()
          commentsInProgress.append(commentCell)
          
          requestToVoteForComment(voteType,
                                  commentModel: commentModel,
                                  commentID: commentID,
                                  commentCell: commentCell)
        } else {
          commentCell.hideProgress()
        }
      }
    }
  }
  
  private static func requestToVoteForComment(_ voteType: VUCommentVoteType,
                                              commentModel: VUCommentModel,
                                              commentID: String,
                                              commentCell: VUCommentCell) {
    
    if commentModel.votedType != .none {
  
      VUAlertsHub.showAlert("📊 Duplicate vote",
                            message: "You can't vote for same the comment more than once.")
     
      stopProgressFor(commentCell)
      return
    }
    
    if VUParametersChecker.compare(name: commentModel.userName,
                                   currentName: VUCurrentUser.name!,
                                   email: commentModel.userEmail,
                                   currentEmail: VUCurrentUser.email!) {
      VUAlertsHub.showAlert("😐 Trying to vote yourself",
                            message: "Please, don't try to vote your own comments.")
      
      stopProgressFor(commentCell)
      return
    }
   
    VUServerManager.voteForComment(type: voteType,
                                   commentID: commentID,
                                   name: VUCurrentUser.name!,
                                   email: VUCurrentUser.email!) { (isVoted, vuukleError) in
      if isVoted {
        successToVoteFormComment(voteType,
                                 commentModel: commentModel,
                                 commentID: commentID,
                                 commentCell: commentCell)
      } else {
        errorActionWithComment(error: vuukleError,
                              commentCell: commentCell)
      }
    }
  }
  
  // TODO: • Success to vote for comment
  private static func successToVoteFormComment(_ voteType: VUCommentVoteType,
                                               commentModel: VUCommentModel,
                                               commentID: String,
                                               commentCell: VUCommentCell) {
    commentModel.votedType = voteType
    
    if let currentName = VUCurrentUser.name, let currentEmail = VUCurrentUser.email {
      
      let votedKey = "\(currentName)\(currentEmail)voted\(commentID)"
      
      switch voteType {
      
      case .upVote:
        UserDefaults.standard.set("VUUKLE_UP_VOTE", forKey: votedKey)
        
        commentModel.upVotes += 1
        VUTableViewManager.reloadComment(commentCell)
        
        if VUDesignHUB.commentCell.commentVotingStyle == .fingerIcons {
          
          VUAlertsHub.showHUD("Up voted successfully!",
                              image: .hudUpVotedIcon)
        } else {
          VUAlertsHub.showHUD("Up voted successfully!",
                              image: .hudSuccessIcon)
        }
        
      case .downVote:
        UserDefaults.standard.set("VUUKLE_DOWN_VOTE", forKey: votedKey)
        
        commentModel.downVotes += 1
        VUTableViewManager.reloadComment(commentCell)
        
        if VUDesignHUB.commentCell.commentVotingStyle == .fingerIcons {
          
          VUAlertsHub.showHUD("Down voted successfully!",
                              image: .hudDownVotedIcon)
        } else {
          VUAlertsHub.showHUD("Down voted successfully!",
                              image: .hudSuccessIcon)
        }
        
      default: break
      }
    }
    stopProgressFor(commentCell)
  }

  
  // MARK: - CONTINUE LAST ACTION
  private static func continueLastAction(_ action: VULoginActionType,
                                         commentCell: VUCommentCell) {
   
    switch action {
    
    case .reportComment:
      if let indexPath = VUCommentsVC.sharedInstance.tableView.indexPath(for: commentCell) {
        
        reportComment(indexPath.row,
                      commentCell: commentCell)
      }
    case .downVote:
      if let indexPath = VUCommentsVC.sharedInstance.tableView.indexPath(for: commentCell) {
        
        voteForComment(indexPath.row,
                       voteType: .downVote,
                       commentCell: commentCell)
      }
      
    case .upVote:
      if let indexPath = VUCommentsVC.sharedInstance.tableView.indexPath(for: commentCell) {
        
        voteForComment(indexPath.row,
                       voteType: .upVote,
                       commentCell: commentCell)
      }
    default: break
    }
  }
  

  // MARK: - SUPPORT METHODS
  private static func stopProgressFor(_ commentCell: VUCommentCell) {
    
    commentCell.hideProgress()
    
    if let index = commentsInProgress.index(of: commentCell) {
      commentsInProgress.remove(at: index)
    }
  }
  
  private static func errorActionWithComment(error: VURequestError?,
                                             commentCell: VUCommentCell? = nil) {
    
    if VUInternetChecker.isOnline == false {
      VUAlertsHub.showAlert("🔌😐 Comments is offline",
                            message: "Please, check your device Wi-Fi and Cellural Data settings.")
      
    } else if let vuukleError = error {
      VUBugReportsFactory.showSendReportBUG(vuukleError)
      
    } else {
      VUAlertsHub.showHUD("Please, try later",
                          image: .hudErrorIcon)
    }
    
    if let commentCell = commentCell {
      stopProgressFor(commentCell)
    }
  }
  
}
