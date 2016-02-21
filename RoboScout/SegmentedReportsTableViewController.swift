//
//  SegmentedReportsTableViewController.swift
//  RoboScout
//
//  Created by Sharon Kass on 2/20/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import UIKit
import CoreData

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
        
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // Grab values from text boxes
        let entity = NSEntityDescription.entityForName("Report", inManagedObjectContext: context)
        let newReport = Report(entity: entity!, insertIntoManagedObjectContext: context)
        newReport.scout = addNewReportViewController!.selectedScout
        newReport.team = selectedTeam
        newReport.cannPassSallyPort = 1
        
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

        cell.textLabel?.text = reportsForSelectedTeam[indexPath.row].scout?.scoutName
        cell.detailTextLabel?.text = "Defense: Excellent  Offense: Just Okay"

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
                print("Report found: \(r)")
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
