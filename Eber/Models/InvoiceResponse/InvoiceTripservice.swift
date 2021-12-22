//
//	InvoiceTripservice.swift
//
//	Create by MacPro3 on 4/10/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class InvoiceTripservice: Model {

	var v : Int!
	var id : String!
	var basePrice : Double!
	var basePriceDistance : Double!
	var cancellationFee : Double!
	var cityId : String!
	var createdAt : String!
	var isSurgeHours : Int!
	var maxSpace : Int!
	var minFare : Double!
	var priceForTotalTime : Double!
	var priceForWaitingTime : Double!
	var pricePerUnitDistance : Double!
	var providerMiscellaneousFee : Double!
	var providerProfit : Double!
	var providerTax : Double!
	var serviceTypeId : String!
	var serviceTypeName : String!
	var surgeEndHour : Int!
	var surgeMultiplier : Double!
	var surgeStartHour : Int!
	var tax : Double!
	var updatedAt : String!
	var userMiscellaneousFee : Double!
	var userTax : Double!
	var waitingTimeStartAfterMinute : Int!
    var basePriceTime : Double!
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = (dictionary["__v"] as? Int) ?? 0
		id = (dictionary["_id"] as? String) ?? ""
        basePriceTime = (dictionary["base_price_time"] as? Double) ?? 0.0
		basePrice = (dictionary["base_price"] as? Double) ?? 0.0
		basePriceDistance = (dictionary["base_price_distance"] as? Double) ?? 0.0
		cancellationFee = (dictionary["cancellation_fee"] as? Double) ?? 0.0
		cityId = (dictionary["city_id"] as? String) ?? ""
		createdAt = (dictionary["created_at"] as? String) ?? ""
		isSurgeHours = (dictionary["is_surge_hours"] as? Int) ?? 0
		maxSpace = (dictionary["max_space"] as? Int) ?? 0
		minFare = (dictionary["min_fare"] as? Double) ?? 0.0
		priceForTotalTime = (dictionary["price_for_total_time"] as? Double) ?? 0.0
		priceForWaitingTime = (dictionary["price_for_waiting_time"] as? Double) ?? 0.0
		pricePerUnitDistance = (dictionary["price_per_unit_distance"] as? Double) ?? 0.0
		providerMiscellaneousFee = (dictionary["provider_miscellaneous_fee"] as? Double) ?? 0.0
		providerProfit = (dictionary["provider_profit"] as? Double) ?? 0.0
		providerTax = (dictionary["provider_tax"] as? Double) ?? 0.0
		serviceTypeId = (dictionary["service_type_id"] as? String) ?? ""
		serviceTypeName = (dictionary["service_type_name"] as? String) ?? ""
		surgeEndHour = (dictionary["surge_end_hour"] as? Int) ?? 0
		surgeMultiplier = (dictionary["surge_multiplier"] as? Double) ?? 0.0
		surgeStartHour = (dictionary["surge_start_hour"] as? Int) ?? 0
		tax = (dictionary["tax"] as? Double) ?? 0.0
		updatedAt = (dictionary["updated_at"] as? String) ?? ""
		userMiscellaneousFee = (dictionary["user_miscellaneous_fee"] as? Double) ?? 0.0
		userTax = (dictionary["user_tax"] as? Double) ?? 0.0
		waitingTimeStartAfterMinute = (dictionary["waiting_time_start_after_minute"] as? Int) ?? 0
	}

}
