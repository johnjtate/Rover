//
//  PhotoDetailViewController.swift
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func updateViews() {
        
        
        
        
    }
    
// landing pad for segue
    var photo: JJTPhoto? {
        didSet {
            updateViews()
        }
    }
    
    

}
