import 'package:flutter/material.dart';
// import 'package:formcapture/pages.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(
                Icons.delete,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  // const FormattingToolBar(),
                  TextField(
                    controller: _titleController,
                    cursorColor: Colors.black,
                    maxLines: null,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  // TextField(
                  //   controller: _noteController,
                  //   cursorColor: Colors.black,
                  //   maxLines: null,
                  //   style: const TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 22,
                  //   ),
                  //   decoration: const InputDecoration(
                  //     hintText: 'Body',
                  //     border: InputBorder.none,
                  //   ),
                  // ),
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    children: const [
                      TableRow(children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'First Name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Last Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Taylor',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Swift',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '19891989',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Sabrina',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Carpenter',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '66667777',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            child: const Icon(Icons.save, color: Colors.white),
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const NotesPage()));
              // setState(() {
              //   notes.add(Note(_titleController.text, _noteController.text));
              // });
            }));
  }
}

// class TableContent extends StatelessWidget {
//   const TableContent({super.key, required this.content});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: EdgeInsets.all(8.0),
//         child: ListTile(
//           title: Text('$content',
//               style: const TextStyle(fontSize: 18)),
//         ));
//   }
// }
