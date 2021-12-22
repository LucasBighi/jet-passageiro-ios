
import Foundation
 
public class GoogleDistanceMatrixResponse: Model {
	public var destination_addresses : Array<String>?
	public var origin_addresses : Array<String>?
	public var rows : Array<Rows>?
	public var status : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let GoogleDistanceMatrixResponse_list = GoogleDistanceMatrixResponse.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of GoogleDistanceMatrixResponse Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [GoogleDistanceMatrixResponse]
    {
        var models:[GoogleDistanceMatrixResponse] = []
        for item in array
        {
            models.append(GoogleDistanceMatrixResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let GoogleDistanceMatrixResponse = GoogleDistanceMatrixResponse(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: GoogleDistanceMatrixResponse Instance.
*/
	required public init?(dictionary: NSDictionary) {

        destination_addresses = []
		if (dictionary["destination_addresses"] != nil)
        {
            destination_addresses = dictionary["destination_addresses"] as? Array<String>
        }
        origin_addresses = []
        
		if (dictionary["origin_addresses"] != nil) {
            origin_addresses = dictionary["origin_addresses"] as? Array<String>
        }
        rows = []
		if (dictionary["rows"] != nil) {
            rows = Rows.modelsFromDictionaryArray(array: dictionary["rows"] as! NSArray) }
        status =  (dictionary["status"] as? String) ?? ""
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.status, forKey: "status")

		return dictionary
	}

}
