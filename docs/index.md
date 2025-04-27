# Easy Sync

## Abstract:
Boise State University administrators currently spend hours manually inputting class schedules from PeopleSoft Campus Solutions into Google Calendar due to format incompatibilities. Our solution automates this process by transforming PeopleSoft data into a Google Calendar-friendly format. Additionally, our solution allows administrators to assign schedules to specific Google Calendars, ensuring proper organization with ease. By streamlining this process, our tool will significantly reduce data entry time for the Geosciences department and possibly provide a solution for other university departments.

## Members:
 - Aidan Flinn
 - Ethan Barnes
 - Tyler Pierce

## Project Description

The project is packaged within an executable that when clicked/ran will open the application
//image of executable? 

After navigating through the landing page with the next button, the input page is within view. The user will have the ability to upload a file within the following formats: .csv, .xls, and .xlsx
Upon selecting a file from the user's local file system a "use defaults" option can be selected which will automatically tailor to the format returned from PeopleSoft class schedule exporting
//image of input page

If selecting the "use defaults" option and then clicking next page, the login page will appear. Utilizing the google_signin_dart package the user will be able to authenticate with a google email.
Once signed in, the user can then select one of the calendar sets linked from their google account in the left columnm. The user will also select a grouping of events by location in the right column.
The selected grouping of events by location will then be uploaded to the selected calendar set.
//image of login page

If the "use defaults" option is not selected on the input page then the user will be directed to the edit page upon clicking the next button. The user will then be prompted several questions such as
how is the title displayed, what column contains the start time of the event? The user will match the columns parsed from their uploaded file to the columns that will become the fields for the 
events being uploaded to google calendar.
//image of edit page


![SDP-Logo](images/sdp-logo.png?raw=true)
