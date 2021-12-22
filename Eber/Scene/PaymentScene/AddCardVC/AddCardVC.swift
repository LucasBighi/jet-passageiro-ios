//
//  AddCardVC.swift
//  EdeliveryPaypalVC
//
//  Created by Elluminati on 17/04/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import Stripe


enum CardBrand: String
    
{
    case CardBrandVisa = "Visa"
    case CardBrandAmex = "amex"
    case CardBrandMasterCard = "MasterCard"
    case CardBrandDiscover = "discover"
    case CardBrandJCB = "JCB"
    case CardBrandDinersClub = "Diners Club"
    case CardBrandUnknown = "Unknown"
    var description: String
    {
        return self.rawValue
    }
}
class AddCardVC: BaseVC,UITextFieldDelegate
{
    var card_length = 19
    var mongth_length = 2
    let numberSet = NSCharacterSet(charactersIn:"0123456789").inverted
    var month:String = ""
    var year:String = ""
    //MARK:- Outlets
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    
    @IBOutlet weak var txtCardHolderName: ACFloatingTextfield!
    @IBOutlet weak var txtCreditCardNumber: ACFloatingTextfield!
    @IBOutlet weak var txtExpDate: ACFloatingTextfield!
    @IBOutlet weak var txtCvv: ACFloatingTextfield!
    @IBOutlet weak var lblMessage: UILabel!
    
    //MARK:- Variables
    //MARK:- View Lifecycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if preferenceHelper.getStripeKey().isEmpty()
        {
            let dialogForStripeError:CustomAlertDialog = CustomAlertDialog.showCustomAlertDialog(title: "TXT_STRIPE_KEY_ERROR".localized, message: "", titleLeftButton: "", titleRightButton: "TXT_OK".localized)
            dialogForStripeError.onClickRightButton = { [unowned self, unowned dialogForStripeError] in
                    dialogForStripeError.removeFromSuperview()
                    self.navigationController?.popViewController(animated: true)
            }
        }
        else
        {
            Stripe.setDefaultPublishableKey(preferenceHelper.getStripeKey())
        }
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        setLocalization()
        
    }

  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationView.navigationShadow()
    }
    @IBAction func onClickBtnBack(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickBtnSave(_ sender: Any) {
        if checkValidation()
        {
            generateToken()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setLocalization()
    {
        
        
        lblTitle.text = "TXT_CARDS".localized
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        
        txtExpDate.delegate = self
        txtCreditCardNumber.delegate = self
        txtCvv.delegate = self
        txtCardHolderName.delegate = self
        
        txtCvv.placeholder = "TXT_CVV".localized
        txtExpDate.placeholder = "TXT_MM_YY".localized
        txtCreditCardNumber.placeholder = "TXT_CREDIT_CARD_NUMBER".localized
        txtCardHolderName.placeholder = "TXT_CARD_HOLDER_NAME".localized
        lblMessage.text = "TXT_CARD_MSG".localized
        
        //Colors
        txtCvv.textColor = UIColor.themeTextColor
        txtExpDate.textColor = UIColor.themeTextColor
        txtCreditCardNumber.textColor = UIColor.themeTextColor
        txtCardHolderName.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeTextColor
        
        txtCvv.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        txtExpDate.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        txtCardHolderName.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        txtCreditCardNumber.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblMessage.font = FontHelper.font(size: FontSize.regular, type: FontType.Light )
        
        btnSave.setTitle("".localizedCapitalized, for: .normal)
        btnSave.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        btnSave.setTitleColor(UIColor.themeTextColor  , for: .normal)
        
        
        btnBack.setupBackButton()}
    fileprivate func openMonthPickerDialog() {
        self.view.endEditing(true)
        
        let customMonthPicker:CustomMonthYearPickerDialog = CustomMonthYearPickerDialog.showCustomMonthPickerDialog(title: "TXT_PLEASE_SELECT_CARD_EXPIRY_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
        
        customMonthPicker.onClickRightButton =
            { [unowned self, unowned customMonthPicker] (selectedMonth,selectedYear) in
                if selectedYear.count > 0  && selectedMonth.count > 0
                {
                    let stringExpdate = selectedMonth + "/" + selectedYear
                    self.month = selectedMonth
                    self.year = selectedYear
                    self.txtExpDate.text = stringExpdate
                    customMonthPicker.removeFromSuperview()
                }
        }
        
        customMonthPicker.onClickLeftButton = { [/*unowned self,*/ unowned customMonthPicker] in 
            customMonthPicker.removeFromSuperview()
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtExpDate
        {
            openMonthPickerDialog()
             return false
        }
        return true
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == txtCardHolderName
        {
           _ = txtCreditCardNumber.becomeFirstResponder()
        }
        if textField == txtCreditCardNumber
        {
            _ = txtExpDate.becomeFirstResponder()
        }
        else if textField == txtExpDate
        {
            _ = txtCvv.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtCardHolderName
        {
            return true
        }
        
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
                if textField == txtCreditCardNumber
                {
                    if txtCreditCardNumber.text?.count == card_length && range.length == 0
                    {
                       _ =  txtExpDate.becomeFirstResponder()
                        return false
                    }
                    else
                    {
                        if txtCreditCardNumber.text?.count == 2 && range.length == 0
                        {
                            let strCardType = self.cardBrand(number: txtCreditCardNumber.text!)
                            card_length = length(forCardType: strCardType)
                            
                        }
                        else if (txtCreditCardNumber.text?.count)! >= card_length && range.length == 0
                        {
                          _ = txtExpDate.becomeFirstResponder()
                            return false
                        }
                        else if txtCreditCardNumber.text?.count == 4 || txtCreditCardNumber.text?.count == 9 || txtCreditCardNumber.text?.count == 14
                        {
                            let str: String = txtCreditCardNumber.text!
                            txtCreditCardNumber.text = str + "-"
                        }
                        return true;
                    }
                }
               
                else if textField == txtCvv
                {
                    if (txtCvv.text?.count)! >= 4
                    {
                        textField.resignFirstResponder()
                        return false
                    }
                    return true
                }
                else
                {
                    textField.resignFirstResponder()
                    return false
                }
            }
            else
            {
                return false
            }
            
        }
    }
   
   
    
    func wsAddCardToServer(card:ServerCard)
    {
        Utility.showLoading()
        
       
        
        
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
             PARAMS.TOKEN  : preferenceHelper.getSessionToken() ,
             PARAMS.LAST_FOUR   : card.lastFour ,
             PARAMS.PAYMENT_TOKEN: card.paymentToken,
             PARAMS.CARD_TYPE: card.cardType,
             PARAMS.CARD_HOLDER_NAME : card.cardHolderName,
             PARAMS.TYPE : CONSTANT.TYPE_USER
        ]
        printE(dictParam);
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.ADD_CARD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { [unowned self] (response, error) -> (Void) in
            
            if Parser.isSuccess(response: response)
            {
                DispatchQueue.main.async
                    { [unowned self] in
                        self.navigationController?.popViewController(animated: true)
                        Utility.hideLoading()
                }
                
            }
            
            
        }
        
        
    }
    //MARK:- Card Methods
    func cardBrand(number: String) -> String
    {
        if number.hasPrefix("34") || number.hasPrefix("37")
        {
            return CardBrand.CardBrandAmex.rawValue
        }
        else if number.hasPrefix("60") || number.hasPrefix("62") || number.hasPrefix("64") || number.hasPrefix("65") {
            return CardBrand.CardBrandDiscover.rawValue
        }
        else if number.hasPrefix("35") {
            return CardBrand.CardBrandJCB.rawValue
        }
        else if number.hasPrefix("30") || number.hasPrefix("36") || number.hasPrefix("38") || number.hasPrefix("39") {
            return CardBrand.CardBrandDinersClub.rawValue
        }
        else if number.hasPrefix("4") {
            return CardBrand.CardBrandVisa.rawValue
        }
        else if number.hasPrefix("5") {
            return CardBrand.CardBrandMasterCard.rawValue
        }
        else {
            return CardBrand.CardBrandUnknown.rawValue
        }
    }
    func length(forCardType type: String) -> Int
    {
        switch type
        {
        case CardBrand.CardBrandAmex.rawValue:
            return 18
        case CardBrand.CardBrandDinersClub.rawValue:
            return 17
        case CardBrand.CardBrandJCB.rawValue,CardBrand.CardBrandMasterCard.rawValue,CardBrand.CardBrandVisa.rawValue,CardBrand.CardBrandDiscover.rawValue:
            return 19
        default:
            return 19
        }
    }
    func generateToken()
    {
        let strCard: String = txtCreditCardNumber.text!.replacingOccurrences(of: "-", with: "")
        let cardObject = STPCardParams()
        cardObject.number = strCard
        cardObject.expMonth = UInt(month.toInt() )
        cardObject.expYear = UInt(year.toInt() )
        cardObject.cvc = txtCvv.text
        let StpClient = STPAPIClient()
        StpClient.createToken(withCard: cardObject, completion: {(_ token: STPToken?, _ error: Error?) -> Void in
            if error != nil {
                Utility.hideLoading()
                self.openErrorDialog(message: (error?.localizedDescription)!)
                
            }
            else {
                
                     let card:ServerCard = ServerCard();
                    card.cardType = STPCard.string(from:(token?.card?.brand) ?? STPCardBrand.visa)
                    card.paymentToken = token?.tokenId ?? ""
                    card.lastFour = token?.card?.last4 ?? ""
                    card.cardExpiryDate = self.month  + "/" + self.year
                    card.cardHolderName = self.txtCardHolderName.text ?? ""
                    self.wsAddCardToServer(card: card)
                
              }
        })
    }
    func openErrorDialog(message:String)
    {
       Utility.showToast(message: message)
           
    }
    func checkValidation() -> Bool
    {
        if (txtCardHolderName.text?.count)! < 1
        {
            
            txtCardHolderName.showErrorWithText(errorText: "VALIDATION_MSG_ENTER_CARD_HOLDER_NAME_FIRST".localized)
            return false
        }
        else if (txtCreditCardNumber.text?.count)! < card_length
        {
                        txtCreditCardNumber.showErrorWithText(errorText: "VALIDATION_MSG_ENTER_VALID_CREDIT_CARD_NUMBER".localized)
           return false
        }
            
      
        else if (txtCvv.text?.count)! < 3
        {
            txtCvv.showErrorWithText(errorText: "VALIDATION_MSG_ENTER_VALID_CVV_NUMBER".localized)
            return false
        }
        else if (txtExpDate.text!.isEmpty())
        {
            txtExpDate.showErrorWithText(errorText: "VALIDATION_MSG_ENTER_VALID_EXPIRY_DATE".localized)
            return false
        }
        else
        {
            Utility.showLoading()
            return true
        }
    }
}
