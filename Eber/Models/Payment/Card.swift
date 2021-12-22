//
//	Card.swift
//
//	Create by MacPro3 on 15/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class Card: Model
{


	var id : String!
	var cardType : String!
	var createdAt : String!
	var customerId : String!
	var isDefault : Int!
	var lastFour : String!
	var paymentToken : String!
	var type : Int!
	var updatedAt : String!
	var userId : String!
    var isSelectedForDelete : Bool = false

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		
		id = (dictionary["_id"] as? String) ?? ""
		cardType = (dictionary["card_type"] as? String) ?? ""
		createdAt = (dictionary["created_at"] as? String) ?? ""
		customerId = (dictionary["customer_id"] as? String) ?? ""
		isDefault = (dictionary["is_default"] as? Int) ?? 0
		lastFour = (dictionary["last_four"] as? String) ?? ""
		paymentToken = (dictionary["payment_token"] as? String) ?? ""
		type = (dictionary["type"] as? Int) ?? 0
		updatedAt = (dictionary["updated_at"] as? String) ?? ""
		userId = (dictionary["user_id"] as? String) ?? ""
	}

}


public class WalletResponse {
    public var success : Bool!
    public var message : Int!
    public var wallet : Double!
    public var walletCurrencyCode : String!
    
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let Wallet = Wallet(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Wallet Instance.
     */
    required public init?(dictionary: [String:Any]) {
        
        success = (dictionary["success"] as? Bool) ?? false
        message = (dictionary["message"] as? Int) ?? 0
        wallet = (dictionary["wallet"] as? Double)?.roundTo() ?? 0.00
        walletCurrencyCode = (dictionary["wallet_currency_code"] as? String) ?? ""
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.success, forKey: "success")
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.wallet, forKey: "wallet")
        dictionary.setValue(self.walletCurrencyCode, forKey: "wallet_currency_code")
        
        return dictionary
    }
    
}

public class WalletStatusResponse {
    var success : Bool!
    var message : Int!
    var isUseWallet : Bool!

    
  init(fromDictionary dictionary: [String:Any])
  {
        
        success = (dictionary["success"] as? Bool) ?? false
        message = (dictionary["message"] as? Int) ?? 0
        isUseWallet = (dictionary["is_use_wallet"] as? Bool) ?? false
    }
    
    
}
