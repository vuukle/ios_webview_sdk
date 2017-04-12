//
//  VUTableViewCellsFactory.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit


class VUTableViewManager {
  
  // MARK: - • Reload
  static func reloadComment(_ commentCell: VUCommentCell) {
    
    if VUModelsFactory.isUpdatingUI == false,
      let indexPath = VUCommentsVC.sharedInstance.tableView.indexPath(for: commentCell) {
     
      VUModelsFactory.isUpdatingUI = true
      
      VUCommentsBuilderModel.setTempHeight()
      
      VUCommentsVC.sharedInstance.tableView.beginUpdates()
      VUCommentsVC.sharedInstance.tableView.reloadRows(at: [indexPath],
                                                       with: .none)
      VUCommentsVC.sharedInstance.tableView.endUpdates()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        VUCommentsBuilderModel.updateTableViewHeight()
      }
      
      VUModelsFactory.isUpdatingUI = false
    }
  }
  
  static func reloadRows(_ indexesArray: [IndexPath]) {
    
    VUCommentsBuilderModel.setTempHeight()
    
    VUCommentsVC.sharedInstance.tableView.beginUpdates()
    VUCommentsVC.sharedInstance.tableView.reloadRows(at: indexesArray,
                                                     with: .none)
    VUCommentsVC.sharedInstance.tableView.endUpdates()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      VUCommentsBuilderModel.updateTableViewHeight()
    }
    
    VUModelsFactory.isUpdatingUI = false
  }
  
  
  // MARK: - • Insert rows
  static func insertRows(rowCount: Int,
                         from: Int,
                         animation: UITableViewRowAnimation,
                         commentCell: VUCommentCell? = nil) {
    
    var indexPathArray = [IndexPath]()
    
    if rowCount > 0 {
      for i in 0..<rowCount {
        indexPathArray.append(IndexPath(row: from + i, section: 0))
      }
    }
    
    VUCommentsBuilderModel.setTempHeight()
    
    VUCommentsVC.sharedInstance.tableView.beginUpdates()
    VUCommentsVC.sharedInstance.tableView.insertRows(at: indexPathArray,
                                                     with: animation)
    
//    if let loadMoreIndex = VUModelsFactory.modelsArray.index(where: { $0 is VULoadMoreModel }) {
//      
//      let reloadIndexPath = IndexPath(row: loadMoreIndex, section: 0)
//      VUCommentsVC.sharedInstance.tableView.reloadRows(at: [reloadIndexPath],
//                                                       with: .none)
//    }
    VUCommentsVC.sharedInstance.tableView.endUpdates()
    
    if let commentCell = commentCell,
      let commentIndex = VUModelsFactory.commentsInProgress.index(of: commentCell) {
      
      VUModelsFactory.commentsInProgress.remove(at: commentIndex)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      VUCommentsBuilderModel.updateTableViewHeight()
    }
    
    VUModelsFactory.isUpdatingUI = false
  }
  
  static func insertReplyRows(rowCount: Int,
                              from: Int,
                              commentCell: VUCommentCell) {
    
    var repliesIndexPaths = [IndexPath]()
    
    if rowCount > 0 {
      for i in 1...rowCount {
        repliesIndexPaths.append(IndexPath(row: from + i, section: 0))
      }
    }
    
    let reloadIndex = IndexPath(row: from, section: 0)
    
    VUCommentsBuilderModel.setTempHeight()
    
    VUCommentsVC.sharedInstance.tableView.beginUpdates()
    VUCommentsVC.sharedInstance.tableView.reloadRows(at: [reloadIndex],
                                                     with: .none)
    VUCommentsVC.sharedInstance.tableView.insertRows(at: repliesIndexPaths,
                                                     with: .top)
    VUCommentsVC.sharedInstance.tableView.endUpdates()
    
    if let commentIndex = VUModelsFactory.commentsInProgress.index(of: commentCell) {
      VUModelsFactory.commentsInProgress.remove(at: commentIndex)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      VUCommentsBuilderModel.updateTableViewHeight()
    }
    
    VUModelsFactory.isUpdatingUI = false
  }
  
  
  // MARK: - • Delete rows
  static func deleteRows(deleteIndex: Int,
                         animation: UITableViewRowAnimation,
                         commentCell: VUCommentCell? = nil) {
    
    let deleteIndex = IndexPath(row: deleteIndex, section: 0)
    
    VUCommentsBuilderModel.setTempHeight()
    
    VUCommentsVC.sharedInstance.tableView.beginUpdates()
    VUCommentsVC.sharedInstance.tableView.deleteRows(at: [deleteIndex],
                                                     with: animation)
    VUCommentsVC.sharedInstance.tableView.endUpdates()
    
    if let commentCell = commentCell,
      
      let commentIndex = VUModelsFactory.commentsInProgress.index(of: commentCell) {
      VUModelsFactory.commentsInProgress.remove(at: commentIndex)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      VUCommentsBuilderModel.updateTableViewHeight()
    }
    
    VUModelsFactory.isUpdatingUI = false
  }
  
  
  static func deleteReplyRows(rowCount: Int,
                              from: Int,
                              commentCell: VUCommentCell) {
    
    var repliesIndexPaths = [IndexPath]()
    
    if rowCount > 0 {
      for i in 1...rowCount {
        repliesIndexPaths.append(IndexPath(row: from + i, section: 0))
      }
    }
    let reloadIndex = IndexPath(row: from, section: 0)
    
    VUCommentsVC.sharedInstance.tableView.beginUpdates()
    VUCommentsVC.sharedInstance.tableView.reloadRows(at: [reloadIndex],
                                                     with: .none)
    VUCommentsVC.sharedInstance.tableView.deleteRows(at: repliesIndexPaths,
                                                     with: .bottom)
    VUCommentsVC.sharedInstance.tableView.endUpdates()
    
    if let lIndex = VUModelsFactory.commentsInProgress.index(of: commentCell) {
      VUModelsFactory.commentsInProgress.remove(at: lIndex)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      VUCommentsBuilderModel.updateTableViewHeight()
    }
    
    VUModelsFactory.isUpdatingUI = false
  }
  
}
