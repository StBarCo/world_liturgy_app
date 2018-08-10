library world_liturgy_app.globals;
import 'package:world_liturgy_app/json/serializePrayerBook.dart';
import 'package:world_liturgy_app/json/serializeCalendar.dart';
import 'package:world_liturgy_app/json/serializeSongBook.dart';
import 'package:world_liturgy_app/data/database.dart';
import 'package:world_liturgy_app/model/calendar.dart';

PrayerBooksContainer allPrayerBooks;
CalendarScaffold calendarScaffold;
SongBooksContainer allSongBooks;
DatabaseClient db;
Day currentDay;

Map translationMap = {
  'en_ke':{
//    GENERAL TRANSLATIONS
    'languageName':'English',

//  Prompts
    'yes': 'Yes',
    'no': 'No',
    'exitMessage': 'Do you want to exit?',

//    Tab names
    'songs': 'Songs',
    'prayerBook': 'Prayer Book',
    'lectionary': 'Lectionary',
    'bible': 'Bible',


//    TRANSLATIONS FOR INSTRUCTIONS
    'or': 'or',
    'tapToExpand': 'Tap to Expand',

//    TRANSLATIONS FOR TERMS
    'collect': 'Collect',
    'postCommunionPrayer': 'Post-Communion Prayer',


//    TRANSLATIONS FOR LEADERS
    'leader': 'Leader',
    'minister': 'Minister',
//    'deacon':'Deacon,
    'bishop': 'Bishop',
//    'archbishop': 'Archbishop',
    'reader': 'Reader',

//    TRANSLATIONS FOR PEOPLE SIDE
    'people': 'People',
    'all': 'All'





  },

  'sw_ke':{
    //    GENERAL TRANSLATIONS
    'languageName':'Kiswahili',

//  Prompts
    'yes': 'Ndiyo',
    'no': 'Hapana',
    'exitMessage': 'Je, unataka kutoka?',

//    Tab names
    'songs': 'Nyimbo',
    'prayerBook': 'Maombe',
    'lectionary': 'Taratibu ya Masomo',
    'bible': 'Biblia',


//    TRANSLATIONS FOR INSTRUCTIONS
    'or': 'au',
    'tapToExpand': 'Bomba ili Kupanua',

    //    TRANSLATIONS FOR TERMS
    'collect': 'Sala',
    'postCommunionPrayer': 'Baada ya Ushirika',



//    TRANSLATIONS FOR LEADERS
    'leader': 'Kiongozi',
    'minister': 'Kasisi',
    'bishop': 'Askofu',
//    'archbishop': 'Archbishop',
    'reader': 'Msomaji',

//    TRANSLATIONS FOR PEOPLE SIDE
    'people': 'Watu',
    'all': 'Wote'
  }
};


String translate(language, key){
  try {
    return translationMap[language][key];

  } catch(e){
    print('Translation Error: ' + language.toString() + 'AND' + key.toString());
    print(e.toString());
    return '';
  }
}

//String setAndGetCurrentLanguage({String language, PrayerBook prayerBook, int indexNumber, String indexString}){
//  if(language != null){
//    currentLanguage = language;
//  } else if (prayerBook != null){
//    currentLanguage = prayerBook.language;
//  } else if (indexNumber != null){
//    currentLanguage = allPrayerBooks.prayerBooks[indexNumber].language;
//  } else if (indexString != null){
//    currentLanguage = allPrayerBooks.getPrayerBook(indexString).language;
//  }
//
//  return currentLanguage;
//}