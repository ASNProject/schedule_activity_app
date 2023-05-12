import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SetTimeSchedule extends StatefulWidget {
  const SetTimeSchedule({super.key});

  @override
  State<SetTimeSchedule> createState() => _SetTimeScheduleState();
}

class _SetTimeScheduleState extends State<SetTimeSchedule> {
  TextEditingController timeinput = TextEditingController();
  Map<String, dynamic>? selectedJson;
  @override
  void initState() {
    timeinput.text = "00:00";
    super.initState();
  }

  final List<Map<String, dynamic>> sounds = [
    {
      'name': 'Sarapan pagi.mp3',
      'id': 1,
    },
    {
      'name': 'Apel pagi.mp3',
      'id': 2,
    },
    {
      'name': 'Olahraga pagi.mp3',
      'id': 2,
    },
    {
      'name': 'Kegiatan Belajar.mp3',
      'id': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
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
                  String getTime = '${pickedTime.hour}:${pickedTime.minute}';
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
              setState(() {
                selectedJson = value!;
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
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Simpan',
                  style: TextStyle(fontSize: 16),
                ),
              )),
        )
      ],
    );
  }
}
