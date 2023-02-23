//
//  HomeTiles.swift
//  StatsScanner
//
//  Created by Kamran on 12/30/21.
//

import UIKit

/// Class that sets up each tile on the home screen and stylizes each of them. Also contains fields that are needed for other classes to access
///
///- Authors: Kamran Hussain
class HomeTiles: UICollectionViewCell {
    
    static let identifier = "hometile" /// Static identifing string that cannot be changed or modified
    
    @IBOutlet var myImageView: UIImageView!         /// Image view that displays the dataset icon
    @IBOutlet weak var dataSetName: UILabel!        /// Dataset name that can be supplied by either the dataset or the Dataset Project
    @IBOutlet weak var creationDate: UILabel!       /// Creation date that is logged in the dataset and displayed on the tile. This is done to help the user differentiate between two datasets with the same name
    @IBOutlet var numitems: UILabel!                /// Label that displays a string representing the total number of elements in the dataset
    @IBOutlet var openDataset: UIButton!            /// Button that opens the dataset in the informatic view. Fetches the dataset and moves to a new view controller
    
    /// Creates cell view and stylizes the elements including drop shadow, buttons, and dataset icon. All parameters are fields of this class, fields should be edited to change the cells attributes.
    ///
    ///  - Authors: Kamran Hussain
    override func layoutSubviews() {
        contentView.backgroundColor = .secondarySystemFill
        // cell rounded section
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        dataSetName.adjustsFontSizeToFitWidth = true
        dataSetName.baselineAdjustment = UIBaselineAdjustment.alignCenters
        creationDate.adjustsFontSizeToFitWidth = true
        creationDate.baselineAdjustment = UIBaselineAdjustment.alignCenters
        numitems.adjustsFontSizeToFitWidth = true
        numitems.baselineAdjustment = UIBaselineAdjustment.alignCenters
        openDataset.titleLabel?.textColor = .white
        openDataset.titleLabel?.adjustsFontForContentSizeCategory = true
        openDataset.titleLabel?.adjustsFontSizeToFitWidth = true
        openDataset.titleLabel?.minimumScaleFactor = 0.25
        openDataset.titleLabel?.baselineAdjustment = UIBaselineAdjustment.alignCenters
        openDataset.titleLabel?.numberOfLines = 1
        
        contentView.clipsToBounds = true
    }
    
}

class Footer: UIView {
    
    static let identifier = "footerview"
    
    @IBOutlet var infofooter : UIButton!
    
    override func layoutSubviews() {
        self.frame.size.width = UIScreen.main.bounds.width
        infofooter.setTitle(UIApplication.versionBuild() + "  ", for: .normal)
        infofooter.semanticContentAttribute = .forceRightToLeft
        addSubview(infofooter)
        infofooter.showsMenuAsPrimaryAction = true
        
        let login = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Log Out", image: UIImage(systemName: "power"), attributes: .destructive) { (action) in
                print("log out")
            },
            UIAction(title: "Profile", image: UIImage(systemName: "person.circle")) { (action) in
                print("profile")
            }
        ])
        let actions = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Contact Us", image: UIImage(systemName: "mail")) { (action) in
                print("contact us")
            },
            UIAction(title: "Upgrade", image: UIImage(systemName: "arrow.up.circle")) { (action) in
                print("upgrade")
            },
            UIAction(title: "Watch Tutorial", image: UIImage(systemName: "play.rectangle.on.rectangle")) { (action) in
                if let rr = URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ") {
                    UIApplication.shared.open(rr)
                }
            }
        ])
        let settingsMenu = UIMenu(title: "Settings", children: [
            actions, login
        ])
        infofooter.menu = settingsMenu
    }
}
