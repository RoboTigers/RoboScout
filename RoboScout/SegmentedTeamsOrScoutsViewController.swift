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
    
    // Push data from this device to all connected devices
    @IBAction func pushData(sender: AnyObject) {
        // Send all Teams
        // Do not need this as teams array is always up to date: refreshTeams()
        for teamToSend in teams {
            let teamDict : [String: AnyObject] = teamToSend.toDictionary()
            print ("Sending: teamDict = \(teamDict)")
            var jsonToSend : NSData = NSData()
            do {
                try jsonToSend = NSJSONSerialization.dataWithJSONObject(teamDict, options: NSJSONWritingOptions.PrettyPrinted)
            } catch {
                print("json error: \(error)")
            }
            tellEveryoneService.sendData(jsonToSend)
            print ("Sent data")
        }
        
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
        print("get team controller which just was unwinded")
        let addNewTeamViewController = unwindSegue.sourceViewController as? AddNewTeamViewController
        
        // teamNumber and teamName and location are required
        if ((addNewTeamViewController?.teamNumber.text?.isEmpty) != nil) ||
            ((addNewTeamViewController?.teamName.text?.isEmpty) != nil) ||
            ((addNewTeamViewController?.location.text?.isEmpty) != nil)     {
            
                print("  !!!!!!!  required field(s) missing")
                
                let refreshAlert = UIAlertController(title: "Missing Field", message: "All fields are required.", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    print("Missing data so return from unwind")
                    return
                }))
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(refreshAlert, animated: true, completion: nil)
                })
                
                return
        }
        
        // teamNumber must not already exist
        
        print(addNewTeamViewController!.teamNumber.text)
       
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // Get current year
        let currentYear = getCurrentYear()
        
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
        if ((addNewScoutViewController?.scoutName.text?.isEmpty) != nil) ||
            ((addNewScoutViewController?.fullName.text?.isEmpty) != nil)     {
                
                print("  !!!!!!!  required field(s) missing")
                
                let refreshAlert = UIAlertController(title: "Missing Field", message: "All fields are required.", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    print("Missing data so return from unwind")
                    return
                }))
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(refreshAlert, animated: true, completion: nil)
                })
                
                return
        }
        
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // Get current year
        let currentYear = getCurrentYear()
        
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
                let teamToDelete = teams.removeAtIndex(indexPath.row)
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
                let scoutToDelete = scouts.removeAtIndex(indexPath.row)
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
        request.predicate = NSPredicate(format: "year = %@", yearStr)
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
                //print("Scout found: \(s)")
            }
            teamOrScoutTableView.reloadData()
        } else {
            print("No scouts found")
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
        
        // TODO: For now we will just send team data, need to expand to include scout and report data
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Team", inManagedObjectContext: context)
        let receivedTeam = Team(entity: entity!, insertIntoManagedObjectContext: context)
        
        // Get received team from json data
        receivedTeam.loadFromJson(data)
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
}

