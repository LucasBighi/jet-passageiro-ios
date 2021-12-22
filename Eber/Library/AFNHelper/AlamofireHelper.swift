
//
//  AlamofireHelper.swift
//  Store
//
//  Created by Elluminati on 07/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

extension URLSession {
    func cancelTasks(completionHandler: @escaping (() -> Void)) {
        self.getAllTasks { (tasks: [URLSessionTask]) in 
            for task in tasks {
                if let url = task.originalRequest?.url?.absoluteString {
                    printE("\(#function) \(url) cancel")
                }
                
                task.cancel()
            }
            
            DispatchQueue.main.async(execute: {
                completionHandler()
            })
        }
    }
}

typealias voidRequestCompletionBlock = (_ response:[String:Any],_ error:Any?) -> (Void)


class AlamofireHelper: NSObject
{
    static let POST_METHOD = "POST"
    static let GET_METHOD = "GET"
    static let PUT_METHOD = "PUT"
    
    var dataBlock:voidRequestCompletionBlock={_,_ in};
    
    static var manager: Alamofire.SessionManager = {

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default
        )
        
        return manager
    }()
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override init() {

        super.init()
        
    }
    
    func getResponseFromURL(url : String,methodName : String,paramData : [String:Any]? , block:@escaping voidRequestCompletionBlock)
    {
        
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url

        if (methodName == AlamofireHelper.POST_METHOD)
        {
            
            AlamofireHelper.manager.request(urlString, method: .post, parameters: paramData, encoding:JSONEncoding.default, headers: nil).responseJSON
                {
                    (response:DataResponse<Any>) in
                    

                    if self.isRequestSuccess(response: response)
                    {
                        switch(response.result)
                        {
                            
                        case .success(_):
                            if response.result.value != nil
                            {
                                print("Url : - \(String(describing: response.request?.urlRequest)) \n parameters :- \(String(describing: paramData)) \n  Response \(String(describing: response.result.value))")
                                
                                self.dataBlock((response.result.value as? [String:Any])!,nil)

                                
                                
                            }
                            break
                            
                        case .failure(_):
                            
                            if response.result.error != nil
                            {
                                let dictResponse:[String:Any] = [:]
                                self.dataBlock(dictResponse,response.result.error!)
                            }
                            break
                        }
                    }
                    else
                    {
                        let dictResponse:[String:Any] = [:]
                        self.dataBlock(dictResponse,response.result.error!)
                    }
            }
        }
        else if(methodName == AlamofireHelper.GET_METHOD)
        {
            
            AlamofireHelper.manager.request(urlString).responseJSON(completionHandler: { (response:DataResponse<Any>) in
                
                
                if self.isRequestSuccess(response: response)
                {
                    switch(response.result)
                    {
                        
                    case .success(_):
                        
                        if response.result.value != nil
                        {
                            self.dataBlock((response.result.value as? [String:Any])!,nil)
                        }
                        break
                        
                    case .failure(_):
                        if response.result.error != nil
                        {
                            let dictResponse:[String:Any] = [:]
                            self.dataBlock(dictResponse,response.result.error!)
                        }
                        break
                    }
                }
                else
                {
                    let dictResponse:[String:Any] = [:]
                    self.dataBlock(dictResponse,response.result.error!)
                }
                
            })
            
        }
        
    }
    
    func getResponseFromURL(url : String,paramData : [String:Any]? ,image : UIImage!, block:@escaping voidRequestCompletionBlock) {
        
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url
        
        let imgData = image.jpegData(compressionQuality: 0.2) ?? Data.init()
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: PARAMS.IMAGE_URL,fileName: "picture_data", mimeType: "image/jpg")
            
            for (key, value) in paramData!
            {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            
        },to:urlString)
        { (result) in
            
            
            switch result
            {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    if (response.result.value != nil)
                    {
                        print("Url : - \(String(describing: response.request?.urlRequest)) \n parameters :- \(String(describing: paramData)) \n  Response \(response.result.value)")
                        self.dataBlock((response.result.value as? [String:Any])!,nil)
                    }
                }
            case .failure(let encodingError):
                let responseError:[String:Any] = [:]
                self.dataBlock(responseError,encodingError)
            }
        }
        
    }
    
    
    
    func getTempResponseFromURL(url : String,methodName : String,paramData : [String:Any]? , block:@escaping voidRequestCompletionBlock)
    {
        
        self.dataBlock = block
        let urlString:String = url
        
        if (methodName == AlamofireHelper.POST_METHOD)
        {
            
            AlamofireHelper.manager.request(urlString, method: .post, parameters: paramData, encoding:JSONEncoding.default, headers: nil).responseJSON
                {
                    (response:DataResponse<Any>) in
                    
                    
                    if self.isRequestSuccess(response: response)
                    {
                        switch(response.result)
                        {
                            
                        case .success(_):
                            if response.result.value != nil
                            {
                                print("Url : - \(String(describing: response.request?.urlRequest)) \n parameters :- \(String(describing: paramData)) \n  Response \(response.result.value)")
                                
                                self.dataBlock((response.result.value as? [String:Any])!,nil)
                                
                                
                                
                            }
                            break
                            
                        case .failure(_):
                            
                            if response.result.error != nil
                            {
                                let dictResponse:[String:Any] = [:]
                                self.dataBlock(dictResponse,response.result.error!)
                            }
                            break
                        }
                    }
                    else
                    {
                        let dictResponse:[String:Any] = [:]
                        self.dataBlock(dictResponse,response.result.error!)
                    }
            }
        }
        else if(methodName == AlamofireHelper.GET_METHOD)
        {
            
            AlamofireHelper.manager.request(urlString).responseJSON(completionHandler: { (response:DataResponse<Any>) in
                
                
                if self.isRequestSuccess(response: response)
                {
                    switch(response.result)
                    {
                        
                    case .success(_):
                        
                        if response.result.value != nil
                        {
                            self.dataBlock((response.result.value as? [String:Any])!,nil)
                        }
                        break
                        
                    case .failure(_):
                        if response.result.error != nil
                        {
                            let dictResponse:[String:Any] = [:]
                            self.dataBlock(dictResponse,response.result.error!)
                        }
                        break
                    }
                }
                else
                {
                    let dictResponse:[String:Any] = [:]
                    self.dataBlock(dictResponse,response.result.error!)
                }
                
            })
            
        }
        
    }
    func isRequestSuccess(response:DataResponse<Any>) -> Bool
    {
        
        var statusCode = response.response?.statusCode
        if let error = response.result.error as? AFError
        {
            
            let status = "HTTP_ERROR_CODE_" + String(statusCode ?? 0)
            Utility.showToast(message: status.localized)
            
            statusCode = error._code
            Utility.hideLoading()
            return false
        }
        else if (response.result.error as? URLError) != nil
        {
            
            //Utility.showToast(message: "URL_IS_WRONG")
            Utility.hideLoading()
            return false
        }
        else
        {
            return true
        }
    }
}
