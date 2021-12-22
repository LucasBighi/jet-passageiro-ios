//
//  PhoneVC.swift
//  Cabtown
//
//  Created by Elluminati  on 30/08/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class PhoneVC: BaseVC,OtpDelegate
{

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnCountryPhoneCode: UIButton!
    @IBOutlet weak var txtPhoneNumber: ACFloatingTextfield!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var bottomBarView: UIView!
    var strForCountryPhoneCode:String =  CurrentTrip.shared.currentCountryPhoneCode
    var strForCountryFlag:String =  CurrentTrip.shared.currentCountryFlag
    var strForCountry:String = CurrentTrip.shared.currentCountry

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialViewSetup()
        btnDone.setTitle(FontAsset.icon_forward_arrow, for: .normal)
        btnDone.setRoundIconButton()
        btnDone.setTitleColor(UIColor.white,for:.normal)
        btnDone.titleLabel?.font = FontHelper.assetFont(size: 30)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCountryPhoneCode.setTitle(strForCountryPhoneCode, for: .normal)
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
        lblMessage.text = "TXT_INTRO_MSG".localized
        lblMessage.textColor = UIColor.themeTextColor
        lblMessage.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)

        btnCountryPhoneCode.setTitle(strForCountryPhoneCode, for: .normal)
        btnCountryPhoneCode.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        
        btnCountryPhoneCode.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        
        txtPhoneNumber.placeholder = "TXT_MOBILE_MSG".localized
        setTextFieldSetup(txtPhoneNumber)
        
        btnBack.setupBackButton()    
     
    }
    func onOtpDone() {
        self.performSegue(withIdentifier: SEGUE.PHONE_TO_REGISTER, sender: self)
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
        if checkValidation()
        {
            wsCheckUserExist()
        }
       
     }
    @IBAction func onClickBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickBtnCountryPhonecode(_ sender: Any)
    {
        openCountryDialog()
    }
    func checkValidation() -> Bool
    {
        if (txtPhoneNumber.text?.isEmpty() ?? true)
        {
            txtPhoneNumber.showErrorWithText(errorText: "VALIDATION_MSG_ENTER_PHONE_NUMBER".localized)
            return false
        }
        
        let validPhoneNumber = txtPhoneNumber.text!.isValidMobileNumber()
        if validPhoneNumber.0 == false
        {
            txtPhoneNumber.showErrorWithText(errorText: validPhoneNumber.1)
            return false
            
        }
        return true
        
    }
    func openCountryDialog()
    {
        self.view.endEditing(true)
        let dialogForCountry  = CustomCountryDialog.showCustomCountryDialog()
        dialogForCountry.onCountrySelected =
            { [unowned self, unowned dialogForCountry]
                (country:Country) in
                printE(country.countryName!)
                self.strForCountryPhoneCode = country.countryPhoneCode
                self.strForCountry = country.countryName
                self.txtPhoneNumber.text = ""
                preferenceHelper.setMinPhoneNumberLength(country.phoneNumberMinLength)
                preferenceHelper.setMaxPhoneNumberLength(country.phoneNumberLength)
               self.btnCountryPhoneCode.setTitle(self.strForCountryPhoneCode, for: .normal)
               dialogForCountry.removeFromSuperview()
        }
   }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE.PHONE_TO_PASSWORD
        {
            if let destinationVc = segue.destination as? PasswordVC
            {
                destinationVc.strForCountryPhoneCode = strForCountryPhoneCode
                destinationVc.strForPhoneNumber = txtPhoneNumber.text ?? ""
            }
        }
        else if segue.identifier == SEGUE.PHONE_TO_REGISTER
            {
                if let destinationVc = segue.destination as? RegisterVC
                {
                    destinationVc.strForCountryPhoneCode = strForCountryPhoneCode
                    destinationVc.strForPhoneNumber = txtPhoneNumber.text ?? ""
                    destinationVc.strForCountry = strForCountry
                    destinationVc.strLoginBy = CONSTANT.MANUAL
                    
                }
        }
    }
}

extension PhoneVC:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.onClickBtnDone(self)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
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
                if textField == txtPhoneNumber
                {
                    if txtPhoneNumber.text!.count >= preferenceHelper.getMaxPhoneNumberLength() && range.length == 0
                    {
                        _ =  txtPhoneNumber.becomeFirstResponder()
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
}

extension PhoneVC
{
    func wsCheckUserExist()
    {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        
        let dictParam : [String : Any] =
            [ PARAMS.PHONE:txtPhoneNumber.text?.trim() ?? "",
              PARAMS.COUNTRY_PHONE_CODE : strForCountryPhoneCode];
        
        
        afh.getResponseFromURL(url: WebService.CHECK_USER_REGISTER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            printE(Utility.conteverDictToJson(dict: response))
            
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    let responseModel:ResponseModel = ResponseModel.init(fromDictionary: response)
                    if responseModel.message == MessageCode.USER_REGISTERED
                    {
                        Utility.hideLoading()
                        self.performSegue(withIdentifier: SEGUE.PHONE_TO_PASSWORD, sender: self)
                    }
                    else
                    {
                        let isSmsOn:Bool = (response[PARAMS.USER_SMS] as? Bool) ?? false
                        preferenceHelper.setIsPhoneNumberVerification(isSmsOn)
                        if (preferenceHelper.getIsPhoneNumberVerification())
                        {
                            Utility.hideLoading()
                            let smsOtp:String = (response[PARAMS.SMS_OTP] as? String) ?? ""
                            if let otpvc:OtpVC =  AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "OtpVC") as? OtpVC
                            {
                                self.present(otpvc, animated: true, completion: {
                                   
                                    otpvc.delegate = self
                                    otpvc.strForCountryPhoneCode = self.strForCountryPhoneCode
                                    otpvc.strForPhoneNumber = self.txtPhoneNumber.text?.trim() ?? ""
                                     otpvc.updateOtpUI(otpEmail: "", otpSms: smsOtp, emailOtpOn: false, smsOtpOn: true)
                                })
                            }
                        }
                        else
                        {
                            self.performSegue(withIdentifier: SEGUE.PHONE_TO_REGISTER, sender: self)
                            Utility.hideLoading()
                        }
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

