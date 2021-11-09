import 'package:atclient_test/models/httpresult.dart';
import 'package:http/http.dart' as http;

import 'package:at_commons/at_commons.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:atclient_test/main.dart';

updateCounter(int counter) async {
  String? currentAtsign;
  late AtClient atClient;
  late AtClientManager atClientManager;

  atClientManager = AtClientManager.getInstance();
  atClient = atClientManager.atClient;
  currentAtsign = atClient.getCurrentAtSign();
  var currentAtsignNoAt = currentAtsign!.replaceAll('@', '');
  Future<AtClientPreference> futurePreference = loadAtClientPreference();
 String message = '<!DOCTYPE html> <html> <head> <meta http-equiv="refresh" content="5" /><style> h1 {text-align: center;} </style> </head><body> <h1>${currentAtsign.toUpperCase()} using RADIO listening on ${counter.toString().padRight(10)} USB </h1> </body> </html>';
  var preference = await futurePreference;
  atClientManager.atClient.setPreferences(preference);

  var metaData = Metadata()
    ..isPublic = true
    ..isEncrypted = false
    ..namespaceAware = true
    ..ttl = 3600000;

  var key = AtKey()
    ..key = 'counter1'
    ..sharedBy = currentAtsign
    ..sharedWith = null
    ..metadata = metaData;

  print('Updating Counter1 to : ' + counter.toString());
  //await atClient.delete(key);
  await atClient.put(key, message);
  //atClientManager.syncService.sync();


// Comment out this section and everything works fine
// Section START
    key = AtKey()
    ..key = 'counter2'
    ..sharedBy = currentAtsign
    ..sharedWith = null
    ..metadata = metaData;

      print('Updating Counter2 to : ' + counter.toString());
  //await atClient.delete(key);
  await atClient.put(key, message);
  //atClientManager.syncService.sync();


      key = AtKey()
    ..key = 'counter3'
    ..sharedBy = currentAtsign
    ..sharedWith = null
    ..metadata = metaData;

      print('Updating Counter3 to : ' + counter.toString());
  //await atClient.delete(key);
  await atClient.put(key, message);
  //atClientManager.syncService.sync();

// Section END


}

void getValue(HttpResult result,counter) async {
  String? currentAtsign;
  late AtClient atClient;
  late AtClientManager atClientManager;

  atClientManager = AtClientManager.getInstance();
  atClient = atClientManager.atClient;
  currentAtsign = atClient.getCurrentAtSign();
  var stuff = await http.get(Uri.parse('https://wavi.ng/api?atp=counter$counter.ai6bh$currentAtsign'));

  result.httpResponse = stuff.body;
}
