/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Elements: Model {
	public var distance : Distance?
	public var duration : Duration?
	public var status : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let elements_list = Elements.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Elements Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Elements]
    {
        var models:[Elements] = []
        for item in array
        {
            models.append(Elements(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let elements = Elements(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Elements Instance.
*/
	required public init?(dictionary: NSDictionary) {

		if (dictionary["distance"] != nil) { distance = Distance(dictionary: dictionary["distance"] as! NSDictionary) }
		if (dictionary["duration"] != nil) { duration = Duration(dictionary: dictionary["duration"] as! NSDictionary) }
		status = dictionary["status"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.distance?.dictionaryRepresentation(), forKey: "distance")
		dictionary.setValue(self.duration?.dictionaryRepresentation(), forKey: "duration")
		dictionary.setValue(self.status, forKey: "status")

		return dictionary
	}

}
