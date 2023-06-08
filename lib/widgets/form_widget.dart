import 'package:flutter/material.dart';
import 'package:flutter_todolist_app/models/task.dart';
import 'package:flutter_todolist_app/home_page.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  String getBStCValue() {
    String textValue = _controller1.text;
    return(textValue);
  }
  String getBSCValue() {
    String textValue = _controller2.text;
    return(textValue);
  }
  String getMemoValue() {
    String textValue = _controller3.text;
    return(textValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      title: const Text('버스 추가'),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller1,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: '정류소 코드',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: _controller2,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: '버스 번호',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: _controller3,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: '메모',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              primary: const Color(0xff2da9ef),
            ),
            onPressed: () async {
              String url = 'http://apis.data.go.kr/6260000/BusanBIMS/busStopArrByBstopidLineid?bstopid='+getBStCValue()+'&lineid='+getBSCValue()+'&serviceKey=jYABDRpHfCj7JWagOCRBX%2FOSt2OHX4ba1Nff5kuzOGkQaT%2F0BM1xNO4X5KAXNTfeiuKTcEFXnNU1pbFMVf9upg%3D%3D';
              String nodenm = "";
              String lineno = "";
              String min1 = "";
              String min2 = "";
              String station1 = "";
              String station2 = "";
              try {
                http.Response response = await http.get(
                  Uri.parse (url),
                );

                XmlDocument XmlData = XmlDocument.parse(response.body);
                nodenm = XmlData.findAllElements('nodenm').first.text;
                lineno = XmlData.findAllElements('lineno').first.text;
                min1 = XmlData.findAllElements('min1').first.text;
                min2 = XmlData.findAllElements('min2').first.text;
                station1 = XmlData.findAllElements('station1').first.text;
                station2 = XmlData.findAllElements('station2').first.text;
              }
              catch(e) {
                print(e);
              }
              Navigator.of(context).pop();
              listTask.add(Task(url,nodenm+", "+lineno+"번" ,station1 + "정거장 전, " + min1 + "분 후 도착\n" +station2 + "정거장 전, " +min2 +"분 후 도착",getMemoValue(),false));
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return const HomePage();
                  },
                ),
              );
            },
            child: const Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
