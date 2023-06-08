import 'package:flutter/material.dart';
import 'package:flutter_todolist_app/models/task.dart';
import 'package:flutter_todolist_app/archive_page.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:cp949_dart/cp949_dart.dart' as cp949;

class SubFormWidget extends StatefulWidget {
  const SubFormWidget({Key? key}) : super(key: key);

  @override
  State<SubFormWidget> createState() => Sub_FormWidgetState();
}

class Sub_FormWidgetState extends State<SubFormWidget> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  String getSubValue() {
    String textValue = _controller1.text;
    return(textValue);
  }String getWayValue() {
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
      title: const Text('지하철 추가'),
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
                hintText: '지하철역 코드',
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
                hintText: '상행선 = 0, 하행선 = 1',
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
              String way = getWayValue();
              String time = DateTime.now().hour.toString().padLeft(2, '0')+DateTime.now().minute.toString().padLeft(2, '0');
              String day = "";
              String SubName = "";
              String hour = "";
              String minute = "";
              
              if (DateTime.now().weekday >= 1 && DateTime.now().weekday <= 5) {
                day = "1";
              }
              else if(DateTime.now().weekday == 6) {
                day = "2";
              }
              else if (DateTime.now().weekday == 7) {
                day = "3";
              }

              String url = "http://data.humetro.busan.kr/voc/api/open_api_process.tnn?act=xml&scode="+getSubValue()+"&day="+day+"&updown"+way+"&enum=1&serviceKey=jYABDRpHfCj7JWagOCRBX%2FOSt2OHX4ba1Nff5kuzOGkQaT%2F0BM1xNO4X5KAXNTfeiuKTcEFXnNU1pbFMVf9upg%3D%3D";

              try {
                http.Response response = await http.get(
                  Uri.parse (url+'&stime='+time),
                );

                XmlDocument XmlData = XmlDocument.parse(response.body);
                SubName = cp949.decodeString(XmlData.findAllElements('sname').first.text);
                hour = XmlData.findAllElements('hour').first.text;
                minute = XmlData.findAllElements('time').first.text;
              }
              catch(e) {
                print(e);
              }
              Navigator.of(context).pop();
              listTask.add(Task(url,SubName+'역',hour+'시 '+minute +'분 도착예정',getMemoValue(),true));
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return const ArchivePage();
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
