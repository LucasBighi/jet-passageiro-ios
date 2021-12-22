
import Foundation

class Document: Model
{
    
    var v : Int!
    var id : String!
    var createdAt : String!
    var documentId : String!
    var documentPicture : String!
    var expiredDate : String!
    var isDocumentExpired : Bool!
    var isExpiredDate : Bool!
    var isUniqueCode : Bool!
    var isUploaded : Int!
    var name : String!
    var option : Int!
    var uniqueCode : String!
    var updatedAt : String!
    var userId : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        createdAt = dictionary["created_at"] as? String
        documentId = dictionary["document_id"] as? String
        documentPicture = dictionary["document_picture"] as? String
        expiredDate = dictionary["expired_date"] as? String
        isDocumentExpired = dictionary["is_document_expired"] as? Bool
        isExpiredDate = dictionary["is_expired_date"] as? Bool
        isUniqueCode = dictionary["is_unique_code"] as? Bool
        isUploaded = dictionary["is_uploaded"] as? Int
        name = dictionary["name"] as? String
        option = dictionary["option"] as? Int
        uniqueCode = dictionary["unique_code"] as? String
        updatedAt = dictionary["updated_at"] as? String
        userId = dictionary["user_id"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if v != nil{
            dictionary["__v"] = v
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if documentId != nil{
            dictionary["document_id"] = documentId
        }
        if documentPicture != nil{
            dictionary["document_picture"] = documentPicture
        }
        if expiredDate != nil{
            dictionary["expired_date"] = expiredDate
        }
        if isDocumentExpired != nil{
            dictionary["is_document_expired"] = isDocumentExpired
        }
        if isExpiredDate != nil{
            dictionary["is_expired_date"] = isExpiredDate
        }
        if isUniqueCode != nil{
            dictionary["is_unique_code"] = isUniqueCode
        }
        if isUploaded != nil{
            dictionary["is_uploaded"] = isUploaded
        }
        if name != nil{
            dictionary["name"] = name
        }
        if option != nil{
            dictionary["option"] = option
        }
        if uniqueCode != nil{
            dictionary["unique_code"] = uniqueCode
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
}


