//
//  JETanjoTableViewCell.swift
//  JET
//
//  Created by Lucas Marques Bighi on 14/12/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class JETanjoTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!

    override func awakeFromNib() {
        userImageView.setRound()
        addButton.setSimpleIconButton()
    }

    func setup(data: JETanjoModel) {
        userImageView.downloadedFrom(link: data.picturePath)
        usernameLabel.text = "\(data.firstName) \(data.lastName)"
    }
}
