import 'package:flutter/foundation.dart';

void printLog({required Object message}) {
  if (kDebugMode) {
    print(message);
  }
}

void printError({required Object error}){
  if (kDebugMode){
    print(error);
  }
}

void printMap({required Map<String, dynamic> map}){

}