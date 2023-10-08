import 'package:flutter/material.dart';
import 'package:localization_plus/localization_plus.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocalizationPlusController controller = await LocalizationPlusController.init(
    path: 'i18n',
    supportedLocales: [
      'en_US'.toLocale(),
      'ar_SA'.toLocale(),
      'tr_TR'.toLocale(),
      'ru_RU'.toLocale(),
    ],
    fallbackLocale: 'en_US'.toLocale(),
    useFallbackTranslations: true,
    // saveLocale: true,
    // useOnlyLangCode: false,
    // loader: const RootBundleAssetLoader(),
  );

  getIt.registerLazySingleton<LocalizationPlusController>(() => controller);

  runApp(
    LocalizationPlus(
      controller: getIt<LocalizationPlusController>(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Localizations
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.currentLocale,

      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  Map<String, String> languageTitles = {
    'tr_TR': 'Türkçe (Türkiye)',
    'en_US': 'English (United States)',
    'ar_SA': 'العربية (المملكة العربية السعودية)',
    'ru_RU': 'русский (Россия)',
  };

  @override
  void initState() {
    super.initState();

    getIt<LocalizationPlusController>().addListener(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.currentLocale.toString()),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'.trans()),
        actions: [
          TextButton(
            child: Text(languageTitles[context.currentLocale.toString()]!),
            onPressed: () => showLanguageDialog(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('notations'.trans(arguments: {'arg': 'test'})),
                      const SizedBox(height: 10),
                      Text(trans('welcome', arguments: {'username': 'fatih'})),
                      const SizedBox(height: 10),
                      Text('goodbye'.trans(arguments: {'username': 'fatih'})),
                      const SizedBox(height: 10),
                      Text('locale'.trans(arguments: {
                        'language': context.currentLocale.toString()
                      })),
                      const SizedBox(height: 10),
                      Text('I love programming.'.trans()),
                      const SizedBox(height: 10),
                      Text(
                          '${'user.profile.firstname'.trans()} ${'user.profile.lastname'.trans()}'),
                      const SizedBox(height: 10),
                      const Text('fallback').trans(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('price'.transChoice(counter)),
                      const SizedBox(height: 10),
                      Text('clicked'.plural(counter)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(
                            onPressed: () =>
                                counter > 0 ? setState(() => counter--) : null,
                            child: const Icon(Icons.exposure_minus_1),
                          ),
                          Text(counter.toString()),
                          FilledButton(
                            onPressed: () =>
                                counter < 15 ? setState(() => counter++) : null,
                            child: const Icon(Icons.exposure_plus_1),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showLanguageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Column(
            children: context.supportedLocales
                .map(
                  (locale) => ListTile(
                    title: Text(languageTitles[locale.toString()].toString()),
                    selected: locale == context.currentLocale,
                    onTap: () {
                      Navigator.pop(context);
                      context.setLocale(locale);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
