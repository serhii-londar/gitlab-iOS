//
//  UserTableViewCell.swift
//  gitlab-iOS
//
//  Created by Xplorld on 2016/3/21.
//  Copyright © 2016年 dyweb. All rights reserved.
//

import UIKit
import TagListView

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var stateTags: TagListView!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 5.0
        avatarImageView.clipsToBounds = true
    }
}

class UserTableViewCellViewModel : TableViewCellViewModel {
    
    let user:User
    init(user:User) {
        self.user = user
    }
    
    @objc let cellIdentifier =  "UserCell"
    
    @objc func configureCell(cell:UITableViewCell) {
        let theCell = cell as! UserTableViewCell
        theCell.nameLabel.text = user.name
        theCell.IDLabel.text = "#\(user.id)"
        theCell.emailLabel.text = user.email ?? user.website_url
        
        UIImage.imageFromURL(URL: user.avatar_url) {
            theCell.avatarImageView.image = $0
        }
        
        theCell.stateTags.removeAllTags()
        guard let state = user.state else {return}
        theCell.stateTags.addTag(state).tagBackgroundColor = LabelTinter.darkRed()
        
    }
    
    @objc func didSelectCell(indexPath: NSIndexPath, controller: RYTableViewController) {
        
    }
    @objc var resetAfterSelect = true
}