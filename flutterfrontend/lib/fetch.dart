import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataFetchingWidget extends StatefulWidget {
  final String? token;

  const DataFetchingWidget(this.token, {super.key});

  @override
  State<DataFetchingWidget> createState() => _DataFetchingWidgetState();
}

class _DataFetchingWidgetState extends State<DataFetchingWidget> {
  String? _url;
  String? _data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_url != null && _url!.isNotEmpty) {
              _fetchData();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid URL')),
              );
            }
          },
          child: const Text('Fetch'),
        ),
        const SizedBox(height: 20),
        _data != null
            ? Text(
                _data!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              )
            : Container(),
      ],
    );
  }

  void _fetchData() async {
    try {
      http.Response response = await http.get(
        Uri.parse(_url!),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        // var jsonData = jsonDecode(response.body);
        setState(() {
          // _data = jsonData.toString();
          _data = response.body;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
