import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import 'core/constants/app/app_constants.dart';
import 'core/init/lang/lang_manager.dart';
import 'core/init/navigation/navigation_route.dart';
import 'core/init/navigation/navigation_service.dart';
import 'core/init/theme/app_theme_dark.dart';
import 'core/init/theme/app_theme_light.dart';
import 'core/init/theme/cubit/theme_cubit.dart';
import 'view/home/countdown/cubit/countdown_cubit.dart';
import 'view/home/counter/cubit/counter_cubit.dart';
import 'view/home/todo/cubit/todo_cubit.dart';

// ignore: avoid_void_async
void main() async {
  //await _init();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(),
          ),
          BlocProvider<CounterCubit>(
            create: (BuildContext context) {
              return CounterCubit()..getCounterList();
            },
          ),
          BlocProvider<CountdownCubit>(
            create: (BuildContext context) {
              return CountdownCubit()..getCountdownList();
            },
          ),
          BlocProvider<TodoCubit>(
            create: (BuildContext context) {
              return TodoCubit()..getTodoList();
            },
          ),
        ],
        child: EasyLocalization(
            supportedLocales: LanguageManager.instance.supportedLocales,
            path: AppConstants.LANG_PATH,
            child: MyApp())

        //     DevicePreview(
        //   enabled: true,
        //   builder: (context) {
        //     return EasyLocalization(
        //         child: MyApp(),
        //         supportedLocales: LanguageManager.instance.supportedLocales,
        //         path: AppConstants.LANG_PATH);
        //   }, // Wrap your app
        // ),
        ));
  });
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    context.read<ThemeCubit>().updateAppTheme();
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        //locale: DevicePreview.locale(context), // Add the locale here
        //builder: DevicePreview.appBuilder, // Add the builder here
        debugShowCheckedModeBanner: false,
        theme: AppThemeLight.instance.theme,
        darkTheme: AppThemeDark.instance.theme,
        themeMode: context.select((ThemeCubit themeCubit) => themeCubit.state.themeMode),
        onGenerateRoute: NavigationRoute.instance.generateRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
      );
    });
  }
}
