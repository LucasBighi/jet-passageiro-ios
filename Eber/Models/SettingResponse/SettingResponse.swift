//
//	SettingResponse.swift
//
//	Create by MacPro3 on 7/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class SettingResponse: ModelNSObj {

	var adminPhone : String!
	var contactUsEmail : String!
	
    var iosUserAppForceUpdate : Bool!
	var iosUserAppGoogleKey : String!
	var iosUserAppVersionCode : String!
    var userEmailVerification : Bool!
    var userPath : Bool!
    var userSms : Bool!

    
	var isTip : Bool!
    var isShowEta : Bool!
	var scheduledRequestPreStartMinute : Int!
	var stripePublishableKey : String!
    var imageBaseUrl : String!
	var isTwilioCallMasking : Bool!
	var success : Bool!
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		adminPhone = (dictionary["admin_phone"] as? String) ?? ""

		contactUsEmail = (dictionary["contactUsEmail"] as? String) ?? ""
		iosUserAppForceUpdate = (dictionary["ios_user_app_force_update"] as? Bool) ?? false
         imageBaseUrl = (dictionary["image_base_url"] as? String) ?? ""
		iosUserAppGoogleKey = (dictionary["ios_user_app_google_key"] as? String) ?? ""
		iosUserAppVersionCode = (dictionary["ios_user_app_version_code"] as? String) ?? ""
        
        userEmailVerification = (dictionary["userEmailVerification"] as? Bool) ?? false
        userPath = (dictionary["userPath"] as? Bool) ?? false
        userSms = (dictionary["userSms"] as? Bool) ?? false
        isTwilioCallMasking = (dictionary["twilio_call_masking"] as? Bool) ?? false
        isShowEta = (dictionary["is_show_estimation_in_user_app"] as? Bool) ?? false
        isTip = (dictionary["is_tip"] as? Bool) ?? false
		scheduledRequestPreStartMinute = (dictionary["scheduled_request_pre_start_minute"] as? Int) ?? 0
		stripePublishableKey = (dictionary["stripe_publishable_key"] as? String) ?? ""
		success = (dictionary["success"] as? Bool) ?? false
		
		
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if adminPhone != nil{
			dictionary["admin_phone"] = adminPhone
		}
        if isShowEta != nil{
            dictionary["is_show_estimation_in_user_app"] = isShowEta
        }
		if iosUserAppForceUpdate != nil{
			dictionary["ios_user_app_force_update"] = iosUserAppForceUpdate
		}
		if iosUserAppGoogleKey != nil{
			dictionary["ios_user_app_google_key"] = iosUserAppGoogleKey
		}
		if iosUserAppVersionCode != nil{
			dictionary["ios_user_app_version_code"] = iosUserAppVersionCode
		}
		
		if isTip != nil{
			dictionary["is_tip"] = isTip
		}
		
		
		if scheduledRequestPreStartMinute != nil{
			dictionary["scheduled_request_pre_start_minute"] = scheduledRequestPreStartMinute
		}
		if stripePublishableKey != nil{
			dictionary["stripe_publishable_key"] = stripePublishableKey
		}
        
        if isTwilioCallMasking != nil{
            dictionary["twilio_call_masking"] = isTwilioCallMasking
        }
		if success != nil{
			dictionary["success"] = success
		}
		if userEmailVerification != nil{
			dictionary["userEmailVerification"] = userEmailVerification
		}
		if userPath != nil{
			dictionary["userPath"] = userPath
		}
		if userSms != nil{
			dictionary["userSms"] = userSms
		}
		return dictionary
	}

    

}
