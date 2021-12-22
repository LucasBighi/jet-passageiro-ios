//
//  ResponseModel.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
public class ResponseModel: Model
{
    public var success : Bool = false
    public var message : String = "0"
    public var errorCode : String = "0"
    
    init(fromDictionary dictionary: [String:Any])
    {
        success = (dictionary["success"] as? Bool) ?? false
        if  success
        {
            message = (dictionary["message"] as? String) ?? "0"
        }
        else
        {
            errorCode = (dictionary["error_code"] as? String) ?? "0"
        }
    }
  
}


public class PromoResponseModel: Model
{
    public var success : Bool = false
    public var message : String = "0"
    public var promo_id : String = ""
    public var promo_apply_for_cash : Int = 0
    public var promo_apply_for_card : Int = 0
    public var errorCode : String = "0"
    
    init(fromDictionary dictionary: [String:Any])
    {
        success = (dictionary["success"] as? Bool) ?? false
        promo_id = (dictionary["promo_id"] as? String) ?? ""
        promo_apply_for_cash = (dictionary["promo_apply_for_cash"] as? Int) ?? 0
        promo_apply_for_card = (dictionary["promo_apply_for_card"] as? Int) ?? 0
        
        if  success
        {
            message = (dictionary["message"] as? String) ?? "0"
        }
        else
        {
            errorCode = (dictionary["error_code"] as? String) ?? "0"
        }
    }
    
}
