//
//  VUFailureVC.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit


class VUFailureVC: UIViewController {
  
  /* Singleton*/
  static let sharedInstance: VUFailureVC = UIStoryboard(name: "Vuukle", bundle: Bundle(for: VUFailureVC.self)).instantiateViewController(withIdentifier: VUIdentifiersUI.VUFailureVC) as! VUFailureVC
  
  
  // MARK: - Class varibles
  var errorMessage = ""
  
  
  // MARK: - @IBOutlets
  @IBOutlet weak var errorMessageLabel: UILabel!
  @IBOutlet weak var errorImageView: UIImageView!
  @IBOutlet weak var vuukleVersionLabel: UILabel!
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  
    errorMessageLabel.text = "ERROR: \(errorMessage)"
    vuukleVersionLabel.text = "pod 'Vuukle', version \(VUGlobals.vuukleVersion)"
    
    if errorMessage == "Vuukle is offline" {
      errorImageView.image = UIImage(assetIdentifier: .offlineIcon)
    }
  }
  
}
