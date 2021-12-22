//
//  MapVC.swift
//  Cabtown Provider
//
//  Created by Elluminati iMac on 19/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


class MapVC: BaseVC, CLLocationManagerDelegate, GMSMapViewDelegate,AddressDelegate,UIGestureRecognizerDelegate
{
    var isViewDidLoad: Bool = false
    
    var isNearByProviderCalled: Bool = false
    
    @IBOutlet var lblIconNoServiceAvailable: UILabel!
    @IBOutlet var btnPromoCode: UIButton!
    @IBOutlet var lblIconRentCar: UILabel!
    @IBOutlet var heightForAppPromotionView: NSLayoutConstraint!
    private struct MapPath : Decodable{
        var routes : [Route]?
    }
    
    private struct Route : Decodable{
        var overview_polyline : OverView?
    }
    
    private struct OverView : Decodable {
        var points : String?
    }
    func pickupAddressSet() {
        lblPickupAddress.text = CurrentTrip.shared.pickupAddress
        
        lblDestinationAddress.text = CurrentTrip.shared.destinationtAddress
        isShowActiveView = true
        self.previousProviderId = ""
        isSourceToDestPathDrawn = false
        checkForAvailableService()
        setMarkers()
        self.timeAndDistance = self.locationManager?.getTimeAndDistance(sourceCoordinate: CurrentTrip.shared.pickupCoordinate, destCoordinate: CurrentTrip.shared.destinationCoordinate) ?? (time:"0", distance: "0")
        self.wsGetFareEstimate()
    }
    func destinationAddressSet() {
        lblPickupAddress.text = CurrentTrip.shared.pickupAddress
        lblDestinationAddress.text = CurrentTrip.shared.destinationtAddress
        isShowActiveView = true
        isSourceToDestPathDrawn = false
        if CurrentTrip.shared.destinationtAddress.isEmpty()
        {
            lblFareEstimate.text = "TXT_FARE_ESTIMATE".localized
            destinationMarker.map = nil
            polyLinePath.map = nil
        }
        checkForAvailableService()

        self.setMarkers()
        self.timeAndDistance = self.locationManager?.getTimeAndDistance(sourceCoordinate: CurrentTrip.shared.pickupCoordinate, destCoordinate: CurrentTrip.shared.destinationCoordinate) ?? (time:"0", distance: "0")
        self.wsGetFareEstimate()
    }
    
    
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var viewForAppPromotion: UIView!
    @IBOutlet weak var btnAppPromotion: UIButton!
    
    let socketHelper:SocketHelper = SocketHelper.shared
    /*Bottom View Animation*/
    
    @IBOutlet weak var scrFilterView: UIScrollView!
    @IBOutlet weak var lblIconPinSourceLocation: UILabel!
    private var animationProgress: CGFloat = 0
    private var currentState: State = .closed
    @IBOutlet weak var heightForFilter: NSLayoutConstraint!
    
    @IBOutlet weak var lblIconETA: UILabel!
    @IBOutlet weak var lblIconFareEstimate: UILabel!
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()

    @IBOutlet weak var vwDivider: UIView!

    private var originalPullUpControllerViewSize: CGSize = .zero
    @IBOutlet weak var viewForRentalPackage: UIView!
    @IBOutlet weak var lblRentalPackSize: UILabel!
    
    @IBOutlet weak var viewForSelectRetalPackage: UIView!
    @IBOutlet weak var btnSelectPackage: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    //Ideal View
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var viewForWhereToGo: UIView!
    @IBOutlet weak var lblWhereToGo: UILabel!
    @IBOutlet weak var btnMyLocation: UIButton!
    var isSourceToDestPathDrawn:Bool = false
    var polyLinePath:GMSPolyline = GMSPolyline.init()
    var previousCity:String = "";
    //Provider Filter View
    @IBOutlet weak var viewForProviderFilter: UIView!
    @IBOutlet weak var dialogForProviderFilter: UIView!
    @IBOutlet weak var lblAccessibility: UILabel!
    @IBOutlet weak var btnHotspot: UIButton!
    @IBOutlet weak var btnHandicap: UIButton!
    @IBOutlet weak var btnBabySeat: UIButton!
    @IBOutlet weak var lblSelectLanguage: UILabel!
    @IBOutlet weak var tblProviderLanguage: UITableView!
    @IBOutlet weak var btnApplyFilter: UIButton!
    @IBOutlet weak var btnCancelFilter: UIButton!
    @IBOutlet weak var heightForLanguageTable: NSLayoutConstraint!
    
    @IBOutlet var lblBabySeat: UILabel!
    @IBOutlet var lblHandicap: UILabel!
    @IBOutlet var lblHotspot: UILabel!
    
    
    @IBOutlet weak var lblProviderGenderSelection: UILabel!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var btnRegular: UIButton!
    
    @IBOutlet weak var btnRental: UIButton!
    
    @IBOutlet weak var viewForRideNowLater: UIView!
    
    
    //Favourite Address View
    @IBOutlet weak var btnHomeAddress: UIButton!
    @IBOutlet weak var btnWorkAddress: UIButton!
    @IBOutlet weak var btnAddAddress: UIButton!
    @IBOutlet weak var stkFavouriteAddress: UIStackView!
    //Address View
    @IBOutlet weak var viewForAddresses: UIView!
    @IBOutlet weak var viewForPickupAddress: UIView!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var btnPickupAddress: UIButton!
    @IBOutlet weak var viewForDestinationAddress: UIView!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    @IBOutlet weak var btnDestinationAddress: UIButton!
    @IBOutlet weak var btnRideLater: UIButton!
    
    
    //No Service View
    @IBOutlet weak var viewForNoServiceAvailable: UIView!
    @IBOutlet weak var lblSorry: UILabel!
    @IBOutlet weak var lblNoServiceAvailable: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    
    //ViewFor Available Service
    @IBOutlet weak var viewForAvailableService: UIView!
    @IBOutlet weak var viewForServices: UIView!
    @IBOutlet weak var collectionViewForServices: UICollectionView!
    @IBOutlet weak var viewForFareEstimate: UIView!
    @IBOutlet weak var btnFareEstimate: UIButton!
    @IBOutlet weak var lblFareEstimate: UILabel!
    @IBOutlet weak var viewForPayment: UIView!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblPaymentIcon: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var btnPayment: UIButton!
    @IBOutlet weak var viewForEta: UIView!
    @IBOutlet weak var lblEta: UILabel!
    @IBOutlet weak var btnEta: UIButton!
    @IBOutlet weak var btnRideNow: UIButton!
    @IBOutlet weak var btnScheduleTripTime: UIButton!
    @IBOutlet weak var btnCorporatePay: UIButton!
    
    //Dialogs
    var dialogFromDriverDetail: CustomDriverDetailDialog?
    var dialogForSelectRentPackage : CustomRentCarDialog?
    
    var driverMarkerImage:UIImage? = nil
    private var popupOffset: CGFloat = 0
    
    //View For Type Description
    @IBOutlet weak var viewForTypeDescription: UIView!
    @IBOutlet weak var lblTypeName: UILabel!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblTypeDescription: UILabel!
    @IBOutlet weak var dialogForTypeDescription: UIView!
    @IBOutlet weak var btnHideTypeDescription: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
    //Varialbles
    public var str = ""
    var paymentMode = PaymentMode.UNKNOWN
    var animMapDuration:Double = 0.5
    var currentMarker = GMSMarker()
    var locationManager: LocationManager? = LocationManager()
    var isDoAnimation:Bool = false
    var selectedIndex:Int = 0
    var arrForProviderLanguage:[Language] = []
    var arrFinalForVehicles:[Citytype] = []
    var arrNormalForVehicles:[Citytype] = []
    var arrRentalForVehicles:[Citytype] = []
    var arrForSelectedLanguages:[Language] = []
    var  isHotSpotSelected:Bool = false,
    isBabySeatSelected:Bool = false,
    isHandicapSelected:Bool = false;
    
    
    var arrayForProviderMarker:[GMSMarker] = []
    var pickupMarker:GMSMarker = GMSMarker.init()
    var destinationMarker:GMSMarker = GMSMarker.init()
    var isShowActiveView:Bool = false
    var strProviderId:String = ""
    var strFutureTripSelectedDate:String = ""
    var previousProviderId:String = ""
    
    var promoId:String = ""

    var timeAndDistance: (time:String, distance:String) = (time: "0", distance: "0")
    //MARK:
    //MARK: View life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.isViewDidLoad = true
        setMap()
        self.showPromotionView(show: false)
        
        view.addSubview(viewForProviderFilter)
        viewForProviderFilter.backgroundColor = UIColor.themeOverlayColor
        stkFavouriteAddress.isHidden = true

        let pinImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        pinImageView.tintColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        pinImageView.image = UIImage(named: "asset-pin-current-location")
        currentMarker.iconView = pinImageView
        
        currentMarker.map = mapView
        currentMarker.groundAnchor = CGPoint.init(x: 0.5, y: 0.5)
        
        self.locationManager?.autoUpdate = false
        self.navigationController?.isNavigationBarHidden = true
        self.revealViewController()?.delegate = self;
        btnCorporatePay.isSelected = false
        seperatorView.backgroundColor = UIColor.themeLightDividerColor
        Utility.hideLoading()
        if preferenceHelper.getUserId().isEmpty
        {
            self.stopTripStatusTimer()
            self.stopTripNearByProviderTimer()
            return
        }
        else
        {

            self.initialViewSetup()
            self.gettingCurrentLocation { [unowned self] in
                if CurrentTrip.shared.currentCoordinate.latitude != 0.0 && CurrentTrip.shared.currentCoordinate.longitude != 0.0
                {
                    self.resetTripNearByProviderTimer()
                }
            }
            setCollectionView()
            setupRevealViewController()
            idealView()
            self.wsGetLanguage()
            self.wsGetAddress()
        }
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapVC.handleLongPress))
        lpgr.minimumPressDuration = 0.3
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionViewForServices?.addGestureRecognizer(lpgr)
        
        
        self.collectionViewForServices.reloadData()
        mapView.settings.compassButton = true
        bottomConstraint.constant = -self.viewForAvailableService.frame.height
        //viewForAvailableService.addGestureRecognizer(panRecognizer)
        viewForAvailableService.isHidden = true
        popupOffset = viewForAvailableService.frame.size.height
        self.bottomConstraint.constant = -self.viewForAvailableService.frame.height
        btnBack.setupBackButton()
        btnBack.setTitleColor(.black, for: .normal)
        
        btnPromoCode.setTitle("\("TXT_CREDIT".localizedCapitalized):\(0.25.toString())", for: .normal)
        
        btnPromoCode.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnPromoCode.backgroundColor = UIColor.clear
        btnPromoCode.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        self.updateEtaUI()
    }

    func updateEtaUI() {
        if preferenceHelper.getIsShowEta() {
            self.viewForEta.isHidden = false
            self.vwDivider.isHidden = false
        } else{
            self.viewForEta.isHidden = true
            self.vwDivider.isHidden = true
        }
    }
    func showPromotionView(show:Bool)
    {
        if show
        {
            heightForAppPromotionView.constant = 60
            viewForAppPromotion.isHidden = false
        }
        else
        {
            heightForAppPromotionView.constant = 0
            viewForAppPromotion.isHidden = true
        }
    }
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        
        let p = gesture.location(in: self.collectionViewForServices)
        
        if /*let indexPath =*/self.collectionViewForServices.indexPathForItem(at: p) != nil {
            // get the cell at indexPath (the one you long pressed)
            openTypeDescriptionDialog()
            // do stuff with the cell
        } else {
            printE("couldn't find index path")
        }
    }
    func openTypeDescriptionDialog()
    {
        self.lblTypeName.text = CurrentTrip.shared.selectedVehicle.typeDetails.typename
        self.imgType.downloadedFrom(link: CurrentTrip.shared.selectedVehicle.typeDetails.typeImageUrl,
                                    placeHolder: "asset-profile-placeholder",
                                    isFromCache:true,
                                    isIndicator:false,
                                    mode:.scaleAspectFit,
                                    isAppendBaseUrl:true)
        self.lblTypeDescription.text = CurrentTrip.shared.selectedVehicle.typeDetails.descriptionField
        self.viewForTypeDescription.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        socketHelper.connectSocket()
        if preferenceHelper.getUserId().isEmpty
        {
            self.stopTripStatusTimer()
            self.stopTripNearByProviderTimer()
            APPDELEGATE.gotoLogin()
            return
        }
        if !CurrentTrip.shared.user.corporateDetail.id.isEmpty() && CurrentTrip.shared.user.corporateDetail.status == FALSE
        {
            self.openCorporateRequestDialog()
        }
        
        self.resetTripNearByProviderTimer()
        self.wsGetTripStatus()
        updateAddressUI()
        btnRideLater.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTripNearByProviderTimer()
        socketHelper.disConnectSocket()
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        setupLayout()
        
    }
    
    //MARK:
    //MARK: Socket Listeners
    
    func registerProviderSocket(id:String)
    {
        
        let myProviderId = "'\(id)'"
        self.socketHelper.socket?.on(myProviderId)
        {
            [weak self] (data, ack) in
            guard let `self` = self else { return }
            guard let response = data.first as? [String:Any] else
            { return }
            print("Soket Response\(response)")
            let location = (response["location"] as? [Double]) ?? [0.0,0.0]
            let bearing = (response["bearing"] as? Double) ?? 0.0
            let providerid = (response["provider_id"] as? String) ?? ""
            if let marker = self.arrayForProviderMarker.first(where: { (marker) -> Bool in
                marker.accessibilityLabel == providerid
                
            })
            {
                
                self.animateMarker(marker: marker, coordinate: CLLocationCoordinate2D.init(latitude: location[0], longitude: location[1]), bearing: bearing)

            }
            
        }
        
    }
    
    func animateMarker(marker:GMSMarker, coordinate:CLLocationCoordinate2D,bearing:Double)
    {
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setValue(0.5, forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock {
            }
            marker.rotation = bearing
            CATransaction.commit()
            
            
            CATransaction.begin()
            CATransaction.setValue(1.5, forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock {
            }
            marker.position = coordinate
            CATransaction.commit()
        }

        
        
        
        
        
    }
    func unRegisterProviderSocket(id:String)
    {
        socketHelper.socket?.off(id)
    }
    func registerAllProviderSocket(providers:[Provider])
    {
        
        self.setProviderMarker(arrProvider: providers)
    }
    func unRegisterProviderSocket()
    {
        for marker in arrayForProviderMarker
        {
            if let id = marker.accessibilityLabel
            {
                let myProviderId = "'\(id)'"
                unRegisterProviderSocket(id: myProviderId)
            }
        }
    }
    //MARK:
    //MARK: Set localized
    func initialViewSetup()
    {
        
        btnAppPromotion.setTitle("TXT_BOOK_EDELIVERY".localized, for: .normal)
        
        btnAppPromotion.titleLabel?.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        btnAppPromotion.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        lblWhereToGo.text = "TXT_WHERE_TO_GO".localized
        lblWhereToGo.textColor = UIColor.themeLightTextColor
        lblWhereToGo.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblAccessibility.text = "TXT_ACCESSIBILITY".localized
        lblAccessibility.textColor = UIColor.themeTextColor
        lblAccessibility.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblSelectLanguage.text = "TXT_SELECT_LANGUAGE".localized
        lblSelectLanguage.textColor = UIColor.themeTextColor
        lblSelectLanguage.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblProviderGenderSelection.text = "TXT_REQUEST_PROVIDER_GENDER".localized
        lblProviderGenderSelection.textColor = UIColor.themeTextColor
        lblProviderGenderSelection.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        btnMale.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnMale.setTitle(" " + "TXT_MALE".localizedCapitalized, for: .normal)
        btnMale.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        btnFemale.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnFemale.setTitle(" " + "TXT_FEMALE".localizedCapitalized, for: .normal)
        btnFemale.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        btnCorporatePay.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnCorporatePay.setTitle(" " + "TXT_PAY_BY_CORPORATE".localized, for: .normal)
        btnCorporatePay.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        
        btnHideTypeDescription.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnHideTypeDescription.setTitle(" " + "TXT_CLOSE".localizedCapitalized, for: .normal)
        btnHideTypeDescription.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnHideTypeDescription.backgroundColor = UIColor.themeButtonBackgroundColor
        
        

        btnHotspot.setTitle(FontAsset.icon_check_box_normal, for: .normal)
        btnHotspot.setTitle(FontAsset.icon_check_box_selected, for: .selected)

        lblHotspot.text = "TXT_HOTSPOT".localizedCapitalized
        lblHotspot.textColor = UIColor.themeTextColor
        lblHotspot.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
        
        
        
        lblBabySeat.text = "TXT_BABY_SEAT".localizedCapitalized
        lblBabySeat.textColor = UIColor.themeTextColor
        lblBabySeat.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
        btnBabySeat.setTitle(FontAsset.icon_check_box_normal, for: .normal)
        btnBabySeat.setTitle(FontAsset.icon_check_box_selected, for: .selected)

        lblHandicap.text = "TXT_HANDICAP".localizedCapitalized
        lblHandicap.textColor = UIColor.themeTextColor
        lblHandicap.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
        btnHandicap.setTitle(FontAsset.icon_check_box_normal, for: .normal)
        btnHandicap.setTitle(FontAsset.icon_check_box_selected, for: .selected)

        btnHandicap.setSimpleIconButton()
        btnHotspot.setSimpleIconButton()
        btnBabySeat.setSimpleIconButton()
        
        
        /* let buttonAttributes: [NSAttributedString.Key: Any] = [.font: FontHelper.assetFont()]
         let textAttributes: [NSAttributedString.Key: Any] = [.font: FontHelper.font(size: FontSize.regular, type: .Regular)]

         let radioButtonNormalString = NSMutableAttributedString(string: FontAsset.icon_check_box_normal, attributes: buttonAttributes)
         let radioButtonSelectedString = NSMutableAttributedString(string: FontAsset.icon_check_box_selected, attributes: buttonAttributes)



         let hotSpotString = NSMutableAttributedString.init(string: " " + "TXT_HOTSPOT".localizedCapitalized, attributes: textAttributes)

         let babySeatString = NSMutableAttributedString.init(string: " " + "TXT_BABY_SEAT".localizedCapitalized, attributes: textAttributes)

         let handicapString = NSMutableAttributedString.init(string: " " + "TXT_HANDICAP".localizedCapitalized, attributes: textAttributes)


         let newHotSpotNormalString = NSMutableAttributedString.init(attributedString: radioButtonNormalString)
         newHotSpotNormalString.append(hotSpotString)

         let newHotSpotSelectedString = NSMutableAttributedString.init(attributedString: radioButtonSelectedString)
         newHotSpotSelectedString.append(hotSpotString)*/

        btnApplyFilter.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnApplyFilter.setTitle(" " + "TXT_APPLY".localizedCapitalized, for: .normal)
        btnApplyFilter.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnApplyFilter.backgroundColor = UIColor.themeButtonBackgroundColor

        btnSelectPackage.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnSelectPackage.setTitle("TXT_SELECT_PACKAGE".localizedCapitalized, for: .normal)
        btnSelectPackage.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnSelectPackage.backgroundColor = UIColor.themeButtonBackgroundColor

        btnRideNow.setTitle("BTN_RIDE_NOW".localizedCapitalized, for: .normal)
        btnRideNow.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnRideNow.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnRideNow.backgroundColor = UIColor.themeButtonBackgroundColor

        btnRideLater.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnRideLater.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnRideLater.backgroundColor = UIColor.themeButtonBackgroundColor

        btnCancelFilter.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        btnCancelFilter.setTitle(" " + "TXT_CANCEL".localizedCapitalized, for: .normal)
        btnCancelFilter.setTitleColor(UIColor.themeLightTextColor, for: .normal)

        lblSorry.text = "TXT_SORRY".localized
        lblSorry.textColor = UIColor.themeTextColor
        lblSorry.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblNoServiceAvailable.text = "TXT_NO_SERVICE_AVAILABLE_IN_THIS_AREA".localized
        lblNoServiceAvailable.textColor = UIColor.themeLightTextColor
        lblNoServiceAvailable.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblPickupAddress.text = "TXT_PICKUP_ADDRESS".localized
        lblPickupAddress.textColor = UIColor.themeTextColor
        lblPickupAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblDestinationAddress.text = "TXT_DESTINATION_ADDRESS".localized
        lblDestinationAddress.textColor = UIColor.themeTextColor
        lblDestinationAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblFareEstimate.text = "TXT_FARE_ESTIMATE".localized
        lblFareEstimate.textColor = UIColor.themeTextColor
        lblFareEstimate.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        
        lblEta.text = "TXT_ETA".localized
        lblEta.textColor = UIColor.themeTextColor
        lblEta.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        
        
        lblPayment.text = "TXT_ADD_PAYMENT".localized
        lblPayment.textColor = UIColor.themeTextColor
        lblPayment.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        
        lblRentalPackSize.text = "TXT_DEFAULT".localized
        lblRentalPackSize.textColor = UIColor.themeTextColor
        lblRentalPackSize.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        
        
        
        tblProviderLanguage.tableFooterView = UIView.init()
        
        hideProviderFilter()
        viewForNoServiceAvailable.backgroundColor = UIColor.themeDialogBackgroundColor.withAlphaComponent(0.9)
        viewForAvailableService.backgroundColor = UIColor.themeDialogBackgroundColor.withAlphaComponent(0.9)
        
        

        self.btnRideLater.titleLabel?.numberOfLines = 2
        self.btnRideLater.titleLabel?.textAlignment = .center
        
        
        viewForTypeDescription.backgroundColor = UIColor.themeOverlayColor
        dialogForTypeDescription.backgroundColor = UIColor.themeDialogBackgroundColor
        
        lblTypeName.text = "TXT_TYPE_NAME".localized
        lblTypeName.textColor = UIColor.themeTextColor
        lblTypeName.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblTypeDescription.text = "TXT_DEFAULT".localized
        lblTypeDescription.textColor = UIColor.themeLightTextColor
        lblTypeDescription.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        btnRegular.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnRegular.setTitle("TXT_NOW".localizedCapitalized, for: .normal)
        btnRegular.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnRegular.setTitleColor(UIColor.themeTextColor, for: .selected)
        
        btnRental.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnRental.setTitle("TXT_RENTAL".localizedCapitalized, for: .normal)
        btnRental.setTitleColor(UIColor.themeTextColor, for: .selected)
        btnRental.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        
        
        lblIconETA.text = FontAsset.icon_time
        lblIconPinSourceLocation.text = FontAsset.icon_pickup_location
        lblPayment.text = FontAsset.icon_payment_cash
        lblIconFareEstimate.text = FontAsset.icon_fare_estimate
        lblIconRentCar.text = FontAsset.icon_car_rent
        lblIconNoServiceAvailable.text = FontAsset.icon_no_service_available
        
        
        lblIconNoServiceAvailable.setForIcon()
        lblIconRentCar.setForIcon()
        lblIconPinSourceLocation.setForIcon()
        lblPaymentIcon.setForIcon()
        lblIconETA.setForIcon()
        lblIconFareEstimate.setForIcon()
        
        
        btnAddAddress.setTitle(FontAsset.icon_add, for: .normal)
        btnHomeAddress.setTitle(FontAsset.icon_btn_home, for: .normal)
        btnWorkAddress.setTitle(FontAsset.icon_btn_work, for: .normal)
        btnMyLocation.setTitle(FontAsset.icon_btn_current_location, for: .normal)
        btnMenu.setTitle(FontAsset.icon_menu, for: .normal)
        btnMenu.setUpTopBarButton()
        btnFilter.setTitle(FontAsset.icon_filter, for: .normal)
        btnFilter.setUpTopBarButton()
        btnScheduleTripTime.setTitle(FontAsset.icon_schedule_calender, for: .normal)
        btnAddAddress.setRoundIconButton()
        btnAddAddress.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        btnHomeAddress.setRoundIconButton()
        btnHomeAddress.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        btnWorkAddress.setRoundIconButton()
        btnWorkAddress.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
        btnMyLocation.setSimpleIconButton()
        btnMyLocation.titleLabel?.font = FontHelper.assetFont(size: 30)
        btnScheduleTripTime.setRoundIconButton()
        btnScheduleTripTime.backgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
    }
    
    func setupLayout()
    {
        viewForProviderFilter.frame = view.bounds
        viewForAppPromotion.roundCorners(corners: [.topLeft,.topRight], radius: 15.0)
        viewForWhereToGo.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        viewForWhereToGo.setShadow()
        
        
        self.dialogForTypeDescription.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        btnHideTypeDescription.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnHideTypeDescription.frame.height/2, borderWidth: 1.0)
        
        
        viewForAddresses.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        viewForAddresses.setShadow()
        
        btnRideNow.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnRideNow.frame.height/2, borderWidth: 1.0)
        btnRideLater.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnRideLater.frame.height/2, borderWidth: 1.0)
        
        
        btnSelectPackage.setRound(withBorderColor: UIColor.clear, andCornerRadious: 10.0, borderWidth: 1.0)
        
        
        btnApplyFilter.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnApplyFilter.frame.height/2, borderWidth: 1.0)
        self.dialogForProviderFilter.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        dialogForProviderFilter.setShadow()
        
    }
    
    //MARK:
    //MARK: Get Current Location
    func gettingCurrentLocation(completionHandler: @escaping (() -> Void))
    {
        self.locationManager?.currentLocation { [weak self] (location, error) in
            if error != nil
            {
                //Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
                completionHandler()
            }
            else
            {
                if let currentLocation = location
                {
                    if currentLocation.coordinate.latitude != 0.0 && currentLocation.coordinate.longitude != 0.0
                    {
                        print(currentLocation.coordinate)
                        if CurrentTrip.shared.currentCoordinate.isEqual(currentLocation.coordinate) {
                            if CurrentTrip.shared.pickupAddress.isEmpty() {
                                self?.locationManager?.getAddressFromLatitudeLongitude(latitude: CurrentTrip.shared.currentCoordinate.latitude, longitude: CurrentTrip.shared.currentCoordinate.longitude, completion: { (address, locations) in
                                    CurrentTrip.shared.setPickupLocation(latitude: locations[0], longitude: locations[1], address: address)
                                    self?.animateToCurrentLocation()
                                    self?.checkForAvailableService()
                                })
                            }
                        }else {
                            CurrentTrip.shared.currentCoordinate = currentLocation.coordinate
                            self?.locationManager?.getAddressFromLatitudeLongitude(latitude: CurrentTrip.shared.currentCoordinate.latitude, longitude: CurrentTrip.shared.currentCoordinate.longitude, completion: { (address, locations) in
                                CurrentTrip.shared.setPickupLocation(latitude: locations[0], longitude: locations[1], address: address)
                                self?.animateToCurrentLocation()
                                self?.checkForAvailableService()
                            })
                        }
                        completionHandler()
                    }
                    else
                    {
                        // Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
                        completionHandler()
                    }
                }
                else
                {
                    Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
                    completionHandler()
                }
            }
        }
    }

    func setMap()
    {
        mapView.clear()
        mapView.delegate = self
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = false;
        mapView.settings.rotateGestures = false;
        mapView.settings.myLocationButton = false;
        mapView.isMyLocationEnabled = false;
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
    func animateToCurrentLocation()
        
    {

        CATransaction.begin()
        CATransaction.setValue(animMapDuration, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock { 
        }
        let camera = GMSCameraPosition.camera(withTarget: CurrentTrip.shared.currentCoordinate, zoom: 17.0, bearing: 45, viewingAngle: 0.0)
        self.mapView?.animate(to: camera)
        self.currentMarker.position = CurrentTrip.shared.currentCoordinate
        CATransaction.commit()
        self.animMapDuration = 1.5
    }

    //MARK: Action Methods
    @IBAction func btnSelectPackage(_ sender: Any) {
        openRentPackageDialog()
    }
    
    @IBAction func creditAction(_ sender: Any) {
        let navigationVC = revealViewController()?.mainViewController as? UINavigationController
        navigationVC?.performSegue(withIdentifier: SEGUE.HOME_TO_OWN_CREDIT, sender: self)
    }

    @IBAction func beDriverAction(_ sender: Any) {
        let navigationVC = revealViewController()?.mainViewController as? UINavigationController
        navigationVC?.performSegue(withIdentifier: SEGUE.HOME_TO_BE_DRIVER, sender: self)
    }

    func openRentPackageDialog() {
        if dialogForSelectRentPackage == nil {
            dialogForSelectRentPackage = CustomRentCarDialog.showCustomRentCarDialog(title: "TXT_PACKAGES".localized, message: "", titleLeftButton:"TXT_CANCEL".localized , titleRightButton: "TXT_RENT_NOW".localized)
            self.updateRideNowButton()
        }
        
        dialogForSelectRentPackage?.onClickLeftButton = { 
            [unowned self, weak dialogForSelectRentPackage = self.dialogForSelectRentPackage] in 
            printE(dialogForSelectRentPackage!)
            self.dialogForSelectRentPackage?.removeFromSuperview()
            self.dialogForSelectRentPackage = nil
            dialogForSelectRentPackage = nil
        }
        dialogForSelectRentPackage?.onClickRightButton = { 
            [unowned self, weak dialogForSelectRentPackage = self.dialogForSelectRentPackage] in 
            printE(dialogForSelectRentPackage!)
            self.dialogForSelectRentPackage?.removeFromSuperview()
            self.dialogForSelectRentPackage = nil
            dialogForSelectRentPackage = nil
            self.createRentTrip()
        }
    }
    
    func updateRideNowButton()
    {
        if dialogForSelectRentPackage != nil
        {
            dialogForSelectRentPackage?.btnRight.isEnabled = btnRideNow.isEnabled
            if dialogForSelectRentPackage?.btnRight.isEnabled ?? true
            {
                dialogForSelectRentPackage?.btnRight.alpha = 1.0
            }
            else
            {
                dialogForSelectRentPackage?.btnRight.alpha = 0.5
            }
        }
        
    }
    @IBAction func btnRegular(_ sender: Any) {
        btnRental.isSelected = false
        btnRegular.isSelected = true
        viewForFareEstimate.isHidden = false
        viewForRentalPackage.isHidden = true
        viewForRideNowLater.isHidden = false
        viewForSelectRetalPackage.isHidden = true
        fillVehicleArrayWith(array: self.arrNormalForVehicles)
    }
    @IBAction func btnRental(_ sender: Any) {
        btnRental.isSelected = true
        btnRegular.isSelected = false
        viewForFareEstimate.isHidden = true
        viewForRentalPackage.isHidden = false
        viewForRideNowLater.isHidden = true
        viewForSelectRetalPackage.isHidden = false
        fillVehicleArrayWith(array: self.arrRentalForVehicles)
    }
    
    @IBAction func onClickBtnMyLocation(_ sender: Any) {
        if self.locationManager != nil {
            if self.locationManager!.requestUserLocation()
            {
                self.getCurrentocation()
            }
        }
        
    }
    @IBAction func onClickBnHideTypeDescription(_ sender: Any)
    {
        viewForTypeDescription.isHidden = true
    }
    
    @IBAction func onClickBtnPromoCode(_ sender: Any) {
        let navigationVC = revealViewController()?.mainViewController as? UINavigationController
        navigationVC?.performSegue(withIdentifier: SEGUE.HOME_TO_PAYMENT, sender: self)
    }

    func getCurrentocation()
    {
        self.locationManager?.currentLocation { [unowned self] (location, error) in
            if error != nil
            {
                //Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
            }
            else
            {
                
                if let currentLocation  = location
                {
                    if currentLocation.coordinate.latitude != 0.0 && currentLocation.coordinate.longitude != 0.0
                    {
                        if CurrentTrip.shared.currentCoordinate.isEqual(currentLocation.coordinate) {
                            if CurrentTrip.shared.pickupAddress.isEmpty() {
                                self.locationManager?.getAddressFromLatitudeLongitude(latitude: CurrentTrip.shared.currentCoordinate.latitude, longitude: CurrentTrip.shared.currentCoordinate.longitude, completion: { (address, locations) in
                                    CurrentTrip.shared.setPickupLocation(latitude: locations[0],
                                                                         longitude: locations[1],
                                                                         address: address)
                                })
                            }
                        }
                        else{
                            CurrentTrip.shared.currentCoordinate = currentLocation.coordinate
                            self.locationManager?.getAddressFromLatitudeLongitude(latitude: CurrentTrip.shared.currentCoordinate.latitude, longitude: CurrentTrip.shared.currentCoordinate.longitude, completion: { (address, locations) in
                                CurrentTrip.shared.setPickupLocation(latitude: locations[0],
                                                                     longitude: locations[1],
                                                                     address: address)
                            })

                        }
                        self.animateToCurrentLocation()
                    }
                }
            }
        }
    }

    @IBAction func onClickBtnWhereToGo(_ sender: Any) {
        if let addressVC = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
        {
            addressVC.delegate = self
            addressVC.flag = AddressType.destinationAddress
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
    }
    @IBAction func onClickBtnPickupAddress(_ sender: Any) {
        if let addressVC = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
        {
            addressVC.delegate = self
            addressVC.flag = AddressType.pickupAddress
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
    }
    @IBAction func onClickBtnDestinationAddress(_ sender: Any){
        
        if let addressVC = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
        {
            addressVC.delegate = self
            addressVC.flag = AddressType.destinationAddress
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
    }
    @IBAction func onClickBtnBack(_ sender: Any){
        idealView()
    }
    
    @IBAction func onClickBtnHideFilterView(_ sender: Any) {
        hideProviderFilter()
    }

    @IBAction func onClickBtnFareEstimate(_ sender: Any) {
        openFareEstimateDialog()
    }

    @IBAction func onClickBtnPayment(_ sender: Any) {
        if CurrentTrip.shared.isCashModeAvailable == FALSE || CurrentTrip.shared.isCardModeAvailable == FALSE
        {
            Utility.showToast(message: "VALIDATION_MSG_NO_OTHER_PAYMENT_MODE_AVAILABLE".localized)
        }
        else
        {
            if promoId.isEmpty()
            {
                openPaymentDialog()
            }
            else
            {
                let dialogForConfirmationDialog = CustomAlertDialog.showCustomAlertDialog(title: "TITLE_PROMO_REMOVE_MESSAGE".localized, message: "MSG_PROMO_REMOVE_MESSAGE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
                dialogForConfirmationDialog.onClickLeftButton =
                    { [/*unowned self,*/ unowned dialogForConfirmationDialog] in
                        
                        dialogForConfirmationDialog.removeFromSuperview();
                        
                }
                dialogForConfirmationDialog.onClickRightButton =
                    { [/*unowned self,*/ unowned dialogForConfirmationDialog] in
                        dialogForConfirmationDialog.removeFromSuperview();
                        self.openPaymentDialog()
                }
            }
        }
    }

    @IBAction func onClickBtnAddAddress(_ sender: Any)
    {
        if let addressVC = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
        {
            addressVC.delegate = self
            addressVC.flag = AddressType.pickupAddress
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
    }

    @IBAction func onClickBtnHomeAddress(_ sender: Any)
    {
        let address = CurrentTrip.shared.favouriteAddress
        CurrentTrip.shared.setDestinationLocation(latitude: address.homeLocation[0], longitude: address.homeLocation[1], address: address.homeAddress)
        destinationMarker.position = CurrentTrip.shared.destinationCoordinate
        lblPickupAddress.text = CurrentTrip.shared.pickupAddress
        lblDestinationAddress.text = CurrentTrip.shared.destinationtAddress
        isShowActiveView = true
        isSourceToDestPathDrawn = false
        checkForAvailableService()

        self.timeAndDistance = self.locationManager?.getTimeAndDistance(sourceCoordinate: CurrentTrip.shared.pickupCoordinate, destCoordinate: CurrentTrip.shared.destinationCoordinate) ?? (time:"0", distance: "0")
        self.wsGetFareEstimate()
    }

    @IBAction func onClickBtnWorkAddress(_ sender: Any)
    {
        
        let address = CurrentTrip.shared.favouriteAddress
        CurrentTrip.shared.setDestinationLocation(latitude: address.workLocation[0], longitude: address.workLocation[1], address: address.workAddress)
        destinationMarker.position = CurrentTrip.shared.destinationCoordinate
        
        lblPickupAddress.text = CurrentTrip.shared.pickupAddress
        lblDestinationAddress.text = CurrentTrip.shared.destinationtAddress
        isShowActiveView = true
        isSourceToDestPathDrawn = false
        checkForAvailableService()

        self.timeAndDistance = self.locationManager?.getTimeAndDistance(sourceCoordinate: CurrentTrip.shared.pickupCoordinate, destCoordinate: CurrentTrip.shared.destinationCoordinate) ?? (time:"0", distance: "0")
        self.wsGetFareEstimate()
    }
    @IBAction func onClickBtnHotSpot(_ sender: Any) {
        btnHotspot.isSelected = !btnHotspot.isSelected
    }
    @IBAction func onClickBtnHandicap(_ sender: Any) {
        btnHandicap.isSelected = !btnHandicap.isSelected
    }
    @IBAction func onClickBtnBabySeat(_ sender: Any) {
        btnBabySeat.isSelected = !btnBabySeat.isSelected
    }
    @IBAction func onClickBtnMaleProvider(_ sender: Any) {
        btnMale.isSelected = !btnMale.isSelected
    }
    
    @IBAction func onClickBtnFemaleProvider(_ sender: Any) {
        btnFemale.isSelected = !btnFemale.isSelected
    }
    @IBAction func onClickBtnFilter(_ sender: Any) {
        
        btnBabySeat.isSelected = isBabySeatSelected
        btnHotspot.isSelected = isHotSpotSelected
        btnHandicap.isSelected = isHandicapSelected
        if arrForProviderLanguage.isEmpty
        {
            lblSelectLanguage.isHidden = true
            tblProviderLanguage.isHidden = true
        }
        else
        {
            for language in arrForProviderLanguage
            {
                language.isSelected = false
                for selectedLanguage in arrForSelectedLanguages
                {
                    if selectedLanguage.id == language.id
                    {
                        language.isSelected = true
                    }
                }
                
            }
            heightForLanguageTable.constant = tblProviderLanguage.contentSize.height < 120 ? tblProviderLanguage.contentSize.height : 120
            
            tblProviderLanguage.reloadData()
            heightForLanguageTable.constant = tblProviderLanguage.contentSize.height < 120 ? tblProviderLanguage.contentSize.height : 120
        }
        showProviderFilter()
    }
    @IBAction func onClickBtnApplyFilter(_ sender: Any) {
        isBabySeatSelected = btnBabySeat.isSelected
        isHotSpotSelected = btnHotspot.isSelected
        isHandicapSelected = btnHandicap.isSelected
        arrForSelectedLanguages.removeAll()
        for language in arrForProviderLanguage
        {
            if language.isSelected
            {
                arrForSelectedLanguages.append(language)
            }
        }
        resetTripNearByProviderTimer()
        hideProviderFilter()
    }
    @IBAction func onClickBtnCancelFilter(_ sender: Any) {
        hideProviderFilter()
    }
    @IBAction func onClickBtnRideLater(_ sender: Any) {
        
        if paymentMode != PaymentMode.UNKNOWN
        {
            openFixedPriceDialog(futureTrip: true)
        }
        else
        {
            openPaymentDialog()
        }
    }
    func showProviderFilter()
    {
        if scrFilterView.contentSize.height > (UIScreen.main.bounds.height - 100)
        {
            heightForFilter.constant = (UIScreen.main.bounds.height - 100)
        }
        else
        {
            heightForFilter.constant = (scrFilterView.contentSize.height + 40)

        }
        viewForProviderFilter.isHidden = false
    }
    func hideProviderFilter()
    {
        viewForProviderFilter.isHidden = true
    }
    @IBAction func onClickBtnScheduleTripTime(_ sender: Any) {
        openFutureRequestDate()
    }
    
    @IBAction func onClickBtnCorporatePay(_ sender: Any) {
        btnCorporatePay.isSelected.toggle()
    }
    @IBAction func onClickBtnPromotionAppView(_ sender: Any) {
        let pullUpController: AppPromotionVC = UIStoryboard(name: "Map",bundle: nil).instantiateViewController(withIdentifier: "AppPromotionVC") as! AppPromotionVC
        self.present(pullUpController, animated: true) {
            
        }
    }
    
    func createRentTrip()
    {
        if paymentMode != PaymentMode.UNKNOWN
        {
            self.wsCreateRentRequest()
        }
        else
        {
            openPaymentDialog()
        }
    }
    @IBAction func onClickBtnRideNow(_ sender: Any)
    {
        
        if paymentMode != PaymentMode.UNKNOWN
        {
            checkSurgeTime(startHour: CurrentTrip.shared.selectedVehicle.surgeStartHour.toString(), endHour: CurrentTrip.shared.selectedVehicle.surgeEndHour.toString(), serverTime: CurrentTrip.shared.serverTime)
            if CurrentTrip.shared.isSurgeHour
            {
                let dialogForSurgePrice = CustomSurgePriceDialog.showCustomSurgePriceDialog(title: "TXT_SURGE_PRICE".localized, message: "TXT_SURGE_PRICE_MESSAGE".localized, surgePrice: CurrentTrip.shared.selectedVehicle.surgeMultiplier.toString() + "x", titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_CONFIRM".localized)
                dialogForSurgePrice.onClickLeftButton = { [/*unowned self, */unowned dialogForSurgePrice] in
                    dialogForSurgePrice.removeFromSuperview()
                }
                dialogForSurgePrice.onClickRightButton = { [unowned self, unowned dialogForSurgePrice] in
                    dialogForSurgePrice.removeFromSuperview()
                    
                    self.openFixedPriceDialog()
                }
            }
            else
            {
                openFixedPriceDialog()
            }
            

        }
        else
        {
            openPaymentDialog()
        }
        
        
    }
    
    //MARK:
    //MARK: User Define Methods
    func openDriverDetailDialog()  {
        let name = CurrentTrip.shared.tripStaus.trip.providerFirstName + " " +   CurrentTrip.shared.tripStaus.trip.providerLastName
        
        if dialogFromDriverDetail == nil
        {
            dialogFromDriverDetail = CustomDriverDetailDialog.showCustomDriverDetailDialog(name: name, imageUrl: CurrentTrip.shared.providerPicture,rate: CurrentTrip.shared.tripStaus.trip.providerRate , message: "TXT_CONNECTING_NEAR_BY_DRIVER".localized, cancelButton: "TXT_CANCEL_TRIP".localized)
            self.dialogFromDriverDetail?.onClickCancelTrip = { 
                [unowned self, weak dialogFromDriverDetail = self.dialogFromDriverDetail] in
                self.wsCancelTrip()
                printE(dialogFromDriverDetail!)
            }
        }
    }

    func checkForAvailableService()
    {
        if CurrentTrip.shared.pickupCoordinate.latitude != 0.0 && CurrentTrip.shared.pickupCoordinate.longitude != 0.0
        {
            self.locationManager?.fetchCityAndCountry(location: CLLocation.init(latitude: CurrentTrip.shared.pickupCoordinate.latitude, longitude: CurrentTrip.shared.pickupCoordinate.longitude))
            { [weak self] (city, country, error) in
                if error != nil
                {
                    Utility.hideLoading()
                    Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
                }
                else
                {
                    CurrentTrip.shared.pickupCity = city ?? ""
                    CurrentTrip.shared.pickupCountry = country ?? ""
                    self?.wsGetAvailableVehicleTypes()
                    if !(self?.arrFinalForVehicles.isEmpty ?? true) && (self?.isShowActiveView ?? false)
                    {
                        self?.resetTripNearByProviderTimer()
                    }
                }
            }
        }
        else
        {
            Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
        }
    }

    func idealView()
    {
        hideProviderFilter()
        viewForNoServiceAvailable.isHidden = true
        hideBottomView()
        
        viewForAddresses.isHidden = true
        btnBack.isHidden = true
        btnFilter.isHidden = true
        viewForWhereToGo.isHidden = false
        btnMyLocation.isHidden = false
        btnMenu.isHidden = false
        pickupMarker.map = nil
        pickupMarker.snippet = "Source Location"
        
        destinationMarker.map = nil
        mapView.clear()
        self.polyLinePath.map = nil
        self.mapView.padding = UIEdgeInsets.init(top: viewForWhereToGo.frame.maxY, left: 20, bottom: 20, right: 20)
        currentMarker.map = mapView
        
        updateAddressUI()
        
        CurrentTrip.shared.clearDestinationAddress()
        isShowActiveView = false
        btnRideLater.isHidden = true
        lblFareEstimate.text = "TXT_FARE_ESTIMATE".localized
        isShowActiveView = false
        
        
        self.resetTripNearByProviderTimer()
        if self.locationManager != nil
        {
            if self.locationManager!.requestUserLocation()
            {
                
                self.animateToCurrentLocation()
            }
        }
    }
    
    func isMarkerWithinScreen(marker: GMSMarker) -> Bool {
        let region = self.mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: region)
        return bounds.contains(marker.position)
    }
    
    func activeView()
    {
        self.showPromotionView(show: false)
        bottomView.isHidden = true
        
        stkFavouriteAddress.isHidden = true
        //collectionViewForServices.reloadData()
        self.mapView.padding = UIEdgeInsets.init(top: viewForAddresses.frame.maxY, left: 20, bottom: viewForAvailableService.frame.height, right: 20)
        if self.arrFinalForVehicles.isEmpty
        {
            viewForNoServiceAvailable.isHidden = false
            viewForAvailableService.isHidden = true
            
        }
        else
        {
            viewForNoServiceAvailable.isHidden = true
            showBottomView()
            showPathFrom(source: CurrentTrip.shared.pickupCoordinate, toDestination: CurrentTrip.shared.destinationCoordinate)
        }
        viewForAddresses.isHidden = false
        btnBack.isHidden = false
        btnFilter.isHidden = false
        viewForWhereToGo.isHidden = true
        btnMyLocation.isHidden = true
        btnMenu.isHidden = true
        btnAddAddress.isHidden = true
        self.setMarkers()
        Utility.hideLoading()
    }
    func setMarkers()
    {
        currentMarker.map = nil
        if !CurrentTrip.shared.pickupAddress.isEmpty
        {
            pickupMarker.position =  CurrentTrip.shared.pickupCoordinate
            pickupMarker.icon = UIImage.init(named: "asset-pin-pickup-location")
            pickupMarker.map = mapView
        }
        if !CurrentTrip.shared.destinationtAddress.isEmpty
        {

            destinationMarker.position =  CurrentTrip.shared.destinationCoordinate
            destinationMarker.icon = UIImage.init(named: "asset-pin-destination-location")
            destinationMarker.map = mapView
        }
    }
    
    func updateAddressUI()
    {
        let addressData:UserAddress = CurrentTrip.shared.favouriteAddress
        
        if addressData.workAddress.isEmpty() && addressData.homeAddress.isEmpty()
        {
            btnHomeAddress.isHidden = true
            btnWorkAddress.isHidden = true
            btnAddAddress.isHidden = false
        }
        else if !addressData.workAddress.isEmpty() && !addressData.homeAddress.isEmpty()
        {
            btnHomeAddress.isHidden = false
            btnWorkAddress.isHidden = false
            btnAddAddress.isHidden = true
        }
        else if !addressData.workAddress.isEmpty() && addressData.homeAddress.isEmpty()
        {
            btnHomeAddress.isHidden = true
            btnWorkAddress.isHidden = false
            btnAddAddress.isHidden = false
        }
        else if addressData.workAddress.isEmpty() && !addressData.homeAddress.isEmpty()
        {
            btnHomeAddress.isHidden = false
            btnWorkAddress.isHidden = true
            btnAddAddress.isHidden = false
        }
        else
        {
            btnHomeAddress.isHidden = true
            btnWorkAddress.isHidden = true
            btnAddAddress.isHidden = true
        }
        
    }
    
    
    
    func checkSurgeTime(startHour:String,endHour:String,serverTime:String)
    {
        
        let currentDate:Date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = DateFormat.WEB
        
        let tempDateFormatter = DateFormatter.init()
        tempDateFormatter.dateFormat = DateFormat.WEB
        tempDateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        let serverDateTime = tempDateFormatter.date(from: serverTime)
        tempDateFormatter.timeZone = TimeZone.init(identifier: CurrentTrip.shared.timeZone)
        let tempStrDate = tempDateFormatter.string(from: serverDateTime!)
        let tempDate = tempDateFormatter.date(from: tempStrDate)
        let cal:Calendar = Calendar.current
        
        
        let serverHour:Int = cal.component(Calendar.Component.hour, from: tempDate!)
        let serverMinut:Int = cal.component(Calendar.Component.minute, from: tempDate!)
        
        var isSurge:Bool = false
        
        for surgeHours in CurrentTrip.shared.selectedVehicle.surgeHours
        {
            if surgeHours.day == serverDateTime?.dayNumberOfWeek().toString()
            {
                for dayTime in surgeHours.dayTime
                {
                    
                    var startHour = 0;
                    var startMinut = 0;
                    var endHour = 0;
                    var endMinut = 0;
                    
                    if dayTime.startTime.contains(":")
                    {
                        let time = dayTime.startTime.components(separatedBy: ":")
                        startHour = time[0].toInt()
                        startMinut = time[1].toInt()
                    }
                    if dayTime.endTime.contains(":")
                    {
                        let time = dayTime.endTime.components(separatedBy: ":")
                        endHour = time[0].toInt()
                        endMinut = time[1].toInt()
                    }
                    let surgeStartDate:Date = Calendar.current.date(bySettingHour: startHour, minute: startMinut, second: 0, of: currentDate)!
                    
                    let surgeEndDate:Date = Calendar.current.date(bySettingHour: endHour, minute: endMinut, second: 0, of: currentDate)!
                    
                    let currentTime:Date = Calendar.current.date(bySettingHour: serverHour, minute: serverMinut, second: 0, of: currentDate)!
                    
                    if ((surgeStartDate <= currentTime) &&
                        (surgeEndDate >= currentTime) &&
                        (CurrentTrip.shared.selectedVehicle.isSurgeHours == TRUE))
                    {


                        CurrentTrip.shared.selectedVehicle.surgeMultiplier = dayTime.multiplier.toDouble()
                        isSurge = true
                        break;
                    }
                    else
                    {
                        isSurge = false
                    }
                }
            }
            
        }
        
        if (isSurge)
        {
            
            CurrentTrip.shared.selectedVehicle.surgeMultiplier = CurrentTrip.shared.selectedVehicle.richAreaSurgeMultiplier >  CurrentTrip.shared.selectedVehicle.surgeMultiplier ? CurrentTrip.shared.selectedVehicle.richAreaSurgeMultiplier :CurrentTrip.shared.selectedVehicle.surgeMultiplier
            
            CurrentTrip.shared.isSurgeHour =  (CurrentTrip.shared.selectedVehicle.surgeMultiplier != 1.0 && CurrentTrip.shared.selectedVehicle.surgeMultiplier > 0.0)
            
        }
        else if (CurrentTrip.shared.selectedVehicle.richAreaSurgeMultiplier != 1.0 && CurrentTrip.shared.selectedVehicle.richAreaSurgeMultiplier > 0.0)
        {
            
            CurrentTrip.shared.selectedVehicle.surgeMultiplier =   CurrentTrip.shared.selectedVehicle.richAreaSurgeMultiplier
            CurrentTrip.shared.isSurgeHour = true
        }
        else
        {
            CurrentTrip.shared.isSurgeHour = false
        }
        if (CurrentTrip.shared.tripType == TripType.ZONE || CurrentTrip.shared.tripType == TripType.AIRPORT || CurrentTrip.shared.tripType == TripType.CITY)
        {
            CurrentTrip.shared.isSurgeHour = false
        }
        

    }
    
    func checkSurgeTimeForFutureRequest(startHour:String,endHour:String,serverTime:String,bookHours:Int,bookMin:Int,bookDay:Int) -> Bool
    {
        
        let currentDate:Date = Calendar.current.date(bySetting: .day, value: bookDay, of: Date()) ?? Date()
        let futureTime:Date = Calendar.current.date( bySettingHour: bookHours, minute: bookMin, second: 0, of: currentDate)!

        var isSurge:Bool = false


        for surgeHours in CurrentTrip.shared.selectedVehicle.surgeHours
        {
            if surgeHours.day == futureTime.dayNumberOfWeek().toString()
            {
                for dayTime in surgeHours.dayTime
                {
                    
                    
                    var startHour = 0;
                    var startMinut = 0;
                    var endHour = 0;
                    var endMinut = 0;
                    
                    if dayTime.startTime.contains(":")
                    {
                        let time = dayTime.startTime.components(separatedBy: ":")
                        startHour = time[0].toInt()
                        startMinut = time[1].toInt()
                    }
                    if dayTime.endTime.contains(":")
                    {
                        let time = dayTime.endTime.components(separatedBy: ":")
                        endHour = time[0].toInt()
                        endMinut = time[1].toInt()
                    }
                    let surgeStartDate:Date = Calendar.current.date(bySettingHour: startHour, minute: startMinut, second: 0, of: currentDate)!
                    
                    let surgeEndDate:Date = Calendar.current.date(bySettingHour: endHour, minute: endMinut, second: 0, of: currentDate)!
                    
                    if ((surgeStartDate <= futureTime) &&
                        (surgeEndDate >= futureTime) &&
                        (CurrentTrip.shared.selectedVehicle.isSurgeHours == TRUE))
                    {
                        
                        
                        CurrentTrip.shared.selectedVehicle.surgeMultiplier = dayTime.multiplier.toDouble()
                        isSurge = true
                        break;
                    }
                    else
                    {
                        isSurge = false
                    }
                }
            }
            
        }
        
        if (isSurge)
        {
            
            CurrentTrip.shared.selectedVehicle.surgeMultiplier = CurrentTrip.shared.selectedVehicle.richAreaSurgeMultiplier >  CurrentTrip.shared.selectedVehicle.surgeMultiplier ? CurrentTrip.shared.selectedVehicle.richAreaSurgeMultiplier :CurrentTrip.shared.selectedVehicle.surgeMultiplier
            
            CurrentTrip.shared.isSurgeHour =  (CurrentTrip.shared.selectedVehicle.surgeMultiplier != 1.0 && CurrentTrip.shared.selectedVehicle.surgeMultiplier > 0.0)
            
        }
        else if (CurrentTrip.shared.selectedVehicle.richAreaSurgeMultiplier != 1.0 && CurrentTrip.shared.selectedVehicle.richAreaSurgeMultiplier > 0.0)
        {
            
            CurrentTrip.shared.selectedVehicle.surgeMultiplier =   CurrentTrip.shared.selectedVehicle.richAreaSurgeMultiplier
            CurrentTrip.shared.isSurgeHour = true
        }
        else
        {
            CurrentTrip.shared.isSurgeHour = false
        }
        
        if (CurrentTrip.shared.tripType == TripType.ZONE || CurrentTrip.shared.tripType == TripType.AIRPORT || CurrentTrip.shared.tripType == TripType.CITY)
        {
            CurrentTrip.shared.isSurgeHour = false
        }
        return CurrentTrip.shared.isSurgeHour
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        
    }
    func resetTripNearByProviderTimer()
    {
        Utility.hideLoading()
        self.stopTripNearByProviderTimer()
        self.wsGetNearByProvider()
        CurrentTrip.timerForNearByProvider =  Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(self.wsGetNearByProvider), userInfo: nil, repeats: true)
    }
    func stopTripNearByProviderTimer()
    {
        CurrentTrip.timerForNearByProvider?.invalidate()
    }
    func startTripStatusTimer()
    {
        
        if CurrentTrip.timeForTripStatus == nil
        {
            wsGetTripStatus()
            CurrentTrip.timeForTripStatus?.invalidate()
            CurrentTrip.timeForTripStatus =    Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(wsGetTripStatus), userInfo: nil, repeats: true)
        }
    }
    func stopTripStatusTimer()
    {
        CurrentTrip.timeForTripStatus?.invalidate()
        CurrentTrip.timeForTripStatus = nil
    }
    
    func setProviderMarker(arrProvider:[Provider])
    {
        
        
        arrayForProviderMarker.removeAll()
        for provider in arrProvider
        {
            if provider.providerLocation.count > 1
            {
                if provider.providerLocation[0] != 0.0 && provider.providerLocation[1] != 0.0
                {
                    let marker:GMSMarker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: provider.providerLocation[0], longitude: provider.providerLocation[1]))
                    
                    
                    
                    //marker.icon = UIImage.init(named: "asset-driver-pin-placeholder")
                    marker.groundAnchor = CGPoint.init(x: 0.5, y: 0.5)
                    if !isShowActiveView
                    {
                        self.driverMarkerImage = UIImage.init(named: "asset-driver-pin-placeholder")
                    }
                    
                    if let image = self.driverMarkerImage
                    {
                        
                        DispatchQueue.main.async {
                            marker.icon = image
                            self.driverMarkerImage = image
                            marker.rotation = provider.bearing;
                            marker.snippet = provider.firstName + provider.lastName
                            marker.map = self.mapView;
                            marker.accessibilityLabel = provider.id
                        }
                        

                    }
                    else
                    {
                        
                        let url =  CurrentTrip.shared.selectedVehicle.typeDetails.mapPinImageUrl
                        
                        Utility.downloadImageFrom(link: url!, completion: { (image) in
                            marker.icon = image
                            self.driverMarkerImage = image
                            marker.rotation = provider.bearing;
                            marker.snippet = provider.firstName + provider.lastName
                            marker.map = self.mapView;
                            marker.accessibilityLabel = provider.id

                        })
                    }
                    self.arrayForProviderMarker.append(marker)
                    self.registerProviderSocket(id: provider.id)
                    
                }
                
            }
        }
    }
}
//MARK: Dialogs
extension MapVC
{
    func openFutureRequestDate()
    {
        let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_TO_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
        
        datePickerDialog.setDatePickerForFutureTrip()
        
        datePickerDialog.onClickLeftButton = {
            datePickerDialog.removeFromSuperview()
        }
        
        datePickerDialog.onClickRightButton = { selectedDate in
                
                let selectedTime = datePickerDialog.getFutureTripBookingDate()
                self.strFutureTripSelectedDate = datePickerDialog.timeInterval(date: selectedDate).toString()
                
                
                let calender = Calendar.current
                let dateComponents:DateComponents = calender.dateComponents([.hour,.minute,.day], from: selectedDate)
                
                let hour = dateComponents.hour ?? 0
                let minut = dateComponents.minute ?? 0
                let day = dateComponents.day ?? 0

                if self.checkSurgeTimeForFutureRequest(startHour: CurrentTrip.shared.selectedVehicle.surgeStartHour.toString(), endHour: CurrentTrip.shared.selectedVehicle.surgeEndHour.toString(), serverTime: CurrentTrip.shared.serverTime, bookHours: hour, bookMin: minut, bookDay:day)
                {
                    let dialogForSurgePrice = CustomSurgePriceDialog.showCustomSurgePriceDialog(title: "TXT_SURGE_PRICE".localized, message: "TXT_SURGE_PRICE_MESSAGE".localized, surgePrice: CurrentTrip.shared.selectedVehicle.surgeMultiplier.toString() + "x", titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_CONFIRM".localized)
                    dialogForSurgePrice.onClickLeftButton = {

                        dialogForSurgePrice.removeFromSuperview()
                    }
                    dialogForSurgePrice.onClickRightButton = {

                        self.btnRideLater.setTitle("TXT_SCHEDULE_TRIP".localized + "\n \(selectedTime)", for: .normal)
                        self.btnRideLater.isHidden = false
                        dialogForSurgePrice.removeFromSuperview()
                        
                    }
                    
                }
                else
                {
                    
                    self.btnRideLater.setTitle("TXT_SCHEDULE_TRIP".localized + "\n \(selectedTime)", for: .normal)
                    self.btnRideLater.isHidden = false
                }
                datePickerDialog.removeFromSuperview()
        }
    }
    func openFareEstimateDialog()
    {
        _ = FareEstimateDialog.showFareEstimateDialog()
    }
    func openPaymentDialog()
    {
        let dialogForPayment = CustomPaymentSelectionDialog.showCustomPaymentSelectionDialog()
        dialogForPayment.onClickCardButton = { [unowned self/*, unowned dialogForPayment*/] in
            self.paymentMode = PaymentMode.CARD
            self.updatePaymentUI()
            self.updatePromoView()
        }
        dialogForPayment.onClickCashButton = { [unowned self/*, unowned dialogForPayment*/] in
            self.paymentMode = PaymentMode.CASH
            self.updatePromoView()
            self.updatePaymentUI()
        }
    }
    
    func openCorporateRequestDialog()
    {
        let dialogForCorporateRequest = CustomCorporateRequestDialog.showCustomCorporateRequestDialog(title: "TXT_CORPORATE_REQUEST".localized, message: "TXT_CORPORATE_REQUEST_MESSAGE".localized, titleLeftButton: "TXT_NO".localized, titleRightButton: "TXT_YES".localized)
        dialogForCorporateRequest.onClickLeftButton = { 
            [unowned self, unowned dialogForCorporateRequest] in
            dialogForCorporateRequest.removeFromSuperview()
            self.wsAcceptRejectCorporateRequest(accept: false)
        }
        dialogForCorporateRequest.onClickRightButton = { 
            [unowned self, unowned dialogForCorporateRequest] in
            dialogForCorporateRequest.removeFromSuperview()
            self.wsAcceptRejectCorporateRequest(accept: true)
        }
    }
    func openFixedPriceDialog(futureTrip:Bool = false)
    {
        
        if CurrentTrip.shared.isAskUserForFixedFare
        {

            let dialogForFixedTrip = CustomAlertDialog.showCustomAlertDialog(title: "TXT_FIXED_RATE_AVAILABLE".localized, message: "MSG_FIXED_RATE_DIALOG".localized, titleLeftButton: "TXT_NO".localized, titleRightButton: "TXT_YES".localized)
            dialogForFixedTrip.onClickLeftButton =
                { [unowned self, unowned dialogForFixedTrip] in

                    dialogForFixedTrip.removeFromSuperview();

                    if futureTrip
                    {
                        CurrentTrip.shared.isFixedFareTrip = false
                        self.wsCreateFutureRequest()
                    }
                    else
                    {
                        CurrentTrip.shared.isFixedFareTrip = false
                        self.wsCreateRequest()
                    }
                    return;
            }
            dialogForFixedTrip.onClickRightButton =
                { [unowned self, unowned dialogForFixedTrip] in
                    dialogForFixedTrip.removeFromSuperview();

                    if CurrentTrip.shared.destinationtAddress.isEmpty()
                    {
                        Utility.showToast(message: "VALIDATION_MSG_SELECT_DESTINATION_ADDRESS_FIRST".localized)
                    }
                    else
                    {
                        if futureTrip
                        {
                            CurrentTrip.shared.isFixedFareTrip = true
                            self.wsCreateFutureRequest()
                        }
                        else
                        {
                            CurrentTrip.shared.isFixedFareTrip = true
                            self.wsCreateRequest()
                        }
                    }

            }
        }
        else
        {
            if futureTrip
            {
                CurrentTrip.shared.isFixedFareTrip = false
                self.wsCreateFutureRequest()
            }
            else
            {
                CurrentTrip.shared.isFixedFareTrip = false
                self.wsCreateRequest()
            }
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

    func wsApplyPromo(promo:String,dialog:CustomVerificationDialog)
    {
        if !promo.isEmpty()
        {
            Utility.showLoading()
            var  dictParam : [String : Any] = [:]
            dictParam[PARAMS.PROMO_CODE] = promo
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN ] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.CITY_ID] = arrFinalForVehicles[selectedIndex].cityid
            dictParam[PARAMS.COUNTRY_ID] = arrFinalForVehicles[selectedIndex].countryid
            dictParam[PARAMS.PAYMENT_MODE] = self.paymentMode
            
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.APPLY_PROMO_CODE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
                [unowned self, unowned dialog] (response, error) -> (Void) in
                if (error != nil)
                {
                    Utility.hideLoading()
                    self.promoId = ""
                    
                }
                else
                {
                    if Parser.isSuccess(response: response)
                    {
                        Utility.hideLoading()
                        let promoResponseModel = PromoResponseModel.init(fromDictionary: response)
                        self.promoId = promoResponseModel.promo_id
                        dialog.removeFromSuperview()
                    }
                }
                self.updatePromoView()
            }
        }
    }
    
    func updatePaymentUI() {
        if paymentMode == PaymentMode.CARD {
            lblPayment.text = "TXT_CARD".localized
            //imgPayment.image = UIImage.init(named: "asset-card")
            self.lblPaymentIcon.text = FontAsset.icon_payment_card
            
            
        }
        else if paymentMode == PaymentMode.CASH {
            lblPayment.text = "TXT_CASH".localized
            //imgPayment.image = UIImage.init(named: "asset-cash")
            self.lblPaymentIcon.text = FontAsset.icon_payment_cash

        }
        else {
            lblPayment.text = "TXT_ADD_PAYMENT".localized

        }

        
    }
    
    func updatePromoView()
    {
        if promoId.isEmpty
        {
            btnPromoCode.isUserInteractionEnabled = true
            btnPromoCode.setTitle("TXT_HAVE_PROMO_CODE".localizedCapitalized, for: .normal)
            self.promoId = ""
        }
        else
        {
            if (self.paymentMode == PaymentMode.CASH && CurrentTrip.shared.isPromoApplyForCash == TRUE) || (self.paymentMode == PaymentMode.CARD && CurrentTrip.shared.isPromoApplyForCard == TRUE)
            {
                btnPromoCode.isUserInteractionEnabled = true
                btnPromoCode.setTitle("TXT_PROMO_APPLIED".localizedCapitalized, for: .normal)
            }
            else
            {
                btnPromoCode.isUserInteractionEnabled = true
                btnPromoCode.setTitle("TXT_HAVE_PROMO_CODE".localizedCapitalized, for: .normal)
                self.promoId = ""
            }
        }
    }
    
    func openAdminApproveDialog()
    {
        let dialogForAdminApprove = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ADMIN_ALERT".localized, message: "MSG_APPROVE_ERROR".localized, titleLeftButton: "TXT_LOGOUT".localized, titleRightButton: "TXT_EMAIL".localized)
        dialogForAdminApprove.onClickLeftButton =
            { [/*unowned self,*/ unowned dialogForAdminApprove] in
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                dialogForAdminApprove.removeFromSuperview();
                APPDELEGATE.gotoLogin()
                return;
        }
        dialogForAdminApprove.onClickRightButton =
            { [/*unowned self,*/ unowned dialogForAdminApprove] in
                
                let email = preferenceHelper.getContactEmail()
                if let url = URL(string: "mailto://\(email)"), UIApplication.shared.canOpenURL(url)
                {
                    if #available(iOS 10, *) {
                        dialogForAdminApprove.removeFromSuperview();
                        UIApplication.shared.open(url)
                    } else {
                        dialogForAdminApprove.removeFromSuperview();
                        UIApplication.shared.openURL(url)
                    }
                }
        }
    }
}
//MARK: RevealViewController Delegate Methods
extension MapVC:PBRevealViewControllerDelegate
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
//MARK: CollectionView Delegate Methods
extension MapVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func setCollectionView()
    {
        let nibName = UINib(nibName: "ServiceTypeCollectionViewCell", bundle:nil)
        collectionViewForServices.register(nibName, forCellWithReuseIdentifier: "cell")
        collectionViewForServices.dataSource = self
        collectionViewForServices.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if selectedIndex == indexPath.row {
            return
        }
        
        selectedIndex = indexPath.row
        driverMarkerImage = nil

        self.previousProviderId = ""
        CurrentTrip.shared.selectedVehicle = arrFinalForVehicles[indexPath.row]
        self.collectionViewForServices.reloadData()
        self.resetTripNearByProviderTimer()
        self.wsGetFareEstimate()
        if btnRental.isSelected
        {
            lblRentalPackSize.text = CurrentTrip.shared.selectedVehicle.carRentalList.count.toString()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ServiceTypeCollectionViewCell
        
        cell.lblServiceTypeName.text = arrFinalForVehicles[indexPath.row].typeDetails.typename
        cell.imgServiceType.downloadedFrom(link: arrFinalForVehicles[indexPath.row].typeDetails.typeImageUrl, placeHolder: "asset-driver-pin-placeholder", isFromCache: true, isIndicator: true, mode: .scaleAspectFit, isAppendBaseUrl: true)
        
        if indexPath.row == selectedIndex
        {
            cell.selectorView.backgroundColor = UIColor.themeSelectionColor
            cell.lblServiceTypeName.textColor = UIColor.themeTextColor
        }
        else
        {
            cell.selectorView.backgroundColor = UIColor.clear
            cell.lblServiceTypeName.textColor = UIColor.themeLightTextColor
        }
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFinalForVehicles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if arrFinalForVehicles.count <= 3
        {
            let totalCellWidth = (collectionView.frame.width/3) * CGFloat(collectionView.numberOfItems(inSection: 0))
            let edgeInsets = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth)) / 2
            return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
//MARK:- Table View Delegate Methods
extension MapVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForProviderLanguage.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProviderLanguageCell
        cell.setCellData(data: arrForProviderLanguage[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        arrForProviderLanguage[indexPath.row].isSelected = !arrForProviderLanguage[indexPath.row].isSelected
        tblProviderLanguage.reloadData()
    }
    
}
//MARK:- Web Service Calls
extension MapVC
{
    func wsGetLanguage()
    {
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_LANGUAGE_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            
            if (error != nil)
            {
                
            }
            else
            {
                if Parser.isSuccess(response: response,withSuccessToast: false,andErrorToast: false)
                {
                    self.arrForProviderLanguage.removeAll()
                    let languageResponse:LanguageResponse = LanguageResponse.init(fromDictionary: response)
                    let languages = languageResponse.languages!
                    for language in languages
                    {
                        self.arrForProviderLanguage.append(language)
                    }
                }
            }
            
        }
    }
    
    
    
    func wsGetAddress()
    {

        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_FAVOURITE_ADDRESS_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            
            if (error != nil)
            {
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    let userDataResponse:UserAddressResponse = UserAddressResponse.init(fromDictionary: response)
                    CurrentTrip.shared.favouriteAddress = userDataResponse.userAddress
                    self.updateAddressUI()
                }

            }
            
        }
    }
    func wsGetAvailableVehicleTypes()
    {
        
        Utility.showLoading()
        self.previousCity = CurrentTrip.shared.pickupCity
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.COUNTRY]  = CurrentTrip.shared.pickupCountry
        dictParam[PARAMS.CITY]  = CurrentTrip.shared.pickupCity
        dictParam[PARAMS.LATITUDE] = CurrentTrip.shared.pickupCoordinate.latitude.toString(places: 6)
        dictParam[PARAMS.LONGITUDE] = CurrentTrip.shared.pickupCoordinate.longitude.toString(places: 6)
        dictParam[PARAMS.COUNTRY_CODE] = CurrentTrip.shared.currentCountryCode
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_AVAILABLE_VEHICLE_TYPES, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { /*[unowned self]*/ (response, error) -> (Void) in
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                
                self.arrFinalForVehicles.removeAll()
                if Parser.isSuccess(response: response)
                {
                    let vehicleListResponse:VehicleListResponse = VehicleListResponse.init(fromDictionary: response)
                    if vehicleListResponse.isCorporateRequest
                    {
                        self.btnCorporatePay.isHidden = false
                    }
                    else
                    {
                        self.btnCorporatePay.isHidden = true
                    }
                    CurrentTrip.shared.serverTime = vehicleListResponse.serverTime
                    CurrentTrip.shared.timeZone = vehicleListResponse.cityDetail.timezone
                    CurrentTrip.shared.isCardModeAvailable =  vehicleListResponse.cityDetail.isPaymentModeCard
                    CurrentTrip.shared.isCashModeAvailable =  vehicleListResponse.cityDetail.isPaymentModeCash
                    CurrentTrip.shared.isPromoApplyForCash =  vehicleListResponse.cityDetail.isPromoApplyForCash
                    CurrentTrip.shared.isPromoApplyForCard =  vehicleListResponse.cityDetail.isPromoApplyForCard
                    
                    
                    CurrentTrip.shared.currencyCode = vehicleListResponse.currencyCode
                    CurrentTrip.shared.distanceUnit = Utility.getDistanceUnit(unit: vehicleListResponse.cityDetail.unit)
                    
                    CurrentTrip.shared.isAskUserForFixedFare = vehicleListResponse.cityDetail.isAskUserForFixedFare
                    
                    
                    
                    if CurrentTrip.shared.isCashModeAvailable == FALSE || CurrentTrip.shared.isCardModeAvailable == FALSE
                    {
                        self.paymentMode = (CurrentTrip.shared.isCashModeAvailable == TRUE) ? PaymentMode.CASH : PaymentMode.CARD
                    }
                    else
                    {
                        self.paymentMode =  PaymentMode.CASH
                    }
                    
                    self.updatePaymentUI()
                    self.arrRentalForVehicles.removeAll()
                    self.arrNormalForVehicles.removeAll()
                    self.arrFinalForVehicles.removeAll()
                    for vehicle in vehicleListResponse.citytypes
                    {

                        self.arrNormalForVehicles.append(vehicle)
                        
                        if vehicle.isRentalType
                        {
                            self.arrRentalForVehicles.append(vehicle)
                        }
                        
                    }
                    self.btnRental.isHidden = self.arrRentalForVehicles.isEmpty
                    
                    self.btnRegular(self.btnRegular!)
                    if self.btnRental.isSelected
                    {
                        self.fillVehicleArrayWith(array: self.arrRentalForVehicles)
                    }
                    else
                    {
                        self.fillVehicleArrayWith(array: self.arrNormalForVehicles)
                    }
                    if !self.arrFinalForVehicles.isEmpty
                    {
                        if self.isShowActiveView
                        {
                            self.activeView()
                        }
                    }
                    else
                    {
                        if self.isShowActiveView
                        {
                            self.activeView()
                        }
                    }
                }
                else
                {
                    let isSuccess:ResponseModel = ResponseModel.init(fromDictionary: response)
                    let errorCode:String = "ERROR_CODE_" + String(isSuccess.errorCode )
                    self.lblNoServiceAvailable.text = errorCode.localized
                    if String(isSuccess.errorCode) == "1002" || String(isSuccess.errorCode ) == "1003"
                    {
                        self.activeView()
                    }
                    else if self.isShowActiveView
                    {
                        self.activeView()
                    }
                }
            }
        }
    }
    func wsGetFareEstimate()
    {
        
        if !CurrentTrip.shared.selectedVehicle.id.isEmpty() && !CurrentTrip.shared.pickupAddress.isEmpty() && !CurrentTrip.shared.destinationtAddress.isEmpty()
        {
            
            
            var  dictParam : [String : Any] = [:]
            
            

            
            self.checkSurgeTime(startHour: CurrentTrip.shared.selectedVehicle.surgeStartHour.toString(), endHour: CurrentTrip.shared.selectedVehicle.surgeEndHour.toString(), serverTime: CurrentTrip.shared.serverTime)
            
            
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.TIME] = (timeAndDistance.time.toInt() ?? 0).toString()
            dictParam[PARAMS.DISTANCE] = timeAndDistance.distance
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.SERVICE_TYPE_ID] = CurrentTrip.shared.selectedVehicle.id
            dictParam[PARAMS.SURGE_MULTIPLIER] = CurrentTrip.shared.selectedVehicle.surgeMultiplier
            
            dictParam[PARAMS.DESTINATION_LATITUDE] = CurrentTrip.shared.destinationCoordinate.latitude.toString(places: 6)
            dictParam[PARAMS.DESTINATION_LONGITUDE] = CurrentTrip.shared.destinationCoordinate.longitude.toString(places: 6)
            dictParam[PARAMS.PICKUP_LATITUDE] = CurrentTrip.shared.pickupCoordinate.latitude.toString(places: 6)
            dictParam[PARAMS.PICKUP_LONGITUDE] = CurrentTrip.shared.pickupCoordinate.longitude.toString(places: 6)
            dictParam[PARAMS.IS_SURGE_HOURS] = CurrentTrip.shared.isSurgeHour ? TRUE : FALSE
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.GET_FARE_ESTIMATE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
                
                if (error != nil)
                {
                    
                }
                else
                {
                    if Parser.isSuccess(response: response)
                    {
                        let fareEstimateResponse:FareEstimateResponse = FareEstimateResponse.init(fromDictionary: response)
                        CurrentTrip.shared.estimateFareTotal = fareEstimateResponse.estimatedFare
                        CurrentTrip.shared.estimateFareTime =    fareEstimateResponse.time
                        self.lblFareEstimate.text =  CurrentTrip.shared.estimateFareTotal.toCurrencyString(currencyCode: CurrentTrip.shared.currencyCode)
                        CurrentTrip.shared.estimateFareDistance =    (Double(fareEstimateResponse.distance.replacingOccurrences(of: ".", with: "")) ?? 0.0) / 100
                        CurrentTrip.shared.tripType =  fareEstimateResponse.tripType.toInt()
                    }
                }
            }
        }
    }
    
    @objc func wsGetNearByProvider()
    {
        
        if isNearByProviderCalled
        {
            return
        }
        
        
        
        if preferenceHelper.getUserId().isEmpty
        {
            self.stopTripNearByProviderTimer()
        }
        else
        {
            self.isNearByProviderCalled = true
            var  dictParam : [String : Any] = [:]
            
            if isShowActiveView
            {
                
                var selectedAccessibility:[String] = []
                
                var selectedGender:[String] = []
                if btnMale.isSelected
                {
                    selectedGender.append(Gender.MALE)
                }
                if btnFemale.isSelected
                {
                    selectedGender.append(Gender.FEMALE)
                }
                if isHotSpotSelected
                {
                    selectedAccessibility.append(VehicleAccessibity.HOTSPOT)
                }
                if isBabySeatSelected
                {
                    selectedAccessibility.append(VehicleAccessibity.BABY_SEAT)
                }
                if isHandicapSelected
                {
                    selectedAccessibility.append(VehicleAccessibity.HANDICAP)
                }
                dictParam[PARAMS.SERVICE_TYPE_ID] = CurrentTrip.shared.selectedVehicle.id
                
                var arrForSelectedProviderLanguage :[String] = []
                for language in arrForSelectedLanguages
                {
                    arrForSelectedProviderLanguage.append(language.id)
                }
                dictParam[PARAMS.PROVIDER_LANGUAGE] = arrForSelectedProviderLanguage
                dictParam[PARAMS.VEHICLE_ACCESSIBILITY] = selectedAccessibility
                dictParam[PARAMS.PROVIDER_GENDER] = selectedGender
                
                if paymentMode != PaymentMode.UNKNOWN
                {
                    dictParam[PARAMS.PAYMENT_MODE] = paymentMode
                }
                else
                {
                    dictParam[PARAMS.PAYMENT_MODE] = PaymentMode.CASH
                }
                
            }
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()

            dictParam[PARAMS.LATITUDE] = CurrentTrip.shared.pickupCoordinate.latitude.toString(places: 6)
            dictParam[PARAMS.LONGITUDE] = CurrentTrip.shared.pickupCoordinate.longitude.toString(places: 6)

            
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.GET_NEAR_BY_PROVIDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in

                self.isNearByProviderCalled = false
                if (error != nil)
                {

                }
                else
                {
                    for marker in self.arrayForProviderMarker
                    {
                        marker.map = nil
                    }
                    //self.unRegisterProviderSocket()
                    self.arrayForProviderMarker.removeAll()

                    if Parser.isSuccess(response: response,withSuccessToast:false,andErrorToast: false)
                    {
                        let providerResponse:NearByProviderResponse = NearByProviderResponse.init(fromDictionary: response)


                        if self.isShowActiveView
                        {
                            self.activeView()

                        }
                        if providerResponse.providers.count > 0
                        {
                            self.btnRideNow.isEnabled = true
                            self.btnRideNow.alpha = 1.0
                            self.updateRideNowButton()


                            self.registerAllProviderSocket(providers: providerResponse.providers)


                            if self.previousProviderId != providerResponse.providers[0].id
                            {
                                self.previousProviderId = providerResponse.providers[0].id
                                if preferenceHelper.getIsShowEta() {

                                    let timeAndDistance = self.locationManager?.getTimeAndDistance(sourceCoordinate: CurrentTrip.shared.pickupCoordinate, destCoordinate: CLLocationCoordinate2D.init(latitude: providerResponse.providers[0].providerLocation[0], longitude:  providerResponse.providers[0].providerLocation[1]))

                                    let time = (timeAndDistance?.time.toInt() ?? 0)/60

                                    self.lblEta.text = "TXT_ETA".localized + " : " + time.toString() + MeasureUnit.MINUTES

                                }


                            }
                        }
                        else
                        {
                            self.lblEta.text = "TXT_ETA".localized + " : " + 0.toString() + MeasureUnit.MINUTES

                            self.previousProviderId = "";

                            self.updateRideNowButton()

                            self.btnRideNow.isEnabled = false
                            self.btnRideNow.alpha = 0.5
                        }
                         self.updateEtaUI()
                    }
                    else
                    {
                        self.previousProviderId = "";
                        self.lblEta.text = "TXT_ETA".localized + " : " + 0.toString() + MeasureUnit.MINUTES

                        self.btnRideNow.isEnabled = false
                        self.btnRideNow.alpha = 0.5
                        if self.isShowActiveView
                        {
                            self.activeView()
                        }
                    }
                }

            }
        }
    }

    
    func wsCreateRequest()
    {
        Utility.showLoading()
        var selectedAccessibility:[String] = []
        if isHotSpotSelected
        {
            selectedAccessibility.append(VehicleAccessibity.HOTSPOT)
        }
        if isBabySeatSelected
        {
            selectedAccessibility.append(VehicleAccessibity.BABY_SEAT)
        }
        if isHandicapSelected
        {
            selectedAccessibility.append(VehicleAccessibity.HANDICAP)
        }
        
        
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.SERVICE_TYPE_ID] = CurrentTrip.shared.selectedVehicle.id
        
        
        dictParam[PARAMS.LATITUDE] = CurrentTrip.shared.pickupCoordinate.latitude.toString(places: 6)
        dictParam[PARAMS.LONGITUDE] = CurrentTrip.shared.pickupCoordinate.longitude.toString(places: 6)
        dictParam[PARAMS.TRIP_PICKUP_ADDRESS] = CurrentTrip.shared.pickupAddress
        
        
        dictParam[PARAMS.TRIP_DESTINATION_LATITUDE] = CurrentTrip.shared.destinationCoordinate.latitude.toString(places: 6)
        dictParam[PARAMS.TRIP_DESTINATION_LONGITUDE] = CurrentTrip.shared.destinationCoordinate.longitude.toString(places: 6)
        dictParam[PARAMS.TRIP_DESTINATION_ADDRESS] = CurrentTrip.shared.destinationtAddress

        var languageArray: [String] = []
        for newLanguage in arrForSelectedLanguages {
            languageArray.append(newLanguage.id)
        }
        dictParam[PARAMS.PROVIDER_LANGUAGE] = languageArray
        dictParam[PARAMS.VEHICLE_ACCESSIBILITY] = selectedAccessibility
        
        
        dictParam[PARAMS.IS_SURGE_HOURS] = CurrentTrip.shared.isSurgeHour ? TRUE :FALSE
        dictParam[PARAMS.SURGE_MULTIPLIER] = CurrentTrip.shared.selectedVehicle.surgeMultiplier
        dictParam[PARAMS.IS_FIXED_FARE] = CurrentTrip.shared.isFixedFareTrip ? TRUE :FALSE
        dictParam[PARAMS.TIMEZONE] = CurrentTrip.shared.timeZone
        
        
        if CurrentTrip.shared.isFixedFareTrip
        {
            dictParam[PARAMS.FIXED_PRICE] = CurrentTrip.shared.estimateFareTotal
        }
        else
        {
            dictParam[PARAMS.FIXED_PRICE] = 0.0
        }
        
        if btnCorporatePay.isSelected && btnCorporatePay.isHidden == false
        {
            dictParam[PARAMS.TRIP_TYPE] = TripType.CORPORATE
            
        }
        
        dictParam[PARAMS.PROVIDER_GENDER] = []
        if paymentMode != PaymentMode.UNKNOWN
        {
            dictParam[PARAMS.PAYMENT_MODE] = paymentMode
        }
        else
        {
            dictParam[PARAMS.PAYMENT_MODE] = PaymentMode.CASH
        }
        print("TRip created")
        dictParam[PARAMS.PROMO_ID] = promoId
        Utility.hideLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.CREATE_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    let createTripResponse:CreateTripRespose = CreateTripRespose.init(fromDictionary: response)
                    
                    CurrentTrip.shared.tripId = createTripResponse.tripId
                    
                    self.wsGetTripStatus()
                    self.startTripStatusTimer()
                    self.stopTripNearByProviderTimer()
                    self.openDriverDetailDialog()
                }
                else
                {
                    
                    let responseModel:ResponseModel = ResponseModel.init(fromDictionary: response)
                    if responseModel.errorCode == TRIP_IS_ALREADY_RUNNING
                    {
                        self.wsGetTripStatus()
                    }
                    
                    
                    Utility.hideLoading()
                }
            }
            
        }
    }
    
    
    
    func wsCreateRentRequest()
    {
        Utility.showLoading()
        var selectedAccessibility:[String] = []
        if isHotSpotSelected
        {
            selectedAccessibility.append(VehicleAccessibity.HOTSPOT)
        }
        if isBabySeatSelected
        {
            selectedAccessibility.append(VehicleAccessibity.BABY_SEAT)
        }
        if isHandicapSelected
        {
            selectedAccessibility.append(VehicleAccessibity.HANDICAP)
        }
        
        
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.SERVICE_TYPE_ID] = CurrentTrip.shared.selectedVehicle.id
        dictParam[PARAMS.CAR_RENTAL_ID] = CurrentTrip.shared.selectedVehicle.selectedCarRentelId
        
        
        
        dictParam[PARAMS.LATITUDE] = CurrentTrip.shared.pickupCoordinate.latitude.toString(places: 6)
        dictParam[PARAMS.LONGITUDE] = CurrentTrip.shared.pickupCoordinate.longitude.toString(places: 6)
        dictParam[PARAMS.TRIP_PICKUP_ADDRESS] = CurrentTrip.shared.pickupAddress
        
        
        dictParam[PARAMS.TRIP_DESTINATION_LATITUDE] = CurrentTrip.shared.destinationCoordinate.latitude.toString(places: 6)
        dictParam[PARAMS.TRIP_DESTINATION_LONGITUDE] = CurrentTrip.shared.destinationCoordinate.longitude.toString(places: 6)
        dictParam[PARAMS.TRIP_DESTINATION_ADDRESS] = CurrentTrip.shared.destinationtAddress
        
        var languageArray: [String] = []
        for newLanguage in arrForSelectedLanguages {
            languageArray.append(newLanguage.id)
        }
        dictParam[PARAMS.PROVIDER_LANGUAGE] = languageArray
        dictParam[PARAMS.VEHICLE_ACCESSIBILITY] = selectedAccessibility
        
        
        dictParam[PARAMS.IS_SURGE_HOURS] = FALSE
        dictParam[PARAMS.IS_FIXED_FARE] = FALSE
        dictParam[PARAMS.TIMEZONE] = CurrentTrip.shared.timeZone
        dictParam[PARAMS.FIXED_PRICE] = 0.0
        if btnCorporatePay.isSelected && btnCorporatePay.isHidden == false
        {
            dictParam[PARAMS.TRIP_TYPE] = TripType.CORPORATE
        }
        dictParam[PARAMS.PROVIDER_GENDER] = []
        if paymentMode != PaymentMode.UNKNOWN
        {
            dictParam[PARAMS.PAYMENT_MODE] = paymentMode
        }
        else
        {
            dictParam[PARAMS.PAYMENT_MODE] = PaymentMode.CASH
        }
        dictParam[PARAMS.PROMO_ID] = promoId
        
        
        Utility.hideLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.CREATE_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    let createTripResponse:CreateTripRespose = CreateTripRespose.init(fromDictionary: response)
                    
                    CurrentTrip.shared.tripId = createTripResponse.tripId
                    CurrentTrip.shared.tripStaus = TripStatusResponse.init(fromDictionary: [:])
                    
                    CurrentTrip.shared.tripStaus.trip.providerId = createTripResponse.providerId
                    CurrentTrip.shared.tripStaus.trip.providerFirstName = createTripResponse.firstName
                    CurrentTrip.shared.tripStaus.trip.providerLastName = createTripResponse.lastName
                    self.wsGetTripStatus()
                    self.startTripStatusTimer()
                    self.stopTripNearByProviderTimer()
                    self.openDriverDetailDialog()
                }
                else
                {
                    let responseModel:ResponseModel = ResponseModel.init(fromDictionary: response)
                    if responseModel.errorCode == TRIP_IS_ALREADY_RUNNING
                    {
                        self.wsGetTripStatus()
                    }
                    Utility.hideLoading()
                }
            }
            
        }
    }
    
    func wsCreateFutureRequest()
    {
        var selectedAccessibility:[String] = []
        if isHotSpotSelected
        {
            selectedAccessibility.append(VehicleAccessibity.HOTSPOT)
        }
        if isBabySeatSelected
        {
            selectedAccessibility.append(VehicleAccessibity.BABY_SEAT)
        }
        if isHandicapSelected
        {
            selectedAccessibility.append(VehicleAccessibity.HANDICAP)
        }
        
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.SERVICE_TYPE_ID] = CurrentTrip.shared.selectedVehicle.id
        dictParam[PARAMS.LATITUDE] = CurrentTrip.shared.pickupCoordinate.latitude.toString(places: 6)
        dictParam[PARAMS.LONGITUDE] = CurrentTrip.shared.pickupCoordinate.longitude.toString(places: 6)
        dictParam[PARAMS.TRIP_PICKUP_ADDRESS] = CurrentTrip.shared.pickupAddress
        
        
        dictParam[PARAMS.TRIP_DESTINATION_LATITUDE] = CurrentTrip.shared.destinationCoordinate.latitude.toString(places: 6)
        dictParam[PARAMS.TRIP_DESTINATION_LONGITUDE] = CurrentTrip.shared.destinationCoordinate.longitude.toString(places: 6)
        dictParam[PARAMS.TRIP_DESTINATION_ADDRESS] = CurrentTrip.shared.destinationtAddress
        
        
        
        
        
        var languageArray: [String] = []
        for newLanguage in arrForSelectedLanguages {
            languageArray.append(newLanguage.id)
        }
        dictParam[PARAMS.PROVIDER_LANGUAGE] = languageArray
        dictParam[PARAMS.VEHICLE_ACCESSIBILITY] = selectedAccessibility
        
        
        dictParam[PARAMS.IS_SURGE_HOURS] = CurrentTrip.shared.isSurgeHour ? TRUE :FALSE
        dictParam[PARAMS.SURGE_MULTIPLIER] = CurrentTrip.shared.selectedVehicle.surgeMultiplier
        
        dictParam[PARAMS.IS_FIXED_FARE] = CurrentTrip.shared.isFixedFareTrip ? TRUE :FALSE
        dictParam[PARAMS.TIMEZONE] = CurrentTrip.shared.timeZone
        dictParam[PARAMS.START_TIME] = strFutureTripSelectedDate
        
        
        
        dictParam[PARAMS.FIXED_PRICE] = CurrentTrip.shared.estimateFareTotal
        dictParam[PARAMS.PROVIDER_GENDER] = []
        if btnCorporatePay.isSelected && btnCorporatePay.isHidden == false
        {
            dictParam[PARAMS.TRIP_TYPE] = TripType.CORPORATE
            
        }
        
        if paymentMode != PaymentMode.UNKNOWN
        {
            dictParam[PARAMS.PAYMENT_MODE] = paymentMode
        }
        else
        {
            dictParam[PARAMS.PAYMENT_MODE] = PaymentMode.CASH
        }
        dictParam[PARAMS.PROMO_ID] = promoId
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.CREATE_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response,withSuccessToast: true,andErrorToast: true)
                {
                    Utility.hideLoading()
                    self.idealView()
                }
                else
                {
                    
                    let responseModel:ResponseModel = ResponseModel.init(fromDictionary: response)
                    if responseModel.errorCode == TRIP_IS_ALREADY_RUNNING
                    {
                        self.wsGetTripStatus()
                    }
                    
                    Utility.hideLoading()
                }

            }
            
        }
    }
    func
        wsGetProviderDetail(id:String)
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = id
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_PROVIDER_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        {  (response, error) -> (Void) in
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    let providerResponse :ProviderResponse = ProviderResponse.init(fromDictionary: response)
                    CurrentTrip.shared.tripStaus.trip.providerRate = providerResponse.provider.rate
                    CurrentTrip.shared.providerPicture = providerResponse.provider.picture
                    self.openDriverDetailDialog()
                }
            }
        }
    }
    
    func fillVehicleArrayWith(array:[Citytype])
    {
        arrFinalForVehicles.removeAll()

        for type in array
        {
            
            arrFinalForVehicles.append(type)
            
        }
        if !self.arrFinalForVehicles.isEmpty
        {
            var isDefaultFound:Bool = false
            for index in 0...(self.arrFinalForVehicles.count - 1)
            {
                
                if self.arrFinalForVehicles[index].typeDetails.isDefaultSelected
                {
                    isDefaultFound = true
                    selectedIndex = index
                    CurrentTrip.shared.selectedVehicle = self.arrFinalForVehicles[index]
                    break
                }
            }
            if isDefaultFound == false
            {
                selectedIndex = Int(Double((arrFinalForVehicles.count)/2).rounded(.down))
                CurrentTrip.shared.selectedVehicle = self.arrFinalForVehicles[selectedIndex]
            }

            self.wsGetFareEstimate()
        }
        
        if btnRental.isSelected
        {
            lblRentalPackSize.text = CurrentTrip.shared.selectedVehicle.carRentalList.count.toString()
        }
        
        Utility.hideLoading()
        collectionViewForServices.reloadData()
    }
    func
        wsAcceptRejectCorporateRequest(accept:Bool)
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.CORPORATE_ID] = CurrentTrip.shared.user.corporateDetail.id
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.IS_ACCEPTED] = accept
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        
        
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.USER_ACCEPT_REJECT_CORPORATE_REQUEST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { /*[unowned self]*/ (response, error) -> (Void) in
            
            Utility.hideLoading()
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    CurrentTrip.shared.user.corporateDetail = CorporateDetail.init(fromDictionary: [:])
                }
            }
        }
    }
    
    @objc func wsGetTripStatus()
    {
        
        
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.CHECK_TRIP_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { /*[unowned self]*/ (response, error) -> (Void) in

            if (error != nil) {
                Utility.hideLoading()
            }
            else {
                if Parser.isSuccess(response: response,withSuccessToast: false,andErrorToast: false) {
                    CurrentTrip.shared.tripStaus = TripStatusResponse.init(fromDictionary: response)
                    CurrentTrip.shared.tripId = CurrentTrip.shared.tripStaus.trip.id
                    CurrentTrip.shared.isCardModeAvailable = CurrentTrip.shared.tripStaus.cityDetail.isPaymentModeCard
                    CurrentTrip.shared.isCashModeAvailable = CurrentTrip.shared.tripStaus.cityDetail.isPaymentModeCash 
                    if CurrentTrip.shared.tripStaus.trip.isProviderAccepted == TRUE {
                        self.stopTripStatusTimer()
                        if self.dialogFromDriverDetail != nil {
                            self.dialogFromDriverDetail?.removeFromSuperview()
                            self.dialogFromDriverDetail = nil
                        }
                        APPDELEGATE.gotoTrip()
                        return
                    }
                    else {
                        self.startTripStatusTimer()
                    }
                    Utility.hideLoading()
                }
                else {
                    Utility.hideLoading()
                    self.dialogFromDriverDetail?.removeFromSuperview()
                    self.dialogFromDriverDetail = nil
                    if !CurrentTrip.shared.tripId.isEmpty() {
                        self.idealView()
                        self.stopTripStatusTimer()
                        CurrentTrip.shared.clearTripData()
                        self.gettingCurrentLocation{
                            [unowned self] in
                            if CurrentTrip.shared.currentCoordinate.latitude != 0.0 && CurrentTrip.shared.currentCoordinate.longitude != 0.0 {
                                self.resetTripNearByProviderTimer()
                            }
                        }
                    }
                }
            }
            
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
                    if Parser.isSuccess(response: response)
                    {
                        
                        self.dialogFromDriverDetail?.removeFromSuperview()
                        self.dialogFromDriverDetail = nil
                        self.idealView()
                        self.stopTripStatusTimer()
                        CurrentTrip.shared.clearTripData()
                        
                        self.gettingCurrentLocation{
                            [unowned self] in
                            if CurrentTrip.shared.currentCoordinate.latitude != 0.0 && CurrentTrip.shared.currentCoordinate.longitude != 0.0
                            {
                                self.resetTripNearByProviderTimer()
                            }
                        }
                        Utility.hideLoading()
                    }
                    else
                    {
                        self.stopTripStatusTimer()
                    }
                }
                
            }
        }
        else
        {
            self.dialogFromDriverDetail?.removeFromSuperview()
            self.dialogFromDriverDetail = nil
            self.idealView()
            self.stopTripStatusTimer()
        }
    }
    func showPathFrom(source:CLLocationCoordinate2D, toDestination destination:CLLocationCoordinate2D)
    {
        pickupMarker.position =  source
        destinationMarker.position =  destination
        
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(source)
        bounds = bounds.includingCoordinate(destination)
        
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock
            {
        }
        
        self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
        CATransaction.commit()
        /*
         if preferenceHelper.getIsPathdraw()
         {

         let saddr = "\(source.latitude),\(source.longitude)"
         let daddr = "\(destination.latitude),\(destination.longitude)"
         let apiUrlStr = GOOGLE.DIRECTION_URL +  "\(saddr)&destination=\(daddr)&key=\(preferenceHelper.getGoogleKey())&language=\(arrForLanguages[preferenceHelper.getLanguage()].code)"
         let config = URLSessionConfiguration.default
         let session = URLSession(configuration: config)
         guard let url =  URL(string: apiUrlStr) else
         {
         return
         }
         do
         {

         DispatchQueue.main.async { [unowned self, unowned session] in

         session.dataTask(with: url) { (data, response, error) in

         guard data != nil else {
         return
         }
         do {

         let route = try JSONDecoder().decode(MapPath.self, from: data!)

         if let points = route.routes?.first?.overview_polyline?.points {
         self.drawPath(with: points)
         }

         } catch let error {

         printE("Failed to draw ",error.localizedDescription)
         }
         }.resume()
         }
         }

         }*/
        
        
    }
    private func drawPath(with points : String){
        
        if isSourceToDestPathDrawn == false
        {
            isSourceToDestPathDrawn = true
            
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
                var bounds = GMSCoordinateBounds()
                bounds = bounds.includingCoordinate(self.pickupMarker.position)
                bounds = bounds.includingCoordinate(self.destinationMarker.position)
                
                CATransaction.begin()
                CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
                CATransaction.setCompletionBlock
                    {
                }
                
                self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
                CATransaction.commit()
            }
        }
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

        pickupMarker.infoWindowAnchor = CGPoint(x: 0.0, y: 0.0)
        pickupMarker.appearAnimation = .pop

    }
    
    

}

//Bottom Animation

private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}
extension MapVC
{
    func hideBottomView()
    {
        if self.isViewDidLoad {
            self.isViewDidLoad = false            
            self.viewForAvailableService.isHidden = true
            self.stkFavouriteAddress.isHidden = false
            self.viewForAppPromotion.isHidden = false
            self.bottomView.isHidden = false
            return
        }
        
        let state = currentState.opposite
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations:
        {
            if self.bottomConstraint.constant != -self.viewForAvailableService.frame.height
            {
                self.bottomConstraint.constant = -self.viewForAvailableService.frame.height
            }
            self.view.layoutIfNeeded()
        })
        
        
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
                
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                printE("")
            }
            
            if self.bottomConstraint.constant != -self.viewForAvailableService.frame.height
            {
                self.bottomConstraint.constant = -self.viewForAvailableService.frame.height
            }
            
            self.view.layoutIfNeeded()
            self.viewForAvailableService.isHidden = true
            self.stkFavouriteAddress.isHidden = false
            
            if let bundle = Bundle.main.bundleIdentifier
            {
                if bundle.hasPrefix("com.elluminati")
                {
                    self.showPromotionView(show: false)
                }
                else
                {
                    self.showPromotionView(show: false)
                    
                }
            }
            
            self.bottomView.isHidden = false
        }
        transitionAnimator.startAnimation()
        
        
    }
    func showBottomView()
    {
        viewForAvailableService.isHidden = false
        
        let state = currentState.opposite
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations:
        {
            if self.bottomConstraint.constant != 0
            {
                self.bottomConstraint.constant = 0
            }
            
            self.view.layoutIfNeeded()
        })
        
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
                
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                printE("")
            }

            if self.bottomConstraint.constant != 0

            {
                self.bottomConstraint.constant = 0

            }
            
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state
        {
            //case .began:
            //let translation = recognizer.translation(in: viewForAvailableService)
            
        case .changed:
            let translation = recognizer.translation(in: viewForAvailableService)
            let yVelocity = recognizer.velocity(in: viewForAvailableService).y
            
            if yVelocity > 0 && self.bottomConstraint.constant >= 0
            {
                self.bottomConstraint.constant += translation.y;
            }
            else if yVelocity <= 0 && self.bottomConstraint.constant <= viewForAvailableService.frame.size.height
            {
                self.bottomConstraint.constant += translation.y;
            }
            

        case .ended:
            let yVelocity = recognizer.velocity(in: viewForAvailableService).y
            let shouldClose = yVelocity > 0
            if shouldClose
            {
                let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations:
                {
                    if self.bottomConstraint.constant != -self.viewForAvailableService.frame.height
                    {
                        self.bottomConstraint.constant = -self.viewForAvailableService.frame.height
                    }
                    
                    self.view.layoutIfNeeded()
                    
                })
                transitionAnimator.addCompletion { position in
                    self.onClickBtnBack(self.btnBack!)
                }
                transitionAnimator.startAnimation()
            }
            else
            {
                let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations:
                {
                    if self.bottomConstraint.constant != 0
                    {
                        self.bottomConstraint.constant = 0
                    }
                    self.view.layoutIfNeeded()
                })
                transitionAnimator.startAnimation()
                
            }

        default:
            ()
        }
    }
    
}





