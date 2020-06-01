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


### Add lectionary
* Data - week name, holy day name?
* Find Year, get map of week/holy day.

lectionary - save as json(s)



##Personal Notes
After changing prayerbooks.xml run xml2json.dart to generate prayerbook in jsonformat.