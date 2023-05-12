import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Homepage extends StatefulWidget {
  final String title;
  const Homepage({
    super.key,
    required this.title,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final firebaseDatabase = FirebaseDatabase.instance;
  TextEditingController timeinput = TextEditingController();
  TextEditingController text = TextEditingController();
  TextEditingController sound = TextEditingController();
  Map<String, dynamic>? selectedJson;
  @override
  void initState() {
    timeinput.text = "00:00";
    super.initState();
  }

  final List<Map<String, dynamic>> sounds = [
    {
      'name': 'Sarapan pagi.mp3',
      'id': "1",
    },
    {
      'name': 'Apel pagi.mp3',
      'id': "2",
    },
    {
      'name': 'Olahraga pagi.mp3',
      'id': "3",
    },
    {
      'name': 'Kegiatan Belajar.mp3',
      'id': "3",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: _buildLoadView(),
    );
  }

  _buildLoadView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Set Jadwal Kegiatan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                timeinput.text,
                style:
                    const TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print('${pickedTime.hour}:${pickedTime.minute}');
                      String getTime =
                          '${pickedTime.hour}:${pickedTime.minute}';
                      setState(() {
                        timeinput.text = getTime;
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                  child: const Text('Set Waktu')),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Set Text Tampilan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: TextFormField(
                controller: text,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Masukkan kata/kalimat yang akan ditampilkan'),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Set Suara',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton2<Map<String, dynamic>>(
                hint: const Text('Pilih suara'),
                focusColor: Colors.white,
                value: selectedJson,
                items: sounds.map((json) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: json,
                    child: Text(json['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  print(value!['id']);
                  setState(() {
                    selectedJson = value;
                    sound.text = value['id'];
                  });
                },
              )),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: () {
                    firebaseDatabase.ref().child(timeinput.text).set({
                      "text": text.text,
                      "sound": sound.text,
                    }).asStream();
                    text.text = '';
                    timeinput.text = '';
                    selectedJson = {};
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Simpan',
                      style: TextStyle(fontSize: 16),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
