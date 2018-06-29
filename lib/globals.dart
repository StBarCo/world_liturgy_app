library world_liturgy_app.globals;
import 'package:world_liturgy_app/json/serializePrayerBook.dart';
import 'package:world_liturgy_app/json/serializeCalendar.dart';
import 'package:world_liturgy_app/data/database.dart';
import 'package:world_liturgy_app/model/calendar.dart';

PrayerBooksContainer allPrayerBooks;
CalendarScaffold calendarScaffold;
DatabaseClient db;
Day currentDay;
Map translationMap = {
  'en_ke':{
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