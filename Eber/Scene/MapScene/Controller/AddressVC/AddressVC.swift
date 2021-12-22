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


protocol AddressDelegate: class
{
   func pickupAddressSet()
    func destinationAddressSet()
    
}

class AddressVC: BaseVC, CLLocationManagerDelegate, GMSMapViewDelegate
{
    
    @IBOutlet weak var autoCompleteHeight: NSLayoutConstraint!
    @IBOutlet weak var autoCompleteTop: NSLayoutConstraint!
    
    @IBOutlet weak var tblForAutoComplete: UITableView!
    weak var delegate: AddressDelegate?
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet weak var viewForPickupAddress: UIView!
    @IBOutlet weak var btnClearPickupAddress: UIButton!
    @IBOutlet weak var txtPickupAddress: UITextField!
    
    
    @IBOutlet weak var viewForDestinationAddress: UIView!
    @IBOutlet weak var btnClearDestinaitonAddress: UIButton!
    @IBOutlet weak var txtDestinationAddress: UITextField!
    
    
    @IBOutlet weak var viewForHomeAddress: UIView!
    @IBOutlet weak var btnAddHomeAddress: UIButton!
    @IBOutlet weak var lblHomeAddress: UILabel!
    
    @IBOutlet weak var viewForWorkAddress: UIView!
    @IBOutlet weak var btnAddWorkAddress: UIButton!
    @IBOutlet weak var lblWorkAddress: UILabel!
    
    

    @IBOutlet weak var viewForSetLocationOnMap: UIView!
    @IBOutlet weak var lblSetLocationOnMap: UILabel!
    @IBOutlet weak var btnSetLocationOnMap: UIButton!
    
    @IBOutlet weak var viewForAddDestinationLater: UIView!
    @IBOutlet weak var lblAddDestinationLater: UILabel!
    @IBOutlet weak var btnAddDestinationLater: UIButton!
    
    @IBOutlet weak var lblIconHomeLocation: UILabel!
    @IBOutlet weak var lblIconWorkAddress: UILabel!
    
    @IBOutlet weak var lblIconSetLocationMap: UILabel!
    @IBOutlet weak var lblIconAddDestinationLatter: UILabel!
    
    var locationManager: LocationManager? = LocationManager()
    var arrForAutoCompleteAddress:[(title:String,subTitle:String,address:String,placeid:String)] = []
    
    var flag = AddressType.pickupAddress;
    //MARK:
    //MARK: View life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.locationManager?.autoUpdate = false
        tblForAutoComplete.delegate = self
        tblForAutoComplete.dataSource = self
        
        let homeTapGesutre:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.onClickBtnHomeAddress(_:)))
        lblHomeAddress.addGestureRecognizer(homeTapGesutre)
        lblHomeAddress.isUserInteractionEnabled = true
        
        let workTapGesutre:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.onClickBtnWorkAddress(_:)))
        lblWorkAddress.addGestureRecognizer(workTapGesutre)
        lblWorkAddress.isUserInteractionEnabled = true
        self.txtPickupAddress.placeholder = "TXT_PICKUP_ADDRESS_PLACE_HOLDER".localized
        self.txtDestinationAddress.placeholder = "TXT_DESTINATION_ADDRESS_PLACE_HOLDER".localized
        lblTitle.text = "TXT_WHERE_TO_GO".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        
        self.setLocalization()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        txtPickupAddress.text = CurrentTrip.shared.pickupAddress
        txtDestinationAddress.text = CurrentTrip.shared.destinationtAddress
        
        
        
        lblHomeAddress.text = CurrentTrip.shared.favouriteAddress.homeAddress
        lblWorkAddress.text = CurrentTrip.shared.favouriteAddress.workAddress
        
        if flag == AddressType.pickupAddress
        {
            txtPickupAddress.becomeFirstResponder()
        }
        if flag == AddressType.destinationAddress
        {
            txtDestinationAddress.becomeFirstResponder()
        }
        if flag == AddressType.homeAddress
        {
            txtDestinationAddress.becomeFirstResponder()
        }
        if flag == AddressType.workAddress
        {
            txtDestinationAddress.becomeFirstResponder()
        }
        btnAddWorkAddress.isSelected =  !CurrentTrip.shared.favouriteAddress.workAddress.isEmpty
        btnAddHomeAddress.isSelected =  !CurrentTrip.shared.favouriteAddress.homeAddress.isEmpty
        
        if lblHomeAddress.text!.isEmpty()
        {
            lblHomeAddress.text = "TXT_TAP_TO_ADD_HOME_ADDRESS".localized
        }
        if lblWorkAddress.text!.isEmpty() {
            lblWorkAddress.text = "TXT_TAP_TO_ADD_WORK_ADDRESS".localized
        }
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    //MARK:- Set localized
    func setLocalization()
    {
        txtPickupAddress.text = "TXT_PICKUP_ADDRESS".localized
        txtPickupAddress.textColor = UIColor.themeTextColor
        txtPickupAddress.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        txtDestinationAddress.text = "TXT_DESTINATION_ADDRESS".localized
        txtDestinationAddress.textColor = UIColor.themeTextColor
        txtDestinationAddress.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        btnAddHomeAddress.setTitle("+", for: .normal)
        btnAddHomeAddress.setTitle("TXT_DELETE".localizedCapitalized   , for: .selected)
        btnAddHomeAddress.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnAddHomeAddress.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        btnAddWorkAddress.setTitle("+", for: .normal)
        btnAddWorkAddress.setTitle("TXT_DELETE".localizedCapitalized   , for: .selected)
        btnAddWorkAddress.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        
        btnAddWorkAddress.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        
        lblHomeAddress.textColor = UIColor.themeTextColor
        lblHomeAddress.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblWorkAddress.textColor = UIColor.themeTextColor
        lblWorkAddress.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblSetLocationOnMap.text = "TXT_SET_LOCATION_ON_MAP".localized
        lblSetLocationOnMap.textColor = UIColor.themeTextColor
        lblSetLocationOnMap.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblAddDestinationLater.text = "TXT_ADD_DESTINATION_LATER".localized
        lblAddDestinationLater.textColor = UIColor.themeTextColor
        lblAddDestinationLater.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        
        self.lblIconWorkAddress.text = FontAsset.icon_work_address
        self.lblIconSetLocationMap.text = FontAsset.icon_location
        self.lblIconHomeLocation.text = FontAsset.icon_home_address
        self.lblIconAddDestinationLatter.text = FontAsset.icon_location
        
        
        self.lblIconHomeLocation.setForIcon()
        self.lblIconSetLocationMap.setForIcon()
        self.lblIconAddDestinationLatter.setForIcon()
        self.lblIconWorkAddress.setForIcon()
        
        
        
        btnClearPickupAddress.setTitle(FontAsset.icon_cross_rounded, for: .normal)
        
        btnClearDestinaitonAddress.setTitle(FontAsset.icon_cross_rounded, for: .normal)
        
        btnClearPickupAddress.setSimpleIconButton()
        btnClearDestinaitonAddress.setSimpleIconButton()
        
        
        btnBack.setupBackButton()
    }

    func setupLayout()
    {
        navigationView.navigationShadow()
    }

    //MARK:- Action Methods
    @IBAction func onClickBtnAddDeleteWorkAddress(_ sender: Any) {
    
        flag = AddressType.workAddress
        if (!btnAddWorkAddress.isSelected)
        {
            let locationVC : LocationVC = storyboard?.instantiateViewController(withIdentifier: "locationVC") as! LocationVC
            locationVC.delegate = self
            locationVC.flag = AddressType.workAddress
            
            locationVC.focusLocation =  CurrentTrip.shared.currentCoordinate
            self.present(locationVC, animated: true, completion: nil)
            //btnAddWorkAddress.isSelected =  !btnAddHomeAddress.isSelected
        }
        else
        {
            self.wsSetAddress()
            btnAddWorkAddress.isSelected =  !btnAddHomeAddress.isSelected
        }
    }

    @IBAction func onClickBtnAddDeleteHomeAddress(_ sender: Any)
    {
        flag = AddressType.homeAddress
        if (!btnAddHomeAddress.isSelected)
        {
            let locationVC : LocationVC = storyboard?.instantiateViewController(withIdentifier: "locationVC") as! LocationVC
            locationVC.delegate = self
            locationVC.flag = AddressType.homeAddress
            locationVC.focusLocation =  CurrentTrip.shared.currentCoordinate
            self.present(locationVC, animated: true, completion: nil)
            // btnAddHomeAddress.isSelected =  !btnAddHomeAddress.isSelected
        }
        else
        {
            self.wsSetAddress()
              btnAddHomeAddress.isSelected =  !btnAddHomeAddress.isSelected
        }
    }

    @IBAction func onClickBtnHomeAddress(_ sender: Any) {
        if flag == AddressType.pickupAddress
        {
            let address = CurrentTrip.shared.favouriteAddress
            
            if !address.homeAddress.isEmpty()
            {
                CurrentTrip.shared.setPickupLocation(latitude: address.homeLocation[0], longitude: address.homeLocation[1], address: address.homeAddress)
                txtPickupAddress.text =  address.homeAddress
                if !CurrentTrip.shared.destinationtAddress.isEmpty
                {
                    self.delegate?.pickupAddressSet()
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.txtDestinationAddress.becomeFirstResponder()
                }
            }
            else{
                self.onClickBtnAddDeleteHomeAddress(btnAddHomeAddress as Any)
            }
        }
        else if flag == AddressType.destinationAddress
        {
            let address = CurrentTrip.shared.favouriteAddress
            if !address.homeAddress.isEmpty()
            {
                CurrentTrip.shared.setDestinationLocation(latitude: address.homeLocation[0], longitude: address.homeLocation[1], address: address.homeAddress)
                txtDestinationAddress.text =  address.homeAddress
                if !CurrentTrip.shared.pickupAddress.isEmpty
                {
                    self.delegate?.destinationAddressSet()
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.txtPickupAddress.becomeFirstResponder()
                }
            }
            else{
                self.onClickBtnAddDeleteHomeAddress(btnAddHomeAddress!)
            }
        }
    }

    @IBAction func onClickBtnWorkAddress(_ sender: Any) {
        if flag == AddressType.pickupAddress
        {
            let address = CurrentTrip.shared.favouriteAddress
            if !address.workAddress.isEmpty()
            {
            CurrentTrip.shared.setPickupLocation(latitude: address.workLocation[0], longitude: address.workLocation[1], address: address.workAddress)
            txtPickupAddress.text =  address.workAddress
            if !CurrentTrip.shared.destinationtAddress.isEmpty
            {
                self.delegate?.pickupAddressSet()
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.txtDestinationAddress.becomeFirstResponder()
                }
            }
            else{
                self.onClickBtnAddDeleteWorkAddress(btnAddWorkAddress!)
            }
        }
        else if flag == AddressType.destinationAddress
        {
            let address = CurrentTrip.shared.favouriteAddress
            if !address.workAddress.isEmpty()
            {
                CurrentTrip.shared.setDestinationLocation(latitude: address.workLocation[0] , longitude: address.workLocation[1], address: address.workAddress)
                txtDestinationAddress.text =  address.workAddress
                if !CurrentTrip.shared.pickupAddress.isEmpty
                {
                    self.delegate?.destinationAddressSet()
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.txtPickupAddress.becomeFirstResponder()
                }
            }
            else{
                self.onClickBtnAddDeleteWorkAddress(btnAddWorkAddress!)
            }
        }
    }

    @IBAction func onClickBtnSetLocationOnMap(_ sender: Any)
    {
        let locationVC : LocationVC = storyboard?.instantiateViewController(withIdentifier: "locationVC") as! LocationVC
        locationVC.delegate = self
        locationVC.flag = self.flag

        if self.flag == AddressType.pickupAddress
        {
            if CurrentTrip.shared.pickupCoordinate.latitude != 0.0 &&  CurrentTrip.shared.pickupCoordinate.longitude != 0.0
            {
                locationVC.focusLocation =  CurrentTrip.shared.pickupCoordinate
            }
            else
            {
                locationVC.focusLocation =  CurrentTrip.shared.currentCoordinate
            }
        }
        else if self.flag == AddressType.destinationAddress
        {
            if CurrentTrip.shared.destinationCoordinate.latitude != 0.0 &&  CurrentTrip.shared.destinationCoordinate.longitude != 0.0
            {
                locationVC.focusLocation =  CurrentTrip.shared.destinationCoordinate
            }
            else
            {
                locationVC.focusLocation =  CurrentTrip.shared.currentCoordinate
            }
        }
        else
        {
            locationVC.focusLocation =  CurrentTrip.shared.currentCoordinate
        }
        self.present(locationVC, animated: true, completion: nil)
    }
    
    @IBAction func onClickBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickBtnClearDestinationAddress(_ sender: Any) {
        txtDestinationAddress.text = ""
        tblForAutoComplete.isHidden = true
        txtDestinationAddress.becomeFirstResponder()
        CurrentTrip.shared.clearDestinationAddress()
    }

    @IBAction func onClickBtnClearPickupAddress(_ sender: Any) {
        txtPickupAddress.text = ""
        tblForAutoComplete.isHidden = true
        txtPickupAddress.becomeFirstResponder()
        CurrentTrip.shared.clearPickupAddress()
    }

    @IBAction func onClickBtnAddDestinationLater(_ sender: Any)
    {
        if CurrentTrip.shared.pickupAddress.isEmpty()
        {
            Utility.showToast(message: "VALIDATION_MSG_PICKUP_ADDRESS_NOT_AVAILABLE".localized)
        }
        else
        {
            CurrentTrip.shared.clearDestinationAddress()
            self.delegate?.destinationAddressSet()
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: RevealViewController Delegate Methods

extension AddressVC:UITextFieldDelegate
{
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPickupAddress
        {
            flag = 0
            autoCompleteTop.constant = viewForPickupAddress.frame.maxY + 60
        }
        if textField == txtDestinationAddress
        {
            flag = 1
            autoCompleteTop.constant = viewForDestinationAddress.frame.maxY + 60
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func searching(_ sender: UITextField){
        if sender == txtPickupAddress
        {
            tblForAutoComplete.tag = 0
        }
        else
        {
            tblForAutoComplete.tag = 1
        }
        if (sender.text?.count)! > 2
        {
//            tableDataSource.sourceTextHasChanged(sender.text)
            
            self.locationManager?.googlePlacesResult(input: sender.text!, completion: { [unowned self] (array) in

                 self.arrForAutoCompleteAddress.removeAll()
                 if array.count > 0
                 {
                    self.arrForAutoCompleteAddress = array
                    self.tblForAutoComplete.reloadData()
                    self.autoCompleteHeight.constant = CGFloat(50 * array.count)
                    self.tblForAutoComplete.isHidden = false
                 }
                 else
                 {
                 self.tblForAutoComplete.isHidden = true
                 }

            })
            
        }
        else
        {
          self.arrForAutoCompleteAddress.removeAll()
          self.tblForAutoComplete.reloadData()
          self.tblForAutoComplete.isHidden = true
        }
    }
    
}

extension AddressVC:LocationHandlerDelegate
{
    func finalAddressAndLocation(address: String, latitude: Double, longitude: Double) {
        if flag == AddressType.pickupAddress
        {
            CurrentTrip.shared.setPickupLocation(latitude: latitude, longitude: longitude, address: address)
            txtPickupAddress.text =  address
            if !CurrentTrip.shared.destinationtAddress.isEmpty
            {
                self.delegate?.pickupAddressSet()
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        else
        {
            CurrentTrip.shared.setDestinationLocation(latitude: latitude, longitude: longitude, address: address)
            txtDestinationAddress.text =  address
            if !CurrentTrip.shared.pickupAddress.isEmpty
            {
                self.delegate?.destinationAddressSet()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddressVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrForAutoCompleteAddress.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let autoCompleteCell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell", for: indexPath) as! AutocompleteCell
        
        if indexPath.row < arrForAutoCompleteAddress.count
        {
            autoCompleteCell.setCellData(place: arrForAutoCompleteAddress[indexPath.row])
        }
        
        return autoCompleteCell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row < arrForAutoCompleteAddress.count
        {
            tblForAutoComplete.isHidden = true
            let placeID = arrForAutoCompleteAddress[indexPath.row].placeid
            let address = self.arrForAutoCompleteAddress[indexPath.row].address
            let placeClient = GMSPlacesClient.shared()
            
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))
            
            placeClient.fetchPlace(fromPlaceID: placeID,
                                   placeFields: fields,
                                   sessionToken: GoogleAutoCompleteToken.shared.token, callback: {
                                    (place: GMSPlace?, error: Error?) in
                                    GoogleAutoCompleteToken.shared.token = nil
                                    if let error = error {

                                        // TODO: Handle the error.
                                        printE("An error occurred: \(error.localizedDescription)")
                                        return
                                    }
                                    
                                    if let place = place {
                                        
                                        if self.flag == AddressType.pickupAddress
                                        {
                                            self.txtPickupAddress.text = address
                                            if place.coordinate.latitude != 0.0 && place.coordinate.longitude != 0.0
                                            {
                                                CurrentTrip.shared.setPickupLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, address: address)
                                                if !CurrentTrip.shared.destinationtAddress.isEmpty
                                                {
                                                    self.delegate?.pickupAddressSet()
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                                else
                                                {
                                                    self.txtDestinationAddress.becomeFirstResponder()
                                                }
                                            }
                                            else
                                            {
                                                Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
                                            }
                                            
                                        }
                                        else
                                        {
                                            if place.coordinate.latitude != 0.0 && place.coordinate.longitude != 0.0
                                            {
                                                self.txtDestinationAddress.text = address
                                                CurrentTrip.shared.setDestinationLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, address: address)
                                                if !CurrentTrip.shared.pickupAddress.isEmpty
                                                {
                                                    self.delegate?.destinationAddressSet()
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                                else
                                                {
                                                    self.txtPickupAddress.becomeFirstResponder()
                                                }
                                            }
                                            else
                                            {
                                                Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
                                            }
                                        }
                                    }
            })
        }
        
    }
    
    
}

extension AddressVC
{
    func wsSetAddress()
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        if flag == AddressType.homeAddress
        {
            dictParam[PARAMS.HOME_ADDRESS] = ""
            dictParam[PARAMS.HOME_LATITUDE] = 0.0
            dictParam[PARAMS.HOME_LONGITUDE] = 0.0
        }
        else
        {
            dictParam[PARAMS.WORK_ADDRESS] = ""
            dictParam[PARAMS.WORK_LATITUDE] = 0.0
            dictParam[PARAMS.WORK_LONGITUDE] = 0.0
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
            }
            else
            {
                if Parser.isSuccess(response: response)
                {
                    let userDataResponse:UserAddressResponse = UserAddressResponse.init(fromDictionary: response)
                    CurrentTrip.shared.favouriteAddress = userDataResponse.userAddress
                    self.btnAddWorkAddress.isSelected =  !CurrentTrip.shared.favouriteAddress.workAddress.isEmpty
                    self.btnAddHomeAddress.isSelected = !CurrentTrip.shared.favouriteAddress.homeAddress.isEmpty
                    self.lblHomeAddress.text = CurrentTrip.shared.favouriteAddress.homeAddress
                    self.lblWorkAddress.text = CurrentTrip.shared.favouriteAddress.workAddress
                    
                    if self.lblHomeAddress.text!.isEmpty()
                    {
                        self.lblHomeAddress.text = "TXT_TAP_TO_ADD_HOME_ADDRESS".localized
                    }
                    if self.lblWorkAddress.text!.isEmpty() {
                        self.lblWorkAddress.text = "TXT_TAP_TO_ADD_WORK_ADDRESS".localized
                    }
                    
                    Utility.hideLoading()
                }
            }
        }
    }
}
