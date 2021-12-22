//
//	InvoiceResponse.swift
//
//	Create by MacPro3 on 4/10/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class InvoiceResponse: Model {

	var message : String!
	var success : Bool!
	var trip : InvoiceTrip!
	var tripservice : InvoiceTripservice!
    var providerDetail : InvoiceProvider!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? String
		success = dictionary["success"] as? Bool
		if let tripData = dictionary["trip"] as? [String:Any]{
			trip = InvoiceTrip(fromDictionary: tripData)
		}
		if let tripserviceData = dictionary["tripservice"] as? [String:Any]{
			tripservice = InvoiceTripservice(fromDictionary: tripserviceData)
		}
        if let providerData = dictionary["provider_detail"] as? [String:Any]
            
        {
            providerDetail = InvoiceProvider.init(fromDictionary: providerData)
        }
        
	}

}
class InvoiceProvider{
    
    var picture : String!
    var first_name : String!
    var last_name : String!
   
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        first_name = dictionary["first_name"] as? String
        picture = dictionary["picture"] as? String
        last_name = (dictionary["last_name"] as? String) ?? ""
        
    }
    
}
