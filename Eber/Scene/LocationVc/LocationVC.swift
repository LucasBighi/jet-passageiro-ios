//
//  LocationVC.swift
//  Cabtown
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@objc protocol LocationHandlerDelegate: class {
    
    func finalAddressAndLocation(address:String,latitude:Double,longitude:Double)
   
}
class LocationVC: BaseVC,UINavigationControllerDelegate,UIScrollViewDelegate,GMSMapViewDelegate
{
    
    weak var delegate:LocationHandlerDelegate?
//MARK:
//MARK: Outlets
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet weak var tblAutocomplete: UITableView!
    @IBOutlet weak var heightForAutoComplete: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblIconSourceLocation: UILabel!
    
    @IBOutlet weak var lblIconSetLocation: UILabel!
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var imgForLocation: UIImageView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var viewForSingleAddress: UIView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnClearAddress: UIButton!
   
    var focusLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 22.30, longitude: 70.80)
    var locationManager: LocationManager? = LocationManager()
    var address:String = "";
    var location:[Double] = [0.0,0.0];
    var flag:Int = AddressType.pickupAddress
    var arrForAdress:[(title:String,subTitle:String,address:String,placeid:String)] = []
//MARK:
//MARK: Variables
   
//MARK:
//MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()

        tblAutocomplete.delegate = self
        tblAutocomplete.dataSource = self

        setLocalization()
        self.tblAutocomplete.estimatedRowHeight = UITableView.automaticDimension
        self.mapView.padding = UIEdgeInsets.init(top: viewForSingleAddress.frame.maxY, left: 20, bottom: viewForSingleAddress.frame.maxY, right: 20)
        }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        viewForSingleAddress.isHidden = false
        
        
        if flag == AddressType.pickupAddress
        {
           
            txtAddress.text = CurrentTrip.shared.pickupAddress
            self.animateToLocation(coordinate: focusLocation)
         
        }
        if flag == AddressType.destinationAddress
        {
           txtAddress.text = CurrentTrip.shared.destinationtAddress
         self.animateToLocation(coordinate: focusLocation)
            
        }
        if flag == AddressType.homeAddress
        {
            txtAddress.text = CurrentTrip.shared.favouriteAddress.homeAddress
            self.animateToLocation(coordinate: focusLocation)
         
        }
        if flag == AddressType.workAddress
        {
            txtAddress.text = CurrentTrip.shared.favouriteAddress.workAddress
            self.animateToLocation(coordinate: focusLocation)
            
            
        }
       // txtAddress.becomeFirstResponder()
        
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
        setupLayout()
    }
   
    @IBAction func onClickBtnClearAddress(_ sender: Any) {
        txtAddress.text = "";
        
    }
    func setLocalization() {
        //COLORS
        self.view.backgroundColor = UIColor.themeDialogBackgroundColor;
        
        
        self.viewForSingleAddress.backgroundColor = UIColor.themeDialogBackgroundColor
        
        
        
        self.txtAddress.placeholder = "TXT_ADDRESS".localizedCapitalized
        self.txtAddress.textColor = UIColor.themeTextColor
        self.txtAddress.delegate = self
        self.txtAddress.backgroundColor = UIColor.white
        
        
        
        self.btnDone.backgroundColor = UIColor.themeButtonBackgroundColor
        self.btnDone.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.btnDone.setTitle("TXT_CONFIRM".localizedCapitalized, for: .normal)
        self.btnDone.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
     
        self.navigationView.backgroundColor = UIColor.clear
        
        self.locationManager?.autoUpdate = false
        self.mapView.bringSubviewToFront(self.imgForLocation)
        self.mapView.bringSubviewToFront(self.lblIconSourceLocation)
        self.mapView.delegate = self;
         self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = false;
        
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
        
        lblIconSetLocation.text = FontAsset.icon_location
        lblIconSourceLocation.text = FontAsset.icon_pickup_location
        btnClearAddress.setTitle(FontAsset.icon_cross_rounded, for: .normal)
        btnCurrentLocation.setTitle(FontAsset.icon_btn_current_location, for: .normal)
        
        lblIconSetLocation.setForIcon()
        lblIconSourceLocation.setForIcon()
        btnCurrentLocation.setSimpleIconButton()
        btnClearAddress.setSimpleIconButton()
        
        btnBack.setupBackButton()    
    }
    
    
   
    @IBAction func onClickDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func  setupLayout(){
        
      btnDone.setupButton()
        viewForSingleAddress.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        viewForSingleAddress.setShadow()
        
     
    }

    //MARK: Button action methods
    @IBAction func onClickBtnDone(_ sender: UIButton){
        
       if !address.isEmpty() && location[0] != 0.0 && location[1] != 0.0
       {
            if flag == AddressType.pickupAddress || flag == AddressType.destinationAddress
            {
                self.delegate?.finalAddressAndLocation(address: address, latitude: location[0], longitude: location[1])
               self.dismiss(animated: true) {
                    
                }
            }
           else
            {
                wsSetAddress()
               
            }
        
       }
        else
       {
        Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
        
        }
    }
    @IBAction func onClickBtnBack(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
   
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition){
       
        
            /*let point = mapView.center;
            let myCoordinate = mapView.projection.coordinate(for: point)*/
        let myCoordinate = position.target

        self.locationManager?.getAddressFromLatitudeLongitude(latitude: myCoordinate.latitude, longitude: myCoordinate.longitude, completion: { (address, locations) in
            self.address = address
            self.txtAddress.text = self.address
            self.txtAddress.resignFirstResponder()
            self.location = [myCoordinate.latitude,myCoordinate.longitude]
        })


       
    }
    
    @IBAction func onClickBtnCurrentLocation(_ sender: Any) {
        gettingCurrentLocation()
    }

    func gettingCurrentLocation()
    {
        
        self.locationManager?.currentUpdatingLocation { [unowned self] (location,
            error) in
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
                        CurrentTrip.shared.currentCoordinate = currentLocation.coordinate
                        self.animateToCurrentLocation()
                    }
                    else
                    {
                        //Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
                    }
                }
                else
                {
                    //Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
                }
            }
            
        }
    }
    func animateToCurrentLocation()
        
    {
        
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock {
        }
        let camera = GMSCameraPosition.camera(withTarget: CurrentTrip.shared.currentCoordinate, zoom: 17.0, bearing: 45, viewingAngle: 0.0)
        
        //let address = locationManager.getAddressFromLatitudeLongitude(latitude: CurrentTrip.shared.currentCoordinate.latitude, longitude: CurrentTrip.shared.currentCoordinate.longitude)
        
        
        self.mapView.animate(to: camera)
        CATransaction.commit()

    }

    func animateToLocation(coordinate:CLLocationCoordinate2D)
    {
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock {
        }
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17.0, bearing: 45, viewingAngle: 0.0)
        
        self.mapView.animate(to: camera)
        CATransaction.commit()
    }

    @IBAction func searching(_ sender: UITextField){
        if (sender.text?.count)! > 2 {

            self.locationManager?.googlePlacesResult(input: sender.text!, completion: { [unowned self] (array) in

                self.arrForAdress = array
                if self.arrForAdress.count > 0
                {
                    self.heightForAutoComplete.constant = self.tblAutocomplete.contentSize.height
                    self.tblAutocomplete.reloadData()
                    self.tblAutocomplete.isHidden = false
                }
                else
                {
                    self.tblAutocomplete.isHidden = true
                }
            })
        }
    }
   
}

extension LocationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LocationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForAdress.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let autoCompleteCell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell", for: indexPath) as! AutocompleteCell
        autoCompleteCell.setCellData(place: arrForAdress[indexPath.row])
        return autoCompleteCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        tblAutocomplete.isHidden = true
        let placeID = arrForAdress[indexPath.row].placeid
        let address = self.arrForAdress[indexPath.row].address
        let placeClient = GMSPlacesClient.shared()


        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))

        placeClient.fetchPlace(fromPlaceID: placeID,
                               placeFields: fields,
                               sessionToken: GoogleAutoCompleteToken.shared.token , callback: {
                                (place: GMSPlace?, error: Error?) in
                                GoogleAutoCompleteToken.shared.token = nil
                                if let error = error {
                                    // TODO: Handle the error.
                                    printE("An error occurred: \(error.localizedDescription)")
                                    return
                                }

                                if let place = place {

                                    self.address = address
                                    self.location = [place.coordinate.latitude,place.coordinate.longitude]
                                    self.txtAddress.text = address
                                    self.animateToLocation(coordinate: place.coordinate)
                                }
        })
    }
}

extension LocationVC
{
    func wsSetAddress()
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
       if flag == AddressType.homeAddress
        {
            dictParam[PARAMS.HOME_ADDRESS] = address
            dictParam[PARAMS.HOME_LATITUDE] = location[0]
            dictParam[PARAMS.HOME_LONGITUDE] = location[1]
        }
        else
        {
            dictParam[PARAMS.WORK_ADDRESS] = address
            dictParam[PARAMS.WORK_LATITUDE] = location[0]
            dictParam[PARAMS.WORK_LONGITUDE] = location[1]
        }
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.SET_FAVOURITE_ADDRESS_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    self.wsGetAddress()
                    
                }
            }
            
        }
    }
    
    func wsGetAddress()
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_FAVOURITE_ADDRESS_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            
            if (error != nil)
            {
                Utility.hideLoading()
                self.dismiss(animated: true) {
                    
                }
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    
                    let userDataResponse:UserAddressResponse = UserAddressResponse.init(fromDictionary: response)
                    CurrentTrip.shared.favouriteAddress = userDataResponse.userAddress
                    Utility.hideLoading()
                    self.dismiss(animated: true) {
                        
                    }
               }
                
            }
        }
    }
}
