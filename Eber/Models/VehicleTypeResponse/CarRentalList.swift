//
//	CarRentalList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CarRentalList: ModelNSObj {

	var v : Int!
	var id : String!
	var basePrice : Double!
	var basePriceDistance : Double!
	var basePriceTime : Double!
	var cancellationFee : Double!
	var carRentalIds : [String]!
	var cityname : String!
	var countryname : String!
	var createdAt : String!
	var isBuiesness : Int!
	var isCarRentalBusiness : Int!
	var isHide : Int!
	var isSurgeHours : Int!
	var isZone : Int!
	var maxSpace : Int!
	var minFare : Int!
	var priceForTotalTime : Double!
	var priceForWaitingTime : Int!
	var pricePerUnitDistance : Double!
	var providerMiscellaneousFee : Int!
	var providerProfit : Int!
	var providerTax : Int!
	var surgeEndHour : Int!
	var surgeMultiplier : Int!
	var surgeStartHour : Int!
	var tax : Int!
	var typeImage : String!
	var typename : String!
	var updatedAt : String!
	var userMiscellaneousFee : Int!
	var userTax : Int!
	var waitingTimeStartAfterMinute : Int!
    var isSelected:Bool = false

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = (dictionary["_id"] as? String) ?? ""
		basePrice = (dictionary["base_price"] as? Double) ?? 0.0
		basePriceDistance = (dictionary["base_price_distance"] as? Double) ?? 0.0
		basePriceTime = (dictionary["base_price_time"] as? Double) ?? 0.0
		cancellationFee = (dictionary["cancellation_fee"] as? Double) ?? 0.0
		cityname = dictionary["cityname"] as? String
		countryname = dictionary["countryname"] as? String
		createdAt = dictionary["created_at"] as? String
		isBuiesness = dictionary["is_buiesness"] as? Int
		isCarRentalBusiness = dictionary["is_car_rental_business"] as? Int
		isHide = dictionary["is_hide"] as? Int
		isSurgeHours = dictionary["is_surge_hours"] as? Int
		isZone = dictionary["is_zone"] as? Int
		maxSpace = dictionary["max_space"] as? Int
		minFare = dictionary["min_fare"] as? Int
		priceForTotalTime = (dictionary["price_for_total_time"] as? Double) ?? 0.0
		priceForWaitingTime = dictionary["price_for_waiting_time"] as? Int
		pricePerUnitDistance = (dictionary["price_per_unit_distance"] as? Double) ?? 0.0
		providerMiscellaneousFee = dictionary["provider_miscellaneous_fee"] as? Int
		providerProfit = dictionary["provider_profit"] as? Int
		providerTax = dictionary["provider_tax"] as? Int
		surgeEndHour = dictionary["surge_end_hour"] as? Int
		surgeMultiplier = dictionary["surge_multiplier"] as? Int
		surgeStartHour = dictionary["surge_start_hour"] as? Int
		tax = dictionary["tax"] as? Int
		typeImage = dictionary["type_image"] as? String
		typename = (dictionary["typename"] as? String) ?? ""
		updatedAt = dictionary["updated_at"] as? String
		userMiscellaneousFee = dictionary["user_miscellaneous_fee"] as? Int
		userTax = dictionary["user_tax"] as? Int
		waitingTimeStartAfterMinute = dictionary["waiting_time_start_after_minute"] as? Int
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
		if basePrice != nil{
			dictionary["base_price"] = basePrice
		}
		if basePriceDistance != nil{
			dictionary["base_price_distance"] = basePriceDistance
		}
		if basePriceTime != nil{
			dictionary["base_price_time"] = basePriceTime
		}
		if cancellationFee != nil{
			dictionary["cancellation_fee"] = cancellationFee
		}
		if carRentalIds != nil{
			dictionary["car_rental_ids"] = carRentalIds
		}
		if cityname != nil{
			dictionary["cityname"] = cityname
		}
		if countryname != nil{
			dictionary["countryname"] = countryname
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if isBuiesness != nil{
			dictionary["is_buiesness"] = isBuiesness
		}
		if isCarRentalBusiness != nil{
			dictionary["is_car_rental_business"] = isCarRentalBusiness
		}
		if isHide != nil{
			dictionary["is_hide"] = isHide
		}
		if isSurgeHours != nil{
			dictionary["is_surge_hours"] = isSurgeHours
		}
		if isZone != nil{
			dictionary["is_zone"] = isZone
		}
		if maxSpace != nil{
			dictionary["max_space"] = maxSpace
		}
		if minFare != nil{
			dictionary["min_fare"] = minFare
		}
		if priceForTotalTime != nil{
			dictionary["price_for_total_time"] = priceForTotalTime
		}
		if priceForWaitingTime != nil{
			dictionary["price_for_waiting_time"] = priceForWaitingTime
		}
		if pricePerUnitDistance != nil{
			dictionary["price_per_unit_distance"] = pricePerUnitDistance
		}
		if providerMiscellaneousFee != nil{
			dictionary["provider_miscellaneous_fee"] = providerMiscellaneousFee
		}
		if providerProfit != nil{
			dictionary["provider_profit"] = providerProfit
		}
		if providerTax != nil{
			dictionary["provider_tax"] = providerTax
		}
		
		if surgeEndHour != nil{
			dictionary["surge_end_hour"] = surgeEndHour
		}
		if surgeMultiplier != nil{
			dictionary["surge_multiplier"] = surgeMultiplier
		}
		if surgeStartHour != nil{
			dictionary["surge_start_hour"] = surgeStartHour
		}
		if tax != nil{
			dictionary["tax"] = tax
		}
		if typeImage != nil{
			dictionary["type_image"] = typeImage
		}
		if typename != nil{
			dictionary["typename"] = typename
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if userMiscellaneousFee != nil{
			dictionary["user_miscellaneous_fee"] = userMiscellaneousFee
		}
		if userTax != nil{
			dictionary["user_tax"] = userTax
		}
		if waitingTimeStartAfterMinute != nil{
			dictionary["waiting_time_start_after_minute"] = waitingTimeStartAfterMinute
		}
		return dictionary
	}

}
