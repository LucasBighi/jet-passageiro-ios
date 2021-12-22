//
//  TripVC.swift
//  Cabtown
//
//  Created by Elluminati  on 29/09/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AVFoundation

private struct MapPath : Decodable{
    var routes : [Route]?
}

private struct Route : Decodable{
    var overview_polyline : OverView?
}

private struct OverView : Decodable {
    var points : String?
}

class TripVC: BaseVC, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnProviderRate: UIButton!
    
    //Address View
    @IBOutlet weak var viewForAddresses: UIView!
    @IBOutlet weak var viewForPickupAddress: UIView!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var btnPickupAddress: UIButton!
    @IBOutlet weak var viewForDestinationAddress: UIView!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    @IBOutlet weak var btnDestinationAddress: UIButton!
    
    @IBOutlet weak var viewForDriver: UIView!
    @IBOutlet weak var btnPromoCode: UIButton!
    @IBOutlet weak var viewForDriverContact: UIView!
    @IBOutlet weak var imgDriverPic: UIImageView!
    @IBOutlet weak var lblDriverName: UILabel!
    
    
    @IBOutlet weak var btnCancelTrip: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnSos: UIButton!
    
    @IBOutlet weak var lblCarIdOrTotalTime: UILabel!
    @IBOutlet weak var lblCarIdOrTotalTimeValue: UILabel!
    @IBOutlet weak var lblPlatNoOrTotalDistance: UILabel!
    @IBOutlet weak var lblPlatNoOrTotalDistanceValue: UILabel!
    @IBOutlet weak var lblTripNo: UILabel!
    @IBOutlet weak var lblTripNoValue: UILabel!
    var strProviderId:String = ""
    
    @IBOutlet weak var stkWaitTime: UIStackView!
    @IBOutlet weak var lblWaitingTimeValue: UILabel!
    @IBOutlet weak var lblWaitingTime: UILabel!
    /*ViewForPayment*/
    @IBOutlet weak var viewForSelectedPayment: UIView!
    @IBOutlet weak var imgSelectedPayment: UIImageView!
    @IBOutlet weak var lblPaymentIcon: UILabel!
    @IBOutlet weak var lblSelectedPayment: UILabel!
    @IBOutlet weak var selectedPaymentBackground: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var imgChatNotification: UIImageView!
    @IBOutlet weak var btnMyLocation: UIButton!
    
    var providerMarker:GMSMarker!
    var pickupMarker:GMSMarker!
    var destinationMarker:GMSMarker!
    var onGoingTrip:Trip = Trip.init(fromDictionary: [:])
    var provider:Provider = Provider.init(fromDictionary: [:])
    var providerCurrentStatus:TripStatus = TripStatus.Unknown
    var providerNextStatus:TripStatus = TripStatus.Unknown
    var polyLinePath:GMSPolyline!
    var polyLineCurrentProviderPath:GMSPolyline!;
    var currentProviderPath:GMSMutablePath!
    var previousDriverLatLong:CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var isMapFocus:Bool = false
    var isPathCurrentPathDraw:Bool = false
    var isSourceToDestPathDrawn:Bool = true
    var soundFile: AVAudioPlayer?
    var isCameraBearingChange:Bool = false
    var mapBearing:Double = 0.0
    var currentWaitingTime:Int = 0
    let ChatRef = DBProvider.Instance.dbRef.child(CurrentTrip.shared.tripId).child(CONSTANT.DBPROVIDER.MESSAGES)
    var dialogForTripStatus : CustomStatusDialog? = nil
    var totalTripTime:Int = 0
    let socketHelper:SocketHelper = SocketHelper.shared
    var locationManager: LocationManager? = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        imgDriverPic.isUserInteractionEnabled = true
        imgDriverPic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDriverPic)))
        setMap()
        socketHelper.connectSocket()
        doSomething()
//        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: UIApplication.didBecomeActiveNotification, object: nil)
        viewForSelectedPayment.isHidden = true
        polyLineCurrentProviderPath = GMSPolyline.init()
        polyLinePath = GMSPolyline.init()
        currentProviderPath = GMSMutablePath.init()
        mapView.padding = UIEdgeInsets.init(top:viewForAddresses.frame.maxY, left: 20, bottom: viewForDriver.frame.height, right: 20)
        mapView.settings.compassButton = true
        self.navigationController?.isNavigationBarHidden = true
        self.revealViewController()?.delegate = self;
        if CurrentTrip.shared.tripStaus.trip != nil {
            onGoingTrip = CurrentTrip.shared.tripStaus.trip
            self.providerCurrentStatus = TripStatus(rawValue: self.onGoingTrip.isProviderStatus!) ?? TripStatus.Unknown
        }
        imgSelectedPayment.backgroundColor = UIColor.themeButtonBackgroundColor
        lblPaymentIcon.backgroundColor = UIColor.themeButtonBackgroundColor
        lblPaymentIcon.setRound()
        //self.lblPaymentIcon.backgroundColor = .themeButtonBackgroundColor
        mapView.animate(toZoom: 17)
        mapView.animate(toLocation: CurrentTrip.shared.pickupCoordinate)
        self.stkWaitTime.isHidden = true
        setupRevealViewController()
        initialViewSetup()
        wsGetProviderDetail(id: onGoingTrip.providerId)
        setupPaymentView()
        self.imgChatNotification.isHidden = true
        MessageHandler.Instace.removeObserver()
        MessageHandler.Instace.observeMessage()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topView.navigationShadow()
        topView.backgroundColor = .white
    }

    @objc private func showDriverPic() {
        let vc = PictureDialogViewController(nibName: "PictureDialogViewController", bundle: nil)
        vc.picture = imgDriverPic.image
        present(vc, animated: true)
    }

    func setDriverData()
    {
        lblDriverName.text = provider.firstName + " " + provider.lastName
        imgDriverPic.downloadedFrom(link: provider.picture)
        providerMarker.icon = UIImage.init(named: "asset-driver-pin-placeholder")
        let url = CurrentTrip.shared.tripStaus.mapPinImageUrl
        Utility.downloadImageFrom(link: url!, completion: { (image) in
            self.providerMarker.icon = image
        })
        btnProviderRate.setTitle(provider.rate.toString(places: 1), for: .normal)
    }
    
    @objc private func doSomething() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.wsGetTripStatus()
            print("=====================\nwsGetTripStatus Called\n=====================")

//            self.startLocationListner()
        }
    }

    override func networkEstablishAgain() {
        super.networkEstablishAgain()
        self.wsGetTripStatus()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dialogForTripStatus = nil
        self.stopLocationListner()
        self.stopWaitingTripTimer()
    }
    
    func startLocationListner() {
        self.stopLocationListner()
        let myTripid = "'\(CurrentTrip.shared.tripId)'"
        self.socketHelper.socket?.on(myTripid) {
            [weak self] (data, ack) in
            guard let `self` = self else {
                return
            }
            guard let response = data.first as? [String:Any] else {
                return
            }
            printE("Soket Response\(response)")
            let location = (response["location"] as? [Double]) ?? [0.0,0.0]
            let isTripUpdate = (response[PARAMS.IS_TRIP_UPDATED] as? Bool) ?? false
            if isTripUpdate {
                self.wsGetTripStatus()
            }
            else {
                if location[0] != 0.0 && location[1] != 0.0 {
                    self.onGoingTrip.providerLocation = location
                    self.onGoingTrip.totalTime = (response["total_time"] as? Double) ?? 0.0
                    self.onGoingTrip.totalDistance = (response["total_distance"] as? Double) ?? 0.0
                    self.totalTripTime = self.onGoingTrip.totalTime.toInt()
                    let bearing = (response["bearing"] as? Double) ?? 0.0
                    self.onGoingTrip.bearing = bearing
                    self.updateProviderMarker(providerLocation: location, bearing: bearing)
                    self.updateTripDetail()
                }
            }
        }
    }

    func stopLocationListner() {
        let myTripid = "'\(CurrentTrip.shared.tripId)'"
        self.socketHelper.socket?.off(myTripid)
        self.stopTotalTripTimer()
        self.isPathCurrentPathDraw = false
    }

    func setupPaymentView() {
        viewForSelectedPayment.backgroundColor = UIColor.clear
        selectedPaymentBackground.backgroundColor = UIColor.themeButtonBackgroundColor
        imgSelectedPayment.setRound()
        //self.lblPaymentIcon.setRound()
        selectedPaymentBackground.setRound(withBorderColor: UIColor.clear, andCornerRadious: selectedPaymentBackground.frame.height/2.0, borderWidth: 1.0)
        selectedPaymentBackground.backgroundColor = UIColor.themeButtonBackgroundColor
        lblSelectedPayment.textColor = UIColor.themeButtonTitleColor
    }

    func updatePaymentView(paymentMode:Int) {
        if paymentMode == PaymentMode.CARD {
            lblSelectedPayment.text = "TXT_CARD".localized
            //imgSelectedPayment.image = UIImage.init(named: "asset-trip-card")
            self.lblPaymentIcon.text = FontAsset.icon_payment_card
        }
        else if paymentMode == PaymentMode.CASH {
            lblSelectedPayment.text = "TXT_CASH".localized
            //imgSelectedPayment.image = UIImage.init(named: "asset-trip-cash")
            self.lblPaymentIcon.text = FontAsset.icon_payment_cash
        }
        else {
            lblSelectedPayment.text = "TXT_ADD_PAYMENT".localized
        }
        viewForSelectedPayment.isHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MessageHandler.Instace.delegate = self
        print("viewWillAppear Called")
        self.wsGetTripStatus()
        self.startLocationListner()
    }

    func initialViewSetup() {
        viewForDriver.backgroundColor = UIColor.themeViewBackgroundColor.withAlphaComponent(0.95)
        topView.backgroundColor = .white
        lblPickupAddress.text = "TXT_PICKUP_ADDRESS".localized
        lblPickupAddress.textColor = UIColor.themeTextColor
        lblPickupAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        lblDriverName.text = "TXT_DEFAULT".localized
        lblDriverName.textColor = UIColor.themeTextColor
        lblDriverName.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblTitle.text = "TXT_TRIP_NO".localized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        lblDestinationAddress.text = "TXT_DESTINATION_ADDRESS".localized
        lblDestinationAddress.textColor = UIColor.themeTextColor
        lblDestinationAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        btnCall.setTitle("", for: .normal)
        btnCall.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        btnCall.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        btnCall.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnChat.setTitle("", for: .normal)
        btnChat.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        btnChat.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        btnChat.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnShare.setTitle("", for: .normal)
        btnShare.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        btnShare.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        btnShare.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnCancelTrip.setTitle("  " + "TXT_CANCEL_TRIP".localizedCapitalized + "  ", for: .normal)
        btnCancelTrip.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        btnCancelTrip.backgroundColor = UIColor.themeButtonBackgroundColor
        btnCancelTrip.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnSos.setTitle("  " + "TXT_SOS".localizedCapitalized + "  ", for: .normal)
        btnSos.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        btnSos.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSos.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnProviderRate.setTitle("  " + "0.0".localized + "  ", for: .normal)
        btnProviderRate.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        btnProviderRate.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPromoCode.setTitle("TXT_HAVE_PROMO_CODE".localizedCapitalized, for: .normal)
        btnPromoCode.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnPromoCode.backgroundColor = UIColor.clear
        btnPromoCode.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        lblCarIdOrTotalTime.text = "TXT_VEHICLE".localized
        lblCarIdOrTotalTime.textColor = UIColor.themeLightTextColor
        lblCarIdOrTotalTime.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblCarIdOrTotalTimeValue.text = "".localized
        lblCarIdOrTotalTimeValue.textColor = UIColor.themeTextColor
        lblCarIdOrTotalTimeValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblPlatNoOrTotalDistance.text = "TXT_PLATE_NO".localized
        lblPlatNoOrTotalDistance.textColor = UIColor.themeLightTextColor
        lblPlatNoOrTotalDistance.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        
        lblPlatNoOrTotalDistanceValue.text = "TXT_PLATE_NO".localized
        lblPlatNoOrTotalDistanceValue.textColor = UIColor.themeTextColor
        lblPlatNoOrTotalDistanceValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        
        
        lblTripNo.text = "TXT_CAR_COLOR".localized
        lblTripNo.textColor = UIColor.themeLightTextColor
        lblTripNo.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        
        
        lblWaitingTime.text = "TXT_WAITING_TIME_START_AFTER".localized
        lblWaitingTime.text = "TXT_TOTAL_WAITING_TIME".localized
        lblWaitingTime.textColor = UIColor.themeTextColor
        lblWaitingTime.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblWaitingTimeValue.text = "--".localized
        lblWaitingTimeValue.textColor = UIColor.themeTextColor
        lblWaitingTimeValue.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblDestinationAddress.text = "TXT_DESTINATION_ADDRESS".localized
        lblDestinationAddress.textColor = UIColor.themeTextColor
        lblDestinationAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblTripNoValue.text = "TXT_TRIP_NO".localized
        lblTripNoValue.textColor = UIColor.themeTextColor
        lblTripNoValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        self.btnMenu.setTitle(FontAsset.icon_menu, for: .normal)
        
        self.lblPaymentIcon.setForIcon()
        self.lblPaymentIcon.textColor = UIColor.white
        self.btnMenu.setUpTopBarButton()
        self.btnShare.setTitle(FontAsset.icon_menu_share, for: .normal)
        self.btnShare.setRoundIconButton()
        btnShare.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        
        self.btnChat.setTitle(FontAsset.icon_chat, for: .normal)
        self.btnChat.setRoundIconButton()
        btnChat.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        
        
        self.btnCall.setTitle(FontAsset.icon_call, for: .normal)
        self.btnCall.setRoundIconButton()
        btnCall.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        
        btnMyLocation.setSimpleIconButton()
        btnMyLocation.setTitle(FontAsset.icon_btn_current_location, for: .normal)
        btnMyLocation.titleLabel?.font = FontHelper.assetFont(size: 30)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func setMap()  {
        mapView.clear()
        mapView.delegate = self
        mapView.delegate=self;
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = false;
        mapView.settings.rotateGestures = false;
        mapView.settings.myLocationButton=false;
        mapView.isMyLocationEnabled=false;
        providerMarker = GMSMarker.init()
        pickupMarker = GMSMarker.init()
        destinationMarker = GMSMarker.init()
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "styleable_map", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                printE("Unable to find style.json")
            }
        } catch {
            printE("The style definition could not be loaded: \(error)")
        }
    }
    
    func setupLayout() {
        btnCancelTrip.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnCancelTrip.frame.height/2, borderWidth: 1.0)
        btnSos.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnSos.frame.height/2, borderWidth: 1.0)
        btnCall.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnCall.frame.height/2, borderWidth: 1.0)
        btnChat.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnChat.frame.height/2, borderWidth: 1.0)
        btnShare.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnShare.frame.height/2, borderWidth: 1.0)
        imgDriverPic.setRound()
        topView.navigationShadow()
        topView.backgroundColor = .white
    }

    @IBAction func onClickBtnSos(_ sender: Any) {
        self.wsGetEmergencyContactList()
    }
    
    @IBAction func onClickBtnShare(_ sender: Any) {

        if onGoingTrip.destinationAddress.isEmpty() {
            Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_DESTINATION_FIRST".localized)
        } else {

            let providerLocation: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: onGoingTrip.providerLocation[0], longitude: onGoingTrip.providerLocation[1])

            let destinationLocation: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: onGoingTrip.destinationLocation[0], longitude: onGoingTrip.destinationLocation[1])

            let timeAndDistance = self.locationManager?.getTimeAndDistance(sourceCoordinate: providerLocation, destCoordinate: destinationLocation) ?? (time: "0", distance: "0")

            let time = (timeAndDistance.time.toDouble() * 0.0166667).toString(places: 0)
            let myString = String(format: NSLocalizedString("MSG_SHARE_ETA", comment: ""), onGoingTrip.destinationAddress,onGoingTrip.providerFirstName + " " + onGoingTrip.providerLastName,time)
            

            
            let textToShare = [ myString ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            self.navigationController?.present(activityViewController, animated: true, completion: nil)
            
            
            
        }
        
        
        
        
    }
    
    @IBAction func onClickBtnChat(_ sender: Any) {
        if let chatVc:MyCustomChatVC =  AppStoryboard.Trip.instance.instantiateViewController(withIdentifier: "chatVC") as? MyCustomChatVC
        {
            self.imgChatNotification.isHidden = true
            
            self.navigationController?.pushViewController(chatVc, animated: true)
        }
    }
    @IBAction func onClickBtnCancelTrip(_ sender: Any)
    {
        openCanceTripDialog()
    }
    @IBAction func onClickBtnFocusTrip(_ sender: Any)
    {
        
        isCameraBearingChange = false
        focusMap()
        
    }
    @IBAction func onClickBtnPromo(_ sender: Any)
    {
        if CurrentTrip.shared.tripStaus.isPromoUsed == TRUE
        {
            self.wsRemovePromo()
        }
        else
        {
            openPromoDialog()
        }
    }
    @IBAction func onClickBtnCall(_ sender: Any) {
        
        if preferenceHelper.getIsTwillioEnable()
        {
            btnCall.isEnabled = false
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { (time) in
                self.btnCall.isEnabled = true
            }
            self.wsTwilioVoiceCall()
        }
        else
        {
            provider.phone.toCall()
        }
    }
    @IBAction func onClickBtnDestinaiton(_ sender: Any) {
        
        let locationVC : LocationVC = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "locationVC") as!  LocationVC
        locationVC.delegate = self
        locationVC.flag = AddressType.destinationAddress
        locationVC.focusLocation = CLLocationCoordinate2D.init(latitude: CurrentTrip.shared.tripStaus.trip.destinationLocation[0], longitude: CurrentTrip.shared.tripStaus.trip.destinationLocation[1])
        self.present(locationVC, animated: true, completion: nil)
    }

    @IBAction func onClickBtnChangePayment(_ sender: Any)
    {
        if CurrentTrip.shared.isCardModeAvailable == TRUE && CurrentTrip.shared.isCardModeAvailable == TRUE
        {
            self.openPaymentDialog()
        }
        else
        {
            Utility.showToast(message: "VALIDATION_MSG_NO_OTHER_PAYMENT_MODE_AVAILABLE".localized)
        }
    }

    func startWaitingTripTimer()
    {
        self.wsGetTripStatus()
        CurrentTrip.timerForWaitingTime?.invalidate()
        CurrentTrip.timerForWaitingTime = nil
        CurrentTrip.timerForWaitingTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(waitTimeWatcher), userInfo: nil, repeats: true)
    }

    func stopWaitingTripTimer()
    {
        CurrentTrip.timerForWaitingTime?.invalidate()
    }

    @objc func waitTimeWatcher()
    {
        currentWaitingTime = currentWaitingTime + 1;
        if(currentWaitingTime < 0)
        {
            lblWaitingTime?.text = "TXT_WAITING_TIME_START_AFTER".localized
            lblWaitingTimeValue?.text = abs(currentWaitingTime).toString() + " s"
        }
        else
        {
            lblWaitingTime?.text = "TXT_TOTAL_WAITING_TIME".localized
            lblWaitingTimeValue?.text = abs(currentWaitingTime).toString() + " s"
        }
        if providerCurrentStatus == TripStatus.Arrived
        {
            stkWaitTime?.isHidden = false
        }
        else
        {
            stkWaitTime?.isHidden = true
            stopWaitingTripTimer()
        }
    }

    func updateAddress()
    {
        if let trip = CurrentTrip.shared.tripStaus.trip
        {
            lblPickupAddress.text = trip.sourceAddress
            lblDestinationAddress.text  = trip.destinationAddress
            
            if CurrentTrip.shared.isFixedFareTrip
            {
                self.btnDestinationAddress.isUserInteractionEnabled = false
            }
            else
            {
                self.btnDestinationAddress.isUserInteractionEnabled = true
            }
        }
        
    }
    func updateProviderMarker(providerLocation:[Double],bearing:Double)
    {
        if providerLocation[0] != 0.0 && providerLocation[1] != 0.0
        {
            let providerPrevioustLocation = providerMarker.position
            
            
            let providerCoordinate = CLLocationCoordinate2D.init(latitude: providerLocation[0], longitude: providerLocation[1])
            
            if providerMarker.map == nil
            {
                providerMarker.map = mapView
                mapView.animate(toLocation: providerCoordinate)
                mapView.animate(toZoom: 17)
            }
            
            if providerCurrentStatus == TripStatus.Coming || providerCurrentStatus == TripStatus.Accepted ||  providerCurrentStatus == TripStatus.Arrived || providerCurrentStatus == TripStatus.Started
            {
                isCameraBearingChange = true;
                mapBearing = self.calculateBearing(source: providerPrevioustLocation, to: providerCoordinate)
                
            }
            else
            {
                isCameraBearingChange = false;
            }
            if (isCameraBearingChange)
            {
                CATransaction.begin()
                CATransaction.setValue(0.5, forKey: kCATransactionAnimationDuration)
                CATransaction.setCompletionBlock
                    {
                        self.drawCurrentPath(driverCoordinate:  providerCoordinate)
                }
                mapView.animate(toBearing: mapBearing)
                mapView.animate(toLocation: providerCoordinate)
                mapView.animate(toZoom: 17)
                providerMarker.position = providerCoordinate
                CATransaction.commit()
            }
            providerMarker.position = providerCoordinate
            
        }
    }
    func updateSorceDestinationMarkers()
    {

        if !onGoingTrip.destinationLocation.isEmpty
        {
            if onGoingTrip.destinationLocation[0] != 0.0 && onGoingTrip.destinationLocation[1] != 0.0
            {
                destinationMarker.position = CLLocationCoordinate2D.init(latitude: onGoingTrip.destinationLocation[0], longitude: onGoingTrip.destinationLocation[1])
                destinationMarker.icon = UIImage.init(named: "asset-pin-destination-location")
                if destinationMarker.map == nil
                {
                    destinationMarker.map = mapView
                }
            }
        }
        if onGoingTrip.sourceLocation[0] != 0.0 && onGoingTrip.sourceLocation[1] != 0.0
        {

            pickupMarker.position = CLLocationCoordinate2D.init(latitude: onGoingTrip.sourceLocation[0], longitude: onGoingTrip.sourceLocation[1])
            pickupMarker.icon = UIImage.init(named: "asset-pin-pickup-location")

            if pickupMarker.map == nil
            {
                pickupMarker.map = mapView
            }
        }
        
        
    }
    func calculateBearing(source:CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> Double {
        let lat1 = Double.pi * source.latitude / 180.0
        let long1 = Double.pi * source.longitude / 180.0
        let lat2 = Double.pi * destination.latitude / 180.0
        let long2 = Double.pi * destination.longitude / 180.0
        let rads = atan2(
            sin(long2 - long1) * cos(lat2),
            cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1))
        let degrees = rads * 180 / Double.pi
        return (degrees+360).truncatingRemainder(dividingBy: 360)
    }

    func updatePromoView(isPromoUsed: Bool = CurrentTrip.shared.tripStaus.isPromoUsed == TRUE)

    {
        if isPromoUsed
        {

            btnPromoCode.isUserInteractionEnabled = true
            btnPromoCode.setTitle("TXT_PROMO_APPLIED".localizedCapitalized, for: .normal)
        }
        else
        {
            
            btnPromoCode.isUserInteractionEnabled = true
            btnPromoCode.setTitle("TXT_HAVE_PROMO_CODE".localizedCapitalized, for: .normal)
            
            
        }

    }
    
    func startTotalTripTimer()
    {
        CurrentTrip.timerForTotalTripTime?.invalidate()
        CurrentTrip.timerForTotalTripTime = nil
        CurrentTrip.timerForTotalTripTime =    Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(totalTimeWatcher), userInfo: nil, repeats: true)
    }
    func stopTotalTripTimer()
    {
        CurrentTrip.timerForTotalTripTime?.invalidate()
    }
    @objc func totalTimeWatcher()
    {
        totalTripTime = totalTripTime + 1;
        DispatchQueue.main.async { [unowned self] in 
            self.lblCarIdOrTotalTimeValue.text = self.totalTripTime.toString() + MeasureUnit.MINUTES
        }
    }
    
    
    func showPathFrom(source:CLLocationCoordinate2D, toDestination destination:CLLocationCoordinate2D)
    {
        if preferenceHelper.getIsPathdraw()
        {
            let saddr = "\(source.latitude),\(source.longitude)"
            let daddr = "\(destination.latitude),\(destination.longitude)"
            let apiUrlStr = Google.DIRECTION_URL +  "\(saddr)&destination=\(daddr)&key=\(preferenceHelper.getGoogleKey())&language=\(arrForLanguages[preferenceHelper.getLanguage()].code)"
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            guard let url =  URL(string: apiUrlStr) else
            {
                return
            }
            do
            {
                print("JD DIRECTION API CALLED")
                DispatchQueue.main.async {  /*[unowned self, unowned session] in*/ 
                    
                    session.dataTask(with: url) { [unowned self, unowned session] (data, response, error) in
                        
                        guard data != nil else {
                            return
                        }
                        do {
                            
                            let route = try JSONDecoder().decode(MapPath.self, from: data!)
                            
                            if let points = route.routes?.first?.overview_polyline?.points {
                                self.drawPath(with: points)
                            }
                            self.wsSetGooglePathPickupToDestination(route: String.init(data: data!, encoding: .utf8) ?? "")
                        } catch let error {
                            printE(session)
                            printE("Failed to draw ",error.localizedDescription)
                        }
                        }.resume()
                }
            }
        }
        
    }
    private func drawPath(with points : String){
        
        if isSourceToDestPathDrawn
        {
            isSourceToDestPathDrawn = false

            DispatchQueue.main.async { [unowned self] in
                if self.polyLinePath.map != nil
                {
                    self.polyLinePath.map = nil
                }
                let path = GMSPath(fromEncodedPath: points)
                self.polyLinePath = GMSPolyline(path: path)
                self.polyLinePath.strokeColor = UIColor.themeGooglePathColor
                self.polyLinePath.strokeWidth = 5.0
                self.polyLinePath.geodesic = true
                self.polyLinePath.map = self.mapView
            }
        }
    }
    func drawCurrentPath(driverCoordinate:CLLocationCoordinate2D)
    {
        print("\(#function) previous Coordinate: \(previousDriverLatLong) and new \(driverCoordinate)")
        if (isPathCurrentPathDraw && providerCurrentStatus == TripStatus.Started)
        {

            let tempPath:GMSMutablePath = GMSMutablePath.init()

            if (previousDriverLatLong.latitude != 0.0 && previousDriverLatLong.longitude != 0.0)
            {
                tempPath.add(previousDriverLatLong)
            }
            tempPath.add(driverCoordinate)
            DispatchQueue.main.async { [unowned self] in
                self.polyLineCurrentProviderPath = GMSPolyline.init(path: tempPath)
                self.polyLineCurrentProviderPath.strokeWidth = 5.0;
                self.polyLineCurrentProviderPath.strokeColor = UIColor.themeButtonBackgroundColor
                self.polyLineCurrentProviderPath.map = self.mapView;
                self.previousDriverLatLong = driverCoordinate;
            }
        }
        
    }


    func updateTripDetail()
    {
        lblTripNoValue.text = provider.vehicleDetail.isEmpty
            ? ""
            : provider.vehicleDetail[0].color//onGoingTrip.uniqueId.toString()
        lblTitle.text = "TXT_TRIP_NO".localized + " " + onGoingTrip.uniqueId.toString()
        
        if  providerCurrentStatus == TripStatus.Arrived || providerCurrentStatus == TripStatus.Accepted || providerCurrentStatus == TripStatus.Coming
        {
            lblCarIdOrTotalTime.text = "TXT_CAR_ID".localized
            lblPlatNoOrTotalDistance.text = "TXT_PLATE_NO".localized
            lblCarIdOrTotalTimeValue.text = provider.carModel
            lblPlatNoOrTotalDistanceValue.text = provider.carNumber
            btnSos.isHidden = true
            btnCancelTrip.isHidden = false
        }
        else
        {
            self.totalTripTime = self.onGoingTrip.totalTime.toInt()
            lblCarIdOrTotalTime.text = "TXT_TOTAL_TIME".localized
            lblPlatNoOrTotalDistance.text = "TXT_TOTAL_DISTANCE".localized
            lblCarIdOrTotalTimeValue.text = totalTripTime.toString() + MeasureUnit.MINUTES

            self.startTotalTripTimer()
            lblPlatNoOrTotalDistanceValue.text = onGoingTrip.totalDistance.toString(places: 2   ) + Utility.getDistanceUnit(unit: onGoingTrip.unit)
            btnSos.isHidden = false
            btnCancelTrip.isHidden = true
        }
    }
    
    func playSound()
    {
        if (providerCurrentStatus == TripStatus.Arrived)
        {
            if (preferenceHelper.getIsArivedSoundOn())
            {
                let path = Bundle.main.path(forResource: "alertArriveNotification.mp3", ofType:nil)!
                let url = URL(fileURLWithPath: path)
                
                do {
                    soundFile = try AVAudioPlayer(contentsOf: url)
                    soundFile?.play()
                }
                catch
                {
                    // couldn't load file :(
                }
            }
        }
        else
        {
            if (preferenceHelper.getIsSoundOn())
            {
                let path = Bundle.main.path(forResource: "alertNotification.mp3", ofType:nil)!
                let url = URL(fileURLWithPath: path)
                do {
                    soundFile = try AVAudioPlayer(contentsOf: url)
                    soundFile?.play()
                }
                catch
                {
                    // couldn't load file :(
                }
            }
        }
    }
}

//MARK: RevealViewController Delegate Methods
extension TripVC:PBRevealViewControllerDelegate
{
    @IBAction func onClickBtnMenu(_ sender: Any)
    {}

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

//MARK:- Dialogs

extension TripVC
{
    func openStatusNotificationDialog()
    {
        if dialogForTripStatus == nil
        {
            dialogForTripStatus = CustomStatusDialog.showCustomStatusDialog(message: providerCurrentStatus.text(), titletButton: "TXT_CLOSE".localizedCapitalized)
            dialogForTripStatus?.updateMessage(message: providerCurrentStatus.text())
            dialogForTripStatus?.onClickOkButton =
                { [unowned self, weak dialogForTripStatus = self.dialogForTripStatus] in 
                    self.dialogForTripStatus?.removeFromSuperview();
                    self.dialogForTripStatus = nil                    
                    dialogForTripStatus?.removeFromSuperview()
                    dialogForTripStatus = nil
            }
        }
        else
        {
            dialogForTripStatus?.updateMessage(message: providerCurrentStatus.text())
        }
    }

    func openTipDialog()
    {
        let dialogForTipStatus = CustomTipDialog.showCustomTipDialog(title: "TXT_TIP".localized, message: "30", titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SUBMIT".localized)
        dialogForTipStatus.onClickLeftButton =
        { [weak self, weak dialogForTipStatus] in
            self?.wsPayPayment(tipAmount: 0.0)
            dialogForTipStatus?.removeFromSuperview();
        }
        dialogForTipStatus.onClickRightButton =
        { [weak self, weak dialogForTipStatus] (amount) in
            self?.wsPayPayment(tipAmount: amount)
            dialogForTipStatus?.removeFromSuperview();
        }
    }

    func openCanceTripDialog()
    {
        let dialogForTripStatus = CustomCancelTripDialog.showCustomCancelTripDialog(title: "TXT_CANCEL_TRIP".localized, message: "TXT_CANCELLATION_CHARGE_MESSAGE".localized, cancelationCharge: "0", titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
        if onGoingTrip.isProviderStatus! == TripStatus.Arrived.rawValue
        {
            dialogForTripStatus.setCancellationCharge(cancellationCharge: CurrentTrip.shared.tripStaus.cancellationFee)
        }
        dialogForTripStatus.onClickLeftButton =
        { [unowned dialogForTripStatus] in
            dialogForTripStatus.removeFromSuperview();
        }
        dialogForTripStatus.onClickRightButton =
        { [unowned self, unowned dialogForTripStatus] (reason) in
            dialogForTripStatus.removeFromSuperview()
            self.wsCancelTrip()
        }
    }

    func openSosDialog()
    {
        let dialogForSos = CustomSosDialog.showCustomSosDialog(title: "TXT_SOS".localized, message: "10", titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SEND".localized)
        dialogForSos.onClickLeftButton =
        { [unowned dialogForSos] in
            dialogForSos.stopTimer()
            dialogForSos.removeFromSuperview();
        }
        dialogForSos.onClickRightButton =
        { [unowned self, unowned dialogForSos] in
            dialogForSos.stopTimer()
            self.wsSos()
            dialogForSos.removeFromSuperview();
        }
    }

    func openPromoDialog()
    {
        self.view.endEditing(true)
        
        let dialogForPromo = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_APPLY_PROMO".localized, message: "".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_APPLY".localized, editTextHint: "TXT_ENTER_PROMO".localized,  editTextInputType: false)
        dialogForPromo.onClickLeftButton =
            { [unowned dialogForPromo] in
                dialogForPromo.removeFromSuperview();
        }
        dialogForPromo.onClickRightButton =
            { [unowned self, unowned dialogForPromo] (text:String) in

                if (text.count <  1)
                {
                    dialogForPromo.editText.showErrorWithText(errorText:"MSG_PLEASE_ENTER_VALID_PROMOCODE".localized )
                }
                else
                {
                    self.wsApplyPromo(promo: text,dialog: dialogForPromo)
                }
        }

    }
    func openPaymentDialog()
    {
        let dialogForPayment = CustomPaymentSelectionDialog.showCustomPaymentSelectionDialog()
        dialogForPayment.onClickCardButton = { [unowned self/*, unowned dialogForPayment*/] in
            if self.onGoingTrip.paymentMode != PaymentMode.CARD
            {  self.wsUpdatePaymentMode(paymentMode: PaymentMode.CARD)}
        }
        dialogForPayment.onClickCashButton = { [unowned self/*, unowned dialogForPayment*/] in
            if self.onGoingTrip.paymentMode != PaymentMode.CASH
            {
                self.wsUpdatePaymentMode(paymentMode: PaymentMode.CASH)
            }
        }
    }
    
    
}

extension TripVC:LocationHandlerDelegate
{
    func finalAddressAndLocation(address: String, latitude: Double, longitude: Double)
    {
        CurrentTrip.shared.setDestinationLocation(latitude: latitude, longitude: longitude, address: address)
        lblDestinationAddress.text =  address
        self.wsUpdateDestinationAddress(address: address, latitude: latitude, longitude: longitude)
    }
    
    func focusMap()
    {
        let pickupLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: onGoingTrip.sourceLocation[0], longitude: onGoingTrip.sourceLocation[1])
        let destinationLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: onGoingTrip.destinationLocation[0], longitude: onGoingTrip.destinationLocation[1])
        let driverLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: onGoingTrip.providerLocation[0], longitude: onGoingTrip.providerLocation[1])
        

        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(driverLocation)
        if self.providerCurrentStatus == .Accepted || self.providerCurrentStatus == .Coming
        {
            bounds = bounds.includingCoordinate(pickupLocation)
            mapBearing = self.calculateBearing(source: driverLocation, to: pickupLocation)
            
        }
        else
        {
            if destinationLocation.latitude != 0.0 && destinationLocation.longitude != 0.0
            {
                bounds = bounds.includingCoordinate(destinationLocation)
                mapBearing = self.calculateBearing(source: providerMarker.position, to: destinationLocation)
            }
            else
            {
                mapBearing = self.calculateBearing(source: driverLocation, to: driverLocation)
            }
        }
        
        
        

        isCameraBearingChange = true;
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock
            {
                self.drawCurrentPath(driverCoordinate: driverLocation)
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
        mapView.animate(toBearing: mapBearing)
        isCameraBearingChange = false
        CATransaction.commit()
        
    }

}


//MARK:- Web Service Calls
extension TripVC
{
    func wsGetGooglePath()
    {
        Utility.showLoading()
        print("\(#function)")
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_GOOGLE_PATH_FROM_SERVER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                Utility.hideLoading()
                if Parser.isSuccess(response: response)
                {
                    let googleResponse:GooglePathResponse = GooglePathResponse.init(fromDictionary: response)
                    var path = ""
                    let tripLocations = googleResponse.triplocation

                    path = (tripLocations?.googlePickUpLocationToDestinationLocation) ?? ""

                    let data: Data? = path.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))

                    if self.providerCurrentStatus == TripStatus.Arrived || self.providerCurrentStatus == TripStatus.Started
                    {
                        if data != nil && !path.isEmpty()
                        {
                            do
                            {
                                let route = try JSONDecoder().decode(MapPath.self, from: data!)
                                if let points = route.routes?.first?.overview_polyline?.points {
                                    self.drawPath(with: points)
                                }
                            }
                            catch
                            {
                                printE("error in JSONSerialization")
                            }
                        }
                        else
                        {
                            if !self.onGoingTrip.destinationLocation.isEmpty
                            {
                                if self.onGoingTrip.destinationLocation[0] != 0.0 && self.onGoingTrip.destinationLocation[1] != 0.0
                                {

                                    self.showPathFrom(source: self.pickupMarker.position, toDestination: self.destinationMarker.position)
                                }
                            }

                        }

                        if (self.providerCurrentStatus == TripStatus.Started)
                        {
                            let startToEndTripLocation = googleResponse.triplocation.startTripToEndTripLocations;

                            if (self.isPathCurrentPathDraw)
                            {

                            }
                            else
                            {

                                if ((startToEndTripLocation?.count ?? 0) > 0)
                                {
                                    self.currentProviderPath = GMSMutablePath.init()

                                    for currentLocation in startToEndTripLocation ?? []
                                    {
                                        if let location = currentLocation as? [Any]
                                        {
                                            let currentCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: (location[0] as? Double) ?? 0.0, longitude: (location[1] as? Double) ?? 0.0)
                                            self.currentProviderPath.add(currentCoordinate)
                                            self.previousDriverLatLong = currentCoordinate
                                        }
                                    }

                                    self.polyLineCurrentProviderPath = GMSPolyline.init(path: self.currentProviderPath)
                                    self.polyLineCurrentProviderPath.strokeWidth = 5.0;
                                    self.polyLineCurrentProviderPath.strokeColor = UIColor.themeButtonBackgroundColor;
                                    self.polyLineCurrentProviderPath.map = self.mapView;
                                    self.isPathCurrentPathDraw = true;
                                }
                            }
                        }


                    }

                }
            }
        }
        
    }

    func wsSetGooglePathPickupToDestination(route:String = "") {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
        dictParam[PARAMS.GOOGLE_PATH_START_LOCATION_TO_PICKUP_LOCATION] = ""
        dictParam[PARAMS.GOOGLE_PICKUP_LOCATION_TO_DESTINATION_LOCATION] = route


        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.SET_GOOGLE_PATH_FROM_SERVER, methodName:  AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            }else {
                if Parser.isSuccess(response: response) {


                }
                Utility.hideLoading()
            }
        }

    }
    func wsPayPayment(tipAmount:Double)
    {
        
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TIP_AMOUNT] = tipAmount.toString(places: 2).toDouble()
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
        
        
        
        
        
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
                    self.emitTripNotification()
                    self.stopLocationListner()
                    self.socketHelper.disConnectSocket()
                    APPDELEGATE.gotoInvoice()
                    Utility.hideLoading()
                    return;
                }
            }
        }
        
    }
    func wsGetProviderDetail(id:String)
    {
        if !id.isEmpty()
        {
            Utility.showLoading()
            var  dictParam : [String : Any] = [:]
            dictParam[PARAMS.PROVIDER_ID] = id
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.GET_PROVIDER_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
                if (error != nil)
                {
                    Utility.hideLoading()
                }
                else
                {
                    if Parser.isSuccess(response: response)
                    {
                        let providerResponse :ProviderResponse = ProviderResponse.init(fromDictionary: response)
                        self.provider = providerResponse.provider
                        
                        self.updateTripDetail()
                        self.setDriverData()
                        

                        self.onGoingTrip.providerLocation = providerResponse.provider.providerLocation
                        self.onGoingTrip.bearing = providerResponse.provider.bearing
                        
                        self.updateProviderMarker(providerLocation: self.provider.providerLocation, bearing: self.provider.bearing)
                        
                        Utility.hideLoading()
                    }
                }
            }
        }
    }
    func wsApplyPromo(promo:String,dialog:CustomVerificationDialog)
    {
        if !promo.isEmpty()
        {
            Utility.showLoading()
            var  dictParam : [String : Any] = [:]
            dictParam[PARAMS.PROMO_CODE] = promo
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN ] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
            dictParam[PARAMS.CITY] = ""
            dictParam[PARAMS.COUNTRY] = ""
            
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.APPLY_PROMO_CODE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { 
                [unowned self, unowned dialog] (response, error) -> (Void) in
                if (error != nil)
                {
                    Utility.hideLoading()
//                    self.updatePromoView()
                }
                else
                {
                    if Parser.isSuccess(response: response)
                    {
                        Utility.hideLoading()
                        
//                        self.updatePromoView(isPromoUsed: true)
                        dialog.removeFromSuperview()
                        self.wsGetTripStatus()
                    }
                }
            }
        }
    }
    
    
    func wsRemovePromo()
    {
        if !onGoingTrip.promoId.isEmpty()
        {
            Utility.showLoading()
            var  dictParam : [String : Any] = [:]
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN ] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.PROMO_ID] = onGoingTrip.promoId
            dictParam[PARAMS.TRIP_ID] = onGoingTrip.id

            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.REMOVE_PROMO_CODE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
                [unowned self] (response, error) -> (Void) in
                if (error != nil)
                {
                    Utility.hideLoading()
//                    self.updatePromoView()
                }
                else
                {
                    if Parser.isSuccess(response: response) {
                        Utility.hideLoading()
//                        self.updatePromoView(isPromoUsed: false)
                        self.wsGetTripStatus()
                    }
                }
            }
        }
    }
    @objc func wsGetTripStatus()
    {
        
        
        
        
        if preferenceHelper.getUserId().isEmpty
        {
            self.stopLocationListner()
            APPDELEGATE.gotoLogin()
            return
        }
        else
        {
            var  dictParam : [String : Any] = [:]
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.CHECK_TRIP_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {  (response, error) -> (Void) in
                
                if (error != nil)
                {
                    Utility.hideLoading()
                }
                else
                {DispatchQueue.main.async {
                    if self.view.subviews.count > 0
                    {
                        if Parser.isSuccess(response: response,withSuccessToast: false,andErrorToast: false)
                        {
                            
                            
                            CurrentTrip.shared.tripStaus = TripStatusResponse.init(fromDictionary: response)
                            CurrentTrip.shared.tripId = CurrentTrip.shared.tripStaus.trip.id
                            CurrentTrip.shared.tripType = CurrentTrip.shared.tripStaus.trip.tripType
                            CurrentTrip.shared.isFixedFareTrip = CurrentTrip.shared.tripStaus.trip.isFixedFare
                            CurrentTrip.shared.isCardModeAvailable = CurrentTrip.shared.tripStaus.cityDetail.isPaymentModeCard
                            CurrentTrip.shared.isCashModeAvailable = CurrentTrip.shared.tripStaus.cityDetail.isPaymentModeCash
                            
                            CurrentTrip.shared.isPromoApplyForCash = CurrentTrip.shared.tripStaus.cityDetail.isPromoApplyForCash
                            CurrentTrip.shared.isPromoApplyForCard = CurrentTrip.shared.tripStaus.cityDetail.isPromoApplyForCard
                            
                            
                            if CurrentTrip.shared.tripStaus.trip != nil
                            {
                                self.onGoingTrip = CurrentTrip.shared.tripStaus.trip
                            }
                            self.providerCurrentStatus = TripStatus(rawValue: self.onGoingTrip.isProviderStatus!) ?? TripStatus.Unknown
//                            self.updatePromoView()
                            self.updateAddress()
                            self.updatePaymentView(paymentMode: self.onGoingTrip.paymentMode)

                            
                            if self.strProviderId != CurrentTrip.shared.tripStaus.trip.currentProvider
                            {
                                self.strProviderId = CurrentTrip.shared.tripStaus.trip.currentProvider
                                self.wsGetProviderDetail(id: CurrentTrip.shared.tripStaus.trip.providerId)
                                self.providerNextStatus =  self.providerCurrentStatus
                            }
                            self.provider.bearing = self.onGoingTrip.bearing
                            self.updateSorceDestinationMarkers()
                            
                            self.updateTripDetail()
                            switch (self.providerCurrentStatus)
                            {
                                
                            case TripStatus.Accepted:
                                if self.providerCurrentStatus == self.providerNextStatus
                                {
                                    self.providerNextStatus = TripStatus.Coming
                                    self.playSound()
                                }
                                break
                            case TripStatus.Coming:
                                if self.providerCurrentStatus == self.providerNextStatus
                                {
                                    self.openStatusNotificationDialog()
                                    self.providerNextStatus = TripStatus.Arrived
                                    self.playSound()
                                }
                                break
                            case TripStatus.Arrived:
                                if self.providerCurrentStatus == self.providerNextStatus
                                {
                                    self.openStatusNotificationDialog()
                                    self.playSound()
                                    self.providerNextStatus = TripStatus.Started
                                    
                                    self.wsGetGooglePath()
                                    if CurrentTrip.shared.tripStaus.priceForWaitingTime > 0.0 && !(CurrentTrip.timerForWaitingTime?.isValid ??  false) && (!CurrentTrip.shared.tripStaus.trip.isFixedFare)
                                        
                                    {
                                        self.currentWaitingTime = CurrentTrip.shared.tripStaus.totalWaitTime
                                        self.stkWaitTime.isHidden = false
                                        self.startWaitingTripTimer()
                                    }
                                    else
                                    {
                                        print("JD Timer Wait Price \(CurrentTrip.shared.tripStaus.priceForWaitingTime)")
                                        self.stkWaitTime.isHidden = true
                                    }
                                }
                                break
                                
                            case TripStatus.Started:
                                if self.providerCurrentStatus == self.providerNextStatus
                                {
                                    self.openStatusNotificationDialog()
                                    self.providerNextStatus = TripStatus.End
                                    self.playSound()
                                }
                                self.wsGetGooglePath()
                                break
                                
                            case TripStatus.Completed:
                                if ((self.onGoingTrip.isTip) && !(self.onGoingTrip.isTripEnd == TRUE))
                                {
                                    self.openTipDialog()
                                }
                                else
                                {
                                    if (self.onGoingTrip.isTripEnd == TRUE)
                                    {
                                        self.stopLocationListner()
                                        self.socketHelper.disConnectSocket()
                                        APPDELEGATE.gotoInvoice()
                                    }
                                }
                                break
                            default:
                                printE("BOOM BOOM")
                            }
                        }
                        else
                        {
                            let response:ResponseModel = ResponseModel.init(fromDictionary: response)
                            if response.errorCode == TRIP_IS_ALREADY_CANCELLED
                            {}
                            CurrentTrip.shared.clearTripData()
                            self.stopLocationListner()
                            APPDELEGATE.gotoMap()
                        }
                    }
                    }
                }
            }
        }
    }

    func wsTwilioVoiceCall()
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TYPE] = 1
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.TWILIO_CALL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    
                    self.openTwillioNotificationDialog()
                }
            }
        }
    }

    func openTwillioNotificationDialog()
    {
        let dialogForTwillioCall = CustomStatusDialog.showCustomStatusDialog(message: "TXT_CALL_MESSAGE".localized, titletButton: "TXT_CLOSE".localized)
        dialogForTwillioCall.onClickOkButton =
            { [/*unowned self,*/ unowned dialogForTwillioCall] in
                dialogForTwillioCall.removeFromSuperview();
        }
    }

    func wsCancelTrip()
    {
        if !CurrentTrip.shared.tripStaus.trip.id.isEmpty()
        {
            Utility.showLoading()
            var  dictParam : [String : Any] = [:]
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.TRIP_ID] = CurrentTrip.shared.tripStaus.trip.id
            dictParam[PARAMS.CANCEL_TRIP_REASON] = ""

            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.CANCEL_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
                if (error != nil)
                {Utility.hideLoading()}
                else
                {
                    if Parser.isSuccess(response: response,withSuccessToast: false,andErrorToast: false)
                    {
                        self.emitTripNotification()
                        self.stopLocationListner()
                        CurrentTrip.shared.clearTripData()
                        APPDELEGATE.gotoMap()
                        Utility.hideLoading()
                    }
                    else
                    {
                        self.stopLocationListner()
                    }
                }
            }
        }
        else
        {
            self.stopLocationListner()
        }
    }

    func wsGetEmergencyContactList()
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.DEVICE_TOKEN] = preferenceHelper.getDeviceToken()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_EMERGENCY_CONTACT_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in

            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    Utility.hideLoading()
                    self.openSosDialog()
                }
                else
                {
                    Utility.hideLoading()
                }
            }
        }
    }

    func wsSos()
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        
        let sosLatitude = Double(providerMarker.position.latitude).toString(places: 6)
        let sosLongitude = Double(providerMarker.position.longitude).toString(places: 6)
        let strUrl = "https://www.google.co.in/maps/place/\(sosLatitude),\(sosLongitude)"
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.DEVICE_TOKEN] = preferenceHelper.getDeviceToken()
        dictParam[PARAMS.MAP_IMAGE] = strUrl

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.SEND_SMS_TO_EMERGENCY_CONTACT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { /*[unowned self]*/ (response, error) -> (Void) in

            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response,withSuccessToast: true,andErrorToast: true)
                {
                    Utility.hideLoading()
                }
                else
                {
                    Utility.hideLoading()
                }
            }
        }
    }

    func wsUpdateDestinationAddress(address:String,latitude:Double,longitude:Double)
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.DEVICE_TOKEN] = preferenceHelper.getDeviceToken()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
        dictParam[PARAMS.TRIP_DESTINATION_ADDRESS] = address
        dictParam[PARAMS.TRIP_DESTINATION_LATITUDE] = latitude
        dictParam[PARAMS.TRIP_DESTINATION_LONGITUDE] = longitude

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.SET_DESTINATION_ADDRESS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in

            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    let sourceCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: self.onGoingTrip.sourceLocation[0] , longitude: self.onGoingTrip.sourceLocation[1])

                    self.onGoingTrip.destinationLocation = [latitude,longitude]
                    self.onGoingTrip.destinationAddress = address
                    let destination:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
                    self.isSourceToDestPathDrawn = true
                    self.showPathFrom(source: sourceCoordinate, toDestination: destination)
                    self.emitTripNotification()
                    self.isCameraBearingChange = false;
                    Utility.hideLoading()
                }
                else
                {
                    Utility.hideLoading()
                }
            }
        }
    }

    func wsUpdatePaymentMode(paymentMode:Int)
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.DEVICE_TOKEN] = preferenceHelper.getDeviceToken()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
        dictParam[PARAMS.PAYMENT_TYPE] = paymentMode

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.USER_CHANGE_PAYMENT_TYPE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in

            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    Utility.hideLoading()
                    self.emitTripNotification()
                    self.updatePaymentView(paymentMode: paymentMode)
                    
                    if (paymentMode == PaymentMode.CASH && CurrentTrip.shared.isPromoApplyForCash == TRUE) || (paymentMode == PaymentMode.CARD && CurrentTrip.shared.isPromoApplyForCard == TRUE)
                    {}
                    else
                    {
                        self.wsRemovePromo()
                    }
                }
                else
                {
                    Utility.hideLoading()
                }
            }
        }
    }

    func emitTripNotification()
    {
        let dictParam:[String:Any] =
            [PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.TRIP_ID : CurrentTrip.shared.tripId]
        
        self.socketHelper.socket?.emitWithAck(self.socketHelper.tripDetailNotify, dictParam).timingOut(after: 0) {data in}
    }
}

extension TripVC:MessageRecivedDelegate
{
    // MARK:- Message Recived Delegate
    
    func messageRecived(data: FirebaseMessage)
    {
        imgChatNotification.isHidden = !(data.isRead == false && data.type != CONSTANT.TYPE_USER)
        
    }
    
    func messageUpdated(data: FirebaseMessage)
    {
        imgChatNotification.isHidden = !(data.isRead == false && data.type != CONSTANT.TYPE_USER)
    }
    
}
