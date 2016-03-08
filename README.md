# RoboScout
iOS Application for FRC 2016 Scouting

This app is designed for the iPad and allows for Stand Scouting at the FRC 2016 competition. 
Simply add all teams you want to scout and all scouts in advance of the big day. 
Then sync the data with all your iPads and you are ready for the competition day. 
The idea is that each scout will have an iPad to use while scouting and then all scouts can 
sync their data such that all iPads have all scouting data.

### BEFORE COMPETITION

Enter teams and scouts using the plus sign (+) in the upper right corner:

<p class="group">

  <span>
    <img src="https://cloud.githubusercontent.com/assets/16652800/13597463/ce57471c-e4e6-11e5-91e0-7524af45dce0.png" width="400">
  </span>

  <span>
    <img src="https://cloud.githubusercontent.com/assets/16652800/13597482/ebfe222c-e4e6-11e5-8dec-e817dd0f26d4.png" width="400">
  </span>

</p>

### DURING THE COMPETITION

Click on the team you want to scout or analyze. A list of existing reports for that team is displayed 
with a + button to add another report. Each row indicates the match number and the scout name as well as a list of 
which defenses were crossed in that match. Clicking on the report itself from the list will open a text view of the 
data in that report. 

<img src="https://cloud.githubusercontent.com/assets/16652800/13597711/edf5b490-e4e7-11e5-9b8d-a3342073ec5f.png" width="500">

 Click the + to add a new report (e.g., a new match).

<img src="https://cloud.githubusercontent.com/assets/16652800/13597806/6f9f429a-e4e8-11e5-904e-4b086fc15298.png" width="550">


### SYNCING YOUR DATA

If you want to share your collected reports with your entire team or with analyst(s) for your team simply use 
the ‘Push Data’ button available in the upper left corner on the home screen. The sync functionality supports 
most forms of connectivity - our primary goal was to support bluetooth since internet connectivity may not 
be available during the competition. 

The ‘Push Data’ button will not just blindly send all your data to all connected devices - rather it will only 
push data to devices whose name matches the sender’s device name. The comparison is done by searching the 
device name backwards to the first dash (-) and using everything before the dash as the string to match. 
So if your device is named “RoboScouts-dr1” then you will be able to push your data to any bluetooth-connected device 
whose name starts with “RoboScouts-“.  You will be prompted to confirm if you want to send your data to all 
devices matching `<your-device-name-up-to-last-dash>`

<img src="https://cloud.githubusercontent.com/assets/16652800/13597969/4acf8708-e4e9-11e5-800b-7cdf496b0d52.png" width="300">

The sync is nearly instantaneous and all other connected devices matching your device name pattern will show the 
pushed data in all the screens (Team, Scout, Report). The sync does not support any deleted data. So if you want 
to delete a report for example then you will have to delete it manually on each device. That is, sync is an "add only" 
function.

We have many planned enhancements we hope to make before the next round of competitions so stay tuned for updates.
