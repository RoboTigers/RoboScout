//
//  SegmentedReportsTableViewController.swift
//  RoboScout
//
//  Created by Sharon Kass on 2/20/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import UIKit
import CoreData


// This class is named "Segmented" so that in the future we can add
// a segment control for 'Details' and 'Summary' views of the scouting
// reports for the selected team. But for now we only display details.

class SegmentedReportsTableViewController: UITableViewController {
    
    var selectedTeam : Team!
    var reportsForSelectedTeam = [Report]()
    var nycRegReports = [Report]()
    var liReports = [Report]()
    var championshipReports = [Report]()
    
    @IBAction func addNewReportAction(sender: UIBarButtonItem) {
        print("Add new report")
        performSegueWithIdentifier("AddNewReportSegue", sender: self)
    }
    
    @IBAction func unwindFromReportsCancel(unwindSegue: UIStoryboardSegue) {
        print("Canceled")
    }
    
    @IBAction func unwindFromReportAdd(unwindSegue: UIStoryboardSegue) {
        print("get report controller which just was unwinded")
        let addNewReportViewController = unwindSegue.sourceViewController as? AddNewReportViewController
        print(addNewReportViewController!.selectedScout.scoutName)
        
        // Confirm required fields are entered. We really only have to check for match number
        // since the other required fields have default values.
        if ((addNewReportViewController?.matchNumber.text)!.isEmpty) {
                displayErrorAlertWithOk("Match Number is required")
                return
        }
        
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        
        // The report must not already exist
        // We determine this by using the unique composite key for a report:
        //      event + type + match + team + scout
        
        // Get event from input screen
        var eventStr : String
        switch (addNewReportViewController!.eventSegment.selectedSegmentIndex) {
            case 0: eventStr = "NYC Regional"
            case 1: eventStr = "Long Island"
            case 2: eventStr = "Championship"
            default: eventStr = "Unknown"
        }
        
        // Check for existing Report entity matching our composite key
        let request = NSFetchRequest(entityName: "Report")
        request.returnsObjectsAsFaults = false;
        
        let keyValues: [String: AnyObject] = ["event" : eventStr, "matchNumber" : addNewReportViewController!.matchNumber.text!,
            "team" : selectedTeam, "scout" : addNewReportViewController!.selectedScout]
        var predicates = [NSPredicate]()
        for (key, value) in keyValues {
            print("Adding key (\(key)) and value (\(value)) to predicate")
            let predicate = NSPredicate(format: "%K = %@", key, value as! NSObject)
            predicates.append(predicate)
        }
        let compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicates)
        request.predicate = compoundPredicate
        
        var results:NSArray = NSArray()
        do {
            results = try context.executeFetchRequest(request)
        } catch _ {
            print("Error fetching report with event \(eventStr) and match \(addNewReportViewController!.matchNumber!)")
        }
        
        if results.count > 0 {
            displayErrorAlertWithOk("Report for team \(selectedTeam.teamNumber!) in match \(addNewReportViewController!.matchNumber!.text!) by scout \(addNewReportViewController?.selectedScout.scoutName!) at event \(eventStr) already exists")
            return
        }
        
        
        // Report does not already exist so add new team object to data store

        
        // Prepare data store object
        let entity = NSEntityDescription.entityForName("Report", inManagedObjectContext: context)
        let newReport = Report(entity: entity!, insertIntoManagedObjectContext: context)
        
        // Grab values from text boxes
        newReport.scout = addNewReportViewController!.selectedScout
        newReport.team = selectedTeam
        
        newReport.event = eventStr
        
        // For now we only support "Stand" reports (not "Pit")
        // But we leave the "type" attribute on the Report data entity
        // for future use in this app.
        newReport.type = "Stand"
        
        newReport.matchNumber = addNewReportViewController?.matchNumber.text
        
        newReport.hasAutonomous = addNewReportViewController!.autonomous.selectedSegmentIndex
        newReport.autoSpybot = addNewReportViewController!.spybot.on
        newReport.autoReachedDefense = addNewReportViewController!.autoReachedDefense.on
        newReport.autoCrossedDefense = addNewReportViewController!.autoCrossedDefense.on
        newReport.autoScoredLow = addNewReportViewController!.autoScoredLow.on
        newReport.autoScoredHigh = addNewReportViewController!.autoScoredHigh.on
        
        // Faced
        newReport.facedPortcullis = addNewReportViewController!.portcullisFaced.on
        newReport.facedCheval = addNewReportViewController!.chevalFaced.on
        newReport.facedMoat = addNewReportViewController!.moatFaced.on
        newReport.facedSallyPort = addNewReportViewController!.sallyPortFaced.on
        newReport.facedDrawbridge = addNewReportViewController!.drawbridgeFaced.on
        newReport.facedRamparts = addNewReportViewController!.rampartsFaced.on
        newReport.facedRockWall = addNewReportViewController!.rockWallFaced.on
        newReport.facedRoughTerrain = addNewReportViewController!.roughTerrainFaced.on
        newReport.facedLowBar = addNewReportViewController!.lowBarFaced.on
        
        // Num Crosses
        newReport.numCrossesPortcullis = Int(addNewReportViewController!.portcullisNumCrossesLabel.text!)
        newReport.numCrossesCheval = Int(addNewReportViewController!.chevalNumCrossesLabel.text!)
        newReport.numCrossesMoat = Int(addNewReportViewController!.moatNumCrossesLabel.text!)
        newReport.numCrossesSallyPort = Int(addNewReportViewController!.sallyPortNumCrossesLabel.text!)
        newReport.numCrossesDrawbridge = Int(addNewReportViewController!.drawbridgeNumCrossesLabel.text!)
        newReport.numCrossesRamparts = Int(addNewReportViewController!.rampartsNumCrossesLabel.text!)
        newReport.numCrossesRockWall = Int(addNewReportViewController!.rockWallNumCrossesLabel.text!)
        newReport.numCrossesRoughTerrain = Int(addNewReportViewController!.roughTerrainNumCrossesLabel.text!)
        newReport.numCrossesLowBar = Int(addNewReportViewController!.lowBarNumCrossesLabel.text!)
        
        // Speed values:
        //  0 = Slow
        //  1 = Medium
        //  2 = Fast
        newReport.speedPortcullis = addNewReportViewController!.portcullisSpeed.selectedSegmentIndex
        newReport.speedChevalDeFrise = addNewReportViewController!.chevalSpeed.selectedSegmentIndex
        newReport.speedMoat = addNewReportViewController!.moatSpeed.selectedSegmentIndex
        newReport.speedSallyPort = addNewReportViewController!.sallyPortSpeed.selectedSegmentIndex
        newReport.speedDrawbridge = addNewReportViewController!.drawbridgeSpeed.selectedSegmentIndex
        newReport.speedRamparts = addNewReportViewController!.rampartsSpeed.selectedSegmentIndex
        newReport.speedRockWall = addNewReportViewController!.rockWallSpeed.selectedSegmentIndex
        newReport.speedLowBar = addNewReportViewController!.lowBarSpeed.selectedSegmentIndex
        
        // Offense
        newReport.numScoreSuccessLow = Int(addNewReportViewController!.numLowScoresLabel.text!)
        newReport.numScoreAttemptsHigh = Int(addNewReportViewController!.numHighAttempsLabel.text!)
        newReport.numScoreSuccessesHigh = Int(addNewReportViewController!.numHighScoresLabel.text!)
        
        newReport.didChallange = addNewReportViewController!.didChallange.on
        newReport.didScale = addNewReportViewController!.didScale.on
        newReport.didCapture = addNewReportViewController!.didCapture.on
        
        // Fouls
        newReport.numFoulsTechnical = Int(addNewReportViewController!.techFoulsLabel.text!)
        newReport.numFoulsRegular = Int(addNewReportViewController!.regularFoulsLabel.text!)
        
        
        newReport.overallRating = addNewReportViewController!.slider.value

        newReport.comments = addNewReportViewController!.comments.text
        
        // Persist to data store
        do {
            try context.save()
        } catch _ {
            // Handle core data error
            print("Error saving new report")
        }
        print("newReport: \(newReport)")
        print("Object saved successfully")
        
        getReportsForSelectedTeam()
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("VIEW DID APPEAR")
        //getReportsForSelectedTeam()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reports for Team #\(selectedTeam.teamNumber!)"
        getReportsForSelectedTeam()
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        print ("reports view did load and team number = \(selectedTeam.teamNumber)")
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayErrorAlertWithOk(msg: String) {
        let refreshAlert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Data entry error")
            return
        }))
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(refreshAlert, animated: true, completion: nil)
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("Set number of section to 3")
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        switch(section) {
            case 0: num = nycRegReports.count
            case 1: num = liReports.count
            case 2: num = championshipReports.count
            default: print("ERROR: Should not reach section \(section)")
        }
        print("Set number of rows in section \(section) to \(num)")
        return num
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "SegmentedDetailOrSummaryCell"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath)
        let reportForCell: Report
        switch(indexPath.section) {
            case 0: reportForCell = nycRegReports[indexPath.row]
            case 1: reportForCell = liReports[indexPath.row]
            case 2: reportForCell = championshipReports[indexPath.row]
            default: return cell
        }

        
        //below is what is in the parenthesis after the match #
        
        var parenStr:String = ""
        if (reportForCell.numCrossesPortcullis?.integerValue > 0) {
            parenStr += "| Portcullis "
        }
        
        if (reportForCell.numCrossesCheval?.integerValue > 0) {
            parenStr += "| Cheval De Frise "
        }
        
        if (reportForCell.numCrossesDrawbridge?.integerValue > 0){
            parenStr += "| DrawBridge "
        }
        
        if (reportForCell.numCrossesLowBar?.integerValue > 0){
            parenStr += "| Low Bar "
        }
        
        if (reportForCell.numCrossesMoat?.integerValue > 0){
            parenStr += "| Moat "
        }
        
        if (reportForCell.numCrossesRamparts?.integerValue > 0){
            parenStr += "| Ramparts "
        }
        
        if (reportForCell.numCrossesRockWall?.integerValue > 0){
            parenStr += "| Rock Wall "
        }
        
        if (reportForCell.numCrossesRoughTerrain?.integerValue > 0){
            parenStr += "| Rough Terrain "
        }
        
        if (reportForCell.numCrossesSallyPort?.integerValue > 0){
            parenStr += "| Sally Port "
        }
        
        
    
        cell.textLabel?.text = "Match # " + (reportsForSelectedTeam[indexPath.row].matchNumber)! + " (" + parenStr + ")"
        cell.detailTextLabel?.text = (reportForCell.scout?.scoutName)!
        return cell
        
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "NYC Regionals"
        case 1: return "Long Island"
        case 2: return "Championship"
        default: return "Unknown section: \(section)"
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            
            let reportToDelete: Report = { // start of a closure expression that returns a Report

                switch(indexPath.section) {
                case 0: return nycRegReports.removeAtIndex(indexPath.row)
                case 1: return liReports.removeAtIndex(indexPath.row)
                case 2: return championshipReports.removeAtIndex(indexPath.row)
                default: return Report()
                }
                
            }()
            
                let request = NSFetchRequest(entityName: "Report")
                // Create compund predicate so we can find the object in the graph to delete
                // We need conditions matching event, reportType, driverStation, team, scout 
                // (this composite uniquely identifies the selected report)
            let keyValues: [String: AnyObject] = ["matchNumber" : reportToDelete.matchNumber!, "team" : reportToDelete.team!, "scout" : reportToDelete.scout!]
                var predicates = [NSPredicate]()
                for (key, value) in keyValues {
                    print("Adding key (\(key)) and value (\(value)) to predicate")
                    let predicate = NSPredicate(format: "%K = %@", key, value as! NSObject)
                    predicates.append(predicate)
                }
                let compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicates)
                request.predicate = compoundPredicate
                
                do {
                    let fetchedEntities = try context.executeFetchRequest(request) as! [Report]
                    if let entityToDelete = fetchedEntities.first {
                        context.deleteObject(entityToDelete)
                    }
                } catch {
                    print("Unable to retrieve report object to delete: \(reportToDelete)")
                }
                
                do {
                    try context.save()
                } catch {
                    print("Unable to save context when deleting report: \(reportToDelete)")
                }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            getReportsForSelectedTeam()
        } /* else if editingStyle == .Insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        } */
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var destination = segue.destinationViewController as? UIViewController
//        if let navigationController = destination as? UINavigationController {
//            destination = navigationController.visibleViewController
//        }
//        if let addReportViewController = destination as? AddNewReportViewController {
//            if let segueIdentifier = segue.identifier {
//                switch segueIdentifier {
//                case "AddNewReportSegue":
//                    print ("AddNewReportSegue segue")
//                    addReportViewController.selectedTeam = self.selectedTeam
//                case "ViewExistingReportSegue":
//                    print("ViewExistingReportSegue segue")
//                    // Get report for selected cell
//                    let sectionIndex = tableView.indexPathForSelectedRow!.section
//                    let rowIndex = tableView.indexPathForSelectedRow!.row
//                    print("selected section: \(sectionIndex) row: \(rowIndex)")
//                    let reportForCell: Report = { // start of a closure expression that returns a Report
//                        switch(sectionIndex) {
//                        case 0: return nycRegReports[rowIndex]
//                        case 1: return liReports[rowIndex]
//                        case 2: return championshipReports[rowIndex]
//                        default: return Report()
//                        }
//                        
//                    }()
//                    print("reportForCell: \(reportForCell)")
//                    // Fill in destination view controller model data
//                    addReportViewController.reportToView = reportForCell
//                default:
//                    print ("Unknown segueIdentifier: \(segueIdentifier)")
//                    
//                }
//            }
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController
        if let navigationController = destination as? UINavigationController {
            destination = navigationController.visibleViewController!
        }
        
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case "AddNewReportSegue":
                if let addReportViewController = destination as? AddNewReportViewController {
                    print ("AddNewReportSegue segue")
                    addReportViewController.selectedTeam = self.selectedTeam
                }
            case "ViewExistingReportSegue":
                if let viewExistingReportViewController = destination as? ViewExistingReportViewController {
                    print("ViewExistingReportSegue segue")
                    // Get report for selected cell
                    let sectionIndex = tableView.indexPathForSelectedRow!.section
                    let rowIndex = tableView.indexPathForSelectedRow!.row
                    print("selected section: \(sectionIndex) row: \(rowIndex)")
                    let reportForCell: Report = { // start of a closure expression that returns a Report
                        switch(sectionIndex) {
                        case 0: return nycRegReports[rowIndex]
                        case 1: return liReports[rowIndex]
                        case 2: return championshipReports[rowIndex]
                        default: return Report()
                        }
                    }()
                    print("reportForCell: \(reportForCell)")
                    // Fill in destination view controller model data
                    viewExistingReportViewController.reportToView = reportForCell
                }
            default:
                print ("Unknown segueIdentifier: \(segueIdentifier)")
                
            }
        }
        
        
    }
    
    
    private func getReportsForSelectedTeam() {
        
        reportsForSelectedTeam.removeAll()
        nycRegReports.removeAll()
        liReports.removeAll()
        championshipReports.removeAll()
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // Get current year
        //let yearStr = String(getCurrentYear())
        
        // Get reports from data store
        let request = NSFetchRequest(entityName: "Report")
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "team = %@", selectedTeam)
        var results:NSArray = NSArray()
        // Sort by match number
        let sectionSortDescriptor = NSSortDescriptor(key: "matchNumber", ascending: true, selector: "localizedStandardCompare:")
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        do {
            results = try context.executeFetchRequest(request)
        } catch _ {
            print("Error fetching scouts")
        }
        
        if results.count > 0 {
            for report in results {
                let r = report as! Report
                reportsForSelectedTeam.append(r)
                print("Append event array for \(r.event!)")
                switch (r.event!) {
                    case "NYC Regional": nycRegReports.append(r)
                    case "Long Island": liReports.append(r)
                    case "Championship": championshipReports.append(r)
                    default: print("ERROR: Should never have a report with an unknown event: \(r.event)")
                }
                print("Match: \(r.matchNumber), nyc: \(nycRegReports.count), li: \(liReports.count), champ: \(championshipReports.count)")
            }
        } else {
            print("No reports found")
        }
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
