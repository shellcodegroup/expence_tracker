import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "expense-tracker-408215",
  "private_key_id": "01eb8e38183138d00c3c74f16aa8b1c90493ee48",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCtn4dHrIwq6T+g\nVWXA9WQYZCAP2frcbzzSKdFEnS37g56W43xKQ2Q6EPRtBuZ3Kfh0HnONv2fvAmGc\n6MAWnwYa29bsvys2ThckV/LC0/QiD3UVPHTAVlLSXFiBM03NFYDeyU8iKbhMk4ww\nosuGHL5cFv3iDCkbuHMvVzMQYZxGKZ8hbDWiUnZeQK8gqJ+KXMsFDQ+WFRnnWZ01\nVwzrHIWwVFre739ioIK2QSWn3igutZryqTCJBSV8ArXnZkrT79uVaSXa7JyFJHYA\n65WbuAk0c5vRmjd+PtLMhk2d8gU9YOHZKJi0oJUUmdgEqx29qXmlkdXr2WlWhp1f\nSju+NkHpAgMBAAECggEAO5tGos0yq/K69M0Mq3OzowoQ1dBUpwQLge14WlGJ/UzB\nD/VWcNp1GNhESf/x9Fw034yqyDG7uVr8bxWbCMkcm/D4dvvklna1zDTjc463xE/B\nNwKz5Gpecbjha63U2oE05od/Qu/GxYdsPDBPpiHNGqmMDOR24nzvEoQh1FBmidFk\nUwYHLiLQa5bnPYtMNgHPNi/fFSqq7QnKwedMCgwT+5SvdtXqir1Lkj+F9hgarFQb\n9PBFOrUUEH5x86funRK3A5JNvHuhT+AMGamSHPLTg+4knftnxZVQUQGs7/Hr1Odm\n98NchhiJEKdnOQch1JVc365apDnreyN7ECN4RzvizwKBgQDdKWlzE/KmbQs0Iazm\nFdFFgUlbQ2viDlW/Xwp/dhxVs3CjW4hNGEgubM5xqypRA8qMWAaOARs08GWojFqa\nh+09mXsKobOUhz5UeQ92w4eqkfzT+5OYoOpM8vuolCZ/fL7HGc6beJkEGgWq5Le4\nxikRNFH8MlTIf6CmTnTEFr3M+wKBgQDI+RIUA+pCb0vrfEt4W6qtg6Nr/gi39kVv\nTZGREM3xFSVD4kHmkV5ZsljDtFw4jwTWH3oWXX43DGsabYfUzxfANi6X8MfG0YDj\nuQ0CPWoOg2flyYs9cLhfNNJpiRUobo4dX7ibCuYHGndSrzl9iQNV4O2Jw8B9zkqP\nyThcSaavawKBgBSaG/mdXRhFxipoDKwuUh1Qat32jOE1BqXaG6c+AGu3WIHPMAZG\ngcrZVe3ezQVY/hBOzuWBkuA+mKm30WTdzqrTVlPqNklaw+KomFku479u9AdnQxuP\nuePLKshMbL2piDgR3l47QL3SEr8VqUusIf05S33bzmwS/4seeeAeYjXrAoGAKpHn\nrGmv42aj1Du92L7CBoMNyMBEpIL77jmmDe5bUSfDfv+cKfS84Y8PklTP/AL/aUO9\nnqMrKwnsXeq5jPBY/ZP8hp6wEoMqJBJ8mO7dWjmndlscrWUFCNWthEFPRAM3Ay3V\ncrH6S6Llh5QqP1cYZ8Z/SmE2ku9xh8d9sr6/GgUCgYBaQ6ex4xOpDX8Ar6xHhhfQ\nZyTUrKDhqinyID9UgA2QhggX2prhmXSvy5T6HTyd3HF+mOaWfGlMmi5pEHt42Y2G\n0NmBHelNUDNU7wue38fKWl6zqtVmkJcbpxrN/0K+91J8Blsg+N7kiH+s8E8yulBy\n6LaeHTywvDN57Gq6PCXM9w==\n-----END PRIVATE KEY-----\n",
  "client_email": "expense-tracker@expense-tracker-408215.iam.gserviceaccount.com",
  "client_id": "101685671301872840545",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expense-tracker%40expense-tracker-408215.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

  ''';

  // setup and connect to the spreadsheet
  static const _spreadsheetId = '1Zttova4i0_aq3MvIdbtI4wR4PJ6P_op9ur0SzNqTzB0';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of the data
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Sheet1');
    countRows();
  }

  // count the number of rows in the sheet
  Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now lets load them
    loadTransactions();
  }

  // load the notes from the sheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions
            .add([transactionName, transactionAmount, transactionType]);
      }
    }
    // this will stop circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String transaction, String amount, bool isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions
        .add([transaction, amount, isIncome == true ? 'Income' : 'Expense']);
    await _worksheet!.values.appendRow(
        [transaction, amount, isIncome == true ? 'Income' : 'Expense']);
  }

  // calculate income
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'Income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // calculate expense
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'Expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }

// clear data in sheet
  Future<void> clearSheetData() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions
            .remove([transactionName, transactionAmount, transactionType]);
      }
    }
    // this will stop circular loading indicator
    loading = false;
  }
}
