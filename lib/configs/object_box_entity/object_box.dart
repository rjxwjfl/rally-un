import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store){}

  static Future<ObjectBox> create() async{
    final docDir = await getApplicationDocumentsDirectory();
  }
}