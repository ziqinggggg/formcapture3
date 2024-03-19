import 'package:flutter/material.dart';
import 'package:formcapture/imports.dart';
import 'dart:developer' as devtools show log;

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  List<TextEditingController> controllers = [];
  late final TextEditingController _scannedTextController;
  late final TextEditingController _generatedTextController;
  late String _scannedText;
  String? _generatedText;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for default text fields
    for (int i = 0; i < 3; i++) {
      controllers.add(TextEditingController());
    }
    _scannedTextController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    _scannedTextController.dispose();
    super.dispose();
  }

  void _addTextField() {
    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void _removeTextField(int index) {
    setState(() {
      controllers.removeAt(index);
    });
  }

  Map<String, String> generateFormInfo() {
    devtools.log('_scannedTextController.text' + _scannedTextController.text);
    devtools.log('controllers' + controllers.toString());
    Map<String, String> formFields = {};

    for (int i = 0; i < controllers.length; i++) {
      String key = controllers[i].text;
      formFields[(controllers[i].text)] = '';
    }
    _generatedText;
    return formFields;
  }

  void getScannedText(BuildContext context) {
    _scannedText = context.getArgument<String>()!;
    _scannedTextController.text = _scannedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.done),
        //     onPressed: () {
        //       Map<int, String> formFields = getFormFields();
        //       // Use the formFields map as needed
        //       print(formFields);
        //     },
        //   ),
        // ],
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Done',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _scannedTextController,
              maxLines: null,
              style: const TextStyle(
                fontSize: 22,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              for (int i = 0; i < controllers.length; i++)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllers[i],
                          decoration: InputDecoration(
                            labelText: 'Input Field ${i + 1}',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (controllers.length > 1) {
                            _removeTextField(i);
                          } else {
                            showErrorDialog(
                                context, 'Form field should be more than one');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _addTextField,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 31, 31, 31),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text(
                      'Add Field',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: _generatedText != null,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _generatedTextController,
                maxLines: null,
                style: const TextStyle(
                  fontSize: 22,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Theme.of(context).brightness == Brightness.light
      //       ? Colors.black
      //       : Colors.grey.shade800,
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      //   onPressed: () {},
      // ),
    );
  }
}
