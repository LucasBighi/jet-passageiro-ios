//
//	CreateTripRespose.swift
//
//	Create by MacPro3 on 29/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class CreateTripRespose: Model {

	var bio : String!
	var carModel : String!
	var carNumber : String!
	var firstName : String!
	var lastName : String!
	var message : String!
	var phone : String!
	var picture : String!
	var providerId : String!
	var serviceType : String!
	var sourceLocation : [Double]!
	var success : Bool!
	var tripId : String!
	var userId : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		bio = (dictionary["bio"] as? String) ?? ""
		carModel = (dictionary["car_model"] as? String) ?? ""
		carNumber = (dictionary["car_number"] as? String) ?? ""
		firstName = (dictionary["first_name"] as? String) ?? ""
		lastName = (dictionary["last_name"] as? String) ?? ""
		message = (dictionary["message"] as? String) ?? ""
		phone = (dictionary["phone"] as? String) ?? ""
		picture = (dictionary["picture"] as? String) ?? ""
		providerId = (dictionary["provider_id"] as? String) ?? ""
		serviceType = (dictionary["service_type"] as? String) ?? ""
		sourceLocation = (dictionary["sourceLocation"] as? [Double]) ?? [0.0,0.0]
		success = (dictionary["success"] as? Bool) ?? false
		tripId = (dictionary["trip_id"] as? String) ?? ""
		userId = (dictionary["user_id"] as? String) ?? ""
	}

}
