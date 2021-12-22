
//
//  OrderHistoryVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class WalletHistoryVC: BaseVC, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var arrForWalletHistory = NSMutableArray()
    var selectedWalletRequest:WalletHistoryItem?  = nil
    
    
    //MARK:
    //MARK: View life cycle
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        self.setLocalization()
        wsGetWalletHistory()
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        
        
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        setupLayout()

    }
    //MARK:
    //MARK: Set localized layout
    func setLocalization()
    {
        view.backgroundColor = UIColor.themeViewBackgroundColor;
        tableView.tableFooterView = UIView()
        
        lblTitle.text = "TXT_WALLET_HISTORY".localizedCapitalized
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        
        updateUI(isUpdate: false)
        //LOCALIZED
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        
        
        btnBack.setupBackButton()    
    }
    func setupLayout()
    {
       
        tableView.tableFooterView = UIView()
        navigationView.navigationShadow()
    }
    @IBAction func onClickBtnMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:
    //MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrForWalletHistory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletHistoryCell", for: indexPath) as! WalletHistoryCell
        
        let walletData = (arrForWalletHistory[indexPath.row] as! WalletHistoryItem)
        cell.setWalletHistoryData(walletRequestData: walletData )
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedWalletRequest = arrForWalletHistory[indexPath.row] as? WalletHistoryItem
       
        self.performSegue(withIdentifier: SEGUE.WALLET_HISTORY_TO_WALLET_HISTORY_DETAIL, sender: selectedWalletRequest)
       
        
    }
   
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        
      let obj = segue.destination as! WalletHistoryDetailVC
       obj.walletDetail = sender as? WalletHistoryItem
    }
    
    //MARK:
    //MARK: Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:
    //MARK: User Define Function
    
    func updateUI(isUpdate:Bool = false)
    {
        imgEmpty.isHidden = isUpdate
        tableView.isHidden = !isUpdate
    }
    //MARK:WebService Calls
   
    func wsGetWalletHistory()
    {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.TYPE :String(CONSTANT.TYPE_USER)]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_WALLET_HISTORY, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        {  (response, error) -> (Void) in
            
            Parser.parseWalletHistory(response , toArray: self.arrForWalletHistory, completion: { [unowned self] (result) in
                if result
                {
                    self.tableView.reloadData()
                    self.updateUI(isUpdate: true)
                }
                else
                {
                    self.updateUI(isUpdate: false)
                 }
                Utility.hideLoading()
            })
            
        }
    }
}
