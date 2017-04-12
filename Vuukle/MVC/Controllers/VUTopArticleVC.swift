//
//  VUTopArticleVC.swift
//  Vuukle
//
//  Created by MAC  on 2/27/17.
//  Copyright © 2017 Alex Chaku. All rights reserved.
//

import UIKit

class VUTopArticleVC: UIViewController {

  // Singleton
  static let sharedInstance: VUTopArticleVC = UIStoryboard(name: "Vuukle", bundle: Bundle(for: VUTopArticleVC.self)).instantiateViewController(withIdentifier: VUIdentifiersUI.VUTopArticleVC) as! VUTopArticleVC
  
  @IBOutlet weak var tableView: UITableView!
  var topArticleArray: [VUTopArticleModel]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadTopArticles()
    registerCellsFromNib()
    tableView.estimatedRowHeight = 100
    setDefaultHeight()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func registerCellsFromNib() {
    let nibTopArticle = UINib(nibName: "VUTopArticleCell",
                              bundle: Bundle(for: VUCommentsVC.self))
    tableView.register(nibTopArticle,
                       forCellReuseIdentifier: VUIdentifiersUI.VUTopArticleCell)
  }
  private func loadTopArticles() {
    
    VUServerManager.getTopArticles() { (responceArray, error) in
      if let articlesArray = responceArray, articlesArray.count > 0 {
        self.topArticleArray = articlesArray as? [VUTopArticleModel]
        self.tableView.reloadData()
      }
    }
  }
  
  private func setDefaultHeight() {
    VUCommentsBuilderModel.setDefaultTopArticleHeight()
  }

  
}

// MARK: - UITableViewDataSource
extension VUTopArticleVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return topArticleArray?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: VUIdentifiersUI.VUTopArticleCell) as? VUTopArticleCell ?? VUTopArticleCell()
    
    cell.delegate = self
    if let topArticleArray = topArticleArray {
     let topArticleModel = topArticleArray[indexPath.row]
      cell.setArticle(title: topArticleModel.articleTitle,
                      date: topArticleModel.articleDate,
                      commentsCount: topArticleModel.commentsCount,
                      imageURL: topArticleModel.imageURL)
    }
    checkRowUpdateHeight(indexPath)

    return cell
  }
  
  private func checkRowUpdateHeight(_ indexPath: IndexPath) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      if let topArticleArray = self.topArticleArray {
        if indexPath.row == topArticleArray.count - 1 {
          VUCommentsBuilderModel.updateTopArticleTableViewHeight()
        }
      }
    }
  }

}

// MARK: - UITableViewDelegate

extension VUTopArticleVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}

// MARK: - VUTopArticleCellDelegate
extension VUTopArticleVC: VUTopArticleCellDelegate {
  
  func openTopArticle(_ topArticleCell: VUTopArticleCell, button: UIButton) {
    
    if let indexPath = tableView.indexPath(for: topArticleCell) {
      
      if let topArticleArray = topArticleArray {
        let topArticleModel = topArticleArray[indexPath.row]
        
        VUModelsFactory.openTopArticle(topArticleModel)
      }
    }
  }
  
}
