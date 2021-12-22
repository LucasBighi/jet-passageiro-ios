//
//	Triplocation.swift
//
//	Create by MacPro3 on 3/10/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class Triplocation: Model {

	var v : Int!
	var id : String!
	var actualStartTripToEndTripLocations : [AnyObject]!
	var createdAt : String!
	var endTripLocation : [Int]!
	var endTripTime : String!
	var googlePathStartLocationToPickUpLocation : String!
	var googlePickUpLocationToDestinationLocation : String!
	var googleStartTripToEndTripLocations : [AnyObject]!
	var googleTotalDistance : Int!
	var indexForThatCoveredPathInGoogle : Int!
	var providerStartLocation : [Double]!
	var providerStartTime : String!
	var providerStartToStartTripLocations : [[Double]]!
	var startTripLocation : [Int]!
	var startTripTime : String!
	var startTripToEndTripLocations : [Any]!
	var tripID : String!
	var tripUniqueId : Int!
	var updatedAt : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		actualStartTripToEndTripLocations = dictionary["actual_startTripToEndTripLocations"] as? [AnyObject]
		createdAt = dictionary["created_at"] as? String
		endTripLocation = dictionary["endTripLocation"] as? [Int]
		endTripTime = dictionary["endTripTime"] as? String
		googlePathStartLocationToPickUpLocation = dictionary["googlePathStartLocationToPickUpLocation"] as? String
		googlePickUpLocationToDestinationLocation = dictionary["googlePickUpLocationToDestinationLocation"] as? String
		googleStartTripToEndTripLocations = dictionary["google_start_trip_to_end_trip_locations"] as? [AnyObject]
		googleTotalDistance = dictionary["google_total_distance"] as? Int
		indexForThatCoveredPathInGoogle = dictionary["index_for_that_covered_path_in_google"] as? Int
		providerStartLocation = dictionary["providerStartLocation"] as? [Double]
		providerStartTime = dictionary["providerStartTime"] as? String
		providerStartToStartTripLocations = dictionary["providerStartToStartTripLocations"] as? [[Double]]
		startTripLocation = dictionary["startTripLocation"] as? [Int]
		startTripTime = dictionary["startTripTime"] as? String
		startTripToEndTripLocations = dictionary["startTripToEndTripLocations"] as? [Any]
		tripID = dictionary["tripID"] as? String
		tripUniqueId = dictionary["trip_unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
	}

}
