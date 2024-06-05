// ignore_for_file: avoid_print

import 'package:gsheets/gsheets.dart';
import 'package:outwork_final_admin_panel_app/models/asistance_sheets_model.dart';

class GoogleSheetsApi {
  static const _credentials = '''
{
  "type": "service_account",
  "project_id": "outwork-mx",
  "private_key_id": "bc521eea2904ff2dceb2d60d74375c12032b1920",
  "private_key": "-----BEGIN PRIVATE KEY-----\\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDmWQEnpK9SVcfv\\nSimhUMnz9w5dH47YaDGnOc7PoGAfBnyG0vrRctFYtjEAym28hMBP+w/AkU26CGoH\\nCKOTxnLAfo+zCLDQvBOWB0waIBtClUE4XY/dfD4MolESKv8IV9PXV67oxialbbQh\\ncgHDCl3Y+epXv61dNPYHb6v1HMcxC3lxUAmocV6qE0P25nDXDyQwpNq+mSMc1wk9\\nDzyV023Yky2RLlmWu9riQC4Mmd6TqJSyrHoClDyhTfGlER1laCbzBKkETiuEtqZk\\nY94Tsuf6DJwNha3nxCJ5B/oDLp7/wNZnDGliBn7I5sG4GtE7TrzNvzI40xXvfm0q\\nVHILZm89AgMBAAECggEAEG9hSbbSW4mLTmN4PO5KuoFyIOrTglVM1aWmP+IteYk4\\n8VW0V6VdknrNXEUVN1IxdoNvSEoVxaQ8DGxtX2nVXi6pihigpQQGUboLkAGicEm9\\n8YubbC4lLzmVlzpCIBJEJyU2cZ1RvJPrOkesIIJo18ZdFg2zDOdudnFdT4vSGomY\\nYh+vyC3s6URibchKnJuvG2QHBt4ZjXIPsYzs2l6HMvSwtt26qegzaxBv+DM6ZT7a\\nvqG33FfF0sz74KUoRYJtTfcuVveOr/CyCyQo/orUM/HyhTHFBDpu6nnWv/z58Cm9\\nWmuIp+ug73oKfgjgWT1McWZfKpu1A0e4Da0coiYOAQKBgQD5rjRAg6dNbB/QQWY3\\n9CwOrxhZqGc0sFtiUDQDnHwnqNVD8z8WiEEg9y1HAAvwfIRtYiNz5modH48RWUHa\\nYoyEGNM3/pnt5dqqgNUrmXcmFsFxb/shT8KsOmed66yxi4hro8o3SlztSvL1jYoT\\nBM3CbElKgMWrLeIcolkISdCKIQKBgQDsLYi9G0d9P6HI/ybaO6vp+kKScowh6VQr\\n367a2L7FVrptQSr2bgV+ZJ8cAoZXnjCi9oE5BaDqltWBKj9VssdVvwL/r8GCMS3H\\nHwCQmt9pe5flrisq0IkQXT5nYRp1Yn/xpvXRjCZYmnomYuFriaFL6p0SznN8xNr7\\nfIfg7XSZnQKBgQDDRPn6prxWscRjxHIkOqOmTExX+nvU2kRuLFmxpVX4UnOQdBIY\\nFjIRjR7tE11DFK8hOQqPH1pIMqFaqRr2p/JLcXrnpQhP5V9Rz/Zn5dsof82EYVbf\\no5iVyAu3l1T1ejIUNQH2ogLxVpeTccHVxAEEGFptmS5/BSB80n+dGtWs4QKBgAKM\\nPzRjDfNg81ravc2O5Tzh8UPpLm/TN5A9moJL4kr4s4woLtF3wGFrrne74z0gvL+V\\nTzGRSPoe5HC/Ru2ivxnCtMKTX9AKvcavI+9rbEuUBMB6j4ant0LQ7rJozsNDa8Ps\\nnCxFichc6kJtwKbLVk0eW9FvHrnS2dXqswCPLznVAoGAIOR6vHHIEUX30QqkLGxc\\nXULx5OQ/9n+3BjtqLIMSjPQTzHo9n3aNoz77U2jEtuDKZahcDll+5eotK3EgKvmd\\ngOzSAUYbs3U3m8iOwEtI+ZCFQXVx8Jt3kR6cg2vXFAGJ5pbj5+mjneTdb5S8Br+X\\nSAWZS0eQYiRnQB/lF0ymAdk=\\n-----END PRIVATE KEY-----\\n",
  "client_email": "outwork-mx@outwork-mx.iam.gserviceaccount.com",
  "client_id": "112132437009254289384",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/outwork-mx%40outwork-mx.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

  static const _spreadsheetId = '1kGy6pkkbWKEnlyz7K2Yr9Y7XXWm_GeFKO4S932HX4L0';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _registrationSheet;

  static Future init() async {
    try {
    final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _registrationSheet = await _getWorkSheet(spreadsheet, title: 'register');

    final firstRow = AsistanceSheetsModel.getFields();
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
