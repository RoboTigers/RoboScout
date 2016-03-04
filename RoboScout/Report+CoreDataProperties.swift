//
//  Report+CoreDataProperties.swift
//  RoboScout
//
//  Created by Sharon Kass on 3/4/16.
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
    @NSManaged var facedRoughTerrain: NSNumber?
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
    @NSManaged var numScoreSuccessLow: NSNumber?
    @NSManaged var numScoreSuccessesHigh: NSNumber?
    @NSManaged var numScoreAttemptsHigh: NSNumber?
    @NSManaged var didChallange: NSNumber?
    @NSManaged var didScale: NSNumber?
    @NSManaged var didCapture: NSNumber?
    @NSManaged var numFoulsTechnical: NSNumber?
    @NSManaged var numFoulsRegular: NSNumber?
    @NSManaged var scout: Scout?
    @NSManaged var team: Team?

}
