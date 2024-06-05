// ignore_for_file: avoid_print

import 'package:gsheets/gsheets.dart';
import 'package:outwork_final_admin_panel_app/models/new_sale_model_.dart';

class GoogleSheetsSalesApi {
  static const _credentials = '''
{
  TODO REMOVED BEACUSE OF GIT
}
''';

  static const _spreadsheetId = '1kGy6pkkbWKEnlyz7K2Yr9Y7XXWm_GeFKO4S932HX4L0';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _registrationSheet;

  static Future init() async {
    try {
    final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _registrationSheet = await _getWorkSheet(spreadsheet, title: 'sales');

    final firstRow = NewSaleModel.getFields();
    _registrationSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print(e);
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_registrationSheet == null) return;
    _registrationSheet!.values.map.appendRows(rowList);
  }
}
