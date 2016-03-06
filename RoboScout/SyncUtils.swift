//
//  SyncUtils.swift
//  MpcPoc
//
//  Created by Sharon Kass on 2/24/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Extend data source entities for converting to/from JSON


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
    
    func loadFromJson(teamDict : NSDictionary) {
        print ("Team Dictionary received")
        print ("teamDict = \(teamDict)")
        self.teamName = teamDict["teamName"] as? String
        self.teamNumber = teamDict["teamNumber"] as? String
        self.location = teamDict["location"] as? String
        self.year = teamDict["year"] as? String
        print ("unpacked teamName = \(teamName)")
    }
    
}

// The Scout "reports" releationship will be set in the sync of the Reports entity
// This sync utility will only handle attributes (not relationships) of Scout

extension Scout {
    
    func toDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        dict["scoutName"] = self.scoutName
        dict["fullName"] = self.fullName
        dict["year"] = self.year
        return dict
    }
    
    func loadFromJson(scoutDict : NSDictionary) {
        print ("Scout Dictionary received")
        print ("scoutDict = \(scoutDict)")
        self.scoutName = scoutDict["scoutName"] as? String
        self.fullName = scoutDict["fullName"] as? String
        self.year = scoutDict["year"] as? String
        print ("unpacked scoutName = \(scoutName)")
    }
    
}

extension Report {
    
    func toDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        dict["autoCrossedDefense"] = self.autoCrossedDefense
        dict["autoReachedDefense"] = self.autoReachedDefense
        dict["autoScoredHigh"] = self.autoScoredHigh
        dict["autoScoredLow"] = self.autoScoredLow
        dict["comments"] = self.comments
        dict["event"] = self.event
        dict["hasAutonomous"] = self.hasAutonomous
        dict["matchNumber"] = self.matchNumber
        dict["overallRating"] = self.overallRating
        dict["speedChevalDeFrise"] = self.speedChevalDeFrise
        dict["speedDrawbridge"] = self.speedDrawbridge
        dict["speedLowBar"] = self.speedLowBar
        dict["speedMoat"] = self.speedMoat
        dict["speedPortcullis"] = self.speedPortcullis
        dict["speedRamparts"] = self.speedRamparts
        dict["speedRockWall"] = self.speedRockWall
        dict["speedRoughTerrain"] = self.speedRoughTerrain
        dict["speedSallyPort"] = self.speedSallyPort
        dict["type"] = self.type
        dict["facedPortcullis"] = self.facedPortcullis
        dict["facedCheval"] = self.facedCheval
        dict["facedMoat"] = self.facedMoat
        dict["facedSallyPort"] = self.facedSallyPort
        dict["facedDrawbridge"] = self.facedDrawbridge
        dict["facedRamparts"] = self.facedRamparts
        dict["facedRockWall"] = self.facedRockWall
        dict["facedRoughTerrain"] = self.facedRoughTerrain
        dict["facedLowBar"] = self.facedLowBar
        dict["numCrossesPortcullis"] = self.numCrossesPortcullis
        dict["numCrossesCheval"] = self.numCrossesCheval
        dict["numCrossesMoat"] = self.numCrossesMoat
        dict["numCrossesSallyPort"] = self.numCrossesSallyPort
        dict["numCrossesDrawbridge"] = self.numCrossesDrawbridge
        dict["numCrossesRamparts"] = self.numCrossesRamparts
        dict["numCrossesRockWall"] = self.numCrossesRockWall
        dict["numCrossesRoughTerrain"] = self.numCrossesRoughTerrain
        dict["numCrossesLowBar"] = self.numCrossesLowBar
        dict["numScoreSuccessLow"] = self.numScoreSuccessLow
        dict["numScoreSuccessesHigh"] = self.numScoreSuccessesHigh
        dict["numScoreAttemptsHigh"] = self.numScoreAttemptsHigh
        dict["didChallange"] = self.didChallange
        dict["didScale"] = self.didScale
        dict["didCapture"] = self.didCapture
        dict["numFoulsTechnical"] = self.numFoulsTechnical
        dict["numFoulsRegular"] = self.numFoulsRegular
        
        // Team - send teamNumber which can be used as unique key
        dict["teamNumber"] = self.team!.teamNumber
        
        // Scout - send scoutName which can be used as unique key
        dict["scoutName"] = self.scout!.scoutName
        
        return dict
    }
    
    func loadFromJson(reportDict : NSDictionary, context:NSManagedObjectContext) -> Bool {
        print ("Report Dictionary received")
        print ("reportDict = \(reportDict)")
        
        // Add attributes
        
        self.autoCrossedDefense = reportDict["autoCrossedDefense"] as? NSNumber
        self.autoReachedDefense = reportDict["autoReachedDefense"] as? NSNumber
        self.autoScoredHigh = reportDict["autoScoredHigh"] as? NSNumber
        self.autoScoredLow = reportDict["autoScoredLow"] as? NSNumber
        self.comments = reportDict["comments"] as? String
        self.event = reportDict["event"] as? String
        self.hasAutonomous = reportDict["hasAutonomous"] as? NSNumber
        self.matchNumber = reportDict["matchNumber"] as? String
        self.overallRating = reportDict["overallRating"] as? NSNumber
        self.speedChevalDeFrise = reportDict["speedChevalDeFrise"] as? NSNumber
        self.speedDrawbridge = reportDict["speedDrawbridge"] as? NSNumber
        self.speedLowBar = reportDict["speedLowBar"] as? NSNumber
        self.speedMoat = reportDict["speedMoat"] as? NSNumber
        self.speedPortcullis = reportDict["speedPortcullis"] as? NSNumber
        self.speedRamparts = reportDict["speedRamparts"] as? NSNumber
        self.speedRockWall = reportDict["speedRockWall"] as? NSNumber
        self.speedRoughTerrain = reportDict["speedRoughTerrain"] as? NSNumber
        self.speedSallyPort = reportDict["speedSallyPort"] as? NSNumber
        self.type = reportDict["type"] as? String
        self.facedPortcullis = reportDict["facedPortcullis"] as? NSNumber
        self.facedCheval = reportDict["facedCheval"] as? NSNumber
        self.facedMoat = reportDict["facedMoat"] as? NSNumber
        self.facedSallyPort = reportDict["facedSallyPort"] as? NSNumber
        self.facedDrawbridge = reportDict["facedDrawbridge"] as? NSNumber
        self.facedRamparts = reportDict["facedRamparts"] as? NSNumber
        self.facedRockWall = reportDict["facedRockWall"] as? NSNumber
        self.facedRoughTerrain = reportDict["facedRoughTerrain"] as? NSNumber
        self.facedLowBar = reportDict["facedLowBar"] as? NSNumber
        self.numCrossesPortcullis = reportDict["numCrossesPortcullis"] as? NSNumber
        self.numCrossesCheval = reportDict["numCrossesCheval"] as? NSNumber
        self.numCrossesMoat = reportDict["numCrossesMoat"] as? NSNumber
        self.numCrossesSallyPort = reportDict["numCrossesSallyPort"] as? NSNumber
        self.numCrossesDrawbridge = reportDict["numCrossesDrawbridge"] as? NSNumber
        self.numCrossesRamparts = reportDict["numCrossesRamparts"] as? NSNumber
        self.numCrossesRockWall = reportDict["numCrossesRockWall"] as? NSNumber
        self.numCrossesRoughTerrain = reportDict["numCrossesRoughTerrain"] as? NSNumber
        self.numCrossesLowBar = reportDict["numCrossesLowBar"] as? NSNumber
        self.numScoreSuccessLow = reportDict["numScoreSuccessLow"] as? NSNumber
        self.numScoreSuccessesHigh = reportDict["numScoreSuccessesHigh"] as? NSNumber
        self.numScoreAttemptsHigh = reportDict["numScoreAttemptsHigh"] as? NSNumber
        self.didChallange = reportDict["didChallange"] as? NSNumber
        self.didScale = reportDict["didScale"] as? NSNumber
        self.didCapture = reportDict["didCapture"] as? NSNumber
        self.numFoulsTechnical = reportDict["numFoulsTechnical"] as? NSNumber
        self.numFoulsRegular = reportDict["numFoulsRegular"] as? NSNumber
        
        // Add relationships
        
        
        // Get current year
        let yearStr = String(getCurrentYear())
        
        // Team
        // Find specified team object data store (matching teamNumber and year)
        let requestTeam = NSFetchRequest(entityName: "Team")
        requestTeam.returnsObjectsAsFaults = false;
        let keyValuesForTeam: [String: AnyObject] = ["teamNumber" : reportDict["teamNumber"]!, "year" : yearStr]
        var predicatesTeam = [NSPredicate]()
        for (key, value) in keyValuesForTeam {
            print("Adding key (\(key)) and value (\(value)) to predicate")
            let predicateTeam = NSPredicate(format: "%K = %@", key, value as! NSObject)
            predicatesTeam.append(predicateTeam)
        }
        let compoundPredicateTeam = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicatesTeam)
        requestTeam.predicate = compoundPredicateTeam
        // Execute Request
        var resultsTeam:NSArray = NSArray()
        do {
            resultsTeam = try context.executeFetchRequest(requestTeam)
        } catch _ {
            print("Error fetching teams")
            return false
        }
        
        if resultsTeam.count > 0 {
            // Should only find one team
            for team in resultsTeam {
                let t = team as! Team
                self.team = t
                //print("Team found: \(t)")
            }
        } else {
            print("No teams found")
            return false
        }

        
        // Scout
        // Find specified scout object data store (matching scoutName and year)
        let requestScout = NSFetchRequest(entityName: "Scout")
        requestScout.returnsObjectsAsFaults = false;
        let keyValuesForScout: [String: AnyObject] = ["scoutName" : reportDict["scoutName"]!, "year" : yearStr]
        var predicatesScout = [NSPredicate]()
        for (key, value) in keyValuesForScout {
            print("Adding key (\(key)) and value (\(value)) to predicate")
            let predicateScout = NSPredicate(format: "%K = %@", key, value as! NSObject)
            predicatesScout.append(predicateScout)
        }
        let compoundPredicateScout = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicatesScout)
        requestScout.predicate = compoundPredicateScout
        // Execute Request
        var resultsScout:NSArray = NSArray()
        do {
            resultsScout = try context.executeFetchRequest(requestScout)
        } catch _ {
            print("Error fetching scouts")
            return false
        }
        
        if resultsScout.count > 0 {
            // Should only find one scout
            for scout in resultsScout {
                let s = scout as! Scout
                self.scout = s
                //print("Scout found: \(s)")
            }
        } else {
            print("No scouts found")
            return false
        }

        
        print ("unpacked matchNumber = \(matchNumber)")
        return true
    }
    
    private func getCurrentYear() -> Int {
        // Get current year
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year],  fromDate: date)
        let currentYear = components.year
        return currentYear
    }
    
}



