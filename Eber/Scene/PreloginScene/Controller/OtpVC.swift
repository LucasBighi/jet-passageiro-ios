//
//  OtpVC.swift
//  Cabtown
//
//  Created by Elluminati  on 30/08/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

//MARK: step 1 Add Protocol here.
protocol OtpDelegate: NSObjectProtocol /*class*/ {
    func onOtpDone()
}

class OtpVC: BaseVC
{

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var txtSmsOtp: VPMOTPView!
    @IBOutlet weak var txtEmailOtp: VPMOTPView!
    @IBOutlet weak var lblEnterEmailOtp: UILabel!
    @IBOutlet weak var btnResendCode: UIButton!
    @IBOutlet weak var btnEditMyDetail: UIButton!
    
    
    var strEmailOtp:String = "";
    var strSmsOtp:String = "";
    
    var strForEmail:String = "";
    var strEnteredSmsOtp:String = ""
    var strEnteredEmailOtp:String = ""
    var isSmsOtpOn:Bool = false
    var isEmailOtpOn:Bool = false
    var isFromForgetPassword:Bool = false
    
    var strForCountryPhoneCode:String =  CurrentTrip.shared.currentCountryPhoneCode
    
    
    var strForPhoneNumber:String = "";
    var strForCountry:String = CurrentTrip.shared.currentCountry
    
    var seconds = 15;
    weak var timerForOtp: Timer?
    weak var delegate: OtpDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialViewSetup()
        setupOtpView(otpView: txtSmsOtp)
        setupOtpView(otpView: txtEmailOtp)
        lblEnterEmailOtp.text = "TXT_ENTER_OTP".localized
        lblEnterEmailOtp.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblEnterEmailOtp.textColor = UIColor.themeTextColor
        seconds = 15;
        self.invalidateTimer()
        timerForOtp =   Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtSmsOtp.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func invalidateTimer() {
        self.timerForOtp?.invalidate()
        self.timerForOtp = nil
    }
    
    func initialViewSetup()
    {
        lblMessage.text = "TXT_OTP_MSG".localized
        lblMessage.textColor = UIColor.themeTextColor
        lblMessage.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        btnBack.setupBackButton()
        btnDone.setTitle(FontAsset.icon_forward_arrow, for: .normal)
        btnDone.setRoundIconButton()
        btnDone.titleLabel?.font = FontHelper.assetFont(size: 30)
    }
    @objc func counter()
    {
        seconds = seconds - 1;
        if (seconds == 0)
        {
            seconds = 15;
            self.invalidateTimer()
            
            DispatchQueue.main.async { [unowned self] in
                    self.btnResendCode.setTitle("TXT_RESEND_CODE".localizedCapitalized, for: .normal)
                    self.btnResendCode.isEnabled = true
                
                let myString = "TXT_OTP_MSG".localized + " " + self.strForCountryPhoneCode + " " + self.strForPhoneNumber + "\n"
                
                let timeOutMessage = "TXT_DID_YOU_ENTER_CORRECT_MOBILE_NUMBER".localized
                let attributedTimeoutMessage:NSMutableAttributedString = NSMutableAttributedString.init(string: timeOutMessage)
                
                
                
                
                let range =  NSMakeRange(0, timeOutMessage.count)
                attributedTimeoutMessage.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.themeSelectionColor, range: range)
                attributedTimeoutMessage.append(NSAttributedString.init(string: myString))
                self.lblMessage.attributedText = attributedTimeoutMessage
            }
        }
        else
        {
            let time = "TXT_RESEND_CODE_IN".localized  + seconds.toString()
            DispatchQueue.main.async { [unowned self] in
                self.btnResendCode.setTitle(time, for: .normal)
                self.btnResendCode.isEnabled = false
            }
        }
    }
  
    func updateOtpUI(otpEmail:String,otpSms:String,emailOtpOn:Bool,smsOtpOn:Bool)
    {
        

        strSmsOtp = otpSms
        strEmailOtp = otpEmail
        isEmailOtpOn = emailOtpOn
        isSmsOtpOn = smsOtpOn
        if isSmsOtpOn && !strSmsOtp.isEmpty()
        {
         txtSmsOtp.isHidden = false
        }
        else
        {
            txtSmsOtp.isHidden = true
        }
        
        if isEmailOtpOn && !strEmailOtp.isEmpty()
        {
            txtEmailOtp.isHidden = false
        }
        else
        {
            txtEmailOtp.isHidden = true
            lblEnterEmailOtp.isHidden = true
        }
        
        let strOtpMsg = "TXT_OTP_MSG".localized + " " +  strForCountryPhoneCode + " " +  strForPhoneNumber
        lblMessage.text = strOtpMsg
        
    }
   
    //MARK:- Action Methods
    
    func clearVC() {
        self.delegate = nil
        self.invalidateTimer()
    }
    
    @IBAction func onClickBtnDone(_ sender: Any) {
        self.view.endEditing(true)
        print("email otp = \(strEmailOtp) and sms otp = \(strSmsOtp)")
        if (isEmailOtpOn && !isSmsOtpOn)
        {
            if (strEnteredEmailOtp == strEmailOtp)
            {
                delegate?.onOtpDone()
                self.dismiss(animated: true, completion: nil)
                self.clearVC()
            }
            else
            {
                Utility.showToast(message: "VALIDATION_MSG_ENTER_VALID_OTP".localized)
                
            }
        }
        else if(!isEmailOtpOn && isSmsOtpOn)
        {
            if (strEnteredSmsOtp == strSmsOtp)
            {
                delegate?.onOtpDone()
                self.dismiss(animated: true, completion: nil)
                self.clearVC()
            }
            else
            {
                Utility.showToast(message: "VALIDATION_MSG_ENTER_VALID_OTP".localized)
                
            }
        }
        else
            
        {
            
            if (strEnteredEmailOtp == strEmailOtp)
            {
                if (strEnteredSmsOtp == strSmsOtp)
                {
                    delegate?.onOtpDone()
                    self.dismiss(animated: true, completion: nil)
                    self.clearVC()
                }
                else
                {
                   Utility.showToast(message: "VALIDATION_MSG_ENTER_VALID_OTP".localized)
                    
                }
                
            }
            else
            {
              Utility.showToast(message: "VALIDATION_MSG_ENTER_VALID_OTP".localized)
            }
        }
        
        
    }
    @IBAction func onClickBtnBack(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
        self.clearVC()
    }
    @IBAction func onClickBtnResendCode(_ sender: Any) {
        
        btnResendCode.isEnabled = false
        
        
        
        let strOtpMsg = "TXT_OTP_MSG".localized + " " +  strForCountryPhoneCode + " " +  strForPhoneNumber
        lblMessage.text = strOtpMsg
        
        
        
        
        if (isFromForgetPassword)
        {
            self.wsGetOtp()
        }
        else
        {
            self.wsCheckUserExist()
        }
    }
    func setTextFieldSetup(_ textField:VPMOTPView)
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
//        textField.inputAccessoryView = toolBarView
    }
    
    func setupOtpView( otpView:VPMOTPView)
    {
    otpView.otpFieldsCount = 6;
    otpView.otpFieldDefaultBorderColor = UIColor.gray
    otpView.otpFieldEnteredBorderColor = UIColor.black
    otpView.otpFieldErrorBorderColor = UIColor.themeErrorTextColor
    otpView.otpFieldSize =  200/6;
    otpView.otpFieldBorderWidth = 1;
    otpView.shouldAllowIntermediateEditing = true;
    otpView.delegate = self;
    otpView.initializeUI()
   }
}

extension OtpVC:VPMOTPViewDelegate,UITextFieldDelegate
{
    func enteredOTP(otpString: String, view: VPMOTPView) {
        if view == txtEmailOtp
        {
            strEnteredEmailOtp = otpString
        }
        else
        {
            strEnteredSmsOtp = otpString
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let acceptableCharacters = "0123456789"
        let cs:CharacterSet = CharacterSet.init(charactersIn: acceptableCharacters).inverted
        let filtered:String = string.components(separatedBy: cs).joined(separator: "")
        return string == filtered
    }
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    func hasEnteredAllOTP(hasEntered: Bool, view: VPMOTPView) -> Bool {
        if hasEntered
        {
            if view == txtSmsOtp && strEnteredSmsOtp == strSmsOtp
            {
                return true
            }
            else if view == txtEmailOtp && strEnteredEmailOtp == strEmailOtp
            {
                return true
            }
        }
        return false
    }
}
//MARK:- Web Service Calls
extension OtpVC
{
    func wsCheckUserExist()
    {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        
        let dictParam : [String : Any] =
            [ PARAMS.PHONE:strForPhoneNumber,
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
                            
                            self.strSmsOtp = (response[PARAMS.SMS_OTP] as? String) ?? ""
                            self.invalidateTimer()
                            self.timerForOtp =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.counter), userInfo: nil, repeats: true)
                            Utility.hideLoading()
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
    
    func wsGetOtp()
    {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
     
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PHONE] = strForPhoneNumber
        dictParam[PARAMS.COUNTRY_PHONE_CODE] = strForCountryPhoneCode
        dictParam[PARAMS.EMAIL] = strForEmail
        dictParam[PARAMS.TYPE] = CONSTANT.TYPE_USER
        
        
        afh.getResponseFromURL(url: WebService.GET_OTP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            printE(Utility.conteverDictToJson(dict: response))
            
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {

                if Parser.isSuccess(response: response)
                {
                    
                    self.strEmailOtp = (response[PARAMS.EMAIL_OTP] as? String) ?? ""
                    self.strSmsOtp = (response[PARAMS.SMS_OTP] as? String) ?? ""
                    self.strEnteredSmsOtp = "";
                    self.strEnteredEmailOtp = "";
                    self.txtSmsOtp.initializeUI()
                    self.txtEmailOtp.initializeUI()
                    self.invalidateTimer()
                    self.timerForOtp =   Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.counter), userInfo: nil, repeats: true)
                    Utility.hideLoading()
                }
                else
                {
                    Utility.hideLoading()
                }
            }
        }
    }
}
