import '../bibleParse/formats/zenfania.dart';
import '../bibleParse/formats/usx.dart';
import '../model/bible.dart';

List<Bible> initializeBibles() {
  return [
    Bible(
        abbreviation: 'WEB',
        title: 'World English Bible',
        language: 'en_ke',
        bibleFormat: USXBible(path: 'assets/bibles/WEB', publicationID: 'p4')),
    Bible(
        abbreviation: 'SUV',
        title: 'Swahili Union Version',
        language: 'sw_ke',
        bibleFormat: ZenfaniaBible(
          path: 'assets/bibles/SUV.xml',
          bookTitlesMap: {
            "GEN": {
              'bnumber': '1',
              'title': 'Mwanza',
            },
            "EXO": {
              'bnumber': '2',
              'title': 'Kutoka',
            },
            "LEV": {
              'bnumber': '3',
              'title': 'Mambo ya Walawi',
            },
            "NUM": {
              'bnumber': '4',
              'title': 'Hesabu',
            },
            "DEU": {
              'bnumber': '5',
              'title': 'Kumbukumbu la Torati',
            },
            "JOS": {
              'bnumber': '6',
              'title': 'Yoshua',
            },
            "JDG": {
              'bnumber': '7',
              'title': 'Waamuzi',
            },
            "RUT": {
              'bnumber': '8',
              'title': 'Ruthu',
            },
            "SA": {
              'bnumber': '9',
              'title': 'Samweli',
            },
            "2SA": {
              'bnumber': '10',
              'title': '2 Samweli',
            },
            "KI": {
              'bnumber': '11',
              'title': 'Wafalme',
            },
            "2KI": {
              'bnumber': '12',
              'title': '2 Wafalme',
            },
            "1CH": {
              'bnumber': '13',
              'title': '1 Mambo ya Nyakati',
            },
            "2CH": {
              'bnumber': '14',
              'title': '2 Mambo ya Nyakati',
            },
            "EZR": {
              'bnumber': '15',
              'title': 'Ezra',
            },
            "NEH": {
              'bnumber': '16',
              'title': 'Nehemia',
            },
            "ETH": {
              'bnumber': '17',
              'title': 'Esta',
            },
            "JOB": {
              'bnumber': '18',
              'title': 'Ayubu',
            },
            "PSA": {
              'bnumber': '19',
              'title': 'Zaburi',
            },
            "PRO": {
              'bnumber': '20',
              'title': 'Mithali',
            },
            "ECC": {
              'bnumber': '21',
              'title': 'Mhubiri',
            },
            "SNG": {
              'bnumber': '22',
              'title': 'Wimbo Ulio Bora',
            },
            "ISA": {
              'bnumber': '23',
              'title': 'Isaya',
            },
            "JER": {
              'bnumber': '24',
              'title': 'Yeremia',
            },
            "LAM": {
              'bnumber': '25',
              'title': 'Maombolezo',
            },
            "EZK": {
              'bnumber': '26',
              'title': 'Ezekieli',
            },
            "DAN": {
              'bnumber': '27',
              'title': 'Danieli',
            },
            "HOS": {
              'bnumber': '28',
              'title': 'Hosea',
            },
            "JOL": {
              'bnumber': '29',
              'title': 'Yoeli',
            },
            "AMO": {
              'bnumber': '30',
              'title': 'Amosi',
            },
            "OBA": {
              'bnumber': '31',
              'title': 'Obadai',
            },
            "JON": {
              'bnumber': '32',
              'title': 'Yona',
            },
            "MIC": {
              'bnumber': '33',
              'title': 'Mika',
            },
            "NAH": {
              'bnumber': '34',
              'title': 'Nahumu',
            },
            "HAB": {
              'bnumber': '35',
              'title': 'Habakuki',
            },
            "ZEP": {
              'bnumber': '36',
              'title': 'Sefanai',
            },
            "HAG": {
              'bnumber': '37',
              'title': 'Hagai',
            },
            "ZEC": {
              'bnumber': '38',
              'title': 'Zekaria',
            },
            "MAL": {
              'bnumber': '39',
              'title': 'Malaki',
            },
            "MAT": {
              'bnumber': '40',
              'title': 'Matayo',
            },
            "MRK": {
              'bnumber': '40',
              'title': 'Marko',
            },
            "LUK": {
              'bnumber': '42',
              'title': 'Luka',
            },
            "JHN": {
              'bnumber': '43',
              'title': 'Yohanna',
            },
            "ACT": {
              'bnumber': '44',
              'title': 'Matendo Ya Mitume',
            },
            "ROM": {
              'bnumber': '45',
              'title': 'Warumi',
            },
            "CO": {
              'bnumber': '46',
              'title': 'Wakorintho',
            },
            "2CO": {
              'bnumber': '47',
              'title': '2 Wakorintho',
            },
            "GAL": {
              'bnumber': '48',
              'title': 'Wagalatia',
            },
            "EPH": {
              'bnumber': '49',
              'title': 'Waefeso',
            },
            "PHP": {
              'bnumber': '50',
              'title': 'Wafilipi',
            },
            "COL": {
              'bnumber': '51',
              'title': 'WaKolosai',
            },
            "TH": {
              'bnumber': '52',
              'title': 'Wathesalonike',
            },
            "2TH": {
              'bnumber': '53',
              'title': '2 Wathesalonike',
            },
            "TI": {
              'bnumber': '54',
              'title': 'Timotheo',
            },
            "2TI": {
              'bnumber': '55',
              'title': '2 Timotheo',
            },
            "TIT": {
              'bnumber': '56',
              'title': 'Tito',
            },
            "PHM": {
              'bnumber': '57',
              'title': 'Filemoni',
            },
            "HEB": {
              'bnumber': '58',
              'title': 'Waebrania',
            },
            "JAS": {
              'bnumber': '59',
              'title': 'Yokobo',
            },
            "PE": {
              'bnumber': '60',
              'title': 'Petro',
            },
            "2PE": {
              'bnumber': '61',
              'title': '2 Petro',
            },
            "JN": {
              'bnumber': '62',
              'title': 'Yohanna',
            },
            "2KN": {
              'bnumber': '63',
              'title': '2 Yohanna',
            },
            "3KN": {
              'bnumber': '64',
              'title': '3 Yohanna',
            },
            "JUD": {
              'bnumber': '65',
              'title': 'Yuda',
            },
            "REV": {
              'bnumber': '66',
              'title': 'Ufunua wa Yohanna',
            },
            
          },
        ))
  ];
}
