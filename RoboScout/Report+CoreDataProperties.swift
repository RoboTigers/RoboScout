//
//  Report+CoreDataProperties.swift
//  RoboScout
//
//  Created by Sharon Kass on 2/21/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Report {

    @NSManaged var canPassChevalDeFrise: NSNumber?
    @NSManaged var canPassPortcullis: NSNumber?
    @NSManaged var hasAutonomous: NSNumber?
    @NSManaged var isShooterBot: NSNumber?
    @NSManaged var canPassMoat: NSNumber?
    @NSManaged var canPassRamparts: NSNumber?
    @NSManaged var canPassDrawbridge: NSNumber?
    @NSManaged var cannPassSallyPort: NSNumber?
    @NSManaged var canPassRockWall: NSNumber?
    @NSManaged var canPassRoughTerrain: NSNumber?
    @NSManaged var canPassLowBar: NSNumber?
    @NSManaged var driverStation: String?
    @NSManaged var comments: String?
    @NSManaged var event: String?
    @NSManaged var type: String?
    @NSManaged var team: Team?
    @NSManaged var scout: Scout?

}
