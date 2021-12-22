import Foundation


class DocumentsResponse: Model {
    
    var documents : [Document]!
    var isDocumentUploaded : Bool!
    var message : Int!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        documents = [Document]()
        if let documentsArray = dictionary["userdocument"] as? [[String:Any]]{
            for dic in documentsArray{
                let value = Document(fromDictionary: dic)
                documents.append(value)
            }
        }
        isDocumentUploaded = dictionary["is_document_uploaded"] as? Bool
        message = dictionary["message"] as? Int
        success = dictionary["success"] as? Bool
    }
    
}
