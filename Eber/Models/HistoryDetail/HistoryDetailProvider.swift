//
//	HistoryDetailProvider.swift
//
//	Create by MacPro3 on 12/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class HistoryDetailProvider: ModelNSObj
{

	var v : Int!
	var id : String!
	var carModel : String!
	var carNumber : String!
	var countryPhoneCode : String!
	var createdAt : String!
	var email : String!
	var firstName : String!
	var gender : String!
	var languages : [String]!
	var lastName : String!
	var phone : String!
	var picture : String!
	var providerType : Int!
	var rate : Double!
	var rateCount : Int!
	var serviceType : String!

	

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = (dictionary["__v"] as? Int ) ?? 0
		id = (dictionary["_id"] as? String) ?? ""
		
		carModel = (dictionary["car_model"] as? String) ?? ""
		carNumber = (dictionary["car_number"] as? String) ?? ""
	
		countryPhoneCode = (dictionary["country_phone_code"] as? String) ?? ""
		createdAt = (dictionary["created_at"] as? String) ?? ""
	
		email = (dictionary["email"] as? String) ?? ""
		firstName = (dictionary["first_name"] as? String) ?? ""
		gender = (dictionary["gender"] as? String) ?? ""
		
		
		lastName = (dictionary["last_name"] as? String) ?? ""
		phone = (dictionary["phone"] as? String) ?? ""
		picture = (dictionary["picture"] as? String) ?? ""
		providerType = (dictionary["provider_type"] as? Int ) ?? 0
		rate = (dictionary["rate"] as? Double) ?? 0.0
		rateCount = (dictionary["rate_count"] as? Int ) ?? 0
		serviceType = (dictionary["service_type"] as? String) ?? ""
		
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if v != nil{
			dictionary["__v"] = v
		}
		if id != nil{
			dictionary["_id"] = id
		}
		
		if countryPhoneCode != nil{
			dictionary["country_phone_code"] = countryPhoneCode
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		
		if email != nil{
			dictionary["email"] = email
		}
		if firstName != nil{
			dictionary["first_name"] = firstName
		}
		if gender != nil{
			dictionary["gender"] = gender
		}
		
		
		if languages != nil{
			dictionary["languages"] = languages
		}
		if lastName != nil{
			dictionary["last_name"] = lastName
		}
	
		if phone != nil{
			dictionary["phone"] = phone
		}
		if picture != nil{
			dictionary["picture"] = picture
		}
	
		if providerType != nil{
			dictionary["provider_type"] = providerType
		}
		
		if rate != nil{
			dictionary["rate"] = rate
		}
		if rateCount != nil{
			dictionary["rate_count"] = rateCount
		}
		
		if serviceType != nil{
			dictionary["service_type"] = serviceType
		}
		
		
		
		return dictionary
	}

  
}
