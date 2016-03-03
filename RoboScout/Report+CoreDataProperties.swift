//
//  Report+CoreDataProperties.swift
//  RoboScout
//
//  Created by NYCDOE on 2/21/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Report {

    @NSManaged var canPassSallyPort: NSNumber?
    @NSManaged var canPassChevalDeFrise: NSNumber?
    @NSManaged var canPassDrawbridge: NSNumber?
    @NSManaged var canPassLowBar: NSNumber?
    @NSManaged var canPassMoat: NSNumber?
    @NSManaged var canPassPortcullis: NSNumber?
    @NSManaged var canPassRamparts: NSNumber?
    @NSManaged var canPassRockWall: NSNumber?
    @NSManaged var canPassRoughTerrain: NSNumber?
    @NSManaged var comments: String?
    @NSManaged var event: String?
    @NSManaged var hasAutonomous: NSNumber?
    @NSManaged var type: String?
    @NSManaged var matchNumber: String?
    @NSManaged var overallRating: NSNumber?
    @NSManaged var scout: Scout?
    @NSManaged var team: Team?

}
