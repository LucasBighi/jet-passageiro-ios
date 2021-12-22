//
//	UserDataResponse.swift
//
//	Create by MacPro3 on 10/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class UserDataResponse: ModelNSObj
{
    var firstName : String!
    var lastName : String!
    var cpf: String!
	var address : String!
	
    var city : String!
	var country : String!
	var countryDetail : CountryDetail!
	var countryPhoneCode : String!
	var email : String!
	
    
	var isApproved : Int!
	var isDocumentUploaded : Int!
	var isReferral : Int!
    
	
	var message : String!
	var phone : String!
	var picture : String!
	var referralCode : String!
    
	var socialIds : [String]!
	var socialUniqueId : String!
	var success : Bool!
	var token : String!
	var userId : String!
    
    var providerId : String!
    var tripId : String!
    var tripStatus : Int!
    var isProviderAccepted : Int!
	
    var corporateDetail:CorporateDetail = CorporateDetail.init(fromDictionary: [:])
    var walletCurrencyCode : String!
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any])
    {
		address = (dictionary["address"] as? String) ?? ""
		
        city = (dictionary["city"] as? String) ?? ""
		country = (dictionary["country"] as? String) ?? ""
        countryDetail = CountryDetail(fromDictionary: [:])
		if let countryDetailData = (dictionary["country_detail"] as? [String:Any])
        {
			countryDetail = CountryDetail(fromDictionary: countryDetailData)
		}
		countryPhoneCode = (dictionary["country_phone_code"] as? String) ?? ""
		email = (dictionary["email"] as? String) ?? ""
		firstName = (dictionary["first_name"] as? String) ?? ""
		isApproved = (dictionary["is_approved"] as? Int) ?? 0
        isDocumentUploaded = (dictionary["is_document_uploaded"] as? Int) ?? 0
		isReferral = (dictionary["is_referral"] as? Int) ?? 0
		lastName = (dictionary["last_name"] as? String) ?? ""
        cpf = (dictionary["cpf"] as? String) ?? ""
		message = (dictionary["message"] as? String) ?? ""
		phone = (dictionary["phone"] as? String) ?? ""
		picture = (dictionary["picture"] as? String) ?? ""
		referralCode = (dictionary["referral_code"] as? String) ?? ""
		socialIds = (dictionary["social_ids"] as? [String]) ?? []
		socialUniqueId = (dictionary["social_unique_id"] as? String) ?? ""
		success = (dictionary["success"] as? Bool ) ?? false
       
		token = (dictionary["token"] as? String) ?? ""
		userId = (dictionary["user_id"] as? String) ?? ""
        
        tripId = (dictionary["trip_id"] as? String) ?? ""
        providerId = (dictionary["provider_id"] as? String) ?? ""
        isProviderAccepted = (dictionary["is_provider_accepted"] as? Int) ?? 0
        tripStatus = (dictionary["is_provider_status"] as? Int) ?? 0
        walletCurrencyCode = (dictionary["wallet_currency_code"] as? String) ?? ""
        if let corporateData = (dictionary["corporate_detail"] as? [String:Any])
        {
            corporateDetail = CorporateDetail.init(fromDictionary: corporateData)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if address != nil{
			dictionary["address"] = address
		}
		
		if city != nil{
			dictionary["city"] = city
		}
		if country != nil{
			dictionary["country"] = country
		}
		if countryDetail != nil{
			dictionary["country_detail"] = countryDetail.toDictionary()
		}
		if countryPhoneCode != nil{
			dictionary["country_phone_code"] = countryPhoneCode
		}
		
		
		if email != nil{
			dictionary["email"] = email
		}
        if walletCurrencyCode != nil{
            dictionary["wallet_currency_code"] = email
        }
		if firstName != nil{
			dictionary["first_name"] = firstName
		}
		
		if isApproved != nil{
			dictionary["is_approved"] = isApproved
		}
		if isDocumentUploaded != nil{
			dictionary["is_document_uploaded"] = isDocumentUploaded
		}
		if isReferral != nil{
			dictionary["is_referral"] = isReferral
		}
		if lastName != nil{
			dictionary["last_name"] = lastName
		}
		
		if message != nil{
			dictionary["message"] = message
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if picture != nil{
			dictionary["picture"] = picture
		}
		if referralCode != nil{
			dictionary["referral_code"] = referralCode
		}
		if socialIds != nil{
			dictionary["social_ids"] = socialIds
		}
		if socialUniqueId != nil{
			dictionary["social_unique_id"] = socialUniqueId
		}
		if success != nil{
			dictionary["success"] = success
		}
		if token != nil{
			dictionary["token"] = token
		}
		if userId != nil{
			dictionary["user_id"] = userId
		}
		
		return dictionary
	}

   

}


class CorporateDetail : NSObject{
    
    var id : String = ""
    var countryPhoneCode : String = ""
    var name : String = ""
    var phone : String = ""
    var status : Int = 0
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = (dictionary["_id"] as? String) ?? ""
        countryPhoneCode = (dictionary["country_phone_code"] as? String) ?? ""
        name = (dictionary["name"] as? String) ?? ""
        phone = (dictionary["phone"] as? String) ?? ""
        status = (dictionary["status"] as? Int) ?? 0
    }
    
    
    
}
