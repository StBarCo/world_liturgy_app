import 'package:flutter/material.dart';
import 'styles.dart';

/// Returns a basic paragraph formatted as Biblical Text.
/// Accepts a dynamic list which contain either strings or a Map.
///
/// Accepted maps: 'vNumber': int or int as String -- verse number.
///
/// This basic class is used as the base for all paragraph classes.
/// Standard paragraphs are not displayed with any indentation.
class BibleParagraphBasic extends StatelessWidget {
  final List elements;
  final TextAlign alignment;

  BibleParagraphBasic(this.elements, [this.alignment = TextAlign.left]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text.rich(
        TextSpan(
          children: buildParagraph(elements),
        ),
        textAlign: alignment,
        style: generalTextStyle(),
      ),
    );
  }

  buildParagraph(List elements) {
    List<TextSpan> contents = [];

    elements.forEach((element) {
      if (element is String) {
        contents.add(TextSpan(
          text: element,
        ));
      }
      if (element is Map) {
        if (element.containsKey('vNumber')) {
          contents.add(verseNumber(element['vNumber']));
        }
      }
    });
    return contents;
  }

  TextSpan verseNumber(verse) {
    return TextSpan(
      text: getUnicodeSuperscript(verse) + ' ',
      style: verseNumberStyle(),
    );
  }

  String getUnicodeSuperscript(number) {
    String superscriptNumbers = '';
    Map<String, String> unicodeNumbers = {
      '2': '\u00B2',
      '3': '\u00B3',
      '1': '\u00B9',
      '4': '\u2074',
      '5': '\u2075',
      '6': '\u2076',
      '7': '\u2077',
      '8': '\u2078',
      '9': '\u2079',
      '0': '\u2070',
    };

    for (String digit in number.toString().split('')) {
      superscriptNumbers += unicodeNumbers[digit];
    }
    return superscriptNumbers;
  }
}

/// Used for block quotes additional horizontal margin on both sides.
class BibleParagraphIndented extends BibleParagraphBasic {
  BibleParagraphIndented(elements, [alignment]) : super(elements, alignment);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80.0, right: 80.0, top: 20.0),
      child: Text.rich(
        TextSpan(
          children: buildParagraph(elements),
        ),
        textAlign: alignment,
        style: generalTextStyle(),
      ),
    );
  }
}

/// No break from previous paragraph (no top padding).
class BibleParagraphNoBreak extends BibleParagraphBasic {
  BibleParagraphNoBreak(elements, [alignment]) : super(elements, alignment);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Text.rich(
        TextSpan(
          children: buildParagraph(elements),
        ),
        textAlign: alignment,
        style: generalTextStyle(),
      ),
    );
  }
}

/// Small heading -- esp. for Psalms (e.g. 'of David')
/// or to identify speaker.
class BiblePassageHeading extends BibleParagraphBasic {
  BiblePassageHeading(elements, [alignment]) : super(elements, alignment);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text.rich(
        TextSpan(
          children: buildParagraph(elements),
        ),
        textAlign: alignment,
        style: passageHeadingStyle(),
      ),
    );
  }
}

/// Major section header (e.g. 'Book 1' of the Psalms)
class BibleMajorSection extends BibleParagraphBasic {
  BibleMajorSection(elements, [alignment]) : super(elements, alignment);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text.rich(
        TextSpan(
          children: buildParagraph(elements),
        ),
        textAlign: TextAlign.center,
        style: sectionHeaderStyle(),
      ),
    );
  }
}

class BiblePoetryStanza extends BibleParagraphBasic {
  final int indentLevel;

  BiblePoetryStanza(elements, [this.indentLevel = 0, alignment])
      : super(elements, alignment);

  @override
  Widget build(BuildContext context) {
    String verse = checkForVerseNumber(elements.first);

    return Padding(
      padding: EdgeInsets.only(
          top: verse == null ? 0.0 : 3.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              verse != null ? getUnicodeSuperscript(verse) : '',
              style: verseNumberStyle(),
            ),
            width: 30.0,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: (indentLevel -1)* 30.0,
              ),
              child: Text.rich(
                TextSpan(children: buildParagraph(elements)),
                textAlign: alignment,
                style: generalTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  buildParagraph(List elements) {
    List<TextSpan> contents = [];

    elements.forEach((element) {
      if (element is String) {
        contents.add(TextSpan(
          text: element,
        ));
      }
    });
    return contents;
  }

  String checkForVerseNumber(element) {
    if (element is Map && element.containsKey('vNumber')) {
      return element['vNumber'].toString();
    }
    return null;
  }
}

class BiblePoetryBlankLine extends StatelessWidget {
  BiblePoetryBlankLine();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      '',
      style: generalTextStyle(),
    );
  }
}

class BibleChapterHeader extends StatelessWidget{
  final String chapterNumber;

  BibleChapterHeader(this.chapterNumber);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Text(
        chapterNumber,
        textAlign: TextAlign.center,
        style: chapterHeaderStyle(),
      ),
    );
  }

}

// OTHER POSSIBLE STYLES Listed in USX Style Sheet:

//  <style id="q" publishable="true" versetext="true">
//  <name>q - Poetry - Indent Level 1 - Single Level Only</name>
//  <description>Poetry text, level 1 indent (if single level)</description>
//  <property name="text-indent" unit="in">-1.000</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">1.250</property>
//  </style>
//  <style id="q1" publishable="true" versetext="true">
//  <name>q1 - Poetry - Indent Level 1</name>
//  <description>Poetry text, level 1 indent (if multiple levels) (basic)</description>
//  <property name="text-indent" unit="in">-1.000</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">1.250</property>
//  </style>
//  <style id="q2" publishable="true" versetext="true">
//  <name>q2 - Poetry - Indent Level 2</name>
//  <description>Poetry text, level 2 indent (basic)</description>
//  <property name="text-indent" unit="in">-0.750</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">1.250</property>
//  </style>
//  <style id="q3" publishable="true" versetext="true">
//  <name>q3 - Poetry - Indent Level 3</name>
//  <description>Poetry text, level 3 indent</description>
//  <property name="text-indent" unit="in">-0.500</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">1.250</property>
//  </style>
//  <style id="q4" publishable="true" versetext="true">
//  <name>q4 - Poetry - Indent Level 4</name>
//  <description>Poetry text, level 4 indent</description>
//  <property name="text-indent" unit="in">-0.250</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">1.250</property>
//  </style>
//  <style id="qc" publishable="true" versetext="true">
//  <name>qc - Poetry - Centered</name>
//  <description>Poetry text, centered</description>
//  <property name="text-align">center</property>
//  </style>
//  <style id="qr" publishable="true" versetext="true">
//  <name>qr - Poetry - Right Aligned</name>
//  <description>Poetry text, Right Aligned</description>
//  <property name="text-align">right</property>
//  </style>

//  <style id="qs" publishable="true" versetext="true">
//  <name>qs...qs* - Poetry Text - Selah</name>
//  <description>Poetry text, Selah</description>
//  <property name="font-style">italic</property>
//  <property name="text-align">left</property>
//  </style>

//  <style id="pi" publishable="true" versetext="true">
//  <name>pi - Paragraph - Indented - Level 1 - First Line Indent</name>
//  <description>Paragraph text, level 1 indent (if sinlge level), with first line indent; often used for discourse (basic)</description>
//  <property name="text-indent" unit="in">0.125</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">0.250</property>
//  <property name="margin-right" unit="in">0.250</property>
//  </style>
//  <style id="pi1" publishable="true" versetext="true">
//  <name>pi1 - Paragraph - Indented - Level 1 - First Line Indent</name>
//  <description>Paragraph text, level 1 indent (if multiple levels), with first line indent; often used for discourse</description>
//  <property name="text-indent" unit="in">0.125</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">0.250</property>
//  <property name="margin-right" unit="in">0.250</property>
//  </style>
//  <style id="pi2" publishable="true" versetext="true">
//  <name>pi2 - Paragraph - Indented - Level 2 - First Line Indent</name>
//  <description>Paragraph text, level 2 indent, with first line indent; often used for discourse</description>
//  <property name="text-indent" unit="in">0.125</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">0.500</property>
//  <property name="margin-right" unit="in">0.250</property>
//  </style>
//  <style id="pi3" publishable="true" versetext="true">
//  <name>pi3 - Paragraph - Indented - Level 3 - First Line Indent</name>
//  <description>Paragraph text, level 3 indent, with first line indent; often used for discourse</description>
//  <property name="text-indent" unit="in">0.125</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">0.750</property>
//  <property name="margin-right" unit="in">0.250</property>
//  </style>
//  <style id="pc" publishable="true" versetext="true">
//  <name>pc - Paragraph - Centered (for Inscription)</name>
//  <description>Paragraph text, centered (for Inscription)</description>
//  <property name="text-align">center</property>
//  </style>

//  <style id="cls" publishable="true" versetext="true">
//  <name>cls - Paragraph - Closure of an Epistle</name>
//  <description>Letter Closing</description>
//  <property name="text-align">right</property>
//  </style>

//  <style id="qa" publishable="true" versetext="false">
//  <name>qa - Poetry - Acrostic Heading/Marker</name>
//  <description>Poetry text, Acrostic marker/heading</description>
//  <property name="font-style">italic</property>
//  <property name="text-align">left</property>
//  </style>
//  <style id="qac" publishable="true" versetext="false">
//  <name>qac...qac* - Poetry Text - Acrostic Letter</name>
//  <description>Poetry text, Acrostic markup of the first character of a line of acrostic poetry</description>
//  <property name="font-style">italic</property>
//  <property name="text-align">left</property>
//  </style>
//  <style id="qm" publishable="true" versetext="true">
//  <name>qm - Poetry - Embedded Text - Indent Level 1 - Single Level Only</name>
//  <description>Poetry text, embedded, level 1 indent (if single level)</description>
//  <property name="text-indent" unit="in">-0.750</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">1.000</property>
//  </style>
//  <style id="qm1" publishable="true" versetext="true">
//  <name>qm1 - Poetry - Embedded Text - Indent Level 1</name>
//  <description>Poetry text, embedded, level 1 indent (if multiple levels)</description>
//  <property name="text-indent" unit="in">-0.750</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">1.000</property>
//  </style>
//  <style id="qm2" publishable="true" versetext="true">
//  <name>qm2 - Poetry - Embedded Text - Indent Level 2</name>
//  <description>Poetry text, embedded, level 2 indent</description>
//  <property name="text-indent" unit="in">-0.500</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">1.000</property>
//  </style>
//  <style id="qm3" publishable="true" versetext="true">
//  <name>qm3 - Poetry - Embedded Text - Indent Level 3</name>
//  <description>Poetry text, embedded, level 3 indent</description>
//  <property name="text-indent" unit="in">-0.250</property>
//  <property name="text-align">left</property>
//  <property name="margin-left" unit="in">1.000</property>
//  </style>
