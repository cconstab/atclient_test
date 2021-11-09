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

  var preference = await futurePreference;
  atClientManager.atClient.setPreferences(preference);



  // Save radio Frequency and Mode
  var metaData = Metadata()
    ..isPublic = true
    ..isEncrypted = false
    ..namespaceAware = true
    ..ttl = 3600000;

  var key = AtKey()
    ..key = 'counter'
    ..sharedBy = currentAtsign
    ..sharedWith = null
    ..metadata = metaData;

  print('Updating Counter to : ' + counter.toString());
  //await atClient.delete(key);
  await atClient.put(key, counter.toString());

}

Future<http.Response> getValue(){
    String? currentAtsign;
  late AtClient atClient;
  late AtClientManager atClientManager;

  atClientManager = AtClientManager.getInstance();
  atClient = atClientManager.atClient;
  currentAtsign = atClient.getCurrentAtSign();
return http.get(Uri.parse('https://wavi.ng/api?atp=counter.ai6bh$currentAtsign'));

}