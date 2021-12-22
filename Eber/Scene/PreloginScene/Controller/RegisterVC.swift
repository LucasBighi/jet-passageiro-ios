//
//  RegisterVC.swift
//  Cabtown
//
//  Created by Elluminati  on 30/08/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class RegisterVC: BaseVC,OtpDelegate
{

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var txtFirstName: ACFloatingTextfield!
    @IBOutlet weak var txtLastName: ACFloatingTextfield!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
    @IBOutlet weak var txtPassword: ACFloatingTextfield!
    @IBOutlet weak var txtCpf: ACFloatingTextfield!
    @IBOutlet weak var txtNumber: ACFloatingTextfield!
    
    @IBOutlet weak var lblConfirmationTermsAndCondition: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var lblAnd: UILabel!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    
    @IBOutlet weak var phoneNumberView: UIStackView!
    @IBOutlet weak var btnCountryPhoneCode: UIButton!
    

    var strForCountryPhoneCode:String =  CurrentTrip.shared.arrForCountries[0].countryPhoneCode
    var strForPhoneNumber:String =  ""
    var strForCountry = ""
    var strLoginBy = ""
    var strForSocialId = ""
    var strForFirstName = ""
    var strForLastName = ""
    var strForEmail = ""
    var strForCpf: String =  ""
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialViewSetup()
        
        if (strForCountryPhoneCode.isEmpty())
        {
            strForCountryPhoneCode = CurrentTrip.shared.arrForCountries[0].countryPhoneCode
        }
        txtEmail.isEnabled = strForEmail.isEmpty()
        txtCpf.isEnabled = strForCpf.isEmpty()
        
        if (strLoginBy == CONSTANT.MANUAL)
        {
            phoneNumberView.isUserInteractionEnabled = false
            txtNumber.isUserInteractionEnabled = false
            btnCountryPhoneCode.isUserInteractionEnabled = false
            
        }
        else
        {
            txtPassword.isHidden = true
            phoneNumberView.isUserInteractionEnabled = true
            txtNumber.isUserInteractionEnabled = true
            btnCountryPhoneCode.isUserInteractionEnabled = true
            strForCountry = CurrentTrip.shared.currentCountry
            strForCountryPhoneCode = CurrentTrip.shared.currentCountryPhoneCode
        }
        setUserData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ =   txtFirstName.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initialViewSetup()
    {
        lblMessage.text = "TXT_REGISTER_MSG".localized
        lblMessage.textColor = UIColor.themeTextColor
        lblMessage.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)

   
        txtFirstName.placeholder = "TXT_FIRST_NAME".localized
        txtLastName.placeholder = "TXT_LAST_NAME".localized
        txtPassword.placeholder = "TXT_PASSWORD".localized
        txtEmail.placeholder = "TXT_EMAIL".localized
        txtNumber.placeholder = "TXT_PHONE_NO".localized
       
        lblConfirmationTermsAndCondition.text = "TXT_CONDITIONING_TEXT".localized
        lblConfirmationTermsAndCondition.textColor = UIColor.themeTextColor
        lblConfirmationTermsAndCondition.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblAnd.text = "TXT_AND".localized
        lblAnd.textColor = UIColor.themeTextColor
        lblAnd.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        btnTerms.setTitle("TXT_TERMS_CONDITIONS".localized, for: .normal)
        btnTerms.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnTerms.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        btnPrivacyPolicy.setTitle("TXT_PRIVACY_POLICY".localized, for: .normal)
        btnPrivacyPolicy.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnPrivacyPolicy.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        btnCountryPhoneCode.setTitle(strForCountryPhoneCode, for: .normal)
        btnCountryPhoneCode.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        
        
        btnCountryPhoneCode.titleLabel?.font  = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        btnBack.setupBackButton()    
        
        setTextFieldSetup(txtFirstName)
        setTextFieldSetup(txtLastName)
        setTextFieldSetup(txtPassword)
        setTextFieldSetup(txtCpf)
        setTextFieldSetup(txtEmail)
        setTextFieldSetup(txtNumber)
        
        btnDone.setTitle(FontAsset.icon_forward_arrow, for: .normal)
        btnDone.setRoundIconButton()
        btnDone.titleLabel?.font = FontHelper.assetFont(size: 30)
        btnDone.setTitleColor(.themeButtonBackgroundColor, for: .normal)
    }
  
    
    func setTextFieldSetup(_ textField:UITextField) {
        let windowFrame = APPDELEGATE.window?.frame ?? view.bounds
        let toolBarView = UIView(frame: CGRect(x: 0, y: 0, width: windowFrame.size.width, height: 90))
        let btnDone = UIButton(type: .custom)
        
        btnDone.frame = CGRect(x: windowFrame.size.width - 80, y: 10, width: 70, height: 70)
        btnDone.addTarget(self, action: #selector(onClickBtnDone(_:)), for: .touchUpInside)
        btnDone.setTitle(FontAsset.icon_forward_arrow, for: .normal)
        btnDone.setRoundIconButton()
        btnDone.titleLabel?.font = FontHelper.assetFont(size: 30)
        btnDone.setTitleColor(#colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1), for: .normal)
        toolBarView.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        toolBarView.addSubview(btnDone)
        textField.inputAccessoryView = toolBarView
    }
    
    func setUserData() {
        txtNumber.text = strForPhoneNumber
        txtFirstName.text = strForFirstName
        txtLastName.text = strForLastName
        txtEmail.text = strForEmail
        txtCpf.text = strForCpf
        btnCountryPhoneCode.setTitle(strForCountryPhoneCode, for: .normal)
    }

    //MARK:- Action Methods
    @IBAction func onClickBtnTerms(_ sender: Any) {
        
        if let termsUrl:URL = URL.init(string: preferenceHelper.getTermsAndCondition())
            {
                
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(termsUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(termsUrl)
                }
        }
    }
    
    @IBAction func onClickBtnPrivacy(_ sender: Any)
    {
        if let privacyUrl:URL = URL.init(string: preferenceHelper.getPrivacyPolicy())
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(privacyUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(privacyUrl)
                }
            }
    }
    
    @IBAction func onClickBtnDone(_ sender: Any) {
        self.view.endEditing(true)
        if checkValidation()
        {
            if (preferenceHelper.getIsEmailVerification() || preferenceHelper.getIsPhoneNumberVerification()) && phoneNumberView.isUserInteractionEnabled
            {
                    self.wsGetOtp()
            }
            else
            {
                 self.wsRegister()
            }
        }
     }
    @IBAction func onClickBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func onClickBtnCountryPhonecode(_ sender: Any)
    {
        openCountryDialog()
    }
    func openCountryDialog()
    {
        self.view.endEditing(true)
        let dialogForCountry  = CustomCountryDialog.showCustomCountryDialog()
        dialogForCountry.onCountrySelected =
            { [unowned self, unowned dialogForCountry] 
                (country:Country) in
                preferenceHelper.setMinPhoneNumberLength(country.phoneNumberMinLength)
                preferenceHelper.setMaxPhoneNumberLength(country.phoneNumberLength)
                self.txtNumber.text = ""
                self.strForCountryPhoneCode = country.countryPhoneCode
                self.strForCountry = country.countryName
                self.btnCountryPhoneCode.setTitle(self.strForCountryPhoneCode, for: .normal)
                dialogForCountry.removeFromSuperview()
        }
    }
    func checkValidation() -> Bool {
        if preferenceHelper.getIsEmailVerification() {
            if let email = txtEmail.text {
                if email.isEmpty() {
                    txtEmail.showErrorWithText(errorText: "VALIDATION_MSG_ENTER_EMAIL".localized)
                    return false
                } else if !email.isValidEmail() {
                    txtEmail.showErrorWithText(errorText: "VALIDATION_MSG_INVALID_EMAIL".localized)
                    return false
                }
            }
        }

        if let number = txtNumber.text {
            if number.isEmpty() {
                txtNumber.showErrorWithText(errorText: "VALIDATION_MSG_ENTER_PHONE_NUMBER".localized)
                return false
            }
        }

        let validPhoneNumber = txtNumber.text!.isValidMobileNumber()
        if validPhoneNumber.0 == false {
           txtNumber.showErrorWithText(errorText: validPhoneNumber.1)
            return false
        }

        let validCPF = txtCpf.text!.isValidCPF()
        if validCPF.0 == false {
            txtCpf.showErrorWithText(errorText: validCPF.1)
            return false
        }

        if (txtPassword.text!.isEmpty && strForSocialId.isEmpty()) {
            txtPassword.showErrorWithText(errorText: "VALIDATION_MSG_ENTER_PASSWORD".localized)
            return false;
        }

        if (txtPassword.text!.count < passwordLength && strForSocialId.isEmpty()) {
            let myString = String(format: NSLocalizedString("MSG_PLEASE_ENTER_VALID_PASSWORD",
                                                            comment: ""), String(passwordLength))
            
            txtPassword.showErrorWithText(errorText: myString)
            return false
        }
        return true
    }

    func onOtpDone() {
        wsRegister()
    }
}

extension RegisterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtFirstName
        {
            _ = txtLastName.becomeFirstResponder()
        }
        else if textField == txtLastName
        {
            if txtEmail.isEnabled
            {
                _ = txtEmail.becomeFirstResponder()
            }
            else if txtNumber.isEnabled
            {
                _ = txtNumber.becomeFirstResponder()
            }
            else
            {
                self.onClickBtnDone(self.btnDone!)
            }
            
        }
        else if textField == txtEmail
        {
            if !txtPassword.isHidden
            {_ = txtPassword.becomeFirstResponder()}
        }
        else if textField == txtNumber {
            _ = txtCpf.becomeFirstResponder()
        }
        else
        {
            self.onClickBtnDone(self.btnDone!)
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtNumber
        {
            if  (string == "") || string.count < 1
            {
                return true
            }
            else
            {
                let compSepByCharInSet = string.components(separatedBy: numberSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                if string == numberFiltered
                {
                    if textField == txtNumber
                    {
                        if txtNumber.text!.count >= preferenceHelper.getMaxPhoneNumberLength() && range.length == 0
                        {
                            _ =  txtNumber.becomeFirstResponder()
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
        return true
    }
}

//MARK:- Web Service Calls
extension RegisterVC
{
    func wsRegister()
    {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        
        var  dictParam : [String : Any] = [:]
        strForPhoneNumber = txtNumber.text?.trim() ?? ""
        strForFirstName = txtFirstName.text?.trim() ?? ""
        strForLastName = txtLastName.text?.trim() ?? ""
        strForEmail = txtEmail.text?.trim() ?? ""
        strForCpf = txtCpf.text?.trim() ?? ""

        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        dictParam[PARAMS.CPF] = strForCpf
        dictParam[PARAMS.PHONE] = strForPhoneNumber
        dictParam[PARAMS.COUNTRY_PHONE_CODE] = strForCountryPhoneCode
        dictParam[PARAMS.APP_VERSION] = currentAppVersion
        dictParam[PARAMS.EMAIL] = strForEmail
        dictParam[PARAMS.LAST_NAME] = strForLastName
        dictParam[PARAMS.FIRST_NAME] = strForFirstName
        dictParam[PARAMS.COUNTRY_PHONE_CODE] = strForCountryPhoneCode
        dictParam[PARAMS.DEVICE_TOKEN] = preferenceHelper.getDeviceToken()
        dictParam[PARAMS.DEVICE_TYPE] = CONSTANT.IOS
        dictParam[PARAMS.DEVICE_TIMEZONE] = TimeZone.current.identifier
        dictParam[PARAMS.COUNTRY] = strForCountry
        dictParam[PARAMS.LOGIN_BY] = strLoginBy
        if strLoginBy != CONSTANT.MANUAL
        {
            dictParam[PARAMS.SOCIAL_UNIQUE_ID] = strForSocialId
            dictParam[PARAMS.PASSWORD] = ""
        }
        else
        {
            dictParam[PARAMS.SOCIAL_UNIQUE_ID] = ""
            dictParam[PARAMS.PASSWORD] = txtPassword.text ?? ""
        }
        afh.getResponseFromURL(url: WebService.REGISTER_USER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            printE(Utility.conteverDictToJson(dict: response))
            
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.parseUserDetail(response: response)
                {
                    if !(CurrentTrip.shared.user.isReferral == TRUE) && CurrentTrip.shared.user.countryDetail.isReferral
                    {
                        Utility.hideLoading()
                        self.performSegue(withIdentifier: SEGUE.REGISTER_TO_REFERRAL, sender: self)
                    }
                    else if (CurrentTrip.shared.user.isDocumentUploaded == FALSE)
                    {
                        APPDELEGATE.gotoDocument()
                    }
                    
                    else
                    {
                        APPDELEGATE.gotoMap()
                    }
                    
                }
                else
                {
                    Utility.hideLoading()
                }
            }
        }
    }
    func wsGetOtp()
    {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
         strForEmail = txtEmail.text?.trim() ?? ""
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PHONE] = strForPhoneNumber
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
                printE(Utility.conteverDictToJson(dict: response))
                if Parser.isSuccess(response: response)
                {
                    let smsOtp:String = (response[PARAMS.SMS_OTP] as? String) ?? ""
                    let emailOtp:String = (response[PARAMS.EMAIL_OTP] as? String) ?? ""
                    if let otpvc:OtpVC =  AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "OtpVC") as? OtpVC
                    {
                        self.present(otpvc, animated: true, completion: {
                            
                            otpvc.delegate = self
                            otpvc.strForCountryPhoneCode = self.strForCountryPhoneCode
                            otpvc.strForPhoneNumber = self.strForPhoneNumber
                            otpvc.updateOtpUI(otpEmail: emailOtp, otpSms: smsOtp, emailOtpOn: preferenceHelper.getIsEmailVerification() , smsOtpOn: preferenceHelper.getIsPhoneNumberVerification())
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
}

