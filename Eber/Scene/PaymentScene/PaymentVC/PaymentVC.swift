//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
class PaymentVC: BaseVC,UITabBarDelegate,UIScrollViewDelegate
{
//MARK: OutLets
    
    /*Navigation View*/
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var switchForWallet: UISwitch!
    @IBOutlet weak var lblWallet: UILabel!
    
    /*Credit Card View*/
    @IBOutlet weak var lblCreditCards: UILabel!
    @IBOutlet weak var tblCreditCards: UITableView!
    @IBOutlet weak var creditCardTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewForShabCredits: UIView!
   
    @IBOutlet weak var mainSCrollview: UIScrollView!
    @IBOutlet weak var btnWalletHistory: UIButton!
    @IBOutlet weak var btnAddCard: UIButton!
    
    
    @IBOutlet weak var lblWalletValue: UILabel!
    
    @IBOutlet weak var lblNoCards: UILabel!
    
    @IBOutlet weak var btnAddWalletAmount: UIButton!
    @IBOutlet weak var txtAddWallet: ACFloatingTextfield!
    
    @IBOutlet weak var lblIconWalllet: UILabel!
    
    var deleteCardID:String = ""
    var selectedCard:Card = Card.init(fromDictionary: [:])
    
    var arrForCard:[Card] = []
//MARK: LIFE CYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initialViewSetup()
        
        
      }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        wsGetAllCards()
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
         setUpLayout()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
    }
    
    func setUpLayout()
    {
        navigationView.navigationShadow()
        btnAddCard.setRound(withBorderColor: UIColor.clear, andCornerRadious: 25, borderWidth: 1.0)
    }
    
    
    
    
    func  initialViewSetup()
    {
 
        lblTitle.text = "TXT_PAYMENTS".localized
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        
        lblCreditCards.text = "TXT_CREDIT_CARD".localized
        lblCreditCards.textColor = UIColor.themeTextColor
        lblCreditCards.font = FontHelper.font(size: FontSize.small, type: .Bold)
        
        
        lblWallet.text = "TXT_WALLET".localized
        lblWallet.textColor = UIColor.themeLightTextColor
        lblWallet.font = FontHelper.font(size: FontSize.small, type: .Regular)
        
        
        lblNoCards.text = "TXT_NO_CREDIT_CARD".localized
        lblNoCards.textColor = UIColor.themeTextColor
        lblNoCards.font = FontHelper.font(size: FontSize.regular, type: .Light)
        
        
        
       
        
      
      
        lblWalletValue.textColor = UIColor.themeButtonBackgroundColor
        lblWalletValue.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        
        
        btnAddCard.setTitle("TXT_ADD_CARD".localizedCapitalized, for: .normal)
        btnAddCard.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnAddCard.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Bold)
        btnAddCard.backgroundColor = UIColor.themeButtonBackgroundColor
        
        btnEdit.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnEdit.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Light)
        btnEdit.isSelected = false
        switchForWallet.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        
        
        
        btnWalletHistory.setTitle("TXT_WALLET_HISTORY".localizedCapitalized, for: .normal)
        btnWalletHistory.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnWalletHistory.titleLabel?.font = FontHelper.font(size: FontSize.small, type: .Light)
        
        
        self.btnWalletHistory.isEnabled = true
        self.txtAddWallet.isHidden = true
        
        btnAddWalletAmount.setTitle("TXT_ADD".localizedCapitalized + "  ", for: .normal)
        btnAddWalletAmount.setTitle("TXT_SUBMIT".localizedCapitalized + "  ", for: .selected)
        
        btnAddWalletAmount.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnAddWalletAmount.setTitleColor(UIColor.themeButtonBackgroundColor, for: .selected)
        btnAddWalletAmount.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Bold)
        lblIconWalllet.setForIcon()
        
        btnBack.setupBackButton()    
      }
    
    @IBAction func onClickBtnAddWallet(_ sender: Any) {
        self.view.endEditing(true)
        if btnAddWalletAmount.isSelected
        {
            if !selectedCard.id.isEmpty && txtAddWallet.text!.toDouble() != 0.0
            {
                btnAddWalletAmount.isSelected = !btnAddWalletAmount.isSelected
            
                wsAddAmountToWallet(card: selectedCard, amount: txtAddWallet.text!.toDouble())
                
            }
            else
            {
                if selectedCard.id.isEmpty
                {
                    Utility.showToast(message: "VALIDATION_MSG_ADD_CARD_FIRST".localized)
                }
                if txtAddWallet.text!.toDouble() == 0.0
                {
                    Utility.showToast(message: "VALIDATION_MSG_VALID_AMOUNT".localized)
                }
            }
        }
        else
        {
            self.txtAddWallet.isHidden = false
            self.lblWalletValue.isHidden = true
            btnAddWalletAmount.isSelected = !btnAddWalletAmount.isSelected
        }
        
        
    }
    @IBAction func onClickBtnEdit(_ sender: Any) {
        btnEdit.isSelected = !btnEdit.isSelected
        
    }
    @IBAction func onClickBtnMenu(_ sender: Any) {
        if btnAddWalletAmount.isSelected
        {
            self.txtAddWallet.isHidden = true
            self.lblWalletValue.isHidden = false
            self.txtAddWallet.text = ""
            self.btnAddWalletAmount.isSelected = false
           
        }
        else
        {
            if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController
            {
                navigationVC.popToRootViewController(animated: true)
            }
        }
       
    }
   
    @IBAction func onClickBtnAddCard(_ sender: Any) {
        //self.performSegue(withIdentifier: SEGUE.PAYMENT_TO_ADD_CARD, sender: self)
        showAlertDialog(type: .ok,
                        message: "TXT_ADD_CARD_ERROR".localized) { alertDialog in
            alertDialog.dismiss(animated: false)
        }
    }
   
    @IBAction func onClickSwitchWallet(_ sender: Any)
    {
        self.view.endEditing(true)
        wsChangeWalletStatus(status:switchForWallet.isOn)
    }
    @IBAction func onClickBtnWalletHistory(_ sender: Any) {
        
        self.performSegue(withIdentifier: SEGUE.WALLET_HISTORY, sender: self)
    }
}

extension PaymentVC
{
    
   
    func wsGetAllCards()
    {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        
        let dictParam : [String : Any] =
            [ PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.USER_ID : preferenceHelper.getUserId()];
        
        
        afh.getResponseFromURL(url: WebService.USER_GET_CARDS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                self.selectedCard = Card.init(fromDictionary: [:])
                
                if Parser.isSuccess(response: response)
                {
                    
                    self.arrForCard.removeAll()
                    let allCardResponse:AllCardResponse = AllCardResponse.init(fromDictionary: response)
                    self.switchForWallet.isOn = (allCardResponse.isUseWallet == 1)
                    
                  self.lblWalletValue.text =  allCardResponse.wallet.toString(places: 2) + " " + allCardResponse.walletCurrencyCode
                    
                    
                    for card in allCardResponse.card
                    {
                        if card.isDefault == TRUE
                        {
                            self.selectedCard = card
                        }
                        self.arrForCard.append(card)
                    }
                    if self.arrForCard.count > 0
                    {
                        self.tblCreditCards.isHidden = false
                        self.tblCreditCards.reloadData()
                        self.lblNoCards.isHidden = true
                        self.creditCardTableViewHeight.constant = self.tblCreditCards.contentSize.height
                    }
                    else
                    {
                        self.tblCreditCards.isHidden = true
                        self.lblNoCards.isHidden = false
                        self.creditCardTableViewHeight.constant = 100
                    }

                    Utility.hideLoading()
                 
                }
            }
            
        }
    }
    
    
    func wsSelectCard(card:Card)
    {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
             PARAMS.TOKEN  : preferenceHelper.getSessionToken(),
             PARAMS.CARD_ID: card.id!,
             PARAMS.TYPE : CONSTANT.TYPE_USER
        ]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.DEFAULT_CARD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        {
            (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response)
            {
                
                DispatchQueue.main.async
                    { [unowned self] in
                        for card in self.arrForCard
                        {
                            card.isDefault = FALSE;
                        }
                        card.isDefault = TRUE
                        self.tblCreditCards.reloadData()
                }
            }
            
        }
    }
    func wsDeleteCard(card:Card)
    {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        
        let dictParam : [String : Any] =
            [ PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.USER_ID : preferenceHelper.getUserId(),
              PARAMS.CARD_ID : card.id!,
              PARAMS.TYPE : CONSTANT.TYPE_USER];
        
        
        afh.getResponseFromURL(url: WebService.DELETE_CARD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
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
                    DispatchQueue.main.async { [unowned self] in
                        
                        if let index = self.arrForCard.firstIndex(where: { (iterateCard) -> Bool in
                            card.id ==  iterateCard.id
                        })
                        {
                        if (card.isDefault != nil)
                        {
                            self.arrForCard.remove(at: index)
                            if self.arrForCard.count == 0
                            {
                                   
                            }
                            else
                            {
                            self.wsSelectCard(card: self.arrForCard[0])
                            }
                        }
                        else
                        {
                            self.arrForCard.remove(at: index)
                            
                        }
                        }
                        self.tblCreditCards.reloadData()
                    }
                 }
            }
            
        }
    }
    
   
    func wsChangeWalletStatus(status:Bool)
    {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId(),
             PARAMS.TOKEN  : preferenceHelper.getSessionToken() ,
             PARAMS.IS_WALLET   :  status]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.CHANGE_WALLET_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { (response, error) -> (Void) in
            
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)
            {
                Utility.hideLoading()
                
                let walletStatus:WalletStatusResponse = WalletStatusResponse.init(fromDictionary: response)
                self.switchForWallet.setOn(walletStatus.isUseWallet, animated: true)
                
            }
        }
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func wsAddAmountToWallet(card:Card, amount:Double)
    {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId(),
             PARAMS.TOKEN  : preferenceHelper.getSessionToken(),
             PARAMS.CARD_ID   : card.id!,
             PARAMS.PAYMENT_TOKEN:card.paymentToken!,
             PARAMS.WALLET: amount,
             PARAMS.TYPE : CONSTANT.TYPE_USER
        ]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.ADD_WALLET_AMOUNT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)
            {
                if let walletResponse:WalletResponse = WalletResponse.init(dictionary: response)
                {
                
                    self.txtAddWallet.isHidden = true
                    self.lblWalletValue.isHidden = false
                     self.txtAddWallet.text = ""
                    self.lblWalletValue.text = walletResponse.wallet.toString(places: 2) + " " + walletResponse.walletCurrencyCode
                }
            }
        }
    }
}
extension PaymentVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForCard.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StripeCardCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StripeCardCell
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.isUserInteractionEnabled = true
        cell.setCellData(cellItem: arrForCard[indexPath.row], parent: self)
        return cell;
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.wsSelectCard(card:arrForCard[indexPath.row])
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class StripeCardCell: UITableViewCell
{
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var btnDefault: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    //MARK:- Variables
    weak var stripeVCObject:PaymentVC?
    var currentCard:Card?
    
    @IBOutlet weak var lblCardIcon: UILabel!
    deinit {
        printE("\(self) \(#function)")
    }
    
    //MARK:- LIFECYCLE
    override func awakeFromNib()
    {
        super.awakeFromNib()
        lblCardNumber.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblCardNumber.textColor = UIColor.themeTextColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        lblCardIcon.text = FontAsset.icon_card
        self.lblCardIcon.setForIcon()
        btnDelete.setTitle(FontAsset.icon_cancel, for: .normal)
        btnDelete.setSimpleIconButton()
        
        btnDefault.setTitle(FontAsset.icon_checked, for: .normal)
        btnDefault.setSimpleIconButton()
    }
    //MARK:- SET CELL DATA
    func setCellData(cellItem:Card,parent:PaymentVC)
    {
        currentCard = cellItem
        stripeVCObject = parent
        lblCardNumber.text = "****" + cellItem.lastFour
        btnDefault.isHidden = !(cellItem.isDefault == TRUE)
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickBtnDeleteCard(_ sender: AnyObject)
    {
        openConfirmationDialog()
    }
    
    func openConfirmationDialog()
    {
        
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_DELETE_CARD".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForLogout.onClickLeftButton =
            { [/*unowned self,*/ unowned dialogForLogout] in
                dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton =
            { [unowned self, unowned dialogForLogout] in
                dialogForLogout.removeFromSuperview();
                self.stripeVCObject?.wsDeleteCard(card: self.currentCard!)
        }
    }
}

extension PaymentVC : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtAddWallet
        {
            
            let textFieldString = textField.text! as NSString;
            
            let newString = textFieldString.replacingCharacters(in: range, with:string)
            
            let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
            
            let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
            
            return floatExPredicate.evaluate(with: newString)
        }
        return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}
