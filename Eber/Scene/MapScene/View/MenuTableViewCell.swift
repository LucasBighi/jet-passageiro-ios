//
//  MenuTableViewCell.swift
//  Moby App
//
//  Created by Lucas Marques Bighi on 03/12/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func setup(item: (String, String)) {
        titleLabel.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        titleLabel.text = item.0
        iconImageView.image = UIImage(named: item.1)
    }
}
