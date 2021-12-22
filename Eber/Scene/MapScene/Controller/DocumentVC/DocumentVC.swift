//
//  DocumentVC.swift
//  edelivery
//
//  Created by tag on 07/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class DocumentVC: BaseVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    // MARK: - OUTLET
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lblMandatoryFields: UILabel!
    @IBOutlet weak var tblForDocumentList: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    /*doc Dialog*/
    @IBOutlet var dialogForDocument: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmitDocument: UIButton!
    
    @IBOutlet weak var stkForDoc: UIStackView!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtDocId: UITextField!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocTitle: UILabel!
    @IBOutlet weak var viewForDocumentImage: UIView!
    
    
    @IBOutlet weak var documentDialog: UIView!
    @IBOutlet weak var lblMandatory: UILabel!
    // MARK: - Variables
    var arrdocumentList:NSMutableArray = []
    var documentListLength:Int? = 0
    var selectedDocument:Document? = nil
    var selectedIndex = 0;
    var isPicAdded:Bool = false;
    var dialogForImage:CustomPhotoDialog? = nil;
    
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - LifeCycle
    override func viewDidLoad(){
        super.viewDidLoad()
        lblMandatory.isHidden = true
        if #available(iOS 10.0, *)
        {
            tblForDocumentList.refreshControl = refreshControl
        } else {
            tblForDocumentList.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: .valueChanged)
        
        setLocalization()
        wsGetDocumentList()
        btnSubmit.isEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        viewForDocumentImage.isUserInteractionEnabled = true
        viewForDocumentImage.addGestureRecognizer(tapGestureRecognizer)
        
        tblForDocumentList.estimatedRowHeight = 80
        tblForDocumentList.rowHeight = UITableView.automaticDimension
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        setupLayout()
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
    func setLocalization(){
       
        
        lblMandatoryFields.text = "TXT_MANDATORY_FIELDS".localized
        
        lblTitle.text = "TXT_DOCUMENTS".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        refreshControl.tintColor = UIColor.black
        view.addSubview(dialogForDocument)
        dialogForDocument.isHidden = true
        
        tblForDocumentList.backgroundColor = UIColor.themeViewBackgroundColor
        
        view.backgroundColor = UIColor.themeViewBackgroundColor
        lblMandatoryFields.textColor = UIColor.themeErrorTextColor;
        updateUI(isUpdate:false)
        
        /*Set Font*/
        lblMandatoryFields.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnSubmit.titleLabel?.font = FontHelper.font(size: FontSize.button, type: FontType.Regular)
        btnCancel.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        btnCancel.setTitle("TXT_CANCEL".localizedCapitalized, for: .normal)
        btnSubmitDocument.setTitle("TXT_SUBMIT".localizedCapitalized, for: .normal)
        btnSubmitDocument.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnSubmitDocument.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSubmitDocument.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        
        
        lblMandatory.text = "*".localized
        lblMandatory.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblMandatory.textColor = UIColor.themeErrorTextColor
        
        
        
        txtExpDate.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        txtDocId.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblDocTitle.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        btnSubmit.setTitle("TXT_SUBMIT".localized, for: .normal)
        btnSubmit.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSubmit.titleLabel?.font  = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        btnBack.setupBackButton()    
       
    }
    func setupLayout(){
         dialogForDocument.frame = view.bounds
        tblForDocumentList.tableFooterView = UIView.init()
        navigationView.navigationShadow()
        
        documentDialog.setShadow()
        documentDialog.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
         btnSubmit.setRound(withBorderColor: UIColor.clear, andCornerRadious: 25.0, borderWidth: 1.0)
        btnSubmitDocument.setRound(withBorderColor: .clear, andCornerRadious: 25, borderWidth: 1.0)
    }
    //MARK: TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return documentListLength!;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:DocumentCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DocumentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentdocument:Document = arrdocumentList[indexPath.row] as! Document
        cell.setCellData(cellItem: currentdocument)
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedDocument = arrdocumentList[indexPath.row] as? Document;
        selectedIndex = indexPath.row
        self.openDocumentUploadDialog(selectedDoc:selectedDocument!)
        
    }
    
    //MARK: TextField Delegate Method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtExpDate == textField
        {
            
            openDatePicker()
            return false
        }
        else
        {
            return true
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        return true;
    }
    //MARK:- ACTION FUNCTION
    @IBAction func onClickBtnSubmit(_ sender: Any){
        selectedDocument?.uniqueCode = txtDocId.text
        wsUploadDocuments(selectedDoc:selectedDocument!)
    }
    @IBAction func onClickBtnCancel(_ sender: Any){
        closeDocumentUploadDialog()
    }
    @IBAction func onClickBtnNext(_ sender: Any){
        onClickBtnBack()
    }
    @IBAction func onClickBtnBack(_ sender: Any){
        if(CurrentTrip.shared.user.isDocumentUploaded == FALSE)
        {
            self.openLogoutDialog()
            
        }
        else
        {
            if CurrentTrip.shared.tripStaus.trip.isProviderAccepted == TRUE {
                APPDELEGATE.gotoTrip()
            }
            else {
                APPDELEGATE.gotoMap()
            }
            
        }
    }
    func onClickBtnBack()
    {
       if(CurrentTrip.shared.user.isDocumentUploaded == FALSE)
        {
            self.openLogoutDialog()
            
        }
        else
        {
            if let navigation = self.navigationController
            {
                navigation.popViewController(animated: true);
            }
            else
            {
                APPDELEGATE.gotoMap()
            }
            
        }
    }
    /*Document Dialog image tapped*/
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.openImageDialog()
    }
    //MARK:- USER DEFINE FUNCTION
    
    @objc func handleRefresh(refreshControl: UIRefreshControl)
    {
     wsGetDocumentList()
    }
    func updateUI(isUpdate:Bool = false)
    {
        imgEmpty.isHidden = isUpdate
        tblForDocumentList.isHidden = !isUpdate
        lblMandatoryFields.isHidden = !isUpdate
        if (CurrentTrip.shared.user.isDocumentUploaded == TRUE)
        {
            self.btnSubmit.isEnabled = true
            btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        }
        else
        {
            self.btnSubmit.isEnabled = false
            btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        }
    }
    //MARK:- WEB SERVICE CALLS
    func wsGetDocumentList(){
        let dictParam: [String:Any] =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.TYPE:String(CONSTANT.TYPE_USER)]
        
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.GET_DOCUMENTS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { /*[unowned self]*/ (response, error) -> (Void) in
            
            Parser.parseDocumentList(response, toArray: self.arrdocumentList, completion: { (result) in
                if result
                {
                    DispatchQueue.main.async
                        { /*[unowned self] in*/
                            self.refreshControl.endRefreshing()
                            self.documentListLength = self.arrdocumentList.count;
                            self.tblForDocumentList.reloadData()
                            self.updateUI(isUpdate:true)
                            
                    }
                }
                else
                {
                    self.updateUI(isUpdate:false)
                }
            })
            
        }
    }
    func wsUploadDocuments(selectedDoc:Document){
        
        if(checkDocumentValidation())
        {
            
            
            
            var dictParam: Dictionary<String,Any> =
                [PARAMS.USER_ID:preferenceHelper.getUserId(),
                  PARAMS.TOKEN:preferenceHelper.getSessionToken(),
                 PARAMS.TYPE:String(CONSTANT.TYPE_USER),
                 PARAMS.DOCUMENT_ID:selectedDoc.id!,
                 ]
            
            if selectedDocument!.isUniqueCode! {
                dictParam.updateValue(selectedDoc.uniqueCode!, forKey: PARAMS.UNIQUE_CODE);
                
            }
            if selectedDocument!.isExpiredDate!
            {
                dictParam.updateValue(selectedDoc.expiredDate!, forKey: PARAMS.EXPIRED_DATE);
            }
            
            
            Utility.showLoading()
            let alamoFire:AlamofireHelper = AlamofireHelper.init();
            alamoFire.getResponseFromURL(url: WebService.UPLOAD_DOCUMENT, paramData: dictParam, image: imgDocument.image!, block: { (response, error) -> (Void) in
                
                if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true))
                {
               
                    let documentResponse:UploadDocumentResponse = UploadDocumentResponse.init(fromDictionary: response
                    )
                    
                    CurrentTrip.shared.user.isDocumentUploaded = documentResponse.isDocumentUploaded
                    
                    self.isPicAdded = false
                    self.selectedDocument?.documentPicture = documentResponse.documentPicture
                    
                    self.selectedDocument?.expiredDate = documentResponse.expiredDate
                    self.selectedDocument?.uniqueCode = documentResponse.uniqueCode
                    
                    
                    self.arrdocumentList.replaceObject(at: self.selectedIndex, with: self.selectedDocument!)
                    DispatchQueue.main.async
                        { [unowned self] in
                            self.tblForDocumentList.reloadData()
                            if (CurrentTrip.shared.user.isDocumentUploaded == TRUE)
                            {
                                self.btnSubmit.isEnabled = true
                                self.btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
                            }
                            else
                            {
                                self.btnSubmit.isEnabled = false
                                self.btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
                                
                            }
                            self.closeDocumentUploadDialog()
                    }
                    self.isPicAdded = false
                }
                Utility.hideLoading()
                
            })
        }
        
    }
    func checkDocumentValidation() -> Bool{
        
        
        
      
        
        if ((txtDocId.text?.isEmpty())! && (selectedDocument!.isUniqueCode)!)
        {
            Utility.showToast(message:"VALIDATION_MSG_PLEASE_ENTER_DOCUMENT_ID".localized)
            return false
        }
        else if ((txtExpDate.text?.isEmpty())! && (selectedDocument!.isExpiredDate)!)
        {
            Utility.showToast(message:"VALIDATION_MSG_PLEASE_ENTER_DOCUMENT_EXP_DATE".localized)
            return false
        }
        else if !isPicAdded
        {
            Utility.showToast(message:"VALIDATION_MSG_PLEASE_SELECT_DOCUMENT_IMAGE".localized)
            return false
        }
        else
        {
            return true
        }
    }
    func wsLogout()
    {
        self.view.endEditing(true)
        Utility.showLoading()
        
        
        var  dictParam : [String : Any] = [:]
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        
        dictParam[PARAMS.APP_VERSION] = currentAppVersion
        dictParam[PARAMS.USER_ID] =  preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.LOGOUT_USER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { /*[unowned self]*/ (response, error) -> (Void) in
            
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                
                if Parser.parseLogout(response: response)
                {
                    APPDELEGATE.gotoLogin()
                }
                else
                {
                    Utility.hideLoading()
                }
            }
        }
    }
    //MARK:- DIOLOGS
    func openDocumentUploadDialog(selectedDoc:Document)
    {
        
        dialogForDocument.frame = self.view.frame
        dialogForDocument.isHidden = false
        lblDocTitle.text = ""
        txtDocId.text = ""
        txtExpDate.text = ""
        txtDocId.placeholder = "TXT_ENTER_ID_NUMBER".localized
        txtExpDate.placeholder = "TXT_ENTER_EXP_DATE".localized
        txtDocId.isHidden = false
        txtExpDate.isHidden = false
        self.stkForDoc.isHidden = false
      
        lblDocTitle.text = selectedDocument!.name.uppercased()
        if((selectedDocument!.documentPicture!.isEmpty()))
        {
              self.imgDocument.image = UIImage.init(named: "asset-document-placeholder")
            
            if (selectedDocument!.isExpiredDate)!
            {
                txtExpDate.text = ""
                
            }
            else
            {
                txtExpDate.isHidden = true
            }
            if (selectedDocument!.isUniqueCode)!
            {
                txtDocId.text = ""
            }
            else
            {
                txtDocId.isHidden = true
                
            }
            if(txtExpDate.isHidden && txtDocId.isHidden)
            {
                self.stkForDoc.isHidden = true
                
            }
        }
        else
        {
            imgDocument.downloadedFrom(link: (selectedDocument?.documentPicture)!, placeHolder: "asset-document-placeholder")
            if (selectedDocument!.isExpiredDate)!
            {
                
                txtExpDate.text = Utility.stringToString(strDate: selectedDoc.expiredDate!, fromFormat: DateFormat.WEB, toFormat: DateFormat.DATE_FORMAT)
            }
            else
            {
                txtExpDate.isHidden = true
            }
            if (selectedDocument!.isUniqueCode)!
            {
                txtDocId.text = selectedDoc.uniqueCode
            }
            else
            {
                txtDocId.isHidden = true
                
            }
            if(txtExpDate.isHidden && txtDocId.isHidden)
            {
                self.stkForDoc.isHidden = true
            }
            
        }
        
        if (selectedDocument!.option == TRUE)
        {
            lblMandatory.isHidden = false
        }
        else
        {
            lblMandatory.isHidden = true
        }
        
        imgDocument.setRound()
        
    }
    func closeDocumentUploadDialog(){
        dialogForDocument.isHidden = true
        lblDocTitle.text = ""
        txtDocId.text = ""
        txtExpDate.text = ""
    }
    func openImageDialog(){
        self.view.endEditing(true)
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
        dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage]
            (image:UIImage) in
            self.imgDocument.image = image
            self.isPicAdded = true
            dialogForImage?.removeFromSuperviewAndNCObserver()
            dialogForImage = nil
        }
    }
    func openDatePicker(){
        self.view.endEditing(true)
        let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        let maxDate:Date =  Calendar.current.date(byAdding: .year, value: 100, to: Date()) ?? Date.init()
        datePickerDialog.setMaxDate(maxdate: maxDate)
        datePickerDialog.setMinDate(mindate: Date())
        
        datePickerDialog.onClickLeftButton =
            { [/*unowned self,*/ unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
        }
       
        datePickerDialog.onClickRightButton =
            { [unowned self, unowned datePickerDialog] (selectedDate:Date) in
                let currentDate = Utility.dateToString(date: selectedDate, withFormat: DateFormat.DATE_FORMAT)
                self.selectedDocument?.expiredDate = Utility.dateToString(date: selectedDate, withFormat: DateFormat.WEB)
                self.txtExpDate.text = currentDate
                datePickerDialog.removeFromSuperview()
        }
    }
    func openLogoutDialog(){
        
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_LOGOUT".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
        dialogForLogout.onClickLeftButton =
            { [/*unowned self,*/ unowned dialogForLogout] in
                dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton =
            { [unowned self, unowned dialogForLogout] in
                dialogForLogout.removeFromSuperview();
                self.wsLogout()
        }
    }
}





