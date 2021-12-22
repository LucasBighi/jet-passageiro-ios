//
//  PreferenceHelper.swift
//  tableViewDemo
//
//  Created by Elluminati on 12/01/17.
//  Copyright © 2017 tag. All rights reserved.
//

import UIKit

class PreferenceHelper: NSObject
{
    
    // MARK: Setting Preference Keys
    private let KEY_GOOGLE_KEY = "google_key";
    private let KEY_STRIPE_KEY = "stripe_key";
    
    private let KEY_CONTACT_EMAIL = "contact_email"
    private let KEY_CONTACT_NUMBER = "contact_number"
    
    
    private let KEY_LANGUAGE = "language"
    
    private let KEY_TERMS_AND_CONDITION = "terms_and_condition"
    private let KEY_PRIVACY_AND_POLICY = "privacy_and_policy"
    
    private let KEY_IS_EMAIL_VERIFICATION = "email_verification"
    
    private let KEY_IS_PHONE_NUMBER_VERIFICATION = "phone_number_verification"
    private let KEY_IS_REQUIRED_FORCE_UPDATE = "is_force_update_required"
    
    
    private let KEY_IS_PATH_DRAW = "is_path_draw"
    private let KEY_PRE_TRIP_TIME = "pre_trip_time"
    private let KEY_LATEST_VERSION = "latest_version"
    private let KEY_TWILLIO_ENABLE = "twillio_enable"
    
    
    
    // MARK: User Preference Keys
    private let KEY_IS_SOUND_ON = "is_sound_on"
    private let KEY_IS_PUSH_SOUND_ON = "is_push_sound_on"
    private let KEY_IS_DRIVER_ARRIVED_SOUND = "is_driver_arrived_sound_on";
    private let KEY_IS_ADMIN_DOCUMENT_MANDATORY = "is_admin_document_mandatory";
    
    
    
    // MARK: User Preference Keys
    private let KEY_USER_ID = "user_id"
    private let KEY_SESSION_TOKEN = "session_token"
    private let KEY_DEVICE_TOKEN = "device_token";
    private let KEY_CHAT_NAME = "chat_name"
    private let KEY_PHONE_NUMBER_MAX_LENGTH = "phone_number_max_length";
    private let KEY_PHONE_NUMBER_MIN_LENGTH = "phone_number_min_length";
    private let KEY_IS_USER_SHOW_ETA = "is_user_show_eta"
    private let KEY_LANGUAGE_CODE = "language_code"
    let ph = UserDefaults.standard;
    static let preferenceHelper = PreferenceHelper()
    private override init(){
    }
    
    deinit {
        printE("\(self) \(#function)")
    }
    
// MARK: Getter Setters

    func getLanguageCode() -> String {
        return (ph.value(forKey: KEY_LANGUAGE_CODE) as? String) ?? "pt"
    }
    func setLanguageCode(code: String) {
        ph.set(code, forKey: KEY_LANGUAGE_CODE);
        ph.synchronize();
    }
    func setIsShowEta(_ isOn: Bool) {
        ph.set(isOn, forKey: KEY_IS_USER_SHOW_ETA);
        ph.synchronize();
    }

    func getIsShowEta() -> Bool {
        return (ph.value(forKey: KEY_IS_USER_SHOW_ETA) as? Bool) ?? false
    }


    func setIsTwillioEnable(_ isEnable:Bool)
    {
        ph.set(isEnable, forKey: KEY_TWILLIO_ENABLE);
        ph.synchronize();
    }
    func getIsTwillioEnable() -> Bool
    {
        return (ph.value(forKey: KEY_TWILLIO_ENABLE) as? Bool) ?? false
    }
    
    
   
   
    func setContactEmail(_ email:String){
        ph.set(email, forKey: KEY_CONTACT_EMAIL);
        ph.synchronize();
    }
    func getContactEmail() -> String{
        return (ph.value(forKey: KEY_CONTACT_EMAIL) as? String) ?? ""
    }
    func setChatName(_ name:String){
        ph.set(name, forKey: KEY_CHAT_NAME);
        ph.synchronize();
    }
    func getChatName() -> String{
        return (ph.value(forKey: KEY_CHAT_NAME) as? String) ?? ""
    }
    
    
    func setContactNumber(_ contact:String)
    {
        ph.set(contact, forKey: KEY_CONTACT_NUMBER);
        ph.synchronize();
    }
    func getContactNumber() -> String
    {
        return (ph.value(forKey: KEY_CONTACT_NUMBER) as? String) ?? ""
    }
    
     func setTermsAndCondition(_ url:String)
    {
        ph.set(url, forKey: KEY_TERMS_AND_CONDITION);
        ph.synchronize();
    }
    func getTermsAndCondition() -> String
    {
        return (ph.value(forKey: KEY_TERMS_AND_CONDITION) as? String) ?? ""
    }
    
    func setPrivacyPolicy(_ url:String)
    {
        ph.set(url, forKey: KEY_PRIVACY_AND_POLICY);
        ph.synchronize();
    }
    func getPrivacyPolicy() -> String
    {
        return (ph.value(forKey: KEY_PRIVACY_AND_POLICY) as? String) ?? ""
    }
    
    func setIsEmailVerification(_ isEmailVerification:Bool)
    {
        ph.set(isEmailVerification, forKey: KEY_IS_EMAIL_VERIFICATION);
        ph.synchronize();
    }
    func getIsEmailVerification() -> Bool
    {
        return (ph.value(forKey: KEY_IS_EMAIL_VERIFICATION) as? Bool) ?? false
    }
    
    
    func setIsPhoneNumberVerification(_ isPhoneNumberVerification:Bool)
    {
        ph.set(isPhoneNumberVerification, forKey: KEY_IS_PHONE_NUMBER_VERIFICATION);
        ph.synchronize();
    }
    func getIsPhoneNumberVerification() -> Bool
    {
        return (ph.value(forKey: KEY_IS_PHONE_NUMBER_VERIFICATION) as? Bool) ?? false
    }
 
    func setIsRequiredForceUpdate(_ fUpdate:Bool)
    {
        ph.set(fUpdate, forKey: KEY_IS_REQUIRED_FORCE_UPDATE);
        ph.synchronize();
    }
    func getIsRequiredForceUpdate() -> Bool
    {
        return (ph.value(forKey: KEY_IS_REQUIRED_FORCE_UPDATE) as? Bool) ?? false
    }
    
    func setGoogleKey(_ googleKey:String)
    {
        ph.set(googleKey, forKey: KEY_GOOGLE_KEY);
        ph.synchronize();
    }
    func getGoogleKey() -> String
    {
        return (ph.value(forKey: KEY_GOOGLE_KEY) as? String) ?? ""
    }
    
    func setStripeKey(_ stripeKey:String)
    {
        ph.set(stripeKey, forKey: KEY_STRIPE_KEY);
        ph.synchronize();
    }
    func getStripeKey() -> String
    {
        return (ph.value(forKey: KEY_STRIPE_KEY) as? String) ?? ""
    }
    func setIsPathdraw(_ isPathDraw:Bool)
    {
        ph.set(isPathDraw, forKey: KEY_IS_PATH_DRAW);
        ph.synchronize();
    }
    func getIsPathdraw() -> Bool
    {
        return (ph.value(forKey: KEY_IS_PATH_DRAW) as? Bool) ?? false
    }
    
    
    func setIsArivedSoundOn(_ isOn:Bool)
    {
        ph.set(isOn, forKey: KEY_IS_DRIVER_ARRIVED_SOUND);
        ph.synchronize();
    }
    func getIsArivedSoundOn() -> Bool
    {
        return (ph.value(forKey: KEY_IS_DRIVER_ARRIVED_SOUND) as? Bool) ?? true
    }
    
    func setIsSoundOn(_ isOn:Bool)
    {
        ph.set(isOn, forKey: KEY_IS_SOUND_ON);
        ph.synchronize();
    }
    func getIsSoundOn() -> Bool
    {
        return (ph.value(forKey: KEY_IS_SOUND_ON) as? Bool) ?? true
    }
    
    func setIsPushSoundOn(_ isOn:Bool)
    {
        ph.set(isOn, forKey: KEY_IS_PUSH_SOUND_ON);
        ph.synchronize();
    }
    func getIsPushSoundOn() -> Bool
    {
        return (ph.value(forKey: KEY_IS_PUSH_SOUND_ON) as? Bool) ?? true
    }
    
    func getMaxPhoneNumberLength() -> Int {
        return (ph.value(forKey: KEY_PHONE_NUMBER_MAX_LENGTH) as? Int) ?? 12
    }

    func setMaxPhoneNumberLength(_ length:Int) {
        ph.set(length, forKey: KEY_PHONE_NUMBER_MAX_LENGTH);
        ph.synchronize();
    }
    func getMinPhoneNumberLength() -> Int {
        return (ph.value(forKey: KEY_PHONE_NUMBER_MIN_LENGTH) as? Int) ?? 8
    }

    func setMinPhoneNumberLength(_ length:Int)
    {
        ph.set(length, forKey: KEY_PHONE_NUMBER_MIN_LENGTH);
        ph.synchronize();
    }
    
    
    func setPreSchedualTripTime(_ timeInMin:Int)
    {
        ph.set(timeInMin, forKey: KEY_PRE_TRIP_TIME);
        ph.synchronize();
    }
    func getPreSchedualTripTime() -> Int
    {
        return (ph.value(forKey: KEY_PRE_TRIP_TIME) as? Int) ?? 0
    }
    
    func setLatestVersion(_ version:String)
    {
        ph.set(version, forKey: KEY_LATEST_VERSION);
        ph.synchronize();
    }
    func getLatestVersion() -> String
    {
        return (ph.value(forKey: KEY_LATEST_VERSION) as? String) ?? ""
    }
    // MARK: Preference User Getter Setters
    func setDeviceToken(_ token:String)
    {
        ph.set(token, forKey: KEY_DEVICE_TOKEN);
        ph.synchronize();
    }
    func setLanguage(_ index:Int)
    {
        ph.set(index, forKey: KEY_LANGUAGE);
        ph.synchronize();
    }
    func getLanguage() -> (Int)
    {
        return (ph.value(forKey: KEY_LANGUAGE) as? Int) ?? 0
    }
    func getDeviceToken() -> String
    {
        return (ph.value(forKey: KEY_DEVICE_TOKEN) as? String) ?? ""
    }
    
    func setUserId(_ userId:String)
    {
        ph.set(userId, forKey: KEY_USER_ID);
        ph.synchronize();
    }
    func getUserId() -> String
    {
        return (ph.value(forKey: KEY_USER_ID) as? String) ?? ""
    }
    
    func setSessionToken(_ sessionToken:String)
    {
        ph.set(sessionToken, forKey: KEY_SESSION_TOKEN);
        ph.synchronize();
    }
    func getSessionToken() -> String
    {
        return (ph.value(forKey: KEY_SESSION_TOKEN) as? String) ?? ""
    }
    
    func clearAll()
    {
        ph.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        ph.synchronize();
    }
}
