//
//  Report+CoreDataProperties.swift
//  RoboScout
//
//  Created by Sharon Kass on 3/3/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Report {

    @NSManaged var autoCrossedDefense: NSNumber?
    @NSManaged var autoReachedDefense: NSNumber?
    @NSManaged var autoScoredHigh: NSNumber?
    @NSManaged var autoScoredLow: NSNumber?
    @NSManaged var comments: String?
    @NSManaged var event: String?
    @NSManaged var hasAutonomous: NSNumber?
    @NSManaged var matchNumber: String?
    @NSManaged var overallRating: NSNumber?
    @NSManaged var speedChevalDeFrise: NSNumber?
    @NSManaged var speedDrawbridge: NSNumber?
    @NSManaged var speedLowBar: NSNumber?
    @NSManaged var speedMoat: NSNumber?
    @NSManaged var speedPortcullis: NSNumber?
    @NSManaged var speedRamparts: NSNumber?
    @NSManaged var speedRockWall: NSNumber?
    @NSManaged var speedRoughTerrain: NSNumber?
    @NSManaged var speedSallyPort: NSNumber?
    @NSManaged var type: String?
    @NSManaged var facedPortcullis: NSNumber?
    @NSManaged var facedCheval: NSNumber?
    @NSManaged var facedMoat: NSNumber?
    @NSManaged var facedSallyPort: NSNumber?
    @NSManaged var facedDrawbridge: NSNumber?
    @NSManaged var facedRamparts: NSNumber?
    @NSManaged var facedRockWall: NSNumber?
    @NSManaged var facedRoughTerrain: String?
    @NSManaged var facedLowBar: NSNumber?
    @NSManaged var numCrossesPortcullis: NSNumber?
    @NSManaged var numCrossesCheval: NSNumber?
    @NSManaged var numCrossesMoat: NSNumber?
    @NSManaged var numCrossesSallyPort: NSNumber?
    @NSManaged var numCrossesDrawbridge: NSNumber?
    @NSManaged var numCrossesRamparts: NSNumber?
    @NSManaged var numCrossesRockWall: NSNumber?
    @NSManaged var numCrossesRoughTerrain: NSNumber?
    @NSManaged var numCrossesLowBar: NSNumber?
    @NSManaged var scout: Scout?
    @NSManaged var team: Team?

}
