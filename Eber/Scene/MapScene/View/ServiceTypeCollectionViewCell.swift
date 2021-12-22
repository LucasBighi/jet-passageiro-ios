//
//  ServiceTypeCollectionViewCell.swift
//  Cabtown
//
//  Created by Elluminati  on 07/09/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class ServiceTypeCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var imgServiceType: UIImageView!
    @IBOutlet weak var lblServiceTypeName: UILabel!
    
    deinit {
        printE("\(self) \(#function)")
    }
}
