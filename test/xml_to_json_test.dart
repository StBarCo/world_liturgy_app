import 'dart:io';
import 'package:world_liturgy_app/json/xml_parser.dart';

main() {
  print('foo');

  var dir = Directory.current;

  print(dir);

}

/// TODO:
/// 1: for every WLP xml asset, run this to transform the xml into json string.
/// 2: save json string in file -- maybe as dart constant? maybe as string to be read.