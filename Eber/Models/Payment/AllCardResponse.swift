//
//	AllCardResponse.swift
//
//	Create by MacPro3 on 14/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class AllCardResponse: Model {

	var card : [Card]!
	var isUseWallet : Int!
	var message : String!
	var paymentGateway : [PaymentGateway]!
	var success : Bool!
	var wallet : Double!
	var walletCurrencyCode : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		
        card = [Card]()
        if let cards = dictionary["card"] as? [[String:Any]]
        {
            for dic in cards
            {
                let value = Card(fromDictionary: dic)
                card.append(value)
            }
        }
		isUseWallet = (dictionary["is_use_wallet"] as? Int) ?? 0
		message = (dictionary["message"] as? String) ?? ""
		paymentGateway = [PaymentGateway]()
		if let paymentGatewayArray = dictionary["payment_gateway"] as? [[String:Any]]{
			for dic in paymentGatewayArray{
				let value = PaymentGateway(fromDictionary: dic)
				paymentGateway.append(value)
			}
		}
		success = (dictionary["success"] as? Bool) ?? false
		wallet = (dictionary["wallet"] as? Double)  ?? 0.0
		walletCurrencyCode = (dictionary["wallet_currency_code"] as? String) ?? ""
	}

}





