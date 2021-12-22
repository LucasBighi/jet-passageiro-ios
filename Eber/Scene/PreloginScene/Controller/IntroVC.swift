//
//  ViewController.swift
//  Cabtown
//
//  Created by Elluminati  on 30/08/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseCore

class IntroVC: BaseVC
{
    @IBOutlet weak var viewForAnimation: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblCountryPhoneCode: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var dividerView: UIView!
    
    var socialId:String = "",strForFirstName:String = "",
    strEmail:String = ""
    
    
    var locationManager: LocationManager? = LocationManager()
    var arrForCountryList : [Country] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        wsGetCountries()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialViewSetup()
        
        if self.locationManager!.requestUserLocation()
        {
            getCurrentCountry()
        }
        else
        {
            Utility.hideLoading()
            CurrentTrip.shared.currentCountryPhoneCode = CurrentTrip.shared.arrForCountries[0].countryPhoneCode
            CurrentTrip.shared.currentCountryFlag = CurrentTrip.shared.arrForCountries[0].countryFlag
            CurrentTrip.shared.currentCountry = CurrentTrip.shared.arrForCountries[0].countryName
            preferenceHelper.setMaxPhoneNumberLength(CurrentTrip.shared.arrForCountries[0].phoneNumberLength)
            preferenceHelper.setMinPhoneNumberLength(CurrentTrip.shared.arrForCountries[0].phoneNumberMinLength)
            getCurrentCountry()
        }
    }

    func initialViewSetup()
    {
        lblMessage.text = "TXT_INTRO_MSG".localized
        lblMessage.textColor = UIColor.themeTextColor
        lblMessage.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        
        lblCountryPhoneCode.text =
            
            CurrentTrip.shared.arrForCountries[0].countryPhoneCode
        
        
        lblCountryPhoneCode.textColor = UIColor.themeButtonBackgroundColor
        lblCountryPhoneCode.font  = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        
        lblMobileNumber.text = "TXT_MOBILE_MSG".localized
        lblMobileNumber.textColor = UIColor.themeTextColor
        lblMobileNumber.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        dividerView.backgroundColor = UIColor.themeDividerColor
        
    }

    //MARK:- Action Methods
    @IBAction func onClickBtnLogin(_ sender: Any)
    {
        self.performSegue(withIdentifier: SEGUE.INTRO_TO_PHONE, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE.INTRO_TO_PHONE
        {
            if let destinationVc = segue.destination as? PhoneVC
            {
                destinationVc.strForCountryPhoneCode = CurrentTrip.shared.currentCountryPhoneCode
                destinationVc.strForCountry = CurrentTrip.shared.currentCountry
            }
        }
        if segue.identifier == SEGUE.INTRO_TO_REGISTER
        {
            if let registerVC = segue.destination as? RegisterVC
            {
                
                registerVC.strForSocialId = socialId;
                registerVC.strForLastName = "";
                registerVC.strForFirstName = strForFirstName;
                registerVC.strForEmail = strEmail;
                registerVC.strLoginBy = CONSTANT.SOCIAL;
                registerVC.strForPhoneNumber = "";
                registerVC.strForCountryPhoneCode = CurrentTrip.shared.currentCountryPhoneCode
                registerVC.strForCountry = CurrentTrip.shared.currentCountry
          }
        }
    }

    func getCurrentCountry()
    {
        self.locationManager?.currentLocation { [unowned self] (location, error) in
            if let currentLocation = location
            {
                self.locationManager?.fetchCityAndCountry(location: currentLocation)
                { [unowned self] city, country, error in
                    if let currentCountry = country
                    {
                        var isCountryMatched:Bool = false
                        for countries in CurrentTrip.shared.arrForCountries
                        {
                            if countries.countryName.lowercased() == currentCountry.lowercased()
                            {
                                isCountryMatched = true
                                CurrentTrip.shared.currentCity = city ?? ""
                                CurrentTrip.shared.currentCountry = currentCountry
                                CurrentTrip.shared.currentCountryPhoneCode = countries.countryPhoneCode
                                CurrentTrip.shared.currentCountryFlag = countries.countryFlag
                                
                                preferenceHelper.setMaxPhoneNumberLength(countries.phoneNumberLength)
                                preferenceHelper.setMinPhoneNumberLength(countries.phoneNumberMinLength)
                                
                                break;
                            }
                        }
                        if !isCountryMatched
                        {
                            CurrentTrip.shared.currentCountryPhoneCode = CurrentTrip.shared.arrForCountries[0].countryPhoneCode
                            CurrentTrip.shared.currentCountry = CurrentTrip.shared.arrForCountries[0].countryName
                            preferenceHelper.setMaxPhoneNumberLength(CurrentTrip.shared.arrForCountries[0].phoneNumberLength)
                            preferenceHelper.setMinPhoneNumberLength(CurrentTrip.shared.arrForCountries[0].phoneNumberMinLength)
                        }
                        DispatchQueue.main.async { 
                            self.lblCountryPhoneCode.text = CurrentTrip.shared.currentCountryPhoneCode
                   
                             Utility.hideLoading()
                            self.locationManager?.locationManager.delegate = nil
                            self.locationManager = nil
                        }

                    }
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                    }
                }
            }
            else
            {
                CurrentTrip.shared.currentCountryPhoneCode = CurrentTrip.shared.arrForCountries[0].countryPhoneCode
                CurrentTrip.shared.currentCountry = CurrentTrip.shared.arrForCountries[0].countryName
                
                preferenceHelper.setMaxPhoneNumberLength(CurrentTrip.shared.arrForCountries[0].phoneNumberLength)
                preferenceHelper.setMinPhoneNumberLength(CurrentTrip.shared.arrForCountries[0].phoneNumberMinLength)
                
                DispatchQueue.main.async { [weak self] in
                    self?.lblCountryPhoneCode.text =
                         CurrentTrip.shared.currentCountryPhoneCode
                   
                    Utility.hideLoading()
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
       printE("Location Changed")
    }

    //MARK:- Web Service Calls
    
    func wsLogin()
    {
        self.view.endEditing(true)
        Utility.showLoading()

        var  dictParam : [String : Any] = [:]
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        dictParam[PARAMS.APP_VERSION] = currentAppVersion
        dictParam[PARAMS.DEVICE_TIMEZONE] = TimeZone.current.identifier
        dictParam[PARAMS.DEVICE_TYPE] = CONSTANT.IOS
        dictParam[PARAMS.EMAIL] = strEmail
        dictParam[PARAMS.SOCIAL_UNIQUE_ID] = socialId
        dictParam[PARAMS.DEVICE_TOKEN] = preferenceHelper.getDeviceToken()
        dictParam[PARAMS.LOGIN_BY] = CONSTANT.SOCIAL
        dictParam[PARAMS.PASSWORD] = ""
        
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.LOGIN_USER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            
            if (error != nil)
            {
                Utility.hideLoading()
            }
            else
            {
                Utility.hideLoading()
                if Parser.parseUserDetail(response: response)
                {
                    if !(CurrentTrip.shared.user.isReferral == TRUE) && CurrentTrip.shared.user.countryDetail.isReferral
                    {
                        Utility.hideLoading()
                        self.performSegue(withIdentifier: SEGUE.LOGIN_TO_REFERRAL, sender: self)
                    }
                    else if (CurrentTrip.shared.user.isDocumentUploaded == FALSE)
                    {
                        APPDELEGATE.gotoDocument()
                    }
                    else
                    {
                        self.wsGetTripStatus()
                    }
                }
                else
                {
                    let isSuccess:ResponseModel = ResponseModel.init(fromDictionary: response)
                    if !isSuccess.success
                    {
                        self.performSegue(withIdentifier: SEGUE.INTRO_TO_REGISTER, sender: self)
                    }
                    Utility.hideLoading()
                }
            }
        }
    }

    func wsGetTripStatus()
    {
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.CHECK_TRIP_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { /*[unowned self]*/ (response, error) -> (Void) in
            if (error != nil)
            {}
            else
            {
                if Parser.isSuccess(response: response,withSuccessToast: false,andErrorToast: false)
                {
                    CurrentTrip.shared.tripStaus = TripStatusResponse.init(fromDictionary: response)
                    CurrentTrip.shared.tripId = CurrentTrip.shared.tripStaus.trip.id
                    
                    if CurrentTrip.shared.tripStaus.trip.isProviderAccepted == TRUE
                    {
                        APPDELEGATE.gotoTrip()
                    }
                    else
                    {
                        APPDELEGATE.gotoMap()
                    }
                }
                else
                {
                    APPDELEGATE.gotoMap()
                }
            }
        }
    }

    func wsGetCountries()
    {
        Utility.showLoading()

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_COUTRIES, methodName: AlamofireHelper.POST_METHOD, paramData: Dictionary.init()) {(response, error) -> (Void) in

            if Parser.isSuccess(response: response)
            {
                let response:CountryListResponse = CountryListResponse.init(fromDictionary: response)
                self.arrForCountryList = response.countryList
                for serverCountry:Country in self.arrForCountryList
                {
                    for country in CurrentTrip.shared.arrForCountries
                    {
                        if country.countryPhoneCode == serverCountry.countryPhoneCode
                        {
                            country.phoneNumberLength = serverCountry.phoneNumberLength
                            country.phoneNumberMinLength = serverCountry.phoneNumberMinLength
                        }
                    }
                }
                self.getCurrentCountry()
            }
            else {
                Utility.hideLoading()
            }
        }
    }
}
