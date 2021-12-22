//
//  AlertDialogViewController.swift
//  Moby App
//
//  Created by Lucas Marques Bighi on 07/12/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class AlertDialogViewController: UIViewController {

    enum AlertType {
        case ok, continueCancel
    }

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var type: AlertType = .ok
    var icon: UIImage?
    var message: String?
    var buttonTitle: String?

    var okActionHandler: ((AlertDialogViewController) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.image = icon
        messageLabel.text = message
        cancelButton.setTitle("TXT_ALERT_DIALOG_CANCEL".localized, for: .normal)
        cancelButton.isHidden = type == .ok
        okButton.setTitle(type == .ok
                            ? "TXT_ALERT_DIALOG_OK".localized
                            : "TXT_ALERT_DIALOG_CONTINUE".localized, for: .normal)
    }

    @IBAction func okAction(_ sender: UIButton) {
        okActionHandler?(self)
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: false)
    }
}

extension UIViewController {
    func showAlertDialog(type: AlertDialogViewController.AlertType = .ok,
                         icon: UIImage? = UIImage(named: "box-important"),
                         message: String,
                         _ okHandler: ((AlertDialogViewController) -> Void)? = nil) {
        let alertVC = AlertDialogViewController(nibName: "AlertDialogViewController",
                                                bundle: nil)
        alertVC.type = type
        alertVC.icon = icon
        alertVC.message = message
        alertVC.okActionHandler = okHandler
        alertVC.modalPresentationStyle = .overCurrentContext
        present(alertVC, animated: false)
    }
}
