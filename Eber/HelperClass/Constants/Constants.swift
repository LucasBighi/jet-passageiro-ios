//
//  AlamofireHelper.swift
//  Store
//
//  Created by Disha Ladani on 07/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//


import Foundation
import UIKit

//MARK:- Abbreviation
let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let preferenceHelper = PreferenceHelper.preferenceHelper
let passwordLength = 6
let mobileMinLength = 8
let mobileMazLength = 12
let NOT_REGISTERED_USER = "403"
let TRIP_IS_ALREADY_RUNNING = "995"
let numberSet = NSCharacterSet(charactersIn:"0123456789").inverted

let isConsolePrint = true

public func printE(_ items: Any..., separator: String = "", terminator: String = "") {
    if isConsolePrint {
        debugPrint(items)
        //debugPrint(items, separator, terminator)
        //print(items, separator, terminator)
    }
}

struct AddressType {
    static let pickupAddress:Int = 0
    static let destinationAddress:Int = 1
    static let homeAddress:Int = 2
    static let workAddress:Int = 3
}

struct MeasureUnit
{
   static let MINUTES = " min"
   static let KM = " Km"
   static let MILE = " Mile"
}
struct PaymentMode
{
    static let CASH = 1
    static let CARD = 0
    static let UNKNOWN = -1
}

let arrForLanguages:[(language:String,code:String)] = [(language: "Português", code: "pt"), (language: "English", code: "en")]

let TRIP_IS_ALREADY_CANCELLED = "408"

let TRUE = 1
let FALSE = 0

struct DialogTags {
    static let networkDialog:Int = 400
}

struct WebService
{

static let BASE_URL = "https://vadejet.com.br/"
static var IMAGE_BASE_URL = "https://vadejet.com.br/"

static let TERMS_CONDITION_URL = "get_user_terms_and_condition"
static let PRIVACY_POLICY_URL =  "get_user_privacy_policy"
static let GET_USER_SETTING_DETAIL = "get_user_setting_detail"
static let UPDATE_DEVICE_TOKEN = "updateuserdevicetoken"
/*User Related Web Service*/
static let GET_COUTRIES = "get_country_city_list"
static let CHECK_USER_REGISTER = "check_user_registered"
static let REGISTER_USER = "userregister"
static let LOGIN_USER = "userslogin"
static let LOGOUT_USER = "logout"
static let GET_VERIFICATION_OTP = "verification"
static let GET_OTP = "get_otp";
static let GET_USER_DETAIL = "getuserdetail"
static let FORGOT_PASSWORD = "forgotpassword"
static let CHANGE_PASSWORD = "update_password"
static let APPLY_REFFERAL = "apply_referral_code"
static let UPADTE_PROFILE = "userupdate";
static let CANCEL_TRIP = "canceltrip";
static let SUBMIT_INVOICE = "user_submit_invoice";
static let USER_CHANGE_PAYMENT_TYPE = "userchangepaymenttype";
static let TWILIO_CALL = "twilio_voice_call"
    
static let USER_ACCEPT_REJECT_CORPORATE_REQUEST =   "user_accept_reject_corporate_request"

static let ADD_FAVOURITE_DRIVER = "add_favourite_driver"
static let GET_FAVOURITE_DRIVER = "get_favourite_driver"
static let REMOVE_FAVOURITE_DRIVER = "remove_favourite_driver"
static let GET_ALL_DRIVER_LIST = "get_all_driver_list"

static let ADD_FAVOURITE_FRIEND = "add_favourite_friend"
static let GET_FAVOURITE_FRIEND = "get_favourite_friend"
static let REMOVE_FAVOURITE_FRIEND = "remove_favourite_friend"
static let GET_ALL_FRIEND_LIST = "get_all_friendlist"
    
static let GET_DOCUMENTS = "getuserdocument"
static let UPLOAD_DOCUMENT = "uploaduserdocument"
/* Trip Web-Service Methods*/
static let CREATE_TRIP  =    "createtrip"
static let CHECK_TRIP_STATUS  =    "usergettripstatus"
static let GET_BOOKING_TRIPS  =  "getfuturetrip";
static let GET_AVAILABLE_VEHICLE_TYPES  = "typelist_selectedcountrycity"
static let GET_FARE_ESTIMATE  =  "getfareestimate"
static let GET_PROVIDER_DETAIL = "get_provider_info"
static let PAY_PAYMENT = "pay_payment"
static let GET_NEAR_BY_PROVIDER  = "getnearbyprovider"
static let APPLY_PROMO_CODE  =  "apply_promo_code"
static let REMOVE_PROMO_CODE  =  "remove_promo_code"
/*contact List Web-Service Methods*/
static let GET_EMERGENCY_CONTACT_LIST   =  "get_emergency_contact_list"
static let ADD_EMERGENCY_CONTACT   =  "add_emergency_contact"
static let DELETE_EMERGENCY_CONTACT   =  "delete_emergency_contact"
static let UPDATE_EMERGENCY_CONTACT   =  "update_emergency_contact"
static let SEND_SMS_TO_EMERGENCY_CONTACT   =  "send_sms_to_emergency_contact"
    

    /*History List Web-Service Methods*/
    static let GET_HISTORY_LIST   =  "userhistory"
    static let GET_INVOICE   =  "getuserinvoice"
    static let GET_HISTORY_DETAIL   = "usertripdetail"

    /*JETamigo Web-Service Methods*/
    static let GET_JETAMIGO_LIST   =  "get_referrals_history"
    static let GET_JETAMIGO_INVOICE   =  "getuserinvoice"
    static let GET_JETAMIGO_LIST_DETAIL   = "usertripdetail"

    /* Payment Related Web-Service Methods*/
    static let ADD_CARD = "addcard"
    static let DEFAULT_CARD = "card_selection"
    static let USER_GET_CARDS = "cards";
    static let DELETE_CARD = "delete_card"
    /*Map Screen Service */
   static let GET_FAVOURITE_ADDRESS_LIST   =   "get_home_address"
   static let SET_FAVOURITE_ADDRESS_LIST   =   "set_home_address"
   static let GET_LANGUAGE_LIST   =  "getlanguages"
    static let GET_GOOGLE_PATH_FROM_SERVER   =  "getgooglemappath";
    static let SET_GOOGLE_PATH_FROM_SERVER   =  "setgooglemappath";
    static let SET_DESTINATION_ADDRESS   =  "usersetdestination";
    static let RATE_PROVIDER   =  "usergiverating";
    static let  CHANGE_WALLET_STATUS  = "change_user_wallet_status"
    static let WS_GET_WALLET_HISTORY   =  "get_wallet_history"
    static let ADD_WALLET_AMOUNT = "add_wallet_amount"
    static let GET_USER_REFERAL_CREDIT = "get_user_referal_credit"
}

struct MessageCode
{
    static let USER_REGISTERED = "102"
}

struct SEGUE
{
    static let  INTRO_TO_PHONE = "segueIntroToPhone"
    static let  PHONE_TO_PASSWORD = "seguePhoneToPassword"
    static let  PHONE_TO_REGISTER = "seguePhoneToRegister"
    static let WALLET_HISTORY = "segueToWalletHistory"
    static let  FORGOT_PASSWORD_TO_NEW_PASSWORD = "segueForgotpasswordToNewpassword"
    static let  PASSWORD_TO_FORGOT_PASSWORD = "seguePasswordToForgotPassword"
    
    static let  LOGIN_TO_REFERRAL = "segueLoginToReferral"
    static let  REGISTER_TO_REFERRAL = "segueRegisterToReferral"
    static let  INTRO_TO_REFERRAL = "segueIntroToReferral"
    static let  INTRO_TO_REGISTER = "segueIntroToRegister"
    
    static let SET_DESTINATION_ADDRESS = "usersetdestination"
    static let TRIP_TO_FEEDBACK = "segueToFeedback"
    /*drawer SEGUE*/
    
    /*Map Segue*/
    static let  MAP_TO_ADDRESS  = "segueMapToAddress"
    static let  HOME_TO_PROFILE = "segueHomeToProfile"
    static let  HOME_TO_PAYMENT = "segueHomeToPayment"
    static let  HOME_TO_JETCASH = "segueHomeToJETcash"
    static let  HOME_TO_JETAMIGO = "segueHomeToJETamigo"
    static let  HOME_TO_JETANJO = "segueHomeToJETanjo"
    static let  HOME_TO_FAVOURITE_DRIVER = "segueHomeToFavouriteDriver"
    static let  HOME_TO_MY_BOOKING = "segueHomeToMyBooking"
    static let  HOME_TO_HISTORY = "segueHomeToHistory"
    static let  HOME_TO_SETTING = "segueHomeToSetting"
    static let  HOME_TO_CONTACT_US = "segueHomeToContactUs"
    
    static let  HOME_TO_DOCUMENTS =  "segueHomeToDocuments"
    static let  HISTORY_TO_HISTORY_DETAIL = "segueHistoryToHistoryDetail"
    static let  PAYMENT_TO_ADD_CARD = "seguePaymentToAddCard"
    
    static let  TRIP_TO_INVOICE = "segueToInvoice"
    static let WALLET_HISTORY_TO_WALLET_HISTORY_DETAIL = "segueToWalletHistoryDetail"
    static let  ADD_FAVOURITE_DRIVER = "segueToAddFavouriteDriver"
    static let  ADD_JET_ANJO = "segueToAddJETanjo"
    static let  HOME_TO_OWN_CREDIT = "segueToOwnCredit"
    static let  HOME_TO_BE_DRIVER = "segueToBeDriver"
}



struct PARAMS
{
    //Common

    static let IS_WALLET =  "is_use_wallet"
    static let DOCUMENT_ID = "document_id"
    static let UNIQUE_CODE = "unique_code"
    static let EXPIRED_DATE = "expired_date"
    static let _ID = "_id"
    static let ID = "id"
    static let IMAGE_URL = "picture_data"
    static let USER_ID = "user_id"
    static let PAYMENT_ID = "payment_id"
    static let TRIP_ID = "trip_id"
    static let TOKEN = "token"
    static let  TYPE = "type"
    static let  WALLET = "wallet"
    static let TIP_AMOUNT = "tip_amount"
    static let SERVICE_TYPE_ID = "service_type_id"
    static let CAR_RENTAL_ID = "car_rental_id"
    static let  TIME = "time"
    static let  DISTANCE = "distance"
    static let  IS_SURGE_HOURS = "is_surge_hours"
    static let  FIXED_PRICE = "fixed_price"
    static let  IS_FIXED_FARE = "is_fixed_fare"
    static let  CANCEL_TRIP_REASON = "cancel_reason";
    static let  CORPORATE_ID = "corporate_id";
    static let TRIP_TYPE = "trip_type"
    static let  IS_ACCEPTED = "is_accepted";
    static let IS_TRIP_UPDATED = "is_trip_updated"
    static let  DESTINATION_LATITUDE = "destination_latitude"
    static let  DESTINATION_LONGITUDE = "destination_longitude"
    
    static let  TRIP_DESTINATION_LATITUDE = "d_latitude"
    static let  TRIP_DESTINATION_LONGITUDE = "d_longitude"
    static let  TRIP_DESTINATION_ADDRESS = "destination_address"
    
    
    
    static let  PICKUP_LATITUDE = "pickup_latitude"
    static let  PICKUP_LONGITUDE = "pickup_longitude"
    static let  TRIP_PICKUP_ADDRESS = "source_address"
    static let  MAP_IMAGE = "map";
    
    static let  RATING = "rating";
    static let  REVIEW = "review";
    
    //Register login
    static let CPF = "cpf"
    static let PHONE = "phone"
    static let PASSWORD = "password"
    static let EMAIL = "email"
    static let COUNTRY_PHONE_CODE = "country_phone_code"
    static let COUNTRY_CODE = "country_code"
    
    
    static let USER_SMS="userSms"
    static let SMS_OTP = "otpForSMS"
    static let EMAIL_OTP = "otpForEmail"
    static let APP_VERSION = "app_version"
    static let ADDRESS = "address";
    static let USER_APPROVED = "is_approved"
    static let  FIRST_NAME = "first_name"
    static let  LAST_NAME = "last_name"
    static let  PICTURE = "picture"
    static let  DEVICE_TOKEN = "device_token"
    static let  DEVICE_TYPE = "device_type"
    static let  PLACE_ID = "place_id"
    static let  COUNTRY = "country"
    static let  CITY = "city"
    static let  LOGIN_BY = "login_by"
    static let  SOCIAL_UNIQUE_ID = "social_unique_id"
    static let  SOCIAL_IDS = "social_ids"
    static let  REFERRAL_SKIP = "is_skip"
    static let  OLD_PASSWORD = "old_password"
    static let  NEW_PASSWORD = "new_password"
    static let  REFERRAL_CODE = "referral_code"
    
    
    
    static let  LAST_FOUR = "last_four"
    static let PAYMENT_TOKEN="payment_token";
    static let PAYMENT_MODE = "payment_mode";
    static let SURGE_MULTIPLIER = "surge_multiplier";
    static let PAYMENT_TYPE = "payment_type";
    static let CARD_TYPE = "card_type"
    static let CARD_ID = "card_id"
    static let CARD_EXPIRY_DATE = "card_expiry_date"
    static let CARD_HOLDER_NAME = "card_holder_name"
    
    static let  PROMO_CODE = "promocode"
    static let  PROMO_ID = "promo_id"
    static let LATITUDE = "latitude"
    static let LONGITUDE = "longitude"
    static let PROVIDER_LANGUAGE = "provider_language"
    static let PROVIDER_ID = "provider_id"
    static let VEHICLE_ACCESSIBILITY = "accessibility"
    static let PROVIDER_GENDER = "received_trip_from_gender"
    static let  DEVICE_TIMEZONE = "device_timezone"
    static let TIMEZONE = "timezone"
    static let  DISTANCE_UNIT = "unit"
    static let  EMAIL_VERIFICATION_ON = "userEmailVerification"
    static let  USER_CREATE_TIME = "user_create_time"
    static let  SCHEDULED_REQUEST_PRE_START_TIME = "scheduledRequestPreStartMinute"
    static let  USER_PATH_DRAW = "userPath"
    static let  NAME = "name";
    static let  IS_ALWAYS_SHARE_RIDE_DETAIL = "is_always_share_ride_detail";
    static let  EMERGENCY_CONTACT_DETAIL_ID = "emergency_contact_detail_id";
    
    /*history*/
    static let  START_DATE = "start_date"
    static let  END_DATE = "end_date";
    static let  START_TIME = "start_time"
    //Home And Work Address
    static let  HOME_ADDRESS = "home_address"
    static let  HOME_LATITUDE = "home_latitude";
    static let  HOME_LONGITUDE = "home_longitude"
    static let  WORK_ADDRESS = "work_address";
    static let  WORK_LATITUDE = "work_latitude"
    static let  WORK_LONGITUDE = "work_longitude";

    static let SEARCH_VALUE = "search_value";
    static let CITY_ID = "city_id"
    static let COUNTRY_ID = "country_id"

    static let GOOGLE_PATH_START_LOCATION_TO_PICKUP_LOCATION = "googlePathStartLocationToPickupLocation"
    static let GOOGLE_PICKUP_LOCATION_TO_DESTINATION_LOCATION = "googlePickUpLocationToDestinationLocation"




    
}

struct CONSTANT
{
    static let MANUAL = "manual"
    static let SOCIAL = "social"
    static let IOS = "ios"
    static let SMS_VERIFICATION_ON = 1
    static let EMAIL_VERIFICATION_ON = 2
    static let SMS_AND_EMAIL_VERIFICATION_ON = 3
    static let DELIVERY_LIST = "delivery_list"
    static let SELECTED_STORE="selected_store"
    static let DELIVERY_STORE="delivery_store"
    static let TYPE_USER = 10
    static var STRIPE_KEY = ""
    static let UPDATE_URL = "https://itunes.apple.com/us/app/id1276529954?ls=1&mt=8"
    struct  DBPROVIDER
    {
        static let MESSAGES = "MESSAGES"
        static let MEDIA_MESSAGES = "media_message"
        static let USER = "user"
        static let IMAGE_STORAGE = "image_storage"
        static let VIDEO_STORAGE = "video_storage"
        static let EMAIL = "email"
        static let PASSWORD = "password"
        
    }
    struct MESSAGES {
        static let ID = "id"
        static let TYPE = "type"
        static let TEXT = "message"
        static let TIME = "time"
        static let STATUS = "is_read"
    }
    
}

struct DateFormat
{
    static let TIME_FORMAT_AM_PM = "hh:mm a"
    static let WEB   = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let DATE_TIME_FORMAT = "dd MMMM yyyy, HH:mm"
    
    static let HISTORY_TIME_FORMAT = "hh:mm a"
    static let DATE_FORMAT = "yyyy-MM-dd"
    static let DATE_FORMAT_MONTH = "MMMM yyyy"
    static let DATE_DD_MM_YYYY = "dd/MM/yyyy"
    static let DATE_DD_MON_YYYY = "dd/MMM/yyyy"
    static let TIME_FORMAT_HH_MM = "HH:mm"
    static let DATE_TIME_FORMAT_AM_PM = "yyyy-MM-dd HH:mm"
    static let SCHEDUALE_DATE_FORMATE = "EEEE d MMMM 'at' HH:mm"
    static let MESSAGE_FORMAT = "yyyy-MM-dd, hh:mm a"
}

enum WalletHistoryStatus:Int
{
    case  ADDED_BY_ADMIN = 1
    case  ADDED_BY_CARD = 2
    case  ADDED_BY_REFERRAL = 3
    case  ORDER_CHARGED = 4
    case  ORDER_REFUND = 5
    case  ORDER_PROFIT = 6
    case  ORDER_CANCELLATION_CHARGE = 7
    case  WALLET_REQUEST_CHARGE = 8
    case  Unknown
    func text() -> String
    {
        switch self
        {
        case .ADDED_BY_ADMIN : return "WALLET_STATUS_ADDED_BY_ADMIN".localized   case .ADDED_BY_CARD : return "WALLET_STATUS_ADDED_BY_CARD".localized        case .ADDED_BY_REFERRAL : return "WALLET_STATUS_ADDED_BY_REFERRAL".localized        case .ORDER_CHARGED : return "WALLET_STATUS_ORDER_CHARGED".localized        case .ORDER_REFUND : return "WALLET_STATUS_ORDER_REFUND".localized        case .ORDER_PROFIT : return "WALLET_STATUS_ORDER_PROFIT".localized        case .ORDER_CANCELLATION_CHARGE : return"WALLET_STATUS_ORDER_CANCELLATION_CHARGE".localized        case .WALLET_REQUEST_CHARGE : return "WALLET_STATUS_WALLET_REQUEST_CHARGE".localized        default: return "Unknown"
            
        }
        
    }
};
struct Google
{
    static let GEOCODE_URL = "https://maps.googleapis.com/maps/api/geocode/json?"
    static let AUTO_COMPLETE_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    static let TIME_DISTANCE_URL = "https://maps.googleapis.com/maps/api/distancematrix/json?"
    static let DIRECTION_URL = "https://maps.googleapis.com/maps/api/directions/json?"
    //MARK: Keys
    
    static var MAP_KEY = "AIzaSyC8oPUp66DYkrqyvnx4VgpCUQ_J4pn7m5U"
    static var CLIENT_ID = "754759762565-c0r2ntlbdasvf4jmhjol04jcg3pbmbeu.apps.googleusercontent.com"
    /*Google Parameters*/
    static let  OK = "OK"
    static let  STATUS = "status"
    static let  RESULTS = "results"
    static let  GEOMETRY = "geometry"
    static let  LOCATION = "location"
    static let  ADDRESS_COMPONENTS = "address_components"
    static let  LONG_NAME = "long_name"
    static let  ADMINISTRATIVE_AREA_LEVEL_2 = "administrative_area_level_2"
    static let  ADMINISTRATIVE_AREA_LEVEL_1 = "administrative_area_level_1"
    static let  COUNTRY = "country"
    static let  COUNTRY_CODE = "country_code"
    static let  SHORT_NAME = "short_name"
    static let  TYPES = "types"
    static let  LOCALITY = "locality"
    static let  PREDICTIONS = "predictions"
    static let  LAT = "lat"
    static let  LNG = "lng"
    static let  NAME = "name"
    static let  DESTINATION_ADDRESSES = "destination_addresses"
    static let  ORIGIN_ADDRESSES = "origin_addresses"
    static let  ROWS = "rows"
    static let  ELEMENTS = "elements"
    static let  DISTANCE = "distance"
    static let  VALUE = "value"
    static let  DURATION = "duration"
    static let  TEXT = "text"
    static let  ROUTES = "routes"
    static let  LEGS = "legs"
    static let  STEPS = "steps"
    static let  POLYLINE = "polyline"
    static let  POINTS = "points"
    static let  ORIGIN = "origin"
    static let  ORIGINS = "origins"
    static let  DESTINATION = "destination"
    static let  DESTINATIONS = "destinations"
    static let  DESCRIPTION = "description"
    static let  KEY = "key"
    static let  EMAIL = "email"
    static let  ID = "id"
    static let  PICTURE = "picture"
    static let  URL = "url"
    static let  DATA = "data"
    static let  RADIUS = "radius"
    static let  FIELDS = "fields"
    static let  ADDRESS = "address"
    static let  FORMATTED_ADDRESS = "formatted_address"
    static let  LAT_LNG = "latlng"
    static let  STRUCTURED_FORMATTING = "structured_formatting"
    static let  MAIN_TEXT = "main_text"
    static let  SECONDARY_TEXT = "secondary_text"
    static let PLACE_ID = "place_id"
}

enum Day: Int
{
    case SUN = 0
    case MON = 1
    case TUE = 2
    case WED = 3
    case THU = 4
    case FRI = 5
    case SAT = 6
    func text() -> String
    {
        switch self
        {
            
        case .SUN : return "SUN".localized
        case .MON : return "MON".localized
        case .TUE : return "TUE".localized
        case .WED : return "WED".localized
        case .THU: return "THU".localized
        case .FRI : return "FRI".localized
        case .SAT : return "SAT".localized
        }
    }
}

struct VehicleAccessibity
{
    static let HANDICAP = "handicap";
    static let BABY_SEAT = "baby_seat";
    static let HOTSPOT = "hotspot";
}
struct Gender
{
    static let MALE = "male";
    static let FEMALE = "female";
}

enum TripStatus: Int
{
    case Normal = 0
    case Accepted = 1
    case Coming = 2
    case Arrived = 4
    case Started = 6
    case End = 8
    case Completed = 9
    case Unknown
    func text() -> String
    {
        switch self
        {
        case .Accepted : return "TRIP_STATUS_ACCEPTED".localized
        case .Coming : return "TRIP_STATUS_COMING".localized
        case .Arrived : return "TRIP_STATUS_ARRIVED".localized
        case .Started : return "TRIP_STATUS_STARTED".localized
        case .End: return "TRIP_STATUS_END".localized
        case .Completed : return "TRIP_STATUS_COMPLETED".localized
        case .Normal : return "TRIP_STATUS_WAITING_FOR_ACCEPT".localized
        default: return "Unknown"
        }
    }
}
