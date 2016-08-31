//
//  MoreView.swift
//  Vuukle Comment
//
//  Created by Admin on 03.08.16.
//  Copyright © 2016 Midgets. All rights reserved.
//

import UIKit

class MoreView: UIView {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    static func loadViewFromNib() -> MoreView
    {
        let nib = UINib(nibName: "MoreView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! MoreView
        return view
    }

}
