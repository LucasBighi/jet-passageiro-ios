//
//  ProfileVC.swift
//  Cabtown
//
//  Created by Elluminati on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
class ProfileVC: BaseVC,OtpDelegate
{

//MARK:- Outlets Declaration
    
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationHeight: NSLayoutConstraint!
  
    @IBOutlet weak var scrProfile: UIScrollView!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var btnSelectCountry: UIButton!
    @IBOutlet weak var txtFirstName: ACFloatingTextfield!
    @IBOutlet weak var txtLastName: ACFloatingTextfield!

    @IBOutlet weak var txtEmail: ACFloatingTextfield!
    @IBOutlet weak var txtMobileNumber: ACFloatingTextfield!
    @IBOutlet weak var txtNewPassword: ACFloatingTextfield!
    @IBOutlet weak var txtCpf: ACFloatingTextfield!
    @IBOutlet weak var btnChangePicuture: UIButton!
    
    @IBOutlet var btnHideShowPassword: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var viewForNewPassword: UIView!
    @IBOutlet weak var btnChangePassword: UIButton!
//MARK:- Variable Declaration
    var arrForCountryList:[Country] = []
    var isPicAdded:Bool = false
    var phoneNumberLength = 10
    var dialogForImage:CustomPhotoDialog?;
    var password:String = "";
    var strCountryId:String? = ""
    var strForCountryPhoneCode:String = ""
    let user = CurrentTrip.shared.user
//MARK:- View LifeCycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imgProfilePic.contentMode = .scaleAspectFit
        
        if CurrentTrip.shared.arrForCountries.isEmpty
        {
            wsGetCountries()
        }
        initialViewSetup()
        
        if user.socialUniqueId.isEmpty
        {
            viewForNewPassword.isHidden = false
        }
        else
        {
            viewForNewPassword.isHidden = true
            
       }
       setProfileData();
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
        
    }
    @IBAction func onClickBtnHideShowPassword(_ sender: Any) {
        
        txtNewPassword.isSecureTextEntry = !txtNewPassword.isSecureTextEntry
        btnHideShowPassword.isSelected.toggle()
    }
    override func viewDidLayoutSubviews(){
       super.viewDidLayoutSubviews();
       navigationView.navigationShadow()
       imgProfilePic.setRound()
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
    }
    func  initialViewSetup()
    {
        
        view.backgroundColor = UIColor.themeViewBackgroundColor;
        self.scrProfile.backgroundColor = UIColor.themeViewBackgroundColor;
        
        lblTitle.text = "TXT_PROFILE".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        

        
       
        btnChangePassword.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnChangePassword.setTitleColor(UIColor.themeTextColor, for: .selected)
        btnChangePassword.setTitle("TXT_CHANGE".localizedCapitalized, for: .normal)
        btnChangePassword.setTitle("TXT_CANCEL".localizedCapitalized, for: .selected)

        txtFirstName.placeholder = "TXT_FIRST_NAME".localized
        txtFirstName.text = "".localized
        
        txtLastName.placeholder = "TXT_LAST_NAME".localized
        txtLastName.text = "".localized
        
        txtEmail.placeholder = "TXT_EMAIL".localized
        txtEmail.text = "".localized
        
        txtNewPassword.placeholder = "TXT_NEW_PASSWORD".localized
        txtNewPassword.text = "".localized
        
        txtMobileNumber.placeholder = "TXT_PHONE_NO".localized
        txtMobileNumber.text = "".localized
        
        
        btnSelectCountry.setTitle("TXT_DEFAULT".localizedCapitalized, for: .normal)
        btnSelectCountry.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnSelectCountry.setTitleColor(UIColor.themeButtonBackgroundColor  , for: .normal)
      
        btnSave.setTitle(FontAsset.icon_edit, for: .normal)
        btnSave.setTitle(FontAsset.icon_checked, for: .selected)
        
        btnSave.setTitleColor(UIColor.themeTextColor  , for: .normal)
        btnSave.setUpTopBarButton()
        btnHideShowPassword.setTitle(FontAsset.icon_hide_password, for: .normal)
        btnHideShowPassword.setTitle(FontAsset.icon_show_password  , for: .selected)
        btnHideShowPassword.titleLabel?.font = FontHelper.assetFont(size: 25)
        btnHideShowPassword.setSimpleIconButton()
        
        
        btnMenu.setupBackButton()
    }

    func onOtpDone()
    {
        self.openVerifyAccountDialog()
    }
    @IBAction func onClickBtnCountryDialog(_ sender: Any) {
        openCountryDialog()
    }
    
//MARK:- Action Methods
    
    @IBAction func onClickBtnChangePassword(_ sender: Any)
    {
        self.view.endEditing(true)
        
        txtNewPassword.text = ""
        btnChangePassword.isSelected = !btnChangePassword.isSelected
        txtNewPassword.isEnabled = !txtNewPassword.isEnabled
        if btnChangePassword.isSelected
        {
           _ =  txtNewPassword.becomeFirstResponder()
        }
    }
    
    @IBAction func onClickBtnSave(_ sender: Any) {
        self.view.endEditing(true)
        editProfile()
        btnSave.setTitle(FontAsset.icon_checked, for: .normal)
        
    }
    @IBAction func onClickBtnEditImage(_ sender: Any)
    {
        openImageDialog()
    }
    func openImageDialog(){
        self.view.endEditing(true)
       dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
        dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage]
            (image:UIImage) in
            self.imgProfilePic.image = image
            self.isPicAdded = true
            dialogForImage?.removeFromSuperviewAndNCObserver()
            dialogForImage = nil
        }
    }
    
    
//MARK:- User Define Methods
    func  checkValidation() -> Bool{
        
        
        if (
                (((txtEmail.text?.count)!  < 1)  &&  preferenceHelper.getIsEmailVerification())  ||
                (txtMobileNumber.text?.count)!  < 1
            )
        {
            if ((txtEmail.text!.isEmpty())  &&  preferenceHelper.getIsEmailVerification())
            {
                txtEmail.showErrorWithText(errorText:"VALIDATION_MSG_ENTER_EMAIL".localized );
               scrProfile.scrollRectToVisible(txtEmail.frame, animated: true)
            }
            else if ((txtMobileNumber.text?.isEmpty()) ?? true)
            {
                txtMobileNumber.showErrorWithText(errorText:"VALIDATION_MSG_ENTER_PHONE_NUMBER".localized );
                
                scrProfile.scrollRectToVisible(txtMobileNumber.frame, animated: true)
            }
            else
            {
                
            }
            return false;
            
        }
        else
        {
            
            let validPhoneNumber = txtMobileNumber.text!.isValidMobileNumber()
            
            if(!txtEmail.text!.isValidEmail() &&  preferenceHelper.getIsEmailVerification())
            {
                txtEmail.showErrorWithText(errorText: "VALIDATION_MSG_INVALID_EMAIL".localized)
               scrProfile.scrollRectToVisible(txtEmail.frame, animated: true)
                return false
            }
            else if validPhoneNumber.0 == false
            {
                txtMobileNumber.showErrorWithText(errorText: validPhoneNumber.1)
                return false
                
            }
            else
            {
                    if (!txtNewPassword.isEnabled)
                    {
                        return true
                    }
                    else if (
                        (txtNewPassword.text?.count)! < passwordLength )
                    {
                      
                        let myString = String(format: NSLocalizedString("MSG_PLEASE_ENTER_VALID_PASSWORD", comment: ""),String(passwordLength))
                        
                        txtNewPassword.showErrorWithText(errorText: myString)
                        scrProfile.scrollRectToVisible(txtNewPassword.frame, animated: true)
                 
                        return false

                    }
                    else
                    { return true     }
                
          }
        
        }
    }
    func enableTextFields(enable:Bool) -> Void{
        txtNewPassword.isEnabled = enable
        btnChangePassword.isEnabled = enable
        btnHideShowPassword.isEnabled = enable
        
    }
    func setProfileData(){
        txtFirstName.text = user.firstName
        txtLastName.text = user.lastName

        txtMobileNumber.text = user.phone;
        btnSelectCountry.setTitle(user.countryPhoneCode, for: .normal)
        btnChangePassword.isSelected = false
        txtEmail.text = user.email
        txtCpf.text = user.cpf
        txtNewPassword.isHidden = false
        if !user.picture.isEmpty
        {
        imgProfilePic.downloadedFrom(link: user.picture)
        }
       strForCountryPhoneCode = user.countryPhoneCode
        enableTextFields(enable: false)
        
        
    }
    func  editProfile() -> Void{
        
        if (!txtNewPassword.isEnabled)
        {
            enableTextFields(enable: true)
          _ =  txtNewPassword.becomeFirstResponder()
        }
        else
        {
            if (checkValidation())
            {
                 switch (self.checkWhichOtpValidationON())
                {
                case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                      wsGetOtp(isEmailOtpOn: true, isSmsOtpOn: true)
                    break;
                case CONSTANT.SMS_VERIFICATION_ON:
                    wsGetOtp(isEmailOtpOn: false, isSmsOtpOn: true)
                    break;
                case CONSTANT.EMAIL_VERIFICATION_ON:
                    wsGetOtp(isEmailOtpOn: true, isSmsOtpOn: false)
                    break;
                default:
                    self.openVerifyAccountDialog();
                    break;
                }
            }
        }
        
    }

   
    @IBAction func onClickBtnMenu(_ sender: Any)
    {
        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController
        {
            navigationVC.popToRootViewController(animated: true)
        }
    }
//MARK:_ Dialog Methods
    func checkWhichOtpValidationON() -> Int{
        if (checkEmailVerification() && checkPhoneNumberVerification())
        {
            return CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON;
        }
        else if (checkPhoneNumberVerification())
        {
            return CONSTANT.SMS_VERIFICATION_ON;
        }
        else if (checkEmailVerification())
        {
            return CONSTANT.EMAIL_VERIFICATION_ON;
        }
        return 0;
    }
    func checkEmailVerification() -> Bool{
        return preferenceHelper.getIsEmailVerification() && !(txtEmail.text!.compare(user.email) == ComparisonResult.orderedSame)
        
    }
    func checkPhoneNumberVerification() -> Bool{
        
        return preferenceHelper.getIsPhoneNumberVerification() && !(txtMobileNumber.text! == user.phone)
        

    }
    
    func openVerifyAccountDialog()
    {
        self.view.endEditing(true)
        
       if !user.socialUniqueId.isEmpty
       {
        self.password = ""
        self.wsUpdateProfile();
       }
    
        else
        {
            let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localized, message: "".localized, titleLeftButton: "TXT_NO".localized, titleRightButton: "TXT_YES".localized, editTextHint: "TXT_CURRENT_PASSWORD".localized,  editTextInputType: true)
            dialogForVerification.onClickLeftButton =
                { [unowned dialogForVerification] in
                    dialogForVerification.removeFromSuperview();
            }
            dialogForVerification.onClickRightButton =
                { [unowned self, unowned dialogForVerification] (text:String) in
                    
                    if (text.count <  passwordLength)
                    {
                        if text.isEmpty
                        {
                            dialogForVerification.editText.showErrorWithText(errorText: "VALIDATION_MSG_ENTER_PASSWORD".localized)
                            
                        }
                        else
                        {
                            let myString = String(format: NSLocalizedString("MSG_PLEASE_ENTER_VALID_PASSWORD", comment: ""),String(passwordLength))
                            
                            dialogForVerification.editText.showErrorWithText(errorText: myString)
                        }
                        
                    }
                    else
                    {
                        
                        self.password = text
                        self.wsUpdateProfile();
                        dialogForVerification.removeFromSuperview();
                    }
            }
        }

    }
    
    func openCountryDialog()
    {
        self.view.endEditing(true)
        self.view.endEditing(true)
        let dialogForCountry  = CustomCountryDialog.showCustomCountryDialog()
        dialogForCountry.onCountrySelected =
            { [unowned self, unowned dialogForCountry]
                (country:Country) in
                printE(country.countryName!)
                if country.countryPhoneCode != self.strForCountryPhoneCode
                {
                    self.txtMobileNumber.text = ""
                    self.strForCountryPhoneCode = country.countryPhoneCode
                    self.btnSelectCountry.setTitle(self.strForCountryPhoneCode, for: .normal)
                    preferenceHelper.setMinPhoneNumberLength(country.phoneNumberMinLength)
                    preferenceHelper.setMaxPhoneNumberLength(country.phoneNumberLength)
                    
                    
                }
                dialogForCountry.removeFromSuperview()
        }
    }

   
}

//MARK: - UITextField Delegate Methods
extension ProfileVC :UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        if textField == txtFirstName
        {
            _ = txtLastName.becomeFirstResponder()
        }
        if textField == txtLastName
        {
            _ = txtEmail.becomeFirstResponder()
        }
        else if textField == txtEmail
        {
            _ = txtMobileNumber.becomeFirstResponder()
        }
        else if textField == txtMobileNumber
        {
             _ =  textField.resignFirstResponder();
        }
        else
        {
            _ =   textField.resignFirstResponder();
            return true
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtMobileNumber
        {
               if (string == "") || string.count < 1
                {
                    return true
                }
               else
                {
                    let compSepByCharInSet = string.components(separatedBy: numberSet)
                    let numberFiltered = compSepByCharInSet.joined(separator: "")
                    
                    if string == numberFiltered
                    {
                        if textField == txtMobileNumber
                        {
                            if txtMobileNumber.text!.count >= preferenceHelper.getMaxPhoneNumberLength() && range.length == 0
                            {
                                _ =  txtMobileNumber.becomeFirstResponder()
                                return false
                            }
                            else
                            {
                                
                                return true;
                            }
                        }
                        return true;
                    }
                    else
                    {
                        return false
                    }
                    
                }
        }
        return true;
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


//MARK:- Web Service Calls
extension ProfileVC
{
    func wsUpdateProfile()
    {
        let name = txtFirstName.text!.trim()
        let lastname = txtLastName.text!.trim()
       
        let dictParam : [String : Any] =
            [PARAMS.FIRST_NAME : name,
             PARAMS.LAST_NAME  : lastname  ,
             PARAMS.EMAIL      : txtEmail.text!  ,
             PARAMS.OLD_PASSWORD: password  ,
             PARAMS.NEW_PASSWORD: txtNewPassword.text ?? "",
             PARAMS.LOGIN_BY   : CONSTANT.MANUAL ,
             PARAMS.COUNTRY_PHONE_CODE  :strForCountryPhoneCode ,
             PARAMS.PHONE : txtMobileNumber.text! ,
             PARAMS.DEVICE_TYPE: CONSTANT.IOS,
             PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
             PARAMS.TOKEN: preferenceHelper.getSessionToken(),
             PARAMS.USER_ID: preferenceHelper.getUserId(),
             PARAMS.SOCIAL_UNIQUE_ID: user.socialUniqueId!
        ]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        Utility.showLoading()
        if isPicAdded
        {
            alamoFire.getResponseFromURL(url: WebService.UPADTE_PROFILE, paramData: dictParam, image: imgProfilePic.image) { [unowned self] (response, error) -> (Void) in
                Utility.hideLoading()
                if Parser.parseUserDetail(response: response)
                {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        else
        {
            alamoFire.getResponseFromURL(url: WebService.UPADTE_PROFILE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
            { [unowned self] (response, error) -> (Void) in
                Utility.hideLoading()
                if Parser.parseUserDetail(response: response)
                {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
       
    }
    
    
    
    func wsGetOtp(isEmailOtpOn:Bool,isSmsOtpOn:Bool)
    {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        let strForEmail = txtEmail.text?.trim() ?? ""
        let strPhoneNumber = txtMobileNumber.text?.trim() ?? ""
        
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PHONE] = strPhoneNumber
        dictParam[PARAMS.COUNTRY_PHONE_CODE] = strForCountryPhoneCode
        dictParam[PARAMS.EMAIL] = strForEmail
        dictParam[PARAMS.TYPE] = CONSTANT.TYPE_USER
        
        afh.getResponseFromURL(url: WebService.GET_VERIFICATION_OTP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            printE(Utility.conteverDictToJson(dict: response))
            
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                Utility.hideLoading()
                if Parser.isSuccess(response: response)
                {
                    let smsOtp:String = (response[PARAMS.SMS_OTP] as? String) ?? ""
                    let emailOtp:String = (response[PARAMS.EMAIL_OTP] as? String) ?? ""
                    if let otpvc:OtpVC =  AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "OtpVC") as? OtpVC
                    {
                        self.present(otpvc, animated: true, completion: {
                            
                            otpvc.delegate = self
                            otpvc.strForCountryPhoneCode = self.strForCountryPhoneCode
                            otpvc.strForPhoneNumber = strPhoneNumber
                            otpvc.updateOtpUI(otpEmail: emailOtp, otpSms: smsOtp, emailOtpOn: isEmailOtpOn , smsOtpOn: isSmsOtpOn)
                        })
                    }
                    
                    
                    
                }
                else
                {
                    Utility.hideLoading()
                }
            }
        }
    }
    
    func  wsGetCountries(){
        
        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_COUTRIES, methodName: AlamofireHelper.POST_METHOD, paramData: Dictionary.init()) { [unowned self] (response, error) -> (Void) in
            
            if Parser.isSuccess(response: response)
            {
                let response:CountryListResponse = CountryListResponse.init(fromDictionary: response)
                self.arrForCountryList = response.countryList
                
                for serverCountry:Country in self.arrForCountryList
                {
                    for country in CurrentTrip.shared.arrForCountries
                    {
                        if country.countryPhoneCode == serverCountry.countryPhoneCode
                        {
                            country.phoneNumberLength = serverCountry.phoneNumberLength
                            country.phoneNumberMinLength = serverCountry.phoneNumberMinLength
                            
                        }
                    }
                }
              
                
            }
        }
    }
}
