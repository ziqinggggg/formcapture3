import 'package:formcapture/imports.dart';
import 'dart:developer' as devtools show log;

class InputForm extends StatefulWidget {
  final dynamic path;
  const InputForm({
    super.key,
    required this.path,
  });

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  List<TextEditingController> controllers = [];
  late List<String> formFields = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for default text fields
    for (int i = 0; i < 3; i++) {
      controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    // _textController.dispose();
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

  List<String> generateFormInfo() {
    // devtools.log('_scannedTextController.text' + _textController.text);
    // devtools.log('controllers' + controllers.toString());

    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isNotEmpty) {
        String field = controllers[i].text;
        formFields.add(field);
      }
    }
    return formFields;
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, generateFormInfo());
            },
            child: const Text(
              'Done',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 2,
                // maxHeight:
                //     (context.findRenderObject() as RenderBox).size.height * 200,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 5,
                    child: InteractiveViewer(
                      panEnabled: false,
                      minScale: 2,
                      maxScale: 100,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      child: Image.file(
                        File(widget.path),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Please enter the form labels in the following text fields.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controllers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controllers[index],
                                decoration: InputDecoration(
                                  labelText: 'Input Field ${index + 1}',
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
                                  _removeTextField(index);
                                } else {
                                  showErrorDialog(context,
                                      'Form field should be more than one');
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: SizedBox(
                        height: 55,
                        width: MediaQuery.of(context).size.width - 5,
                        child: ElevatedButton(
                          onPressed: _addTextField,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 31, 31, 31),
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
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
