//
//  InvoiceVC.swift
//  Edelivery
//   Created by Ellumination 23/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class InvoiceVC: BaseVC
{
    
    /*Header View*/
    @IBOutlet var navigationView: UIView!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var lblTripType: UILabel!
    
    
    
    @IBOutlet var viewForHeader: UIView!
    @IBOutlet var lblTotalTime: UILabel!
    @IBOutlet var imgPayment: UIImageView!
    @IBOutlet var lblPaymentIcon: UILabel!
    @IBOutlet var lblPaymentMode: UILabel!
    @IBOutlet var lblDistance: UILabel!
    
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lblTotalValue: UILabel!
    
    @IBOutlet var viewForiInvoiceDialog: UIView!
    @IBOutlet var lblTripId: UILabel!
    @IBOutlet var lblMinFare: UILabel!
    
    @IBOutlet var tblForInvoice: UITableView!
    @IBOutlet var lblIconDistance: UILabel!
    
    
    @IBOutlet var lblIconEta: UILabel!
    @IBOutlet var lblIconPayment: UILabel!
    var arrForInvoice:[[Invoice]]  = []
    var invoiceResponse:InvoiceResponse = InvoiceResponse.init(fromDictionary: [:])
    
    /*Footer View*/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialViewSetup()
        setupRevealViewController()
    }
    @IBAction func onClickBtnSubmitInvoice(_ sender: Any) {
        self.wsSubmitInvoice()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wsGetInvoice()
        navigationView.navigationShadow()
        navigationView.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationView.navigationShadow()
        navigationView.backgroundColor = .white
    }
    
    func initialViewSetup()
    {
        
        lblTitle.text = "TXT_INVOICE".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        lblTotalTime.text = ""
        lblTotalTime.textColor = UIColor.themeTextColor
        lblTotalTime.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblDistance.text = ""
        lblDistance.textColor = UIColor.themeTextColor
        lblDistance.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblPaymentMode.text = ""
        lblPaymentMode.textColor = UIColor.themeTextColor
        lblPaymentMode.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        
        lblTotal.text = "TXT_TOTAL".localized
        lblTotal.textColor = UIColor.themeLightTextColor
        lblTotal.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblMinFare.text = "TXT_MIN_FARE".localized
        lblMinFare.textColor = UIColor.themeErrorTextColor
        lblMinFare.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblTotalValue.text = ""
        lblTotalValue.textColor = UIColor.themeSelectionColor
        lblTotalValue.font = FontHelper.font(size: FontSize.doubleExtraLarge, type: FontType.Bold)
        
        
        lblTripId.text = ""
        lblTripId.textColor = UIColor.themeLightTextColor
        lblTripId.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblTripType.text = ""
        lblTripType.textColor = UIColor.themeTextColor
        lblTripType.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblMinFare.isHidden = true
        self.tblForInvoice.tableHeaderView = UIView.init(frame: CGRect.zero)
        self.tblForInvoice.tableFooterView = UIView.init(frame: CGRect.zero)
        
        //btnSubmit.setTitle("TXT_SUBMIT".localized, for: .normal)
        btnSubmit.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)

        
        lblIconDistance.text = FontAsset.icon_distance
        lblIconEta.text = FontAsset.icon_time
        lblIconPayment.text = FontAsset.icon_payment_cash
        
        lblIconDistance.setForIcon()
        lblIconEta.setForIcon()
        lblIconPayment.setForIcon()
        btnSubmit.setTitle(FontAsset.icon_checked, for: .normal)
        btnSubmit.setUpTopBarButton()
        btnSubmit.setTitleColor(.white, for: .normal)
        
        btnMenu.setTitle(FontAsset.icon_menu, for: .normal)
        btnMenu.setUpTopBarButton()
        
    }

    func setupInvoice()
    {
        let tripDetail:InvoiceTrip = invoiceResponse.trip
        lblTripId.text = tripDetail.invoiceNumber
        lblTotalValue.text = tripDetail.total.toCurrencyString(currencyCode: tripDetail.currencycode)
        
        if tripDetail.paymentMode == TRUE
        {
            //imgPayment.image = UIImage.init(named: "asset-cash")
            lblPaymentMode.text = "TXT_PAID_BY_CASH".localized
            self.lblPaymentIcon.text = FontAsset.icon_payment_cash
        }
        else
        {
            //imgPayment.image = UIImage.init(named: "asset-card")
            lblPaymentMode.text = "TXT_PAID_BY_CARD".localized
            self.lblPaymentIcon.text = FontAsset.icon_payment_card
        }

        lblDistance.text = tripDetail.totalDistance.toString(places: 2) + Utility.getDistanceUnit(unit: tripDetail.unit)

        Utility.hmsFrom(seconds: Int(tripDetail.totalTime * 60)) {[unowned self] hours, minutes, seconds in
            
            if hours > 0
            {
                self.lblTotalTime.text = hours.toString() + " : " + minutes.toString() + MeasureUnit.MINUTES
            }
            else
            {
                self.lblTotalTime.text =  minutes.toString() + MeasureUnit.MINUTES
            }
        }
        
        if invoiceResponse.trip.tripType == TripType.AIRPORT || invoiceResponse.trip.tripType == TripType.CITY || invoiceResponse.trip.tripType == TripType.ZONE || tripDetail.isFixedFare
        {
            lblTripType.isHidden = false
            if invoiceResponse.trip.isFixedFare
            {
                lblTripType.text = "TXT_FIXED_FARE_TRIP".localized
            }
            else if invoiceResponse.trip.tripType == TripType.AIRPORT
            {
                lblTripType.text = "TXT_AIRPORT_TRIP".localized
            }
            else  if invoiceResponse.trip.tripType == TripType.ZONE
            {
                lblTripType.text = "TXT_ZONE_TRIP".localized
            }
            else  if invoiceResponse.trip.tripType == TripType.CITY
            {
                lblTripType.text = "TXT_CITY_TRIP".localized
            }
            else
            {
                lblTripType.isHidden = true
            }
            
        }
        else
        {
            lblTripType.isHidden = true
            
            if tripDetail.isMinFareUsed == TRUE
            {
                lblMinFare.isHidden = false
                lblMinFare.text = "TXT_MIN_FARE".localized + " " +  invoiceResponse.tripservice.minFare.toCurrencyString(currencyCode: tripDetail.currencycode) + " " + "TXT_APPLIED".localized
            }
            else
            {
                lblMinFare.isHidden = true
            }
        }
        print("\(#function) wsgetinvoice() data set")
    }
    func openPaymentDialog()
    {
        let dialogForPendingPayment = CustomAlertDialog.showCustomAlertDialog(title: "TXT_PAYMENT_FAILED".localized, message: "MSG_PAYMENT_FAILED".localized, titleLeftButton: "TXT_PAY_AGAIN".localized, titleRightButton: "TXT_SELECT".localized)
        dialogForPendingPayment.onClickLeftButton =
            { [unowned self, unowned dialogForPendingPayment] in
                
                dialogForPendingPayment.removeFromSuperview();
                self.wsPayPayment(tipAmount: self.invoiceResponse.trip.tipAmount)
                
                
        }
        dialogForPendingPayment.onClickRightButton =
            { [unowned self, unowned dialogForPendingPayment] in
                dialogForPendingPayment.removeFromSuperview();
                
                if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController
                {
                    navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_PAYMENT, sender: self)
                }
                
        }
    }
}


extension InvoiceVC :UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrForInvoice.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForInvoice[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:InvoiceCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InvoiceCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentInvoiceItem:Invoice = arrForInvoice[indexPath.section][indexPath.row]
        cell.setCellData(cellItem: currentInvoiceItem)
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 0
        }
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! InvoiceSection
        sectionHeader.setData(title: arrForInvoice[section][0].sectionTitle)
        return sectionHeader
    }
    
}

extension InvoiceVC:PBRevealViewControllerDelegate
{
    @IBAction func onClickBtnMenu(_ sender: Any)
    {
        
    }
    
    func setupRevealViewController()
    {
        self.revealViewController()?.panGestureRecognizer?.isEnabled = true
        btnMenu.addTarget(self.revealViewController(), action: #selector(PBRevealViewController.revealLeftView), for: .touchUpInside)
    }
    func revealController(_ revealController: PBRevealViewController, willShowLeft viewController: UIViewController) {
        revealController.mainViewController?.view.isUserInteractionEnabled = false;
    }
    func revealController(_ revealController: PBRevealViewController, willHideLeft viewController: UIViewController) {
        revealController.mainViewController?.view.isUserInteractionEnabled = true;
    }
}
extension InvoiceVC
{
    func wsPayPayment(tipAmount:Double)
    {
        
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TIP_AMOUNT] = tipAmount.toString(places: 2).toDouble()
        dictParam[PARAMS.TRIP_ID] = invoiceResponse.trip.id
        
        
        
        
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.PAY_PAYMENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    Utility.hideLoading()
                }
            }
            self.wsGetInvoice()
        }
        
    }
    func wsGetInvoice()
    {
        Utility.showLoading()
        
        
        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let dictParam:[String:String] =
            [PARAMS.TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.TRIP_ID : CurrentTrip.shared.tripId]
        
        let postData = try! JSONSerialization.data(withJSONObject: dictParam, options: [])
        
        let urlString:String = WebService.BASE_URL + WebService.GET_INVOICE
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            
            print("\(#function)")
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                
                
                
                Utility.hideLoading()
                guard let data = data, error == nil else {
                    print("\(#function) error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("\(#function) statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("\(#function) response = \(response)")
                }
                
                do {
                    
                    print("\(#function) Data=\(data)")
                    
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    {
                        print("\(#function) Dictionary=\(convertedJsonIntoDict)")
                        if Parser.isSuccess(response: convertedJsonIntoDict)
                        {
                            self.invoiceResponse = InvoiceResponse.init(fromDictionary: convertedJsonIntoDict)
                            if Parser.parseInvoice(tripService: self.invoiceResponse.tripservice, tripDetail: self.invoiceResponse.trip, arrForInvocie: &self.arrForInvoice)
                            {
                                OperationQueue.main.addOperation({
                                    self.setupInvoice()
                                    self.tblForInvoice.reloadData()
                                })
                                
                                
                            }
                            OperationQueue.main.addOperation({
                                
                                if self.invoiceResponse.trip.isPendingPayments == TRUE
                                {
                                    self.btnSubmit.isEnabled = false
                                    //self.openPaymentDialog()
                                }
                                else
                                {
                                    self.btnSubmit.isEnabled = true
                                }})
                            
                        }
                        
                    }
                } catch let error as NSError {
                    print()
                    print("\(#function) Error=\(error.localizedDescription)")
                }
                
                
                
                
                
            }
            
        })
        
        
        dataTask.resume()
        /*let alamoFire:AlamofireHelper = AlamofireHelper();
         alamoFire.getResponseFromURL(url: WebService.GET_INVOICE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
         { [unowned self] (response, error) -> (Void) in
         if (error != nil)
         {
         Utility.hideLoading()
         }
         else
         {
         Utility.hideLoading()
         if Parser.isSuccess(response: response)
         {
         self.invoiceResponse = InvoiceResponse.init(fromDictionary: response)
         if Parser.parseInvoice(tripService: self.invoiceResponse.tripservice, tripDetail: self.invoiceResponse.trip, arrForInvocie: &self.arrForInvoice)
         {
         self.setupInvoice()
         self.tblForInvoice.reloadData()
         }
         if self.invoiceResponse.trip.isPendingPayments == TRUE
         {
         self.btnSubmit.isEnabled = false
         self.openPaymentDialog()
         }
         else
         {
         self.btnSubmit.isEnabled = true
         }
         }
         }
         }*/
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if SEGUE.TRIP_TO_FEEDBACK == segue.identifier
        {
            if let destinationVC:FeedbackVC = segue.destination as? FeedbackVC
            {
                destinationVC.tripDetail = self.invoiceResponse.trip
                destinationVC.providerDetail = self.invoiceResponse.providerDetail
                
            }
            
        }
    }
    func emitTripNotification()
    {
        let dictParam:[String:Any] =
            [PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.TRIP_ID : CurrentTrip.shared.tripId]
        
        SocketHelper.shared.socket?.emitWithAck(SocketHelper.shared.tripDetailNotify, dictParam).timingOut(after: 0) {data in}
    }
}

class InvoiceCell:UITableViewCell
{
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblPrice: UILabel!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        lblTitle.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblTitle.textColor = UIColor.themeLightTextColor
        lblTitle.text = ""
        
        lblSubTitle.font = FontHelper.font(size: FontSize.small, type: .Light)
        lblSubTitle.textColor = UIColor.themeLightTextColor
        lblSubTitle.text = ""
        
        lblPrice.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        lblPrice.textColor = UIColor.themeTextColor
        lblPrice.text = ""
        
        
    }
    func setCellData(cellItem:Invoice)
    {
        lblTitle.text = cellItem.title!
        lblSubTitle.text = cellItem.subTitle!
        lblPrice.text = cellItem.price
    }
}

class InvoiceSection:UITableViewCell
{
    @IBOutlet var lblSection: UILabel!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        lblSection.textColor = UIColor.themeSelectionColor
        lblSection.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
    }
    func setData(title: String)
        
    {
        lblSection.text =  title
    }
}

//MARK:- Web Service
extension InvoiceVC
{
    func wsSubmitInvoice()
    {
        if !CurrentTrip.shared.tripStaus.trip.id.isEmpty()
        {
            Utility.showLoading()
            var  dictParam : [String : Any] = [:]
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.TRIP_ID] = CurrentTrip.shared.tripStaus.trip.id
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.SUBMIT_INVOICE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
                if (error != nil)
                {Utility.hideLoading()}
                else
                {
                    if Parser.isSuccess(response: response)
                    {
                        Utility.hideLoading()
                        self.emitTripNotification()
                        self.performSegue(withIdentifier: SEGUE.TRIP_TO_FEEDBACK, sender: self)
                    }
                    else
                    {
                        Utility.hideLoading()
                    }
                }
                
            }
        }
        else
        {
        }
    }
}
