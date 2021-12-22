//
//  JETanjoVC.swift
//  newt
//
//  Created by Elluminati  on 10/07/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class JETanjoVC: BaseVC {

    @IBOutlet weak var tblForMyDriver: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var lblEmptyMessage: UILabel!
    @IBOutlet var btnAddDriver: UIButton!
    
    var arrForProvider: [JETanjoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let footerView = UIView.init()
        footerView.backgroundColor = UIColor.themeViewBackgroundColor
        tblForMyDriver.tableFooterView = footerView
        initialViewSetup()
        tblForMyDriver.register(UINib(nibName: "JETanjoTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wsGetFavDrivers()
    }

    func initialViewSetup() {
        view.backgroundColor = UIColor.themeViewBackgroundColor
        tblForMyDriver.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblTitle.text = "TXT_JETANJO".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        lblEmptyMessage.text = "TXT_NO_JETANJO".localized
        lblEmptyMessage.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblEmptyMessage.textColor = UIColor.themeTextColor
        
        btnMenu.setupBackButton()
        
        btnAddDriver.setTitle("TXT_ADD_JETANJO".localized, for: .normal)
        btnAddDriver.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnAddDriver.backgroundColor = UIColor.themeButtonBackgroundColor
        btnAddDriver.titleLabel?.font  = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        btnAddDriver.setRound(withBorderColor: UIColor.clear, andCornerRadious: 25, borderWidth: 1.0)
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationView.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        navigationView.navigationShadow()
    }
   
    @IBAction func onClickBtnAddDriver(_ sender: Any) {
        performSegue(withIdentifier: SEGUE.ADD_JET_ANJO, sender: self)
    }

    func openConfirmationDialog() {
        let dialogForConfirmation = CustomAlertDialog.showCustomAlertDialog(title: "TXT_REMOVE_PROVIDER".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForConfirmation.onClickLeftButton =
            { [/*unowned self,*/ unowned dialogForConfirmation] in
                dialogForConfirmation.removeFromSuperview();
        }
        dialogForConfirmation.onClickRightButton =
            { [/*unowned self,*/ unowned dialogForConfirmation] in
                dialogForConfirmation.removeFromSuperview();
                //self.stripeVCObject?.wsDeleteCard(card: self.currentCard!)
        }
    }
    
    @IBAction func onClickBtnMenu(_ sender: Any) {
        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController
        {
            navigationVC.popToRootViewController(animated: true)
        }
    }
   
}

extension JETanjoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForProvider.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! JETanjoTableViewCell

        cell.addButton.tag = indexPath.row
        cell.addButton.setTitle(FontAsset.icon_cross_rounded, for: .normal)
        cell.addButton.addTarget(self, action: #selector(removeProvider(button:)), for: .touchUpInside)

        cell.setup(data: arrForProvider[indexPath.row])

        cell.selectionStyle = .none
        return cell
    }
    
    @objc func removeProvider(button: UIButton) {
        self.wsRemoveFromFavouriteProvider(index: button.tag)
    }
}

extension JETanjoVC {
    func wsGetFavDrivers() {
        self.view.endEditing(true)
        Utility.showLoading()
        
        var dictParam: [String : Any] = [:]
        dictParam[PARAMS.USER_ID] =  preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        
        let afh = AlamofireHelper()
        afh.getResponseFromURL(url: WebService.GET_FAVOURITE_FRIEND,
                               methodName: AlamofireHelper.POST_METHOD,
                               paramData: dictParam) { response, error in
            
            self.arrForProvider.removeAll()
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                
                if Parser.isSuccess(response: response)
                {
                    let providerResponse = JETanjoResponse(fromDictionary: response)
                    for provider in providerResponse.friendsList
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
    
    
    func wsRemoveFromFavouriteProvider(index:Int)
    {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID: arrForProvider[index].id
        ];
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.REMOVE_FAVOURITE_FRIEND, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { (response, error) -> (Void) in
            Utility.hideLoading()
            if (Parser.isSuccess(response: response, withSuccessToast: true,andErrorToast: true))
            {
                self.arrForProvider.remove(at: index)
                self.updateUIForEmptyProvider()
            }
        }
        
    }
    
    func updateUIForEmptyProvider()
    {
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

