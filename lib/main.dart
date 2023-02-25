import 'dart:io';

import 'package:music_app/imports_bindings.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestFilePermission() async {
  debugPrint(
      "--------------------------FUNCTION CALLED-----------------------------");
  PermissionStatus result;
  // In Android we need to request the storage permission,
  // while in iOS is the photos permission
  if (Platform.isAndroid) {
    debugPrint("ASKING");
    result = await Permission.storage.request();
  } else {
    result = await Permission.photos.request();
  }

  if (result.isGranted) {
    return true;
  }
  //   imageSection = ImageSection.browseFiles;
  //   return true;
  // } else if (Platform.isIOS || result.isPermanentlyDenied) {
  //   imageSection = ImageSection.noStoragePermissionPermanent;
  // } else {
  //   imageSection = ImageSection.noStoragePermission;
  // }
  return false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await requestFilePermission();
  await AppSettingsStorage().openBox();
  var initialRoute = await Routes.initialRoute;
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => GetMaterialApp(
        translationsKeys: AppTranslation.translations,
        locale: Locale(AppSettingsStorage().retriveLanguage()),
        defaultTransition: Transition.cupertino,
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        getPages: Nav.routes,
        themeMode: AppSettingsStorage().retriveTheme(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
      ),
    );
  }
}
