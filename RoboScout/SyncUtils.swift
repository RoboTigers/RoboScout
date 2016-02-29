//
//  SyncUtils.swift
//  MpcPoc
//
//  Created by Sharon Kass on 2/24/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import Foundation

// MARK: - Extend Team for converting to/from JSON


// The Team "reports" releationship will be set in the sync of the Reports entity
// This sync utility will only handle attributes (not relationships) of Team

extension Team {
    
    func toDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        dict["teamName"] = self.teamName
        dict["teamNumber"] = self.teamNumber
        dict["location"] = self.location
        dict["year"] = self.year
        return dict
    }
    
    func loadFromJson(jsonData : NSData) {

            if let dict: AnyObject = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary {
                print ("Team Dictionary received")
                print ("dict = \(dict)")
                self.teamName = dict["teamName"] as? String
                self.teamNumber = dict["teamNumber"] as? String
                self.location = dict["location"] as? String
                self.year = dict["year"] as? String
                print ("unpacked teamName = \(teamName)")
            }
        }
    
}

