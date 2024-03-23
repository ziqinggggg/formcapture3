import 'package:formcapture/imports.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:open_file_plus/open_file_plus.dart';
// import 'package:excel/excel.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

Future<void> shareToExcel(
    String title, String text, List<Map<String, String>> formData) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  var headers = formData.first.keys.toList();

  final headerStyle = workbook.styles.add('headerStyle');
  headerStyle.bold = true;
  headerStyle.hAlign = HAlignType.center;
  headerStyle.vAlign = VAlignType.center;
  // headerStyle.wrapText = true;

  for (var i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(4, i + 1).setText(headers[i]);
    sheet.getRangeByIndex(4, i + 1).cellStyle = headerStyle;
  }

  final bodyStyle = workbook.styles.add('bodyStyle');
  bodyStyle.hAlign = HAlignType.center;
  // bodyStyle.wrapText = true;

  for (int i = 0; i < formData.length; i++) {
    var rowData = formData[i];
    var rowValues = rowData.values.toList();
    for (int j = 0; j < rowValues.length; j++) {
      sheet.getRangeByIndex(i + 5, j + 1).setText(rowValues[j]);
      sheet.getRangeByIndex(i + 5, j + 1).cellStyle = bodyStyle;
    }
  }
  // sheet.autoFitRow(1);

  const int base = 26;
  final StringBuffer columnName = StringBuffer();
  int quotient = headers.length;

  while (quotient > 0) {
    int remainder = (quotient - 1) % base;
    columnName.writeCharCode('A'.codeUnitAt(0) + remainder);
    quotient = (quotient - remainder) ~/ base;
  }
  String char = columnName.toString().split('').reversed.join();

  final Range range = sheet.getRangeByName('A4:${char}${formData.length + 4}');
  final Range range2 = sheet.getRangeByName('B4:${char}${formData.length + 4}');
  range.autoFitColumns();
  range2.autoFitColumns();

  final titleStyle = workbook.styles.add('titleStyle');
  titleStyle.bold = true;
  titleStyle.fontSize = 24;
  // titleStyle.hAlign = HAlignType.center;

  // int charCode = 'A'.codeUnitAt(0) + headers.length-1;
  // String char = String.fromCharCode(charCode);

  sheet.getRangeByName('A1:${char}1').merge();
  sheet.getRangeByIndex(1, 1).setText(title);
  sheet.getRangeByIndex(1, 1).cellStyle = titleStyle;
  sheet.getRangeByName('A2:${char}2').merge();
  sheet.getRangeByIndex(2, 1).setText(text);

  // save the document in the downloads file
  final List<int> bytes = workbook.saveAsStream();
  File('/storage/emulated/0/Download/$title.xlsx').writeAsBytes(bytes);

  // Fluttertoast.showToast(
  //   msg: 'Saved',
  //   toastLength: Toast.LENGTH_SHORT,
  //   gravity: ToastGravity.BOTTOM,
  // );
  OpenFile.open('/storage/emulated/0/Download/$title.xlsx');

  workbook.dispose();
}

// Future<void> shareListToExcel(
//     String title, String text, List<Map<String, String>> dataList) async {
//   try {
//     String json = jsonEncode(dataList);

//     var excel = Excel.createExcel();
//     var sheet = excel['Sheet1'];

//     CellStyle titleCellStyle = CellStyle(
//       bold: true,
//       textWrapping: TextWrapping.WrapText,
//       horizontalAlign: HorizontalAlign.Center,
//     );
//     var titleCell =
//         sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
//     titleCell.value = TextCellValue(title);
//     titleCell.cellStyle = titleCellStyle;

//     var textCell =
//         sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
//     titleCell.value = TextCellValue(text);

//     CellStyle headerCellStyle = CellStyle(
//       bold: true,
//       textWrapping: TextWrapping.WrapText,
//       horizontalAlign: HorizontalAlign.Center,
//     );

//     var headers = dataList.first.keys.toList();
//     for (var i = 0; i < headers.length; i++) {
//       var cell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 3));
//       cell.value = TextCellValue(headers[i]);
//       cell.cellStyle = headerCellStyle;
//     }

//     CellStyle cellStyle = CellStyle(
//       textWrapping: TextWrapping.WrapText,
//     );

//     for (var i = 0; i < dataList.length; i++) {
//       var rowData = dataList[i];
//       var rowValues = rowData.values.toList();
//       for (var j = 0; j < rowValues.length; j++) {
//         var cell = sheet
//             .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 4));
//         cell.value = TextCellValue(rowValues[j]);
//         cell.cellStyle = cellStyle;
//       }
//     }

//     List<int>? fileBytes = excel.save();

//     PermissionStatus status = await Permission.storage.request();
//     if (status == PermissionStatus.granted) {
//       await File('/storage/emulated/0/Download/$title.xlsx')
//           .writeAsBytes(fileBytes!, flush: true)
//           .then((value) {
//         OpenFile.open('/storage/emulated/0/Download/$title.xlsx');
//         log('saved');
//       });
//     } else if (status == PermissionStatus.denied) {
//       log('Denied. Show a dialog with a reason and again ask for the permission.');
//     } else if (status == PermissionStatus.permanentlyDenied) {
//       log('Take the user to the settings page.');
//     }
//   } catch (e) {
//     log("Error while saving Excel file: $e");
//   }
// }