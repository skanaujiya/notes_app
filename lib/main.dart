import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/db/notesdata.dart';

late Box dtb;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DataAdapter());
  dtb= await Hive.openBox('database');
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget{
  @override
  Widget build(BuildContext context)=>MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Notes',
    theme: ThemeData(
      primaryColor: Colors.blueAccent,
    ),
    home: MyApp(),
  );
}


class MyApp extends StatefulWidget{
  @override
  _MyApp createState()=>_MyApp();
}


final TextEditingController _title=TextEditingController();
final TextEditingController _detail=TextEditingController();
ValueNotifier<int> button_clicked= ValueNotifier(0);
textClear(){
  _title.clear();
  _detail.clear();
}


class _MyApp extends State<MyApp>{
  @override
  Widget build(BuildContext context)=> Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        leading: const Icon(Icons.note),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAlertDialog(context);
        },
        backgroundColor: Colors.red,
        splashColor: Colors.blue,
        elevation: 100,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        child: const Icon(Icons.add),
      ) ,
      body:ValueListenableBuilder(
      valueListenable: button_clicked,
      builder: (BuildContext context,int count,_){
        if(dtb.isEmpty)
        {return const Center(child: Text('Empty'),);}
        else
        {
          return ListView.builder(
              itemCount: dtb.length,
              itemBuilder: (context, index){
                Data data= dtb.getAt(index)!;
                return Padding(
                    padding: const EdgeInsets.all(4),
                  child: ListTile(
                    title: Text(data.title),
                    subtitle: Text(data.detail),
                    onTap: (){},
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(color: Colors.black),
                    ),
                    trailing: IconButton(
                      onPressed: (){
                        dtb.deleteAt(index);
                        button_clicked.value--;
                      },
                      icon: const Icon(Icons.delete,color: Colors.red,),
                    ),
                  ),
                );
              }
          );
        }
      },
    ),
  );
}

showAlertDialog(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          elevation: 50,
          title: const Text('Add new data'),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _detail,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Detail',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: (){
                  Data data=Data(title: _title.text, detail: _detail.text);
                  dtb.add(data);
                  button_clicked.value++;
                  textClear();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text("Submit")
            )
          ],
        );
      });
}
