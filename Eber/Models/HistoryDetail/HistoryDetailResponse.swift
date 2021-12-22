//
//	HistoryDetailResponse.swift
//
//	Create by MacPro3 on 12/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class HistoryDetailResponse: ModelNSObj {

	var message : String!
	var provider : HistoryDetailProvider!
	var startTripToEndTripLocations : [[Double]]!
	var success : Bool!
	var trip : InvoiceTrip!
	var tripservice : InvoiceTripservice!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = (dictionary["message"] as? String) ?? ""
       provider = HistoryDetailProvider.init(fromDictionary: [:])
       if let providerData = dictionary["provider"] as? [String:Any]{
			provider = HistoryDetailProvider(fromDictionary: providerData)
		}
		startTripToEndTripLocations = (dictionary["startTripToEndTripLocations"] as? [[Double]]) ?? [[0.0]]
		success = (dictionary["success"] as? Bool) ?? false
        trip = InvoiceTrip(fromDictionary: [:])
        if let tripData = dictionary["trip"] as? [String:Any]{
			trip = InvoiceTrip(fromDictionary: tripData)
		}
        tripservice = InvoiceTripservice(fromDictionary: [:])
		if let tripserviceData = dictionary["tripservice"] as? [String:Any]{
			tripservice = InvoiceTripservice(fromDictionary: tripserviceData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if message != nil{
			dictionary["message"] = message
		}
		if provider != nil{
			dictionary["provider"] = provider.toDictionary()
		}
		if startTripToEndTripLocations != nil{
			dictionary["startTripToEndTripLocations"] = startTripToEndTripLocations
		}
		if success != nil{
			dictionary["success"] = success
		}
		
		return dictionary
	}

   
}
