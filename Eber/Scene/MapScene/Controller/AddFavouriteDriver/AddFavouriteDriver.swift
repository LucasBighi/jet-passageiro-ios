//
//  AddFavouriteDriver.swift
//  newt
//
//  Created by Elluminati  on 10/07/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class AddFavouriteDriverVC: BaseVC {

    @IBOutlet weak var tblForMyDriver: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var lblEmptyMessage: UILabel!
    @IBOutlet var searchView: UIView!
    
    @IBOutlet var lblIconSearch: UILabel!
    @IBOutlet var txtSearch: UITextField!
    
    @IBOutlet var btnSearch: UIButton!
    
    
    var arrForProvider:[Provider] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let footerView = UIView.init()
        footerView.backgroundColor = UIColor.themeViewBackgroundColor
        tblForMyDriver.tableFooterView = footerView
        tblForMyDriver.reloadData()
        initialViewSetup()
        txtSearch.placeholder = "TXT_ENTER_DRIVER_EMAIL_HERE".localized
        self.tblForMyDriver.register(UINib.init(nibName: "CustomDriverDetailCell", bundle: nil), forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wsGetDriverList(strSearchValue: "")
    }
    func initialViewSetup()
    {
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tblForMyDriver.backgroundColor = UIColor.themeViewBackgroundColor
        
        
        lblTitle.text = "TXT_ADD_FAVOURITE_DRIVER".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        lblEmptyMessage.text = "TXT_NO_DRIVER".localized
        lblEmptyMessage.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblEmptyMessage.textColor = UIColor.themeTextColor
        
        btnMenu.setupBackButton()
        
        lblIconSearch.text = FontAsset.icon_search
        lblIconSearch.setForIcon()
        
        btnSearch.setTitle("TXT_SEARCH".localized, for: .normal)
        btnSearch.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        btnSearch.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnSearch.backgroundColor = UIColor.themeButtonBackgroundColor
        
        
    }
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
       navigationView.navigationShadow()
       btnSearch.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnSearch.frame.height/2 , borderWidth: 1.0)
        
    }
   
    @IBAction func onClickBtnSearchDriver(_ sender: Any) {
        self.wsGetDriverList(strSearchValue: txtSearch.text!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
   
    func openConfirmationDialog()
    {
        
        let dialogForConfirmation = CustomAlertDialog.showCustomAlertDialog(title: "TXT_REMOVE_PROVIDER".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForConfirmation.onClickLeftButton =
            { [/*unowned self,*/ unowned dialogForConfirmation] in
                dialogForConfirmation.removeFromSuperview();
        }
        dialogForConfirmation.onClickRightButton =
            { [unowned self, unowned dialogForConfirmation] in
                dialogForConfirmation.removeFromSuperview();
                //self.stripeVCObject?.wsDeleteCard(card: self.currentCard!)
        }
    }
    
    @IBAction func onClickBtnMenu(_ sender: Any) {
        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController
        {
            navigationVC.popViewController(animated: true)
        }
    }
   
}

extension AddFavouriteDriverVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrForProvider.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! CustomDriverDetailCell;
        
        cell.btnRemoveDriver.tag = indexPath.row
        cell.btnRemoveDriver.setTitle(FontAsset.icon_add, for: .normal)
        cell.btnRemoveDriver.addTarget(self, action: #selector(addProvider(button:)), for: .touchUpInside)
        
        cell.setData(data: arrForProvider[indexPath.row])
       
        cell.selectionStyle = UITableViewCell.SelectionStyle.none;
        return cell
    }
    
    @objc func addProvider(button: UIButton) {
        self.wsAddToFavouriteProvider(index: button.tag)
    }
    
    
}

extension AddFavouriteDriverVC
{
    func wsGetDriverList(strSearchValue: String)
    {
        self.view.endEditing(true)
        Utility.showLoading()
        
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] =  preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.SEARCH_VALUE] = strSearchValue

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_ALL_DRIVER_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            self.arrForProvider.removeAll()
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    let providerResponse:ProviderListResponse = ProviderListResponse.init(fromDictionary: response)
                    for provider in providerResponse.provider_list
                    {
                        self.arrForProvider.append(provider)
                    }
                    
                    Utility.hideLoading()
                }
                else
                {
                    
                    Utility.hideLoading()
                }
            }
            self.updateUIForEmptyProvider()
            self.tblForMyDriver.reloadData()
        }
    }
    
    
    func wsAddToFavouriteProvider(index:Int)
    {
        if let strProviderId = self.arrForProvider[index].id, strProviderId.isEmpty == false
        {
            Utility.showLoading()
            let dictParam: Dictionary<String,Any> =
                [PARAMS.USER_ID:preferenceHelper.getUserId(),
                 PARAMS.TOKEN:preferenceHelper.getSessionToken(),
                 PARAMS.PROVIDER_ID:strProviderId
            ];
            let afn:AlamofireHelper = AlamofireHelper.init();
            afn.getResponseFromURL(url: WebService.ADD_FAVOURITE_DRIVER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
            { (response, error) -> (Void) in
                Utility.hideLoading()
                if (Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true))
                {
                    self.arrForProvider.remove(at: index)
                    self.updateUIForEmptyProvider()
                }
            }
        }
        
    }
    
    func updateUIForEmptyProvider()
    {
        txtSearch.text = ""
        if arrForProvider.count > 0
        {
            lblEmptyMessage.isHidden = true
            tblForMyDriver.isHidden = false
        }
        else
        {
            lblEmptyMessage.isHidden = false
            tblForMyDriver.isHidden = true
        }
        tblForMyDriver.reloadData()
    }
}

