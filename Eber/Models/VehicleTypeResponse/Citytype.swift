//
//	Citytype.swift
//
//	Create by MacPro3 on 17/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class Citytype: Model {

	var v : Int!
	var id : String!
	var basePrice : Double!
	var basePriceDistance : Double!
	var cancellationFee : Double!
	var cityid : String!
	var cityname : String!
	var countryid : String!
	var countryname : String!
	var createdAt : String!
	var isBuiesness : Int!
	var isSurgeHours : Int!
	var isZone : Int!
	var maxSpace : Int!
	var minFare : Double!
	var priceForTotalTime : Double!
	var priceForWaitingTime : Double!
	var pricePerUnitDistance : Double!
	var providerMiscellaneousFee : Double!
	var providerProfit : Double!
	var providerTax : Double!
	var surgeEndHour : Int!
	var surgeMultiplier : Double = 0.0
    var richAreaSurgeMultiplier : Double!
	var surgeStartHour : Int!
	var tax : Double!
	var typeDetails : TypeDetail!
	var typeid : String!
	var updatedAt : String!
	var userMiscellaneousFee : Double!
	var userTax : Double!
	var waitingTimeStartAfterMinute : Int!
	var zoneMultiplier : Double!
    var carRentalList : [CarRentalList]!
    var isRentalType :Bool! = false
    var selectedCarRentelId:String = ""
    var surgeHours : [SurgeHour]!
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = (dictionary["__v"] as?  Int) ?? 0
		id = (dictionary["_id"] as?  String) ?? ""
		basePrice = (dictionary["base_price"] as?  Double) ?? 0.0
		basePriceDistance = (dictionary["base_price_distance"] as?  Double) ?? 0.0
		cancellationFee = (dictionary["cancellation_fee"] as?  Double) ?? 0.0
		cityid = (dictionary["cityid"] as?  String) ?? ""
		cityname = (dictionary["cityname"] as?  String) ?? ""
		countryid = (dictionary["countryid"] as?  String) ?? ""
		countryname = (dictionary["countryname"] as?  String) ?? ""
		createdAt = (dictionary["created_at"] as?  String) ?? ""
		isBuiesness = (dictionary["is_buiesness"] as?  Int) ?? 0
		isSurgeHours = (dictionary["is_surge_hours"] as?  Int) ?? 0
		isZone = (dictionary["is_zone"] as?  Int) ?? 0
		maxSpace = (dictionary["max_space"] as?  Int) ?? 0
		minFare = (dictionary["min_fare"] as?  Double) ?? 0.0
		priceForTotalTime = (dictionary["price_for_total_time"] as?  Double) ?? 0.0
		priceForWaitingTime = (dictionary["price_for_waiting_time"] as?  Double) ?? 0.0
		pricePerUnitDistance = (dictionary["price_per_unit_distance"] as?  Double) ?? 0.0
		providerMiscellaneousFee = (dictionary["provider_miscellaneous_fee"] as?  Double) ?? 0.0
		providerProfit = (dictionary["provider_profit"] as?  Double) ?? 0.0
		providerTax = (dictionary["provider_tax"] as?  Double) ?? 0.0
		surgeEndHour = (dictionary["surge_end_hour"] as?  Int) ?? 0
		surgeMultiplier = 0.0
        richAreaSurgeMultiplier = (dictionary["rich_area_surge_multiplier"] as? Double) ?? 0.0
        
		surgeStartHour = (dictionary["surge_start_hour"] as?  Int) ?? 0
		tax = (dictionary["tax"] as? Double) ?? 0.0
        
		if let typeDetailsData = dictionary["type_details"] as? [String:Any]
            {
			typeDetails = TypeDetail(fromDictionary: typeDetailsData)
		}
        else
        {
            typeDetails = TypeDetail.init(fromDictionary: [:])
        }
        carRentalList = []
        if let carRentalListArray = dictionary["car_rental_list"] as? [[String:Any]]{
            for dic in carRentalListArray{
                let value = CarRentalList(fromDictionary: dic)
                carRentalList.append(value)
            }
        }
        if !carRentalList.isEmpty
        {
            isRentalType = true
        }
        surgeHours = [SurgeHour]()
        if let surgeHoursArray = dictionary["surge_hours"] as? [[String:Any]]{
            for dic in surgeHoursArray{
                let value = SurgeHour(fromDictionary: dic)
                surgeHours.append(value)
            }
        }
        
		typeid = (dictionary["typeid"] as?  String) ?? ""
		updatedAt = (dictionary["updated_at"] as?  String) ?? ""
		userMiscellaneousFee = (dictionary["user_miscellaneous_fee"] as?  Double) ?? 0.0
		userTax = (dictionary["user_tax"] as?  Double) ?? 0.0
		waitingTimeStartAfterMinute = (dictionary["waiting_time_start_after_minute"] as?  Int) ?? 0
		zoneMultiplier = (dictionary["zone_multiplier"] as?  Double) ?? 0.0
	}

}
