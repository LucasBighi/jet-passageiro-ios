//
//  SettingVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit


class SettingVC: BaseVC
{
        /*View For Language Navigation*/
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnLanguage: UIButton!
    /*View For Language Notification*/
    @IBOutlet weak var lblLanguageTitle: UILabel!
    @IBOutlet weak var lblLanguageMessage: UILabel!
    @IBOutlet weak var viewForLanguage: UIView!

    /*View For Emergency Contact*/

    @IBOutlet weak var lblEmergencyContacts: UILabel!
    @IBOutlet weak var btnAddContact: UIButton!
    @IBOutlet weak var tblForEmegencyContact: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    //MARK: View life cycle
    
    @IBOutlet weak var viewForNotifiationSound: UIView!
    @IBOutlet weak var lblStopNotificationSound: UILabel!
    @IBOutlet weak var lblStopNotificationSoundMessage: UILabel!
    @IBOutlet weak var swNotificationSound: UISwitch!
    
    @IBOutlet weak var viewForArrivedNotifiationSound: UIView!
    @IBOutlet weak var lblStopArrivedNotificationSound: UILabel!
    @IBOutlet weak var lblStopArrivedNotificationSoundMessage: UILabel!
    @IBOutlet weak var swArrivedNotificationSound: UISwitch!
    
    @IBOutlet weak var lblAppVersion: UILabel!
    @IBOutlet weak var lblAppVersionValue: UILabel!
    
   
    @IBOutlet weak var viewForPushNotifiationSound: UIView!
    @IBOutlet weak var lblStopPushNotificationSound: UILabel!
    @IBOutlet weak var lblStopPushNotificationSoundMessage: UILabel!
    @IBOutlet weak var swPushNotificationSound: UISwitch!
    
    
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var contactId:String = "";
    var nameToSave:String = "";
    var numberDescription :String = ""
    
    var arrForEmegerncyContacts:[EmergencyContactData] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setLocalization()
        lblLanguageMessage.text = LocalizeLanguage.currentAppleLanguageFull()
        self.wsGetEmergencyContactList()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        swNotificationSound.isOn = preferenceHelper.getIsSoundOn()
        swArrivedNotificationSound.isOn = preferenceHelper.getIsArivedSoundOn()
        swPushNotificationSound.isOn = preferenceHelper.getIsPushSoundOn()
    }
    
   
    

    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        navigationView.navigationShadow()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }

    @IBAction func onSwitchValueChanged(_ sender: Any) {
        preferenceHelper.setIsSoundOn(swNotificationSound.isOn)
    }
    @IBAction func onArrivedSwitchChange(_ sender: Any) {
        preferenceHelper.setIsArivedSoundOn(swArrivedNotificationSound.isOn)
    }
    @IBAction func onPushSwitchChange(_ sender: Any) {
        preferenceHelper.setIsPushSoundOn(swPushNotificationSound.isOn)
    }
    func setLocalization()
    {

        viewForLanguage.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblTitle.text = "TXT_SETTINGS".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        
        
        lblAppVersion.text = "TXT_APP_VERSION".localized
        lblAppVersion.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblAppVersion.textColor = UIColor.themeTextColor
        
        
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        
        lblAppVersionValue.textColor = UIColor.themeLightTextColor
        lblAppVersionValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblAppVersionValue.text = currentAppVersion
        
        
        
        lblLanguageTitle.text = "TXT_LANGUAGE".localized
        lblLanguageTitle.textColor = UIColor.themeTextColor
        lblLanguageTitle.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        
        lblLanguageMessage.textColor = UIColor.themeLightTextColor
        lblLanguageMessage.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblLanguageMessage.text = "MSG_LANGUAGE".localized
        
        
        lblEmergencyContacts.textColor = UIColor.themeTextColor
        lblEmergencyContacts.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblEmergencyContacts.text = "TXT_EMERGENCY_CONTACTS".localized
        
        
        
        lblStopNotificationSound.textColor = UIColor.themeTextColor
        lblStopNotificationSound.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblStopNotificationSound.text = "TXT_SOUND_ALERT".localized
        
        
        lblStopNotificationSoundMessage.textColor = UIColor.themeTextColor
        lblStopNotificationSoundMessage.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        lblStopNotificationSoundMessage.text = "TXT_SOUND_ALERT_MESSAGE".localized
        
        
        
        
        lblStopArrivedNotificationSound.textColor = UIColor.themeTextColor
        lblStopArrivedNotificationSound.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblStopArrivedNotificationSound.text = "TXT_ARRIVED_ALERT".localized
        
        
        lblStopArrivedNotificationSoundMessage.textColor = UIColor.themeTextColor
        lblStopArrivedNotificationSoundMessage.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        lblStopArrivedNotificationSoundMessage.text = "TXT_ARRIVED_ALERT_MESSAGE".localized
        
        lblStopPushNotificationSound.textColor = UIColor.themeTextColor
        lblStopPushNotificationSound.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblStopPushNotificationSound.text = "TXT_PUSH_NOTIFICATION".localized
        
        
        lblStopPushNotificationSoundMessage.textColor = UIColor.themeTextColor
        lblStopPushNotificationSoundMessage.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        lblStopPushNotificationSoundMessage.text = "TXT_PUSH_NOTIFICATION_SOUND_MESSAGE".localized
        
        
        btnAddContact.setTitle(" + " + "TXT_ADD".localizedCapitalized, for: .normal)
        btnAddContact.setTitleColor(UIColor.themeButtonBackgroundColor , for: .normal)
        btnAddContact.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)

        
        btnBack.setupBackButton()    
    }
    //MARK:
    //MARK: Button action methods
    
    @IBAction func openLangueDialog(_ sender: Any) {
        self.openLanguageDialog()
    }

    @IBAction func logoutAction(_ sender: Any) {
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_LOGOUT".localized,
                                                                      message: "MSG_LOGOUT".localized,
                                                                      titleLeftButton: "TXT_NO".localized,
                                                                      titleRightButton: "TXT_YES".localized)

        dialogForLogout.onClickLeftButton = { [unowned dialogForLogout] in
            dialogForLogout.removeFromSuperview();
        }

        dialogForLogout.onClickRightButton = { [unowned self] in
            dialogForLogout.removeFromSuperview();
            self.wsLogout()
        }
    }

    func openLanguageDialog()
    {
        
        let dialogForLanguage:CustomLanguageDialog = CustomLanguageDialog.showCustomLanguageDialog()
        
        dialogForLanguage.onItemSelected =
            { [unowned self] (selectedItem:Int) in
                self.changed(selectedItem)
        }
    }
    
    @IBAction func onClickBtnAddNewContact(_ sender: Any) {
        let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:false, subtitleCellType: SubtitleCellValue.email)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func onClickBtnMenu(_ sender: Any) {
        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController
        {
            navigationVC.popToRootViewController(animated: true)
        }
    }
}

extension SettingVC {
    func wsLogout() {
        self.view.endEditing(true)
        Utility.showLoading()

        var dictParam: [String : Any] = [:]
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        dictParam[PARAMS.APP_VERSION] = currentAppVersion
        dictParam[PARAMS.USER_ID] =  preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()

        let afh = AlamofireHelper()
        afh.getResponseFromURL(url: WebService.LOGOUT_USER,
                               methodName: AlamofireHelper.POST_METHOD,
                               paramData: dictParam) { [unowned self] response, error in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                if Parser.parseLogout(response: response) {
                    self.clearPBRevealVC()
                    APPDELEGATE.gotoLogin()
                } else {
                    Utility.hideLoading()
                }
            }
        }
    }
}

extension SettingVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForEmegerncyContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EmergencyContactCell
        {
            cell.setData(data: arrForEmegerncyContacts[indexPath.row])
            cell.btnDelete.tag = indexPath.row
            cell.swForShareDetail.tag = indexPath.row
            cell.swForShareDetail.addTarget(self, action: #selector(self.updateContact(sender:)), for: .valueChanged)
            cell.btnDelete.addTarget(self, action: #selector(self.deleteContact(sender:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell.init()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func deleteContact(sender :UIButton)
    {
        wsDeleteEmergencyContactList(id: arrForEmegerncyContacts[sender.tag].id)
        
    }
    @objc func updateContact(sender :UISwitch)
    {
        if sender.isOn
        {
        wsUpdateEmergencyContactList(contact: arrForEmegerncyContacts[sender.tag], shareDetail: TRUE)
        }
        else
        {
        wsUpdateEmergencyContactList(contact: arrForEmegerncyContacts[sender.tag], shareDetail: FALSE)
        }
        
    }
    
    
}
extension SettingVC : EPPickerDelegate
{
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error : NSError)
    {
        printE("Failed with error \(error.description)")
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact : EPContact)
    {
     
        
        
        
        if contact.phoneNumbers.count > 1
        {
            let multiplePhoneNumbersAlert = UIAlertController(title: "Which one?", message: "This contact has multiple phone numbers, which one did you want use?", preferredStyle: UIAlertController.Style.alert)
         
            for number in contact.phoneNumbers
            {
                
                let numberAction = UIAlertAction(title: number.phoneNumber, style: UIAlertAction.Style.default, handler: { (theAction) -> Void in
            
                    self.numberDescription = number.phoneNumber
                    self.nameToSave = contact.displayName()
                    self.wsAddEmergencyContactList()
                    })
                    //Add the action to the AlertController
                    multiplePhoneNumbersAlert.addAction(numberAction)
            }
        
            //Add a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (theAction) -> Void in
                //Cancel action completion
            })
            //Add the cancel action
            multiplePhoneNumbersAlert.addAction(cancelAction)
            //Present the ALert controller
            self.present(multiplePhoneNumbersAlert, animated: true, completion: nil)
        }
        else if contact.phoneNumbers.isEmpty
        {
            let noPhoneNumbersAlert = UIAlertController(title: "Missing info", message: "You have no phone numbers associated with this contact", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "TXT_OK".localized, style: UIAlertAction.Style.cancel, handler: { (theAction) -> Void in
                //Cancel action completion
            })
            noPhoneNumbersAlert.addAction(cancelAction)
            //Present the ALert controller
            self.present(noPhoneNumbersAlert, animated: true, completion: nil)
            
        }
        else
        {
            self.numberDescription = contact.phoneNumbers[0].phoneNumber
            self.nameToSave = contact.displayName()
            
            self.wsAddEmergencyContactList()
        }
    
    }
    
    func epContactPicker(_: EPContactsPicker, didCancel error : NSError)
    {
        printE("User canceled the selection");
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) {
        printE("The following contacts are selected")
        for contact in contacts {
            printE("\(contact.displayName())")
        }
    }
   
}

extension SettingVC
{
    
    func wsGetEmergencyContactList()
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.DEVICE_TOKEN] = preferenceHelper.getDeviceToken()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_EMERGENCY_CONTACT_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response,withSuccessToast: false,andErrorToast: false)
                {
                    self.arrForEmegerncyContacts.removeAll()
                    let responseContact:EmergencyContactResponse = EmergencyContactResponse.init(fromDictionary: response)
                    
                    for data in responseContact.emergencyContactData
                    {
                        self.arrForEmegerncyContacts.append(data)
                        
                    }
                    self.tblForEmegencyContact.reloadData()
                    self.tableViewHeight.constant = self.tblForEmegencyContact.contentSize.height
                    self.tblForEmegencyContact.isHidden = false
                    Utility.hideLoading()
                    
                }
                else
                {
                    self.tblForEmegencyContact.reloadData()
                    self.tblForEmegencyContact.isHidden = true
                    Utility.hideLoading()
                }
            }
        }
    }
    
    func wsAddEmergencyContactList()
    {
        
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.DEVICE_TOKEN] = preferenceHelper.getDeviceToken()
        dictParam[PARAMS.NAME] = self.nameToSave
        dictParam[PARAMS.PHONE] = self.numberDescription
        dictParam[PARAMS.IS_ALWAYS_SHARE_RIDE_DETAIL] = TRUE
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.ADD_EMERGENCY_CONTACT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
         
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    self.wsGetEmergencyContactList()
                }
                else
                {
                    Utility.hideLoading()
                }
            }
        }
    }
    
    func wsDeleteEmergencyContactList(id:String)
    {
        
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.DEVICE_TOKEN] = preferenceHelper.getDeviceToken()
        dictParam[PARAMS.EMERGENCY_CONTACT_DETAIL_ID] = id

        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.DELETE_EMERGENCY_CONTACT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    self.wsGetEmergencyContactList()
                }
                else
                {
                    Utility.hideLoading()
                }
            }
        }
    }
    func wsUpdateEmergencyContactList(contact:EmergencyContactData, shareDetail:Int)
    {
        
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.DEVICE_TOKEN] = preferenceHelper.getDeviceToken()
        dictParam[PARAMS.NAME] = contact.name
        dictParam[PARAMS.PHONE] = contact.phone
          dictParam[PARAMS.EMERGENCY_CONTACT_DETAIL_ID] = contact.id
        dictParam[PARAMS.IS_ALWAYS_SHARE_RIDE_DETAIL] = shareDetail
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.UPDATE_EMERGENCY_CONTACT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    
                    self.wsGetEmergencyContactList()
                }
                else
                {
                    Utility.hideLoading()
                }
            }
        }
    }
    
}
