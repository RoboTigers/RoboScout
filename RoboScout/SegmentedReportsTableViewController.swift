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
        
        // Prepare data store object
        let entity = NSEntityDescription.entityForName("Report", inManagedObjectContext: context)
        let newReport = Report(entity: entity!, insertIntoManagedObjectContext: context)
        
        // Grab values from text boxes
        newReport.scout = addNewReportViewController!.selectedScout
        newReport.team = selectedTeam
        
        var eventStr : String
        switch (addNewReportViewController!.eventSegment.selectedSegmentIndex) {
        case 0: eventStr = "NYC Regional"
        case 1: eventStr = "Long Island"
        default: eventStr = "Unknown"
        }
        newReport.event = eventStr
        
        var typeStr : String
        switch (addNewReportViewController!.typeSegment.selectedSegmentIndex) {
        case 0: typeStr = "Pit"
        case 1: typeStr = "Stand"
        default: typeStr = "Unknown"
        }
        newReport.type = typeStr
        
        newReport.matchNumber = addNewReportViewController?.matchNumber.text
        
        var shooter : Int
        switch (addNewReportViewController!.shooter.selectedSegmentIndex) {
        case 0: shooter = 1
        case 1: shooter = 0
        default: shooter = 0
        }
        newReport.isShooterBot = shooter
        
        var autonomous : Int
        switch (addNewReportViewController!.autonomous.selectedSegmentIndex) {
        case 0: autonomous = 1
        case 1: autonomous = 0
        default: autonomous = 0
        }
        newReport.hasAutonomous = autonomous
        
        // We do not need a switch statement on the defense segments since we luckily
        // need values 0, 1, 2 which is the default values of the segment controller
        // according to how we laied it out on the storyboard. A value of 0 means the robot
        // never traversed thta defense (whether it didn't try or whether it couldn't). A value
        // of 1 means it passed it once thereby weakening the defense. A value of 2 means
        // it passed it twice thereby taking down that defense.
        newReport.canPassPortcullis = addNewReportViewController!.portcullis.selectedSegmentIndex
        newReport.canPassChevalDeFrise = addNewReportViewController!.cheval.selectedSegmentIndex
        newReport.canPassMoat = addNewReportViewController!.moat.selectedSegmentIndex
        newReport.canPassSallyPort = addNewReportViewController!.sallyPort.selectedSegmentIndex
        newReport.canPassDrawbridge = addNewReportViewController!.drawbridge.selectedSegmentIndex
        newReport.canPassRamparts = addNewReportViewController!.ramparts.selectedSegmentIndex
        newReport.canPassRockWall = addNewReportViewController!.rockWall.selectedSegmentIndex
        newReport.canPassRoughTerrain = addNewReportViewController!.roughTerrain.selectedSegmentIndex
        newReport.canPassLowBar = addNewReportViewController!.lowBar.selectedSegmentIndex
        
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
        
        //print("Reload tableView")
        //self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("VIEW DID APPEAR")
        getReportsForSelectedTeam()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reports for Team #\(selectedTeam.teamNumber!)"
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        print ("reports view did load and team number = \(selectedTeam.teamNumber)")
        
        //navigationItem.backBarButtonItem?.enabled
        //navigationItem.setHidesBackButton(false, animated: true)
        //let backButton : UIBarButtonItem = UIBarButtonItem()
        //backButton.enabled = true
        //navigationItem.setLeftBarButtonItem(backButton, animated: true)
        

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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var ret = 0
        ret = reportsForSelectedTeam.count
        return ret
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "SegmentedDetailOrSummaryCell"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath)

        let overallRating = reportsForSelectedTeam[indexPath.row].overallRating!.stringValue
        cell.textLabel?.text = (reportsForSelectedTeam[indexPath.row].scout?.scoutName)! + " (" + overallRating + ")"
        cell.detailTextLabel?.text = (reportsForSelectedTeam[indexPath.row].type)! + " (" + reportsForSelectedTeam[indexPath.row].event!
            + " - Match # " + (reportsForSelectedTeam[indexPath.row].matchNumber)!  + ")"
        
        return cell
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
            

                let reportToDelete = reportsForSelectedTeam.removeAtIndex(indexPath.row)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func getReportsForSelectedTeam() {
        
        reportsForSelectedTeam.removeAll()
        
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
        do {
            results = try context.executeFetchRequest(request)
        } catch _ {
            print("Error fetching scouts")
        }
        
        if results.count > 0 {
            for report in results {
                let r = report as! Report
                reportsForSelectedTeam.append(r)
            }
            tableView.reloadData()
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
