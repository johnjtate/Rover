//
//  PhotoDetailViewController.swift
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    // MARK: - IBOutlets
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var solLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func updateViews() {
        guard isViewLoaded else { return }
        guard let photo = photo else {
            imageView.image = #imageLiteral(resourceName: "MarsPlaceholder")
            cameraLabel.text = ""
            solLabel.text = ""
            dateLabel.text = ""
            return
        }
        
        cameraLabel.text = photo.cameraName
        solLabel.text = "\(photo.solPhotoWasTaken)"
        dateLabel.text = PhotoDetailViewController.dateFormatter.string(from: photo.earthDateOfPhoto)
        
        let cache = JJTPhotoCache.shared
        if let imageData = cache?.imageData(forIdentifier: photo.photoIdentifier),
            let image = UIImage(data: imageData) {
            imageView.image = image
        } else {
            client.fetchImageData(for: photo) { (data, error) in
            
                if error != nil || data == nil {
                    NSLog("Error fetching photo for: \(String(describing: error))")
                    return
                }
                
                if let image = UIImage(data: data!),
                    self.photo == photo {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
// landing pad for segue
    var photo: JJTPhoto? {
        didSet {
            updateViews()
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    private let client = JJTMarsRoverClient()

}
