import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:projekt/providers/reports.dart';
import 'package:projekt/models/report.dart';
import '../widgets/location_input.dart';
import '../widgets/image_input.dart';

class AddReportScreen extends StatefulWidget {
  static const routeName = '/add-report';
  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  List<String> _categories = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  String dropdownValue = '';
  RelativeRect position;
  PlaceLocation _pickedLocation;
  String _selectedImage;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _validate = false;

  void _selectLocation(double lat, double lon) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lon);
  }

  void _selectImage(String selectedImage) {
    _selectedImage = selectedImage;
  }

  Widget _categorySelectorBuilder() {
    return Container(
      height: 40,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(dropdownValue),
        )),
        PopupMenuButton(
            onSelected: (value) => {
                  setState(() {
                    dropdownValue = value;
                  })
                },
            icon: Icon(Icons.arrow_drop_down),
            itemBuilder: (ctx) {
              return _categories
                  .map((category) =>
                      PopupMenuItem(value: category, child: Text(category)))
                  .toList();
            })
      ]),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: !_validate ? Colors.red : Colors.grey),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  Future<void> _saveReport() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        dropdownValue.isEmpty) {
      return;
    }

    await Provider.of<Reports>(context, listen: false).addReport(
        pickedTitle: _titleController.text,
        pickedDescription: _descriptionController.text,
        pickedLocation: _pickedLocation,
        pickedImage: _selectedImage,
        pickedCategory: dropdownValue);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Tworzenie zgłoszenia'),
            actions: [
              IconButton(onPressed: _saveReport, icon: Icon(Icons.add))
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    // color: Colors.amber,
                    child: Text(
                      'Utwórz zgłoszenie',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _categorySelectorBuilder(),
                  !_validate
                      ? Container(
                          padding: EdgeInsets.only(top: 5, left: 8),
                          height: 20,
                          width: double.infinity,
                          child: Text(
                            'Wybierz kategorię zgłoszenia',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        )
                      : Text('ok'),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    child: TextField(
                      maxLength: 100,
                      maxLines: 1,
                      controller: _titleController,
                      decoration: InputDecoration(
                          label: Text('Tytuł'),
                          border: OutlineInputBorder(),
                          errorText:
                              _validate ? null : 'To pole nie może być puste'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 500,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        label: Text('Opis'),
                        border: OutlineInputBorder(),
                        errorText:
                            _validate ? null : 'To pole nie może być puste'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImageInput(_selectImage),
                  SizedBox(
                    height: 10,
                  ),
                  LocationInput(_selectLocation),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
