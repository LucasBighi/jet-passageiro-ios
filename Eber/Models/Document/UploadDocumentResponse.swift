
import Foundation


public class UploadDocumentResponse: Model
{
    var expiredDate : String!
    var documentPicture : String!
    var isDocumentUploaded : Int!
    var message : Int!
    var success : Bool!
    var uniqueCode : String!

    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        expiredDate = dictionary["expired_date"] as? String
        documentPicture = dictionary["document_picture"] as? String
        isDocumentUploaded = dictionary["is_document_uploaded"] as? Int
        message = dictionary["message"] as? Int
        success = dictionary["success"] as? Bool
        uniqueCode = dictionary["unique_code"] as? String
    }
}

