//
//	FareEstimateResponse.swift
//
//	Create by MacPro3 on 20/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class FareEstimateResponse: Model {

	var basePrice : Double!
	var distance : String!
	var estimatedFare : Double!
	var isMinFareUsed : Int!
	var message : String!
	var pricePerUnitDistance : String!
	var pricePerUnitTime : Double!
	var success : Bool!
	var time : Double!
	var tripType : String!
	var userMiscellaneousFee : Double!
	var userTaxFee : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		basePrice = (dictionary["base_price"] as? Double) ?? 0.0
		distance = (dictionary["distance"] as? String) ?? ""
		estimatedFare = (dictionary["estimated_fare"] as? Double) ?? 0.0
		isMinFareUsed = (dictionary["is_min_fare_used"] as?  Int) ?? 0
		message = (dictionary["message"] as? String) ?? ""
		pricePerUnitDistance = (dictionary["price_per_unit_distance"] as? String) ?? ""
		pricePerUnitTime = (dictionary["price_per_unit_time"] as? Double) ?? 0.0
		success = (dictionary["success"] as? Bool) ?? false
		time = (dictionary["time"] as? Double) ?? 0.0
		tripType = (dictionary["trip_type"] as? String) ?? ""
		userMiscellaneousFee = (dictionary["user_miscellaneous_fee"] as? Double) ?? 0.0
		userTaxFee = (dictionary["user_tax_fee"] as? Int) ?? 0
	}

}
