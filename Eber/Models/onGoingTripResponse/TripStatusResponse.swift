//
//	RootClass.swift
//
//	Create by MacPro3 on 24/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class TripStatusResponse: Model {

	var cancellationFee : Double!
	var cityDetail : CityDetail!
	var isPromoUsed : Int!
	var mapPinImageUrl : String!
	var message : String!
	var paymentGateway : [PaymentGateway]!
	var priceForWaitingTime : Double!
	var success : Bool!
	var totalWaitTime : Int!
	var trip : Trip!
	var waitingTimeStartAfterMinute : Double!
    var timeLeftForTip: Int = 30

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		cancellationFee = (dictionary["cancellation_fee"] as? Double) ?? 0.0
		if let cityDetailData = dictionary["city_detail"] as? [String:Any]{
			cityDetail = CityDetail(fromDictionary: cityDetailData)
		}
		isPromoUsed = (dictionary["isPromoUsed"] as? Int) ?? 0
		mapPinImageUrl = (dictionary["map_pin_image_url"] as? String) ?? ""
		message = (dictionary["message"] as? String) ?? ""
		paymentGateway = [PaymentGateway]()
		if let paymentGatewayArray = dictionary["payment_gateway"] as? [[String:Any]]{
			for dic in paymentGatewayArray{
				let value = PaymentGateway(fromDictionary: dic)
				paymentGateway.append(value)
			}
		}
        timeLeftForTip = (dictionary["time_left_for_tip"] as? Int) ?? 30
		priceForWaitingTime = (dictionary["price_for_waiting_time"] as? Double)  ?? 0.0
		success = (dictionary["success"] as? Bool) ?? false
		totalWaitTime = (dictionary["total_wait_time"] as? Int) ?? 0
		
        if let tripData = dictionary["trip"] as? [String:Any]
        {
			trip = Trip(fromDictionary: tripData)
		}
        else
        {
            trip = Trip(fromDictionary: [:])
        }
		waitingTimeStartAfterMinute = (dictionary["waiting_time_start_after_minute"] as? Double) ?? 0.0
	}

}
