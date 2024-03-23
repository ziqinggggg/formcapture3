import 'package:formcapture/imports.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> shareAsPdf(
    String title, String text, List<Map<String, String>> formData) async {
  final pdf = pw.Document();
  var headers = formData.first.keys.toList();
  int colLimit = 7;
  int pageCount = (headers.length / colLimit).ceil();

  for (int page = 0; page < pageCount; page++) {
    int startIndex = page * colLimit;
    int endIndex = (page + 1) * colLimit;
    endIndex = endIndex > headers.length ? headers.length : endIndex;

    pdf.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              page == 0
                  ? pw.Column(children: [
                      pw.Text(
                        title,
                        style: pw.TextStyle(
                          fontSize: 32,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        text,
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(height: 15),
                    ])
                  : pw.Container(),
              pw.Table(
                border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      for (int i = startIndex; i < endIndex; i++)
                        pw.Container(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(
                            headers[i],
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                  for (int j = 0; j < formData.length; j++)
                    pw.TableRow(
                      children: [
                        for (int i = startIndex; i < endIndex; i++)
                          pw.Container(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(formData[j][headers[i]] ?? ''),
                          ),
                      ],
                    ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  final file = File('/storage/emulated/0/Download/${title}.pdf');
  await file.writeAsBytes(await pdf.save());
  OpenFile.open('/storage/emulated/0/Download/${title}.pdf');
}
