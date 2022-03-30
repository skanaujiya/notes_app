import 'package:hive/hive.dart';
part 'notesdata.g.dart';

@HiveType(typeId:0)

class Data extends HiveObject{
  Data({required this.title, required this.detail});
  @HiveField(0)
  String title;
  @HiveField(1)
  String detail;
}