//
//  ViewController.swift
//  newt
//
//  Created by Elluminati  on 10/07/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class MybookingVC: BaseVC {

    @IBOutlet weak var tblForMyBooking: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var lblEmptyMessage: UILabel!
    
    @IBOutlet weak var lblOngoingTrip: UILabel!
    @IBOutlet weak var viewForSectionOngoingTrip: UIView!
    @IBOutlet weak var viewForOngoinTrip: UIView!
    @IBOutlet weak var viewForOngoingDetail: UIView!
    @IBOutlet weak var lblOngoingTripStatus: UILabel!
    @IBOutlet weak var lblOngoingAddresss: UILabel!
    

    
    @IBOutlet var lblIconTick: UILabel!
    @IBOutlet var lbliconLocation: UILabel!

    var strTripId:String = ""
    var arrForTrip:[Trip] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let footerView = UIView.init()
        footerView.backgroundColor = UIColor.themeViewBackgroundColor
        tblForMyBooking.tableFooterView = footerView
        tblForMyBooking.reloadData()
        initialViewSetup()

        self.wsGetMyBookings()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    func initialViewSetup()
    {
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tblForMyBooking.backgroundColor = UIColor.themeViewBackgroundColor
        
        
        lblTitle.text = "TXT_MY_BOOKINGS".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        lblEmptyMessage.text = "TXT_NO_BOOKING".localized
        lblEmptyMessage.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblEmptyMessage.textColor = UIColor.themeTextColor
        
        
        self.viewForOngoinTrip.backgroundColor = UIColor.themeViewBackgroundColor
        
        
        viewForSectionOngoingTrip.backgroundColor = UIColor.themeSelectionColor
        lblOngoingTrip.textColor = UIColor.themeButtonTitleColor
        lblOngoingTrip.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblOngoingTrip.backgroundColor = UIColor.themeSelectionColor
        lblOngoingTrip.text = "TXT_ON_GOING_TRIP".localized
        
        lblOngoingAddresss.textColor = UIColor.themeTextColor
        lblOngoingAddresss.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblOngoingTripStatus.textColor = UIColor.themeTextColor
        lblOngoingTripStatus.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        
        if CurrentTrip.shared.tripId.isEmpty
        {
            viewForOngoinTrip.isHidden = true
        }
        else
        {
            let providerCurrentStatus: TripStatus = TripStatus(rawValue: CurrentTrip.shared.tripStaus.trip.isProviderStatus) ?? TripStatus.Unknown
            lblOngoingTripStatus.text = providerCurrentStatus.text()
            debugPrint("Trip Status :- \(CurrentTrip.shared.tripStaus.trip.isProviderStatus)")
            
            
            lblOngoingAddresss.text = CurrentTrip.shared.tripStaus.trip.sourceAddress
            viewForOngoinTrip.isHidden = false
            
        }
        lblIconTick.text = FontAsset.icon_checked_bold
        lblIconTick.setForIcon()
        
        lbliconLocation.text = FontAsset.icon_pickup_location
        lbliconLocation.setForIcon()
        
        
        btnMenu.setupBackButton()    
        
    }
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            navigationView.navigationShadow()
        viewForSectionOngoingTrip.sizeToFit()
        viewForSectionOngoingTrip.setRound(withBorderColor: .clear, andCornerRadious: (viewForSectionOngoingTrip.frame.height/2), borderWidth: 0)
        viewForOngoingDetail.setShadow()
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
   
    func openCanceTripDialog()
    {
        
        
        let dialogForTripStatus = CustomCancelTripDialog.showCustomCancelTripDialog(title: "TXT_CANCEL_TRIP".localized, message: "TXT_CANCELLATION_CHARGE_MESSAGE".localized, cancelationCharge: "0", titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
        
        dialogForTripStatus.onClickLeftButton =
            { [unowned dialogForTripStatus] in
                
                dialogForTripStatus.removeFromSuperview();
        }
        dialogForTripStatus.onClickRightButton = { 
            [unowned self, unowned dialogForTripStatus] (reason) in
            self.wsCancelTrip(dialog: dialogForTripStatus,reason: reason)            
        }
    }
    
    func wsCancelTrip(dialog:CustomCancelTripDialog,reason:String)
    {
        if !strTripId.isEmpty()
        {
            Utility.showLoading()
            var  dictParam : [String : Any] = [:]
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.TRIP_ID] = strTripId
            dictParam[PARAMS.CANCEL_TRIP_REASON] = reason
            
            
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.CANCEL_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { 
                [unowned self, unowned dialog] (response, error) -> (Void) in
                if (error != nil)
                {Utility.hideLoading()}
                else
                {
                    if Parser.isSuccess(response: response)
                    {
                        dialog.removeFromSuperview()
                        self.wsGetMyBookings()
                        
                    }
                    else
                    {
                        
                    }
                }
                
            }
        }
        else
        {
            dialog.removeFromSuperview()
            
        }
    }
   
}

extension MybookingVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
       strTripId = arrForTrip[indexPath.row].id
       self.openCanceTripDialog()
        
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
            return 1
       
       
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! MyBookingSection
        
        
        
        sectionHeader.setData(title: "TXT_UP_COMING_TRIP".localized)
        
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrForTrip.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! MyBookingCell;
        cell.setData(tripDetail: arrForTrip[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none;
        return cell
    }
    
    
}

extension MybookingVC
{
    func wsGetMyBookings()
    {
        self.view.endEditing(true)
        Utility.showLoading()
        
        
        var  dictParam : [String : Any] = [:]
         dictParam[PARAMS.USER_ID] =  preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()

        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_BOOKING_TRIPS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            self.arrForTrip.removeAll()
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                
                if Parser.isSuccess(response: response)
                {
                    let scheduleTripListResponse:ScheduleTripListResponse = ScheduleTripListResponse.init(fromDictionary: response)
                    for trip in scheduleTripListResponse.scheduledtrip
                    {
                        self.arrForTrip.append(trip)
                    }

                     Utility.hideLoading()
                }
                else
                {
                    Utility.hideLoading()
                }
            }
             self.updateUI(isUpdate: !self.arrForTrip.isEmpty)

        }
    }

    func updateUI(isUpdate:Bool = false)
    {
        lblEmptyMessage.isHidden = isUpdate
        //tblForMyBooking.isHidden = !isUpdate
        // viewForFilter.isHidden = true
        self.tblForMyBooking.reloadData()

    }
    @IBAction func onClickBtnMenu(_ sender: Any) {
        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController
        {
            navigationVC.popToRootViewController(animated: true)
        }
    }
}

class MyBookingCell:UITableViewCell
{
    @IBOutlet weak var lblDate: UILabel!
   @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet var lblIconLocation: UILabel!
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
      
        
        lblDate.textColor = UIColor.themeLightTextColor
        lblDate.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblTime.textColor = UIColor.themeLightTextColor
        lblTime.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblAddress.textColor = UIColor.themeTextColor
        lblAddress.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblIconLocation.text = FontAsset.icon_pickup_location
        lblIconLocation.setForIcon()
    }

    func setData(tripDetail:Trip)
    {
        lblDate.text = Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: tripDetail.serverStartTimeForSchedule!, fromFormat: DateFormat.WEB, toFormat: DateFormat.DATE_FORMAT)) as String
        lblAddress.text = tripDetail.sourceAddress
        lblTime.text = Utility.stringToString(strDate: tripDetail.serverStartTimeForSchedule!, fromFormat: DateFormat.WEB , toFormat: DateFormat.TIME_FORMAT_HH_MM)
    }
}

class MyBookingSection:UITableViewCell
{
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var roundedView: UIView!

    deinit {
        printE("\(self) \(#function)")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        roundedView.backgroundColor = UIColor.themeSelectionColor
        lblSection.textColor = UIColor.themeButtonTitleColor
        lblSection.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblSection.backgroundColor = UIColor.themeSelectionColor
    }

    func setData(title: String)
    {
        lblSection.text =  title
        roundedView.sizeToFit()
        roundedView.setRound(withBorderColor: .clear, andCornerRadious: (roundedView.frame.height/2), borderWidth: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
