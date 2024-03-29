import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataFetchingWidget extends StatefulWidget {
  final String? token;
  final void Function(bool) setDrawProfile;

  const DataFetchingWidget(this.token, this.setDrawProfile, {super.key});

  @override
  State<DataFetchingWidget> createState() => _DataFetchingWidgetState();
}

class _Entry {
  final String sender;
  final String time;
  final double value;

  _Entry({required this.sender, required this.time, required this.value});

  factory _Entry.fromJson(Map<String, dynamic> json) {
    return _Entry(
      sender: json['sender'],
      time: json['time'],
      value: json['value'],
    );
  }
}

class _DataFetchingWidgetState extends State<DataFetchingWidget> {
  String? _url;
  List<_Entry>? _data;

  @override
  void initState() {
    super.initState();
    _url = 'http://192.168.178.29:4200/';
  }

  List<_Entry> parseJson(String jsonStr) {
    final parsed = json.decode(jsonStr).cast<Map<String, dynamic>>();
    return parsed.map<_Entry>((json) => _Entry.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Enter URL',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _url = value;
                      });
                    },
                    controller: TextEditingController(text: _url),
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () {
                    if (_url != null && _url!.isNotEmpty) {
                      _fetchData(30);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid URL')),
                      );
                    }
                  },
                  child: const Text('Fetch'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          _data != null
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _data!.length,
                    itemBuilder: (context, index) {
                      final item = _data![index];
                      return ListTile(
                        title: Text(item.sender),
                        subtitle: Text(item.time),
                        trailing: Text(item.value.toString()),
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void _fetchData(int num) async {
    widget.setDrawProfile(false);
    try {
      http.Response response = await http.get(
        Uri.parse(_url!),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        setState(() {
          final full = parseJson(response.body);
          _data = full.length <= num ? full : full.sublist(full.length - num);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
