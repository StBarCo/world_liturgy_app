import 'package:flutter/material.dart';

import '../model/calendar.dart';
import '../app.dart';
import '../pages/calendar.dart';
import '../model/bible.dart';
import '../globals.dart' as globals;


class BiblePage extends StatefulWidget{
  BiblePage({Key key}) : super(key:key);

  @override
  _BiblePageState createState() {
    return new _BiblePageState();
  }
}

class _BiblePageState extends State<BiblePage> {
  Bible currentBible;
  String currentBook;
  int currentChapter;

  _BiblePageState();

  @override
  void initState(){
    super.initState();
    currentBible = initialBible();
    currentBook = 'PSA';
    currentBible.bibleFormat.openBook(currentBook).then((var a){
        setState((){
        });
    });
    currentChapter = 9;
  }

  Bible initialBible(){
    return globals.bibles.first;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Bible'),
        textTheme: Theme
            .of(context)
            .textTheme,
      ),
      body: new Container(
        margin: new EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 00.0,
        ),
        child: new ListView(
//          shrinkWrap: true,
          children: currentBible.bibleFormat.renderChapter(currentBook, currentChapter),
        ),
      ),
    );
  }
}


Widget lectionaryReading(item, context){
  List<Widget> list = [];
  String lectionaryType = item.text.split(',')[0].trim();
  String readingType = item.text.split(',')[1].trim();

//  RefreshState.of(context).currentDay
  List<String> readings = getDailyReadings(lectionaryType, readingType, context);

  readings.forEach((ref){
    list.addAll(getPassage(ref, context));
  });

  return Column(
    children: list,
  );
}

List<Widget> getPassage(ref, context){
  List<Widget> list = [];
  String language = getLanguage(context);
  String passage = getDummyPassage(ref);


  list.add(Text(ref));
  list.add(Text(passage ?? ''));

  return list;
}

String getDummyPassage(ref) {
  switch (ref) {
    case 'Ez 15:1-8':
      {
        return ez15;
      }
      break;

    case 'Eph 2:1-10':
      {
        return eph2;
      }
      break;
    case 'Ps 119:89-104':
      {
        return ps119;
      }
      break;
    case 'John 8:31-59':
      {
        return john8;
      }
      break;
  }
  return john8;
}

String ez15 =
        '''15 The word of the Lord came to me: 2 “Son of man, how is the wood of a vine different from that of a branch from any of the trees in the forest? 3 Is wood ever taken from it to make anything useful? Do they make pegs from it to hang things on? 4 And after it is thrown on the fire as fuel and the fire burns both ends and chars the middle, is it then useful for anything? 5 If it was not useful for anything when it was whole, how much less can it be made into something useful when the fire has burned it and it is charred?
      
      6 “Therefore this is what the Sovereign Lord says: As I have given the wood of the vine among the trees of the forest as fuel for the fire, so will I treat the people living in Jerusalem. 7 I will set my face against them. Although they have come out of the fire, the fire will yet consume them. And when I set my face against them, you will know that I am the Lord. 8 I will make the land desolate because they have been unfaithful, declares the Sovereign Lord.” ''';

String eph2 = '''2 As for you, you were dead in your transgressions and sins, 2 in which you used to live when you followed the ways of this world and of the ruler of the kingdom of the air, the spirit who is now at work in those who are disobedient. 3 All of us also lived among them at one time, gratifying the cravings of our flesh[a] and following its desires and thoughts. Like the rest, we were by nature deserving of wrath. 4 But because of his great love for us, God, who is rich in mercy, 5 made us alive with Christ even when we were dead in transgressions—it is by grace you have been saved. 6 And God raised us up with Christ and seated us with him in the heavenly realms in Christ Jesus, 7 in order that in the coming ages he might show the incomparable riches of his grace, expressed in his kindness to us in Christ Jesus. 8 For it is by grace you have been saved, through faith—and this is not from yourselves, it is the gift of God— 9 not by works, so that no one can boast. 10 For we are God’s handiwork, created in Christ Jesus to do good works, which God prepared in advance for us to do.''';


String john8 ='''31 To the Jews who believed in him Jesus said: If you make my word your home you will indeed be my disciples;

32 you will come to know the truth, and the truth will set you free.

33 They answered, 'We are descended from Abraham and we have never been the slaves of anyone; what do you mean, "You will be set free?" '

34 Jesus replied: In all truth I tell you, everyone who commits sin is a slave.

35 Now a slave has no permanent standing in the household, but a son belongs to it for ever.

36 So if the Son sets you free, you will indeed be free.

37 I know that you are descended from Abraham; but you want to kill me because my word finds no place in you.

38 What I speak of is what I have seen at my Father's side, and you too put into action the lessons you have learnt from your father.

39 They repeated, 'Our father is Abraham.' Jesus said to them: If you are Abraham's children, do as Abraham did.

40 As it is, you want to kill me, a man who has told you the truth as I have learnt it from God; that is not what Abraham did.

41 You are doing your father's work. They replied, 'We were not born illegitimate, the only father we have is God.'

42 Jesus answered: If God were your father, you would love me, since I have my origin in God and have come from him; I did not come of my own accord, but he sent me.

43 Why do you not understand what I say? Because you cannot bear to listen to my words.

44 You are from your father, the devil, and you prefer to do what your father wants. He was a murderer from the start; he was never grounded in the truth; there is no truth in him at all. When he lies he is speaking true to his nature, because he is a liar, and the father of lies.

45 But it is because I speak the truth that you do not believe me.

46 Can any of you convict me of sin? If I speak the truth, why do you not believe me?

47 Whoever comes from God listens to the words of God; the reason why you do not listen is that you are not from God.

48 The Jews replied, 'Are we not right in saying that you are a Samaritan and possessed by a devil?' Jesus answered:

49 I am not possessed; but I honour my Father, and you deny me honour.

50 I do not seek my own glory; there is someone who does seek it and is the judge of it.

51 In all truth I tell you, whoever keeps my word will never see death.

52 The Jews said, 'Now we know that you are possessed. Abraham is dead, and the prophets are dead, and yet you say, "Whoever keeps my word will never know the taste of death."

53 Are you greater than our father Abraham, who is dead? The prophets are dead too. Who are you claiming to be?'

54 Jesus answered: If I were to seek my own glory my glory would be worth nothing; in fact, my glory is conferred by the Father, by the one of whom you say, 'He is our God,'

55 although you do not know him. But I know him, and if I were to say, 'I do not know him,' I should be a liar, as you yourselves are. But I do know him, and I keep his word.

56 Your father Abraham rejoiced to think that he would see my Day; he saw it and was glad.

57 The Jews then said, 'You are not fifty yet, and you have seen Abraham!'

58 Jesus replied: In all truth I tell you, before Abraham ever was, I am.

59 At this they picked up stones to throw at him; but Jesus hid himself and left the Temple.''';


String ps119 = '''What you say goes, God,
    and stays, as permanent as the heavens.
Your truth never goes out of fashion;
    it’s as up-to-date as the earth when the sun comes up.
Your Word and truth are dependable as ever;
    that’s what you ordered—you set the earth going.
If your revelation hadn’t delighted me so,
    I would have given up when the hard times came.
But I’ll never forget the advice you gave me;
    you saved my life with those wise words.
Save me! I’m all yours.
    I look high and low for your words of wisdom.
The wicked lie in ambush to destroy me,
    but I’m only concerned with your plans for me.
I see the limits to everything human,
    but the horizons can’t contain your commands!

97-104 
Oh, how I love all you’ve revealed;
    I reverently ponder it all the day long.
Your commands give me an edge on my enemies;
    they never become obsolete.
I’ve even become smarter than my teachers
    since I’ve pondered and absorbed your counsel.
I’ve become wiser than the wise old sages
    simply by doing what you tell me.
I watch my step, avoiding the ditches and ruts of evil
    so I can spend all my time keeping your Word.
I never make detours from the route you laid out;
    you gave me such good directions.
Your words are so choice, so tasty;
    I prefer them to the best home cooking.
With your instruction, I understand life;
    that’s why I hate false propaganda.''';