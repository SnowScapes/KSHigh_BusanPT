import 'package:flutter/material.dart';
import 'package:flutter_todolist_app/archive_page.dart';
import 'package:flutter_todolist_app/models/task.dart';
import 'package:flutter_todolist_app/widgets/card_widget.dart';
import 'package:flutter_todolist_app/widgets/form_widget.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newList = listTask.where((element) => !element.isDone).toList();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: size.width,
                height: size.height / 3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff8d70fe),
                      Color(0xff2da9ef),
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Busan Bus',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ListTile(
                      leading: Text(
                        DateTime.now().day.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 52,
                          color: Colors.amber,
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          DateTime.now().month.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        DateTime.now().year.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: size.height / 4.5,
              left: 16,
              child: Container(
                width: size.width - 32,
                height: size.height / 1.4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      for (var item in newList) {
                        try {
                          http.Response response = await http.get(
                            Uri.parse (item.Url),
                          );
                          XmlDocument XmlData = XmlDocument.parse(response.body);

                          setState(() {
                            item.description = XmlData.findAllElements('station1').first.text + "정거장 전, " + XmlData.findAllElements('min1').first.text + "분 후 도착\n" + XmlData.findAllElements('station2').first.text + "정거장 전, " + XmlData.findAllElements('min2').first.text +"분 후 도착";
                          });
                        }
                        catch(e) {
                          print(e);
                        }
                      }
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      itemBuilder: (context, index) {
                      
                        return CardWidget(
                          task: newList[index],
                        );
                      },
                      itemCount: newList.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 4,
                        );
                      },
                    ),
                  )
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xff2da9ef),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.list_alt_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return const ArchivePage();
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.archive_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const FormWidget();
              });
        },
        backgroundColor: const Color(0xff2da9ef),
        foregroundColor: const Color(0xffffffff),
        child: const Icon(
          Icons.add,
          size: 36,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
