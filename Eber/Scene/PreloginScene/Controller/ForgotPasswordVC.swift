//
//  ForgotPasswordVC.swift
//  Cabtown
//
//  Created by Elluminati  on 30/08/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseVC
{

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var stkEmail: UIStackView!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
    
    @IBOutlet weak var stkPhone: UIStackView!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var txtPhoneNumber: ACFloatingTextfield!
    
    
    
    var strForCountryPhoneCode:String =  CurrentTrip.shared.currentCountryPhoneCode
    var strForCountry:String = CurrentTrip.shared.currentCountry
    var strForPhoneNumber:String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialViewSetup()
        txtPhoneNumber.text = strForCountryPhoneCode + strForPhoneNumber
        stkEmail.isHidden = !preferenceHelper.getIsEmailVerification()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ =   txtPhoneNumber.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initialViewSetup()
    {
        lblMessage.text = "TXT_FORGOT_PASSWORD_MSG".localized
        lblMessage.textColor = UIColor.themeTextColor
        lblMessage.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)

        
        txtPhoneNumber.placeholder = "TXT_MOBILE_MSG".localized
        txtEmail.placeholder = "TXT_EMAIL".localized
        setTextFieldSetup(txtPhoneNumber)
        setTextFieldSetup(txtEmail)
        btnBack.setupBackButton()
        btnEmail.isSelected = false
        btnPhone.isSelected = true
        
        btnPhone.setTitle(FontAsset.icon_radio_box_normal, for: .normal)
        btnPhone.setTitle(FontAsset.icon_radio_box_selected, for: .selected)
        
        btnEmail.setTitle(FontAsset.icon_radio_box_normal, for: .normal)
        btnEmail.setTitle(FontAsset.icon_radio_box_selected, for: .selected)
        
        btnEmail.setSimpleIconButton()
        btnPhone.setSimpleIconButton()
        
        btnDone.setTitle(FontAsset.icon_forward_arrow, for: .normal)
        btnDone.setRoundIconButton()
        btnDone.setTitleColor(UIColor.white,for:.normal)
        btnDone.titleLabel?.font = FontHelper.assetFont(size: 30)
    }
  
    
    func setTextFieldSetup(_ textField:UITextField)
    {
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
    //MARK:- Action Methods
    
    @IBAction func onClickBtnDone(_ sender: Any) {
        self.view.endEditing(true)
        if (txtPhoneNumber.text!.isEmpty() && btnPhone.isSelected)
        {
            Utility.showToast(message: "VALIDATION_MSG_ENTER_PHONE_NUMBER".localized)
        }
        /*else if(!txtPhoneNumber.text!.isValidMobileNumber() && btnPhone.isSelected)
        {
             let myString = String(format: NSLocalizedString("VALIDATION_MSG_INVALID_PHONE_NUMBER_BETWEEN", comment: ""),preferenceHelper.getMinPhoneNumberLength().toString(),preferenceHelper.getMaxPhoneNumberLength().toString())
            
            Utility.showToast(message: myString)
            
        }*/
            
            
        else if(txtEmail.text!.isEmpty() && btnEmail.isSelected)
        {
            Utility.showToast(message: "VALIDATION_MSG_ENTER_EMAIL".localized)
            
        }
            
        else if(!txtEmail.text!.isValidEmail() && btnEmail.isSelected)
        {
            Utility.showToast(message: "VALIDATION_MSG_INVALID_EMAIL".localized)
            
        }
        else if (btnEmail.isSelected)
        {
            
            self.wsForgotPassword()
        }
        else if (btnPhone.isSelected)
        {
            wsGetOtp()
        }
        

     }
    @IBAction func onClickBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onClickBtnPhone(_ sender: Any)
    {
       btnEmail.isSelected = false
        btnPhone.isSelected = true
    }
    @IBAction func onClickBtnEmail(_ sender: Any)
    {
        btnEmail.isSelected = true
        btnPhone.isSelected = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE.FORGOT_PASSWORD_TO_NEW_PASSWORD
        {
            if let destinationVC = segue.destination as? NewPasswordVC
            {
                
                destinationVC.strForCountryPhoneCode = strForCountryPhoneCode;
                destinationVC.strForPhoneNumber = strForPhoneNumber
            }
        }
    }
   
    
}

extension ForgotPasswordVC:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.onClickBtnDone(self)
        return true
    }
}

extension ForgotPasswordVC
{
    func wsForgotPassword()
    {
        
        
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.EMAIL] = txtEmail.text!.trim()
        dictParam[PARAMS.TYPE] = TRUE
        afh.getResponseFromURL(url: WebService.FORGOT_PASSWORD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response,withSuccessToast: true,andErrorToast: true)
                {
                    
                     Utility.hideLoading()
                    self.navigationController?.popViewController(animated: true)
                    
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
        
            var  dictParam : [String : Any] = [:]
            dictParam[PARAMS.PHONE] = strForPhoneNumber
            dictParam[PARAMS.COUNTRY_PHONE_CODE] = strForCountryPhoneCode
            dictParam[PARAMS.TYPE] = CONSTANT.TYPE_USER
             afh.getResponseFromURL(url: WebService.GET_OTP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
             
                
                
                if (error != nil)
                {
                    Utility.hideLoading()
                }
                else
                {
                    if Parser.isSuccess(response: response)
                    {
                        Utility.hideLoading()
                        let smsOtp:String = (response[PARAMS.SMS_OTP] as? String) ?? ""
                        if let otpvc:OtpVC =  AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "OtpVC") as? OtpVC
                        {
                            self.present(otpvc, animated: true, completion: {
                                
                                otpvc.delegate = self
                                otpvc.isFromForgetPassword = true
                                otpvc.strForCountryPhoneCode = self.strForCountryPhoneCode
                                otpvc.strForPhoneNumber = self.strForPhoneNumber
                                otpvc.updateOtpUI(otpEmail: "", otpSms: smsOtp, emailOtpOn: false, smsOtpOn: true)
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

extension ForgotPasswordVC: OtpDelegate
{
    func onOtpDone()
    {
        self.performSegue(withIdentifier: SEGUE.FORGOT_PASSWORD_TO_NEW_PASSWORD, sender: self)
    }
}
