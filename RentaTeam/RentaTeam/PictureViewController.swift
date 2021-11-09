//
//  PictureViewController.swift
//  RentaTeam
//
//  Created by Flash Jessi on 11/9/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    var imageVC: UIImage?
    var desc: String?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Cat"
        getInformation()
        imageSizeSetting()
    }
    
    private func getInformation() {
        image.image = imageVC
        descLabel.text = desc
        dateLabel.text = date
    }
    
    private func imageSizeSetting() {
        guard let imageVC = imageVC else {
            return
        }
        let ratio = imageVC.size.width / imageVC.size.height
        let newWidth = view.frame.width
        width.constant = newWidth
        let newHeight = newWidth / ratio
        height.constant = newHeight
    }

}
