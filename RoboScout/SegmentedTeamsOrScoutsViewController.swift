//
//  SegmentedTeamsOrScoutsViewController.swift
//  RoboScout
//
//  Created by Sharon Kass on 2/4/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import UIKit
import CoreData

class SegmentedTeamsOrScoutsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // Tip: Can test that the service is advertised on the loxcal network either using the dns-sd terminal command:
    // dns-sd -B _services._dns-sd._udp
    let tellEveryoneService = TellEveryoneServiceManager()
    
    // MARK: - Model
    var teams = [Team]()
    var scouts = [Scout]()
    
    // MARK: - Outlets and Actions

    @IBOutlet weak var segmentedTeamOrScoutControl: UISegmentedControl!
    @IBOutlet weak var teamOrScoutTableView: UITableView!
    
    // Push data from this device to all connected devices that match pattern of sending device
    @IBAction func pushData(sender: AnyObject) {
        
        let myDevice : UIDevice = UIDevice.currentDevice();
        let myDeviceName = myDevice.name
        print("My device name is \(myDeviceName)")
        let myDeviceDashIdx = myDeviceName.rangeOfString("-", options: .BackwardsSearch)?.startIndex
        var myDeviceSubstringUpToDash = ""
        if (myDeviceDashIdx != nil) {
            myDeviceSubstringUpToDash = myDeviceName.substringToIndex(myDeviceDashIdx!)
        }
        print("Checking for peers with this string before the last dash: \(myDeviceSubstringUpToDash)")
        
        
        
        pushTeams()
        pushScouts()
        pushReports()
    }
    
    @IBAction func addNewTeamOrScoutAction(sender: UIBarButtonItem) {
        switch (segmentedTeamOrScoutControl.selectedSegmentIndex) {
        case 0:
            print("Add new team")
            performSegueWithIdentifier("AddNewTeamSegue", sender: self)
        case 1:
            print("Add new scout")
            performSegueWithIdentifier("AddNewScoutSegue", sender: self)
        default:
            print("Not team and not scout")
        }
    }
    
    @IBAction func segmentTeamOrScoutSelectedAction(sender: AnyObject) {
        teamOrScoutTableView.reloadData()
    }
    
    @IBAction func unwindFromCancel(unwindSegue: UIStoryboardSegue) {
        print("Canceled")
    }
    
    @IBAction func unwindFromTeamAdd(unwindSegue: UIStoryboardSegue) {
        
        let addNewTeamViewController = unwindSegue.sourceViewController as? AddNewTeamViewController
        
        if ( ((addNewTeamViewController?.teamNumber.text)!.isEmpty)  ||
             ((addNewTeamViewController?.teamName.text)!.isEmpty) ||
             ((addNewTeamViewController?.location.text)!.isEmpty) ) {
                displayErrorAlertWithOk("All Team fields are required")
                return
        }
        
        print(addNewTeamViewController!.teamNumber.text)
       
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // Get current year
        let currentYear = getCurrentYear()
        
        
        // teamNumber must not already exist
        let request = NSFetchRequest(entityName: "Team")
        request.returnsObjectsAsFaults = false;
        
        let keyValues: [String: AnyObject] = ["teamNumber" : addNewTeamViewController!.teamNumber.text!, "year" : currentYear]
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
            print("Error fetching team with number \(addNewTeamViewController!.teamNumber.text!)")
        }
        
        if results.count > 0 {
            displayErrorAlertWithOk("Team \(addNewTeamViewController!.teamNumber.text!) already exists")
            return
        }
        
        
        // Team does not already exist so add new team object to data store
        // Grab values from text boxes
        let entity = NSEntityDescription.entityForName("Team", inManagedObjectContext: context)
        let newTeam = Team(entity: entity!, insertIntoManagedObjectContext: context)
        newTeam.teamNumber = addNewTeamViewController!.teamNumber.text
        newTeam.teamName = addNewTeamViewController!.teamName.text
        newTeam.year = String(currentYear)
        newTeam.location = addNewTeamViewController!.location.text
        
        // Persist to data store
        do {
            try context.save()
        } catch _ {
            // Handle core data error
            print("Error saving new team")
        }
        print("newTeam: \(newTeam)")
        print("Object saved successfully")
        
        //print("Reload tableView")
        //self.tableView.reloadData()
        
    }
    
    
    @IBAction func unwindFromScoutAdd(unwindSegue: UIStoryboardSegue) {
        print("get scout controller which just was unwinded")
        let addNewScoutViewController = unwindSegue.sourceViewController as? AddNewScoutViewController
        
        // scoutname and fullname are required
        if ( ((addNewScoutViewController?.scoutName.text)!.isEmpty)  ||
            ((addNewScoutViewController?.fullName.text)!.isEmpty) ) {
                displayErrorAlertWithOk("All Scout fields are required")
                return
        }
        
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // Get current year
        let currentYear = getCurrentYear()
        
        
        // scoutName must not already exist
        let request = NSFetchRequest(entityName: "Scout")
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "scoutName = %@", addNewScoutViewController!.scoutName.text!)
        var results:NSArray = NSArray()
        do {
            results = try context.executeFetchRequest(request)
        } catch _ {
            print("Error fetching scout with name \(addNewScoutViewController!.scoutName.text!)")
        }
        
        if results.count > 0 {
            displayErrorAlertWithOk("Scout \(addNewScoutViewController!.scoutName.text!) already exists")
            return
        }
        
        
        // Scout does not already exist so add new scout object to data store
        
        // Grab values from text boxes
        let entity = NSEntityDescription.entityForName("Scout", inManagedObjectContext: context)
        let newScout = Scout(entity: entity!, insertIntoManagedObjectContext: context)
        newScout.scoutName = addNewScoutViewController!.scoutName.text
        newScout.year = String(currentYear)
        newScout.fullName = addNewScoutViewController!.fullName.text
        
        // Persist to data store
        do {
            try context.save()
        } catch _ {
            // Handle core data error
            print("Error saving new scout")
        }
        print("newScout: \(newScout)")
        print("Object saved successfully")
        
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
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(animated: Bool) {
        print("VIEW DID APPEAR")
        refreshTeams()
        refreshScouts()
    }
    
    override func viewDidLoad() {
        print("VIEW DID LOAD")
        super.viewDidLoad()
        
        // Set this view controller as the delegate for the sync (tell-everyone) service
        tellEveryoneService.delegate = self
        
        // This will remove extra separators from tableview
        teamOrScoutTableView.tableFooterView = UIView(frame: CGRectZero)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Implement Protocols
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var ret = 0
        switch (segmentedTeamOrScoutControl.selectedSegmentIndex) {
        case 0:
            ret = teams.count
            break
        case 1:
            ret = scouts.count
            break
        default:
            break
        }
        return ret
    }
    
    private struct Storyboard {
        static let CellReuseIdentifier = "SegmentedTeamOrScoutCell"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath)
        
        // Configure the cell...
        switch (segmentedTeamOrScoutControl.selectedSegmentIndex) {
        case 0:
            cell.textLabel?.text = teams[indexPath.row].teamNumber
            cell.detailTextLabel?.text = teams[indexPath.row].teamName
            break
        case 1:
            cell.textLabel?.text = scouts[indexPath.row].scoutName
            cell.detailTextLabel?.text = scouts[indexPath.row].fullName
            break
        default:
            break
        }
        
//        if (indexPath.row+1)%2 == 0 {
//            cell.contentView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
//        }
        
        return cell
    }
        
    // conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            
            switch (segmentedTeamOrScoutControl.selectedSegmentIndex) {
            case 0:
                // Team delete
                
                // Get team to be deleted from the array
                let teamToDelete = teams[indexPath.row]
                
                // Do not remove a team if it has associated reports. User will have to delete the reports. This is for prevention of data loss.
                // TOOD: We could have an alert saying "All associated reports will be deleted. Is this okay?" with an OK action but for now just disallow it.
                if (teamToDelete.reports?.count > 0) {
                    displayErrorAlertWithOk("Cannot delete Team which has Reports")
                    refreshTeams()
                    return
                }
                
                // Delete from this view controllers model
                teams.removeAtIndex(indexPath.row)
                
                // Delete from data store
                let request = NSFetchRequest(entityName: "Team")
                // Create compund predicate so we can find the object in the graph to delete
                // We need condition of teamNumber == (teamNumber of selected team) && year == (year of selected team)
                let keyValues: [String: AnyObject] = ["teamNumber" : teamToDelete.teamNumber!, "year" : teamToDelete.year!]
                var predicates = [NSPredicate]()
                for (key, value) in keyValues {
                    let predicate = NSPredicate(format: "%K = %@", key, value as! NSObject)
                    predicates.append(predicate)
                }
                let compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicates)
                request.predicate = compoundPredicate
                
                do {
                    let fetchedEntities = try context.executeFetchRequest(request) as! [Team]
                    if let entityToDelete = fetchedEntities.first {
                        context.deleteObject(entityToDelete)
                    }
                } catch {
                    print("Unable to retrieve team object to delete: " + teamToDelete.teamNumber!)
                }
                
                do {
                    try context.save()
                } catch {
                    print("Unable to save context when deleting team: " + teamToDelete.teamNumber!)
                }
            case 1:
                // Scout delete
                
                // Get scout to be deleted from the array
                let scoutToDelete = scouts[indexPath.row]
                
                // Do not remove a scout if it has associated reports.
                if (scoutToDelete.reports?.count > 0) {
                    displayErrorAlertWithOk("Cannot delete Scout which has Reports")
                    refreshScouts()
                    return
                }
                
                // Delete from this view controllers model
                scouts.removeAtIndex(indexPath.row)
                
                // Delete from data store
                let request = NSFetchRequest(entityName: "Scout")
                // Create compund predicate so we can find the object in the graph to delete
                // We need condition of scoutName == (scoutName of selected scout) && year == (year of selected scout)
                let keyValues: [String: AnyObject] = ["scoutName" : scoutToDelete.scoutName!, "year" : scoutToDelete.year!]
                var predicates = [NSPredicate]()
                for (key, value) in keyValues {
                    let predicate = NSPredicate(format: "%K = %@", key, value as! NSObject)
                    predicates.append(predicate)
                }
                let compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicates)
                request.predicate = compoundPredicate
                
                do {
                    let fetchedEntities = try context.executeFetchRequest(request) as! [Scout]
                    if let entityToDelete = fetchedEntities.first {
                        context.deleteObject(entityToDelete)
                    }
                } catch {
                    print("Unable to retrieve scout object to delete: " + scoutToDelete.scoutName!)
                }
                
                do {
                    try context.save()
                } catch {
                    print("Unable to save context when deleting scout: " + scoutToDelete.scoutName!)
                }
            default:
                print("Default action for delete row swipe")
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } /* else if editingStyle == .Insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        } */
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navigationController = destination as? UINavigationController {
            destination = navigationController.visibleViewController
        }
        if let reportsViewController = destination as? SegmentedReportsTableViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                    case "Show_Reports":
                        print ("Show_Reports segue")
                        if let cell = sender as? UITableViewCell {
                            let i = teamOrScoutTableView.indexPathForCell(cell)!.row
                            reportsViewController.selectedTeam = teams[i]
                        }
                    default:
                        print ("Unknown segueIdentifier: \(segueIdentifier)")
                    
                }
            }
        }
    }

    
    
    // MARK: - Private utility functions
    
    private func refreshTeams() {
        
        // Empty out teams and replace all
        // TODO: Better approach might be to add to array only if not already contained in array
        teams.removeAll()
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // Get current year
        let yearStr = String(getCurrentYear())
        
        // Get teams from data store
        let request = NSFetchRequest(entityName: "Team")
        request.returnsObjectsAsFaults = false;
        // Filter by year
        request.predicate = NSPredicate(format: "year = %@", yearStr)
        // Sort by team number
        let sectionSortDescriptor = NSSortDescriptor(key: "teamNumber", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        // Execute Request
        var results:NSArray = NSArray()
        do {
            results = try context.executeFetchRequest(request)
        } catch _ {
            print("Error fetching teams")
        }
        
        if results.count > 0 {
            for team in results {
                let t = team as! Team
                teams.append(t)
                //print("Team found: \(t)")
            }
            teamOrScoutTableView.reloadData()
        } else {
            print("No teams found")
        }
    }
    
    private func refreshScouts() {
        
        // Empty out teams and replace all
        // TODO: Better approach might be to add to array only if not already contained in array
        scouts.removeAll()
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // Get current year
        let yearStr = String(getCurrentYear())
        
        // Get scouts from data store
        let request = NSFetchRequest(entityName: "Scout")
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "year = %@", yearStr)
        // Sort by scout name
        let sectionSortDescriptor = NSSortDescriptor(key: "scoutName", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        var results:NSArray = NSArray()
        do {
            results = try context.executeFetchRequest(request)
        } catch _ {
            print("Error fetching scouts")
        }
        
        if results.count > 0 {
            for scout in results {
                let s = scout as! Scout
                scouts.append(s)
            }
            teamOrScoutTableView.reloadData()
        } else {
            print("No scouts found")
        }
    }
    
    private func getAllReports(context:NSManagedObjectContext) -> [Report] {
        // Getting all reports, even reports which may not have team/scout from current year
        // In future perhaps add year to Report entity to improve performance of sync util
        // or else sync reports while syncing each team.
        var reports = [Report]()
        
        // Get reports from data store
        let request = NSFetchRequest(entityName: "Report")
        request.returnsObjectsAsFaults = false;
        
        // Execute request
        var results:NSArray = NSArray()
        do {
            results = try context.executeFetchRequest(request)
        } catch _ {
            print("Error fetching reports")
            return reports
        }
        
        if results.count > 0 {
            for report in results {
                let r = report as! Report
                reports.append(r)
            }
        } else {
            print("No reports found")
            return reports
        }
        
        return reports
    }
    
    private func getCurrentYear() -> Int {
        // Get current year
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year],  fromDate: date)
        let currentYear = components.year
        return currentYear
    }
    
    // MARK: - Sync functionality
    
//    func reflectReceivedMessage (text: String) {
//        //msgLabel.text = text
//    }
    
    func updateTitle (text: String) {
        self.title = text
        self.viewDidAppear(true)
    }

}


extension SegmentedTeamsOrScoutsViewController : TellEveryoneServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: TellEveryoneServiceManager, connectedDevices: [String]) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            //self.connectionsLabel.text = "Connections: \(connectedDevices)"
            self.updateTitle("Found \(connectedDevices)")
        }
    }
    
//    func textChanged(manager: TellEveryoneServiceManager, textString: String) {
//        print("In TEVC, textChanged and the text is \(textString)")
//        NSOperationQueue.mainQueue().addOperationWithBlock {
//            self.reflectReceivedMessage(textString)
//        }
//    }
    
    func dataChanged(manager: TellEveryoneServiceManager, data: NSData) {
        print("In SegmentedTeamsOrScoutsViewController, dataChanged")
        
        if let dictReceived: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
            print ("Dictionary received")
            print ("dictReceived = \(dictReceived)")
            let disriminator:String = (dictReceived["entityDiscriminator"] as? String)!
            let entityObject: NSDictionary = (dictReceived["entityObject"] as? NSDictionary)!
            print("discriminator received:  \(disriminator)")
            print("entity object received: \(entityObject)")
            
            
            switch (disriminator) {
            case "TEAM":
                print("Unpack json to get team data")
                teamDataChanged(entityObject)
            case "SCOUT":
                print("Unpack json to get scout data")
                scoutDataChanged(entityObject)
            case "REPORT":
                print("Unpack json to get report data")
                reportDataChanged(entityObject)
            default:
                print("ERROR: Unknown discriminator")
            }
            
            
            
            if (disriminator == "TEAM") {
                print("Unpack json to get team data")
                teamDataChanged(entityObject)
            }
            
            
            print ("Done processing received \(disriminator)")
        }
        
    }
    
    func teamDataChanged(dict: NSDictionary) {
    
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // First check that received team is not already in the data store
        let teamNumber:String = dict["teamNumber"] as! String
        let request = NSFetchRequest(entityName: "Team")
        request.returnsObjectsAsFaults = false;
            
        // Get current year (sync only supported for "current" year
        let currentYear = getCurrentYear()
            
        let keyValues: [String: AnyObject] = ["teamNumber" : teamNumber, "year" : currentYear]
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
            print("Error fetching team with number \(teamNumber)")
        }
            
        if results.count > 0 {
            // Ignore duplicate received team
            return
        }
        
        
        // Create new Team in data store
        let entity = NSEntityDescription.entityForName("Team", inManagedObjectContext: context)
        let receivedTeam = Team(entity: entity!, insertIntoManagedObjectContext: context)
        
        // Get received team from json data
        receivedTeam.loadFromJson(dict)
        print ("receivedTeam = \(receivedTeam)")
        
        // Persist to data store
        do {
            try context.save()
        } catch _ {
            // Handle core data error
            print("Error saving new team")
        }
        print("receivedTeam: \(receivedTeam)")
        print("Object saved successfully")
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            //self.reflectReceivedMessage(receivedTeam.teamName!)
            self.updateTitle("Received Sync Data")
        }
    }
    
    func scoutDataChanged(dict: NSDictionary) {
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // First check that received scout is not already in the data store
        let scoutName:String = dict["scoutName"] as! String
        let request = NSFetchRequest(entityName: "Scout")
        request.returnsObjectsAsFaults = false;
        
        // Get current year (sync only supported for "current" year
        let currentYear = getCurrentYear()
        
        let keyValues: [String: AnyObject] = ["scoutName" : scoutName, "year" : currentYear]
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
            print("Error fetching scout with unique name \(scoutName)")
        }
        
        if results.count > 0 {
            // Ignore duplicate received team
            return
        }
        
        
        // Create new Scout in data store
        let entity = NSEntityDescription.entityForName("Scout", inManagedObjectContext: context)
        let receivedScout = Team(entity: entity!, insertIntoManagedObjectContext: context)
        
        // Get received scout from json data
        receivedScout.loadFromJson(dict)
        print ("receivedScout = \(receivedScout)")
        
        // Persist to data store
        do {
            try context.save()
        } catch _ {
            // Handle core data error
            print("Error saving new scout")
        }
        print("receivedScout: \(receivedScout)")
        print("Object saved successfully")
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.updateTitle("Received Sync Data")
        }
    }
    
    func reportDataChanged(dict: NSDictionary) {
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // First check that received report is not already in the data store
        // We determine this by using the unique composite key for a report:
        //      event + type + match + team + scout
        
        // Check for existing Report entity matching our composite key
        let request = NSFetchRequest(entityName: "Report")
        request.returnsObjectsAsFaults = false;
        
        // Get team object
        let currentYear = getCurrentYear()
        let requestTeam = NSFetchRequest(entityName: "Team")
        requestTeam.returnsObjectsAsFaults = false;
        let keyValuesForTeam: [String: AnyObject] = ["teamNumber" : dict["teamNumber"]!, "year" : currentYear]
        var predicatesTeam = [NSPredicate]()
        for (key, value) in keyValuesForTeam {
            print("Adding key (\(key)) and value (\(value)) to predicate")
            let predicateTeam = NSPredicate(format: "%K = %@", key, value as! NSObject)
            predicatesTeam.append(predicateTeam)
        }
        let compoundPredicateTeam = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicatesTeam)
        requestTeam.predicate = compoundPredicateTeam
        
        var resultsTeam:NSArray = NSArray()
        do {
            resultsTeam = try context.executeFetchRequest(requestTeam)
        } catch _ {
            print("Error fetching team with number \(dict["teamNumber"])")
        }
        
        if resultsTeam.count == 0 {
            print("Unable to find team \(dict["teamNumber"]) for received report")
            return
        }
        let receivedTeam : Team = resultsTeam[0] as! Team
        
        
        // Get scout object
        let requestScout = NSFetchRequest(entityName: "Scout")
        requestScout.returnsObjectsAsFaults = false;
        let keyValuesForScout: [String: AnyObject] = ["scoutName" : dict["scoutName"]!, "year" : currentYear]
        var predicatesScout = [NSPredicate]()
        for (key, value) in keyValuesForScout {
            print("Adding key (\(key)) and value (\(value)) to predicate")
            let predicateScout = NSPredicate(format: "%K = %@", key, value as! NSObject)
            predicatesScout.append(predicateScout)
        }
        let compoundPredicateScout = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicatesScout)
        requestScout.predicate = compoundPredicateScout
        
        var resultsScout:NSArray = NSArray()
        do {
            resultsScout = try context.executeFetchRequest(requestScout)
        } catch _ {
            print("Error fetching Scout with name \(dict["scoutName"])")
        }
        
        if resultsScout.count == 0 {
            print("Unable to find Scout \(dict["scoutName"]) for received report")
            return
        }
        let receivedScout : Scout = resultsScout[0] as! Scout
        
        
        // Build composite key to search for an already existing report
        let keyValues: [String: AnyObject] = ["event" : dict["event"]!,
            "matchNumber" : dict["matchNumber"]!,
            "team" : receivedTeam, "scout" : receivedScout]
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
            print("Error fetching report with event \(dict["event"]) and match \(dict["matchNumber"]) and team \(receivedTeam.teamNumber) and scout \(receivedScout.scoutName)")
        }
        
        if results.count > 0 {
            print("Report already exists so not adding it to store as part of sync")
            return
        }
        
        
        
        // Create new Report in data store
        let entity = NSEntityDescription.entityForName("Report", inManagedObjectContext: context)
        let receivedReport = Report(entity: entity!, insertIntoManagedObjectContext: context)
        
        // Get received report from json data
        receivedReport.loadFromJson(dict, context: context)
        print ("receivedReport = \(receivedReport)")
        
        // Persist to data store
        do {
            try context.save()
        } catch _ {
            // Handle core data error
            print("Error saving new scout")
        }
        print("receivedReport: \(receivedReport)")
        print("Object saved successfully")
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.updateTitle("Received Sync Data")
        }
    }

    
    
    func pushTeams() {
        // Send all Teams
        for teamToSend in teams {
            let teamDict : [String: AnyObject] = teamToSend.toDictionary()
            var dictToSend = [String: AnyObject]()
            dictToSend["entityDiscriminator"] = "TEAM"
            dictToSend["entityObject"] = teamDict
            print ("Sending: dictToSend = \(dictToSend)")
            var jsonToSend : NSData = NSData()
            do {
                try jsonToSend = NSJSONSerialization.dataWithJSONObject(dictToSend, options: NSJSONWritingOptions.PrettyPrinted)
            } catch {
                print("json error: \(error)")
            }
            tellEveryoneService.sendData(jsonToSend)
            print ("Sent team")
        }
    }
    
    func pushScouts() {
        // Send all Scouts
        for scoutToSend in scouts {
            let scoutDict : [String: AnyObject] = scoutToSend.toDictionary()
            var dictToSend = [String: AnyObject]()
            dictToSend["entityDiscriminator"] = "SCOUT"
            dictToSend["entityObject"] = scoutDict
            print ("Sending: dictToSend = \(dictToSend)")
            var jsonToSend : NSData = NSData()
            do {
                try jsonToSend = NSJSONSerialization.dataWithJSONObject(dictToSend, options: NSJSONWritingOptions.PrettyPrinted)
            } catch {
                print("json error: \(error)")
            }
            tellEveryoneService.sendData(jsonToSend)
            print ("Sent scout")
        }
    }
    
    func pushReports() {
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // Get all reports
        let reports = getAllReports(context)
        if (reports.count == 0) {
            print("No reports found so no reports to push")
            return
        }
        
        // Get current year (sync only supported for "current" year
        let currentYear = getCurrentYear()

        // Send all Reports (for current year)
        for reportToSend in reports {
            if (reportToSend.team?.year == String(currentYear)) {
                let reportDict : [String: AnyObject] = reportToSend.toDictionary()
                var dictToSend = [String: AnyObject]()
                dictToSend["entityDiscriminator"] = "REPORT"
                dictToSend["entityObject"] = reportDict
                print ("Sending: dictToSend = \(dictToSend)")
                var jsonToSend : NSData = NSData()
                do {
                    try jsonToSend = NSJSONSerialization.dataWithJSONObject(dictToSend, options: NSJSONWritingOptions.PrettyPrinted)
                } catch {
                    print("json error: \(error)")
                    return
                }
                tellEveryoneService.sendData(jsonToSend)
                print ("Sent report")
            }
        }
    }
    
}

