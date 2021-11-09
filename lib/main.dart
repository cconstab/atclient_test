import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart'
    show Onboarding;
import 'package:at_utils/at_logger.dart' show AtSignLogger;
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;
import 'package:at_app_flutter/at_app_flutter.dart' show AtEnv;
import 'package:atclient_test/services/update_read.dart';
import 'package:atclient_test/models/httpresult.dart';

import 'package:timer_builder/timer_builder.dart';

Future<void> main() async {
  await AtEnv.load();
  runApp(const MyApp());
}

Future<AtClientPreference> loadAtClientPreference() async {
  var dir = await getApplicationSupportDirectory();
  return AtClientPreference()
        ..rootDomain = AtEnv.rootDomain
        ..namespace = AtEnv.appNamespace
        ..hiveStoragePath = dir.path
        ..commitLogPath = dir.path
        ..isLocalStoreRequired = true
      // TODO set the rest of your AtClientPreference here
      ;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // * load the AtClientPreference in the background
  Future<AtClientPreference> futurePreference = loadAtClientPreference();
  AtClientPreference? atClientPreference;

  final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // * The onboarding screen (first screen)
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MyApp'),
        ),
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () async {
                var preference = await futurePreference;
                setState(() {
                  atClientPreference = preference;
                });
                Onboarding(
                  context: context,
                  atClientPreference: atClientPreference!,
                  domain: AtEnv.rootDomain,
                  rootEnvironment: AtEnv.rootEnvironment,
                  appAPIKey: AtEnv.appApiKey,
                  onboard: (value, atsign) {
                    _logger.finer('Successfully onboarded $atsign');
                  },
                  onError: (error) {
                    _logger.severe('Onboarding throws $error error');
                  },
                  nextScreen: const HomeScreen(),
                );
              },
              child: const Text('Onboard an @sign'),
            ),
          ),
        ),
      ),
    );
  }
}

//* The next screen after onboarding (second screen)
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  String value = "";
  var lookup1 = HttpResult(httpResponse: 'nothing yet');
  var lookup2 = HttpResult(httpResponse: 'nothing yet');
  var lookup3 = HttpResult(httpResponse: 'nothing yet');
  var atClientManager = AtClientManager.getInstance();

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(const Duration(milliseconds: 1000),
        builder: (context) {
        getValue(lookup1,1);
        getValue(lookup2,2);
        getValue(lookup3,3);
      /// Get the AtClientManager instance
      return Scaffold(
        appBar: AppBar(
          title: const Text('AtClient Update Tester'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Counter ${_counter.toString()}',
                  style: const TextStyle(fontSize: 30)),

              Text('HTTP ' + lookup1.httpResponse, style: const TextStyle(fontSize: 20)),
              Text('HTTP ' + lookup2.httpResponse, style: const TextStyle(fontSize: 20)),
              Text('HTTP ' + lookup3.httpResponse, style: const TextStyle(fontSize: 20)),
              /// Use the AtClientManager instance to get the current atsign
              Text(
                  'Current @sign: ${atClientManager.atClient.getCurrentAtSign()}',
                  style: const TextStyle(fontSize: 30)),
            ],
          ),
        ),
      );
    });
  }

  void _incrementCounter() async {
    _counter++;
    updateCounter(_counter);

    //await Future.delayed(const Duration(seconds: 10));
    setState(() {});
  }
}
