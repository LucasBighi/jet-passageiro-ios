//
//  PictureDialogViewController.swift
//  JET
//
//  Created by Lucas Marques Bighi on 08/12/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class PictureDialogViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var btnBack: UIButton!

    var picture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        pictureImageView.image = picture

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
    }

    private func setupBackButton() {
        btnBack.setupBackButton()
        btnBack.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}

extension PictureDialogViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pictureImageView
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(1, animated: true)
    }
}
