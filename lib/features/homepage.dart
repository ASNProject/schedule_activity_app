import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

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
  Query dbRef = FirebaseDatabase.instance.ref().child('todo');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('/todo');
  TextEditingController timeinput = TextEditingController();
  TextEditingController text = TextEditingController();
  TextEditingController sound = TextEditingController();
  late DatabaseReference dbRef2;

  Map<String, dynamic>? selectedJson;
  var l;
  var g;
  var k;
  var l2;
  var g2;
  var k2;
  @override
  void initState() {
    timeinput.text = "00:00";
    super.initState();
    dbRef2 = FirebaseDatabase.instance.ref().child('todo');
  }

  final List<Map<String, dynamic>> sounds = [
    {
      'name': 'Pilih sound',
      'id': "0",
    },
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

  Widget listItem({required Map todo}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo['time'],
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                Text(
                  'Teks: ${todo['text']}',
                ),
                _buildValue(todo),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              reference.child(todo['key']).remove();
              firebaseDatabase.ref().child(todo['time']).remove();
            },
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.red[700],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildValue(Map todo) {
    if (todo['sound'] == '1') {
      return const Text('Sound: Sarapan pagi.mp3');
    } else if (todo['sound'] == '2') {
      return const Text('Sound: Apel pagi.mp3');
    } else if (todo['sound'] == '3') {
      return const Text('Sound: Olahraga pagi.mp3');
    } else if (todo['sound'] == '4') {
      return const Text('Sound: Kegiatan Belajar.mp3');
    } else {
      return const Text('Sound: -');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: const TextStyle(
                      fontSize: 52, fontWeight: FontWeight.bold),
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
                        String getTime =
                            '${pickedTime.hour}:${pickedTime.minute}';
                        setState(() {
                          timeinput.text = getTime;
                        });
                      } else {}
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
                  value: selectedJson,
                  items: sounds.map((json) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: json,
                      child: Text(json['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedJson = value;
                      sound.text = value!['id'];
                    });
                  },
                )),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      Map<String, String> todo = {
                        'text': text.text,
                        'sound': sound.text,
                        'time': timeinput.text
                      };
                      dbRef2.push().set(todo);
                      firebaseDatabase.ref().child(timeinput.text).set({
                        "text": text.text,
                        "sound": sound.text,
                      }).asStream();
                      text.text = '';
                      timeinput.text = '';
                      const snackbar = SnackBar(
                        content: Text('Jadwal berhasil disimpan'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16),
                      ),
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Daftar Jadwal Kegiatan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FirebaseAnimatedList(
                    query: dbRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map todo = snapshot.value as Map;
                      todo['key'] = snapshot.key;
                      return listItem(todo: todo);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
