//
//	RootClass.swift
//
//	Create by Elluminati on 30/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

class WalletHistoryResponse: Model {

	var message : Int!
	var success : Bool!
	var walletHistoryList : [WalletHistoryItem]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		success = dictionary["success"] as? Bool
		walletHistoryList = [WalletHistoryItem]()
		if let walletHistoryArray = dictionary["wallet_history"] as? [[String:Any]]
        {
			for dic in walletHistoryArray{
				let value = WalletHistoryItem(fromDictionary: dic)
				walletHistoryList.append(value)
			}
		}
	}

}
