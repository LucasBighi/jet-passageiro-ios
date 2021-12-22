//
//	WalletHistory.swift
//
//	Create by Elluminati on 30/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

class WalletHistoryItem: Model {
    
    var v : Int!
    var id : String!
    var addedWallet : Double!
    var countryId : String!
    var createdAt : String!
    var totalWalletAmount : Double!
    var uniqueId : Int!
    var updatedAt : String!
    var userId : String!
    var userType : Int!
    var userUniqueId : Int!
    var walletAmount : Double!
    var walletCommentId : Int!
    var walletDescription : String!
    var walletStatus : Int!
    
    var fromCurrencyCode:String!
    var toCurrencyCode:String!
    var currentRate:Double!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        fromCurrencyCode = (dictionary["from_currency_code"] as? String) ?? ""
        toCurrencyCode = (dictionary["to_currency_code"] as? String) ?? ""
        currentRate = (dictionary["current_rate"] as? Double) ?? 0.0
        
        
        addedWallet = (dictionary["added_wallet"] as? Double)?.roundTo() ?? 0.0
        countryId = dictionary["country_id"] as? String
        createdAt = dictionary["created_at"] as? String
        totalWalletAmount = (dictionary["total_wallet_amount"] as? Double)?.roundTo() ?? 0.0
        uniqueId = dictionary["unique_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
        userId = dictionary["user_id"] as? String
        userType = dictionary["user_type"] as? Int
        userUniqueId = dictionary["user_unique_id"] as? Int
        walletAmount = (dictionary["wallet_amount"] as? Double)?.roundTo() ?? 0.0
        walletCommentId = dictionary["wallet_comment_id"] as? Int
        walletDescription = dictionary["wallet_description"] as? String
        walletStatus = (dictionary["wallet_status"] as? Int) ?? 0
        
    }
    
}
struct WalletStatus
{
    static let ADD_WALLET_AMOUNT = 1;
    static let ORDER_REFUND_AMOUNT = 3;
    static let ORDER_PROFIT_AMOUNT = 5;
    static let REMOVE_WALLET_AMOUNT = 2;
    static let ORDER_CHARGE_AMOUNT = 4;
    static let ORDER_CANCELLATION_CHARGE_AMOUNT = 6;
    static let REQUEST_CHARGE_AMOUNT = 8;
}

