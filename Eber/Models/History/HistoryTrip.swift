//
//	HistoryTrip.swift
//
//	Create by MacPro3 on 12/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class HistoryTrip: ModelNSObj, NSCoding {

	var id : String!
	var currency : String!
	var currencycode : String!
	var currentProvider : String!
	var destinationAddress : String!
	var firstName : String!
    
	var invoiceNumber : String!
	var isProviderRated : Int!
	var isTripCancelledByProvider : Int!
	var isTripCancelledByUser : Int!
	var isTripCompleted : Int!
	var isUserRated : Int!
	var lastName : String!
	var picture : String!

	var providerTripEndTime : String!
	var sourceAddress : String!
	var timezone : String!
	var total : String!
	var totalDistance : String!
    var providerServiceFees : String!
	var totalTime : String!
	var tripId : String!
	var uniqueId : Int!
	var unit : Int!
	var userCreateTime : String!
    var createDate : Date!
    var isFavouriteProvider: Bool = false

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = (dictionary["_id"] as? String ) ?? ""
		currency = (dictionary["currency"] as? String ) ?? ""
        isFavouriteProvider = (dictionary["is_favourite_provider"] as? Bool) ?? false
		currencycode = (dictionary["currencycode"] as? String ) ?? ""
		currentProvider = (dictionary["confirmed_provider"] as? String ) ?? ""
		destinationAddress = (dictionary["destination_address"] as? String ) ?? ""
		firstName = (dictionary["first_name"] as? String ) ?? ""
		invoiceNumber = (dictionary["invoice_number"] as? String ) ?? ""
		isProviderRated = (dictionary["is_provider_rated"] as? Int ) ?? 0
		isTripCancelledByProvider = (dictionary["is_trip_cancelled_by_provider"] as? Int ) ?? 0
		isTripCancelledByUser = (dictionary["is_trip_cancelled_by_user"] as? Int ) ?? 0
		isTripCompleted = (dictionary["is_trip_completed"] as? Int ) ?? 0
		isUserRated = (dictionary["is_user_rated"] as? Int ) ?? 0
		lastName = (dictionary["last_name"] as? String ) ?? ""
		picture = (dictionary["picture"] as? String ) ?? ""
		providerServiceFees = (dictionary["provider_service_fees"] as? Double )?.toString(places: 2)
		providerTripEndTime = (dictionary["provider_trip_end_time"] as? String ) ?? ""
		sourceAddress = (dictionary["source_address"] as? String ) ?? ""
		timezone = (dictionary["timezone"] as? String ) ?? ""
		total = (dictionary["total"] as? Double )?.toString(places: 2)
		totalDistance = (dictionary["total_distance"] as? Double )?.toString(places: 2)
		totalTime = (dictionary["total_time"] as? Double )?.toString(places: 2)
		tripId = (dictionary["trip_id"] as? String ) ?? ""
		uniqueId = (dictionary["unique_id"] as? Int ) ?? 0
		unit = (dictionary["unit"] as? Int ) ?? 0
		userCreateTime = (dictionary["user_create_time"] as? String ) ?? ""
        createDate = userCreateTime.toDate(format: DateFormat.WEB)
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["_id"] = id
		}
		if currency != nil{
			dictionary["currency"] = currency
		}
		if currencycode != nil{
			dictionary["currencycode"] = currencycode
		}
		if currentProvider != nil{
			dictionary["confirmed_provider"] = currentProvider
		}
		if destinationAddress != nil{
			dictionary["destination_address"] = destinationAddress
		}
		if firstName != nil{
			dictionary["first_name"] = firstName
		}
		if invoiceNumber != nil{
			dictionary["invoice_number"] = invoiceNumber
		}
		if isProviderRated != nil{
			dictionary["is_provider_rated"] = isProviderRated
		}
		if isTripCancelledByProvider != nil{
			dictionary["is_trip_cancelled_by_provider"] = isTripCancelledByProvider
		}
		if isTripCancelledByUser != nil{
			dictionary["is_trip_cancelled_by_user"] = isTripCancelledByUser
		}
		if isTripCompleted != nil{
			dictionary["is_trip_completed"] = isTripCompleted
		}
		if isUserRated != nil{
			dictionary["is_user_rated"] = isUserRated
		}
		if lastName != nil{
			dictionary["last_name"] = lastName
		}
		if picture != nil{
			dictionary["picture"] = picture
		}
		if providerServiceFees != nil{
			dictionary["provider_service_fees"] = providerServiceFees
		}
		if providerTripEndTime != nil{
			dictionary["provider_trip_end_time"] = providerTripEndTime
		}
		if sourceAddress != nil{
			dictionary["source_address"] = sourceAddress
		}
		if timezone != nil{
			dictionary["timezone"] = timezone
		}
		if total != nil{
			dictionary["total"] = total
		}
		if totalDistance != nil{
			dictionary["total_distance"] = totalDistance
		}
		if totalTime != nil{
			dictionary["total_time"] = totalTime
		}
		if tripId != nil{
			dictionary["trip_id"] = tripId
		}
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		if unit != nil{
			dictionary["unit"] = unit
		}
		if userCreateTime != nil{
			dictionary["user_create_time"] = userCreateTime
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = ( aDecoder.decodeObject(forKey: "_id") as? String ) ?? ""
         currency = ( aDecoder.decodeObject(forKey: "currency") as? String ) ?? ""
         currencycode = ( aDecoder.decodeObject(forKey: "currencycode") as? String ) ?? ""
         currentProvider = ( aDecoder.decodeObject(forKey: "confirmed_provider") as? String ) ?? ""
         destinationAddress = ( aDecoder.decodeObject(forKey: "destination_address") as? String ) ?? ""
         firstName = ( aDecoder.decodeObject(forKey: "first_name") as? String ) ?? ""
         invoiceNumber = ( aDecoder.decodeObject(forKey: "invoice_number") as? String ) ?? ""
         isProviderRated = ( aDecoder.decodeObject(forKey: "is_provider_rated") as? Int ) ?? 0
         isTripCancelledByProvider = ( aDecoder.decodeObject(forKey: "is_trip_cancelled_by_provider") as? Int ) ?? 0
         isTripCancelledByUser = ( aDecoder.decodeObject(forKey: "is_trip_cancelled_by_user") as? Int ) ?? 0
         isTripCompleted = ( aDecoder.decodeObject(forKey: "is_trip_completed") as? Int ) ?? 0
         isUserRated = ( aDecoder.decodeObject(forKey: "is_user_rated") as? Int ) ?? 0
         lastName = ( aDecoder.decodeObject(forKey: "last_name") as? String ) ?? ""
         picture = ( aDecoder.decodeObject(forKey: "picture") as? String ) ?? ""
         providerServiceFees = ( aDecoder.decodeObject(forKey: "provider_service_fees") as? Double )?.toString(places: 2)
         providerTripEndTime = ( aDecoder.decodeObject(forKey: "provider_trip_end_time") as? String ) ?? ""
         sourceAddress = ( aDecoder.decodeObject(forKey: "source_address") as? String ) ?? ""
         timezone = ( aDecoder.decodeObject(forKey: "timezone") as? String ) ?? ""
         total = ( aDecoder.decodeObject(forKey: "total") as? Double )?.toString(places: 2)
         totalDistance = ( aDecoder.decodeObject(forKey: "total_distance") as? Double )?.toString(places: 2)
         totalTime = ( aDecoder.decodeObject(forKey: "total_time") as? Double )?.toString(places: 2)
         tripId = ( aDecoder.decodeObject(forKey: "trip_id") as? String ) ?? ""
         uniqueId = ( aDecoder.decodeObject(forKey: "unique_id") as? Int ) ?? 0
         unit = ( aDecoder.decodeObject(forKey: "unit") as? Int ) ?? 0
         userCreateTime = ( aDecoder.decodeObject(forKey: "user_create_time") as? String ) ?? ""

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if currency != nil{
			aCoder.encode(currency, forKey: "currency")
		}
		if currencycode != nil{
			aCoder.encode(currencycode, forKey: "currencycode")
		}
		if currentProvider != nil{
			aCoder.encode(currentProvider, forKey: "confirmed_provider")
		}
		if destinationAddress != nil{
			aCoder.encode(destinationAddress, forKey: "destination_address")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "first_name")
		}
		if invoiceNumber != nil{
			aCoder.encode(invoiceNumber, forKey: "invoice_number")
		}
		if isProviderRated != nil{
			aCoder.encode(isProviderRated, forKey: "is_provider_rated")
		}
		if isTripCancelledByProvider != nil{
			aCoder.encode(isTripCancelledByProvider, forKey: "is_trip_cancelled_by_provider")
		}
		if isTripCancelledByUser != nil{
			aCoder.encode(isTripCancelledByUser, forKey: "is_trip_cancelled_by_user")
		}
		if isTripCompleted != nil{
			aCoder.encode(isTripCompleted, forKey: "is_trip_completed")
		}
		if isUserRated != nil{
			aCoder.encode(isUserRated, forKey: "is_user_rated")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "last_name")
		}
		if picture != nil{
			aCoder.encode(picture, forKey: "picture")
		}
		if providerServiceFees != nil{
			aCoder.encode(providerServiceFees, forKey: "provider_service_fees")
		}
		if providerTripEndTime != nil{
			aCoder.encode(providerTripEndTime, forKey: "provider_trip_end_time")
		}
		if sourceAddress != nil{
			aCoder.encode(sourceAddress, forKey: "source_address")
		}
		if timezone != nil{
			aCoder.encode(timezone, forKey: "timezone")
		}
		if total != nil{
			aCoder.encode(total, forKey: "total")
		}
		if totalDistance != nil{
			aCoder.encode(totalDistance, forKey: "total_distance")
		}
		if totalTime != nil{
			aCoder.encode(totalTime, forKey: "total_time")
		}
		if tripId != nil{
			aCoder.encode(tripId, forKey: "trip_id")
		}
		if uniqueId != nil{
			aCoder.encode(uniqueId, forKey: "unique_id")
		}
		if unit != nil{
			aCoder.encode(unit, forKey: "unit")
		}
		if userCreateTime != nil{
			aCoder.encode(userCreateTime, forKey: "user_create_time")
		}

	}

}
