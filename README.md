# world_liturgy_app

The base repository for the World Liturgy (www.worldliturgy.org)family of apps.

The purpose of this app is to enable churches to easily create electronic versions of their liturgies, and song books in an accessible XML format. They can essentially be plugged into the World Liturgy framework and have an app.


## Features
* Prayer books with multiple services
* Multiple prayer books in multiple languages.
* Individual sections can be hidden, collapsed, or index and expanded on tap.
* Support for song books.
* User's ability to change font size.
* Integrated church calendar

### Future Features:
* Integrated lectionary with prayer services.
* Support for Bible texts and link with lectionaries.
* Support for searching within a service.


## XML Format for texts
Will be documented soon.

## Wanting more info?

### Contributors
We are looking for help in creating this project. Contact me at info@worldliturgy.org


## IN ORDER TO MODIFY AND PUBLISH ANOTHER PRAYER BOOK:
APP customizations are centralized in:
* /android folder ?
* / assets folder has all the prayerbooks, songbooks, and bibles.
* /lib
** /data 
*** /bible_settings.dart - map of all used bibles
*** /prayer_book_settings - initial favorited services
*** / song_settings - map of songbooks
** / globals  - global settings, appTitle, translation map




## ToDo
### Calendar
*Transfomr
*Save as Maps - (Seasons (DateRange, Principal Feasts, Other days)
*To find one day -- 
    get season - in range
    find week/name
    check if principal feast
    check if other feast
    do something about sundays/other feast days
    

for month, basically do the same, just loop a bit more

### Prayer Book
* Try saving as JSON string
* Then load and create prayer books as needed.

* maybe use future builder on service.dart

### Add lectionary
* Data - week name, holy day name?
* Find Year, get map of week/holy day.

lectionary - save as json(s)



use this video as starting point: https://www.youtube.com/watch?v=H4HWB2Pmgcw -- Generating code in dart