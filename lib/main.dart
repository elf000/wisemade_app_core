// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
// import 'package:flutter_session_manager/flutter_session_manager.dart';  // Removido (não utilizado)
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/pages/app.dart';
import 'package:wisemade_app_core/themes/skeletons.dart';
import 'package:wisemade_app_core/themes/wisemade.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_state.dart';

late Mixpanel mixpanel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      basePath: 'i18n',
      useCountryCode: false,
      useScriptCode: false,
      fallbackFile: 'en',
      decodeStrategies: [YamlDecodeStrategy()],
    ),
    missingTranslationHandler: (key, locale) {
      // Substituímos print por debugPrint para evitar logs em produção
      debugPrint("--- Missing Key: $key, languageCode: ${locale?.languageCode}");
      // Se quiser usar um logger mais avançado, poderia ser:
      // import 'dart:developer' as developer;
      // developer.log(
      //   'Missing translation: $key para ${locale?.languageCode}',
      //   name: 'flutter_i18n',
      // );
    },
  );

  mixpanel = await Mixpanel.init(
    "c88b4457a1bd5f171dae1b3750632df0",
    optOutTrackingDefault: false,
    trackAutomaticEvents: true,
  );
  runApp(MyApp(flutterI18nDelegate: flutterI18nDelegate));
}

class MyApp extends StatefulWidget {
  final FlutterI18nDelegate flutterI18nDelegate;

  const MyApp({
    super.key,
    required this.flutterI18nDelegate,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Qualquer inicialização adicional pode ficar aqui
  }

  @override
  Widget build(BuildContext context) {
    FlutterUxcam.optIntoSchematicRecordings();
    FlutterUxcam.startWithConfiguration(
      FlutterUxConfig(
        userAppKey: '8eggpfc4uajx7ue',
        enableAutomaticScreenNameTagging: true,
        enableAdvancedGestureRecognition: true,
        enableCrashHandling: true,
        enableNetworkLogging: true,
      ),
    );

    return ChangeNotifierProvider<AppState>(
      // Passamos o `context` diretamente ao criar AppState
      create: (providerContext) => AppState(context: providerContext),
      child: Consumer<AppState>(
        builder: (_, state, __) {
          return SkeletonThemeProvider(
            child: MaterialApp(
              title: 'Wisemade',
              theme: WisemadeTheme.darkTheme,
              darkTheme: WisemadeTheme.darkTheme,
              themeMode: ThemeMode.system,
              home: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                child: const AppPage(),
              ),
              localizationsDelegates: [
                widget.flutterI18nDelegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: Locale(state.currentLocale),
              supportedLocales: const [
                Locale('pt'),
                Locale('en'),
                Locale('es'),
              ],
              builder: FlutterI18n.rootAppBuilder(),
            ),
          );
        },
      ),
    );
  }
}