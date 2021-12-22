//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

let ANIMATION_DURATION  = 0.25


public class CustomPhotoDialog: CustomDialog, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var alertView: UIView!
    var onImageSelected : ((UIImage) -> Void)? = nil
    weak var parent:UIViewController?
    let picker = UIImagePickerController()
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    var view:UIView?;
    var imageSelected:UIImage?;
    public override func awakeFromNib()
    {
        super.awakeFromNib();
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        
        self.addGestureRecognizer(tap)
        
        lblTitle?.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        btnRight.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnLeft.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
       
        
        
    }
    public static func showPhotoDialog(_ withTitle:String, andParent:UIViewController) -> CustomPhotoDialog
    {
        
        let view = UINib(nibName: "dialogForChoosePicture", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomPhotoDialog
        view.picker.delegate = view
        
        view.btnLeft.setTitle("TXT_GALLERY".localizedCapitalized, for: UIControl.State.normal)
        view.btnRight.setTitle("TXT_CAMERA".localizedCapitalized, for: UIControl.State.normal)
        view.lblTitle?.text = withTitle.localized;
        view.parent = andParent;
         view.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        
        
        view.frame = (APPDELEGATE.window?.frame)!;
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.alertView.frame = CGRect.init(x: view.center.x, y: view.center.y, width: 0, height: 0);
        return view
    }
    @objc func handleTap()
    {
        self.removeFromSuperview();
    }
    @IBAction func onClickBtnRight(_ sender: UIButton)
    {
        self.removeFromSuperview();
        checkCamera()
    }
    @IBAction func onClickBtnLeft(_ sender: UIButton)
    {
        self.removeFromSuperview();
        self.photoFromLibrary(nil)
    }
    
    //MARK: - Delegates
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            imageSelected = image
            if self.onImageSelected != nil
            {
                onImageSelected!(imageSelected!)
            }
            
            
        }
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageSelected = image
            if self.onImageSelected != nil
            {
                onImageSelected!(imageSelected!)
            }
            
        }
        else
        {
            imageSelected = nil
        }
        
        parent?.dismiss(animated: true, completion: nil)
        picker.delegate = nil
        self.picker.delegate = nil
        self.parent = nil
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        parent?.dismiss(animated: true, completion: nil)
        picker.delegate = nil
        self.picker.delegate = nil
        self.parent = nil
    }
    
    @IBAction func photoFromLibrary(_ sender: UIBarButtonItem?)
    {
        picker.navigationBar.tintColor = UIColor.black;
        picker.navigationBar.barTintColor = UIColor.white
        picker.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black]
        

        picker.allowsEditing = true
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        DispatchQueue.main.async {
            self.parent?.present(self.picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func photoFromCamera(_ sender: UIBarButtonItem?) {
       
        picker.navigationBar.tintColor = UIColor.black;
        picker.navigationBar.barTintColor = UIColor.white
        picker.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black]
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            picker.sourceType =   .camera
            picker.mediaTypes =   UIImagePickerController.availableMediaTypes(for: .camera)!
            picker.cameraFlashMode = .on
            DispatchQueue.main.async {
                self.parent?.present(self.picker, animated: true, completion: nil)
            }
        }
        else
        {
            let alertController = UIAlertController(title: "Camera Error", message: "Camera is not available", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            DispatchQueue.main.async {
                self.parent?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    public override func removeFromSuperview()
    {
        super.removeFromSuperview();
    }
    
    func checkCamera()
    {

        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus
        {
        case .authorized:
              self.photoFromCamera(nil)
        case .denied: alertPromptToAllowCameraAccessViaSetting()
        case .notDetermined: alertToEncourageCameraAccessInitially()
        default:alertToEncourageCameraAccessInitially()
            
            
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [unowned self] success in
            if  success
            {
                self.photoFromCamera(nil)
            }
        })
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let dialogForPermission = CustomAlertDialog.showCustomAlertDialog(title: "IMPORTANT".localized, message: "Camera access required for capturing photos!".localized, titleLeftButton: "".localized, titleRightButton: "TXT_OK".localized)
            dialogForPermission.onClickLeftButton =
                { [/*unowned self,*/ unowned dialogForPermission] in
                    dialogForPermission.removeFromSuperview();
            }
            dialogForPermission.onClickRightButton =
                { [/*unowned self,*/ unowned dialogForPermission] in
                    dialogForPermission.removeFromSuperview();
                   
                }
       
    }
    
}


