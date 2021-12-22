//
//	VehicleListResponse.swift
//
//	Create by MacPro3 on 17/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class VehicleListResponse: Model
{

	var cityDetail : CityDetail!
	var citytypes : [Citytype]!
	var currency : String!
    var currencyCode : String!
	var message : String!
	var paymentGateway : [PaymentGateway]!
	var serverTime : String!
	var success : Bool!
    var isCorporateRequest : Bool = false
    


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any])
    {
		if let cityDetailData = dictionary["city_detail"] as? [String:Any]{
			cityDetail = CityDetail(fromDictionary: cityDetailData)
		}
		citytypes = [Citytype]()
		if let citytypesArray = dictionary["citytypes"] as? [[String:Any]]{
			for dic in citytypesArray{
				let value = Citytype(fromDictionary: dic)
				citytypes.append(value)
			}
		}
		currency = (dictionary["currency"] as? String) ?? ""
        currencyCode = (dictionary["currencycode"] as? String) ?? ""
		message = (dictionary["message"] as? String) ?? ""
		paymentGateway = [PaymentGateway]()
		if let paymentGatewayArray = dictionary["payment_gateway"] as? [[String:Any]]{
			for dic in paymentGatewayArray{
				let value = PaymentGateway(fromDictionary: dic)
				paymentGateway.append(value)
			}
		}
		serverTime = (dictionary["server_time"] as? String) ?? ""
		success = (dictionary["success"] as? Bool) ?? false
        isCorporateRequest = (dictionary["is_corporate_request"] as? Bool) ?? false
    }

}
