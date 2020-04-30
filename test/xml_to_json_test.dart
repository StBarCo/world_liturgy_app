//import 'dart:io';
//import 'package:world_liturgy_app/json/xml_parser.dart';
//
//main() {
//  print('foo');
//
//  var dir = Directory.current;
//
//  print(dir);
//
//}

/// TODO:
/// 1: for every WLP xml asset, run this to transform the xml into json string.
/// 2: save json string in file -- maybe as dart constant? maybe as string to be read.
///

import 'package:build/build.dart';

class CopyBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.txt': ['.copy.txt']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // get teh currently matched asset
    var inputId = buildStep.inputId;

    // Create a new target 'AssetId' based on current one
    var copyAssetId = inputId.changeExtension('.copy.txt');
    var contents = await buildStep.readAsString(inputId);

    // write new asset

    await buildStep.writeAsString(copyAssetId, contents);

  }
}