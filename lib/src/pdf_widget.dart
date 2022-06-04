part of flutter_pdf_designer;

class PdfWidget {
  static pw.Widget generate(
      Map<String, dynamic> json, Map<String, dynamic> data, font) {
    final PdfModel dataModel;
    dataModel = PdfModel.fromJson(json);
    changeAlignmentToPrint(dataModel);
    print(dataModel.toJson());
    //   print(data);
    var barcodeData = data['barcode'];
    //  print(barcodeData);
    final ttf = pw.Font.ttf(font.buffer.asByteData());

    return pw.Container(
      width: dataModel.width,
      height: dataModel.height,
      child: pw.Stack(
        children: dataModel.elements!.map<pw.Widget>((e) {
          print(e.type);

          if (dataModel.elements!.isNotEmpty) {
            switch (e.type) {
              case PdfElementType.text:
                {
                  print('it\'s Text !');
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: pw.Container(
                      alignment: e.alignment,
                      width: e.width,
                      height: e.height,
                      child: pw.Text(
                        e.text == 'CustomerName'
                            ? data.values.first.toString()
                            : e.text!,
                        style: pw.TextStyle(
                            font: ttf,
                            fontSize: e.fontSize,
                            color: PdfColor.fromInt(e.color ?? 0xffFF000000)),
                      ),
                    ),
                  );
                }
              case PdfElementType.image:
                {
                  print('it\'s Image !');
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: e.image != null
                        ? pw.Image(
                            pw.MemoryImage(
                              e.image!,
                            ),
                            height: e.height,
                            width: e.width)
                        : pw.Container(
                            color: PdfColors.red, width: 100, height: 100),
                  );
                }
              case PdfElementType.line:
                {
                  print('it\'s Line !');
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: pw.Container(
                      color: PdfColor.fromInt(e.color),
                      height: e.height,
                      width: e.width ?? 300,
                    ),
                  );
                }
              case PdfElementType.barcode:
                {
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: pw.BarcodeWidget(
                        height: e.height,
                        width: e.width,
                        barcode: e.barcode!,
                        data: barcodeData),
                  );
                }
            }
          }
          return pw.Container(color: PdfColors.red, width: 50, height: 50);
        }).toList(),
      ),
    );
  }

  static Future<ByteData> loadFont(String fontPath) async {
    final font = await rootBundle.load(fontPath);
    return font;
  }

  static changeAlignmentToPrint(PdfModel dataModel) {
    dataModel.elements!.forEach((element) {
      if (element.alignment == Alignment.topLeft) {
        element.alignment = pw.Alignment.topLeft;
      } else if (element.alignment == Alignment.centerLeft) {
        element.alignment = pw.Alignment.centerLeft;
      } else if (element.alignment == Alignment.center) {
        element.alignment = pw.Alignment.center;
      } else if (element.alignment == Alignment.centerRight) {
        element.alignment = pw.Alignment.centerRight;
      } else if (element.alignment == Alignment.bottomCenter) {
        element.alignment = pw.Alignment.bottomCenter;
      } else if (element.alignment == Alignment.bottomLeft) {
        element.alignment = pw.Alignment.bottomLeft;
      } else if (element.alignment == Alignment.topRight) {
        element.alignment = pw.Alignment.topRight;
      } else if (element.alignment == Alignment.bottomRight) {
        element.alignment = pw.Alignment.bottomRight;
      } else if (element.alignment == Alignment.topCenter) {
        element.alignment = pw.Alignment.topCenter;
      } else {
        element.alignment = pw.Alignment.topLeft;
      }
    });
  }
}
