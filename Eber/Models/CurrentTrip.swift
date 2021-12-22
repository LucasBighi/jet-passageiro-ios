//
//  CurrentTrip.swift
//  Cabtown
//
//  Created by Elluminati on 02/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import CoreLocation
/**
 * Created by Jaydeep on 13-Feb-17.
 */


public class CurrentTrip: ModelNSObj
{
    static let shared = CurrentTrip()
    
    
   
    var user:UserDataResponse = UserDataResponse.init(fromDictionary: [:])
    
    
    var arrForCountries:[Country] = Country.modelsFromDictionaryArray()
    var favouriteAddress:UserAddress = UserAddress.init(fromDictionary: [:])
    var tripStaus:TripStatusResponse = TripStatusResponse.init(fromDictionary: [:])
    var providerPicture:String = ""
    
    var tripId:String = ""
    var serverTime:String = ""
    var timeZone:String = ""
    
    var currentCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    var pickupCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    var destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    var temporaryCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    
    var currentCountry:String = ""
    var currentCity:String = ""
    var currentCountryPhoneCode:String = ""
    var currentCountryFlag:String = ""
    var currentCountryCode:String = ""
    
    var selectedVehicle:Citytype = Citytype.init(fromDictionary: [:])
    var currentAddress:String = ""
    var pickupAddress:String = ""
    var destinationtAddress:String = ""
    var temporaryAddress:String = ""
    
    var pickupCity:String = ""
    var pickupCountry:String = ""
    
    var currencyCode:String = ""
    
    var distanceUnit:String = MeasureUnit.KM
    var isPromoApplyForCash:Int = 0
    var isPromoApplyForCard:Int = 0
    
    var isCardModeAvailable:Int = 0
    var isCashModeAvailable:Int = 0
    
    var estimateFareTotal:Double = 0.0
    var estimateFareTime:Double = 0.0
    var estimateFareDistance:Double = 0.0
    var tripType:Int = TripType.NORMAL
    
    
    var isSurgeHour:Bool = false
    var isFixedFareTrip:Bool = false
    var isAskUserForFixedFare:Bool = false
    
    static weak var timeForTripStatus:Timer? = nil
    static weak var timerForNearByProvider:Timer? = nil
    static weak var timerForWaitingTime:Timer? = nil
    static weak var timerForTotalTripTime:Timer? = nil

    private override init()
    {

    }
    func clear()
    {
        CurrentTrip.timeForTripStatus?.invalidate()
        CurrentTrip.timerForNearByProvider?.invalidate()
        CurrentTrip.timerForWaitingTime?.invalidate()
        
        
        clearTripData()
        clearUserData()
        
    }
    func clearTripData()
    {
        tripStaus =  TripStatusResponse.init(fromDictionary: [:])
        tripId = ""
        clearPickupAddress()
        clearDestinationAddress()
        pickupCity = ""
        providerPicture = ""
        CurrentTrip.timerForTotalTripTime?.invalidate()
        CurrentTrip.timerForTotalTripTime = nil
        
 
    }
    func clearUserData()
    {
        self.user = UserDataResponse.init(fromDictionary: [:])
    }
    func clearServiceTypeData()
    {
        
    }
    func clearFavouriteAddress()
    {
        favouriteAddress =  UserAddress.init(fromDictionary: [:])
    }
    
    func setPickupLocation(latitude:Double,longitude:Double,address:String)
    {
        if address.isEmpty() || (latitude == 0.0 && longitude == 0.0)
        {
            //Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
            
        }
        else
        {
            self.pickupAddress = address
            self.pickupCoordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
            
        }
    }
    
    func setDestinationLocation(latitude:Double,longitude:Double,address:String)
    {
        if address.isEmpty() || (latitude == 0.0 && longitude == 0.0)
        {
           // Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
            
        }
        else
        {
            self.destinationtAddress = address
            self.destinationCoordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
            
        }
    }
    
    func clearPickupAddress()
    {
        self.pickupAddress = ""
        self.pickupCoordinate = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
        pickupCity = ""
    }
    func clearDestinationAddress()
    {
        self.destinationtAddress = ""
        self.destinationCoordinate = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    }
    
}



struct TripType {
    static let NORMAL = 0
    
    static let VISITOR = 1
    static let HOTEL = 2
    static let DISPATCHER = 3
    static let SCHEDULE = 5
    static let  PROVIDER = 6
    
    static let  AIRPORT = 11
    static let  ZONE = 12
    static let  CITY = 13
    static let CORPORATE = 7
}
public class CurrencyHelper
{
    static let shared = CurrencyHelper()
    public var myLocale:Locale = Locale.current
    public var currencyCode:String = "INR"
    private init()
    {
        
    }
    
}


