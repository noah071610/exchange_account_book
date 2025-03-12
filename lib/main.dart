// import 'dart:io';

import 'dart:io';

import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:currency_exchange/common/model/account_book_category_model.dart';
import 'package:currency_exchange/common/model/account_book_list_model.dart';
import 'package:currency_exchange/common/model/account_book_model.dart';
import 'package:currency_exchange/common/model/currency_list_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/view/root_tab.dart';
import 'package:currency_exchange/setting/view/display_setting.dart';
import 'package:currency_exchange/setting/view/font_setting.dart';
import 'package:currency_exchange/setting/view/language_setting.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive/hive.dart';
import 'package:currency_exchange/common/constant/color.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:currency_exchange/common/provider/setting_provider.dart';
import 'package:currency_exchange/common/model/setting_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting();
  await dotenv.load(fileName: ".env");

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(CurrencyListModelAdapter());
  Hive.registerAdapter(CurrencyModelAdapter());
  Hive.registerAdapter(AccountBookBtnModelAdapter());
  Hive.registerAdapter(AccountBookModelAdapter());
  Hive.registerAdapter(AccountBookCategoryModelAdapter());
  Hive.registerAdapter(AccountBookListModelAdapter());

  Hive.registerAdapter(SettingModelAdapter());

  await Hive.deleteFromDisk();
  try {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    final hivePath = appDocumentDir.path;

    // Hive 닫기
    await Hive.close();

    // Hive 디렉토리 삭제
    final directory = Directory(hivePath);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }

    // Hive 재초기화
    Hive.init(hivePath);
  } on HiveError {
    await Hive.deleteFromDisk();
  }

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: [
          Locale('en'),
          Locale('ko'),
          Locale('ja'),
        ],

        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('ko'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingProvider);

    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Kanji Master',
      themeMode: setting.themeNum == 2 ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        extensions: [
          CustomColors(
            containerBg: const Color.fromARGB(6, 0, 0, 0),
            containerWhiteBg: Colors.white,
            opposite: Colors.black87,
            buttonBackground: PRIMARY_COLOR,
            buttonTextColor: BUTTON_TEXT_COLOR,
            text: const Color.fromARGB(255, 74, 24, 118),
            primaryBg: const Color.fromARGB(82, 159, 124, 254),
            active: const Color.fromARGB(255, 74, 24, 118),
            icon: Colors.black38,
            primary: const Color.fromARGB(255, 137, 95, 209),
            sub: const Color.fromARGB(255, 74, 24, 118),
            divider100: const Color.fromARGB(18, 0, 0, 0),
            textGrey: const Color.fromRGBO(0, 0, 0, 0.541),
            greenBg: const Color.fromARGB(255, 191, 245, 190),
            greenText: const Color.fromARGB(255, 24, 118, 28),
          ),
        ],
        textTheme: GoogleFonts.getTextTheme(setting.font).apply(
          bodyColor: BLACK_COLOR, // 기본 텍스트 색상 설정
          displayColor: BLACK_COLOR, // 제목 등의 텍스트 색상 설정
        ),
        appBarTheme: AppBarTheme(
          backgroundColor:
              const Color.fromARGB(255, 245, 242, 252), // AppBar 배경 색상 설정
          titleTextStyle: TextStyle(
            color: Colors.black87, // title 색상 설정
          ),
          iconTheme: IconThemeData(
            color: Colors.black38, // action icon 색상 설정
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black38, // 아이콘 버튼 색상 설정
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white, // AlertDialog 배경 색상 설정
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor:
              const Color.fromARGB(255, 105, 88, 171), // 선택된 아이템 색상 설정
          unselectedItemColor:
              const Color.fromARGB(124, 0, 0, 0), // 선택되지 않은 아이템 색상 설정
          backgroundColor: const Color.fromARGB(255, 245, 242, 252),
        ),
        radioTheme: RadioThemeData(
          fillColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const Color.fromARGB(255, 105, 88, 171); // 선택된 상태에서 색상 설정
            }
            return Colors.black38; // 선택되지 않은 상태에서 색상 설정
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const Color.fromARGB(255, 105, 88, 171); // 선택된 상태에서 색상 설정
            }
            return WHITE_COLOR; // 선택되지 않은 상태에서 색상 설정
          }),
          side: BorderSide(
            color: Colors.black38, // side 색상 설정
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: WHITE_COLOR, // BottomSheet 배경 색상 설정
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        extensions: [
          CustomColors(
            containerBg: const Color.fromARGB(255, 20, 18, 23),
            containerWhiteBg: const Color.fromARGB(255, 20, 18, 23),
            opposite: Colors.white,
            buttonBackground: PRIMARY_COLOR,
            buttonTextColor: BUTTON_TEXT_COLOR,
            text: const Color.fromARGB(255, 233, 212, 252),
            primaryBg: const Color.fromARGB(137, 141, 101, 252),
            active: const Color.fromARGB(255, 74, 24, 118),
            icon: Colors.white,
            primary: const Color.fromARGB(255, 137, 95, 209),
            sub: const Color.fromARGB(255, 74, 24, 118),
            divider100: const Color.fromARGB(101, 255, 255, 255),
            textGrey: Colors.grey,
            greenBg: const Color.fromARGB(255, 28, 70, 27),
            greenText: const Color.fromARGB(255, 188, 235, 190),
          ),
        ],
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor:
              const Color.fromARGB(255, 153, 130, 255), // 선택된 아이템 색상 설정
          unselectedItemColor: WHITE_COLOR, // 선택되지 않은 아이템 색상 설정
        ),
        radioTheme: RadioThemeData(
          fillColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const Color.fromARGB(255, 153, 130, 255); // 선택된 상태에서 색상 설정
            }
            return WHITE_COLOR; // 선택되지 않은 상태에서 색상 설정
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const Color.fromARGB(255, 153, 130, 255); // 선택된 상태에서 색상 설정
            }
            return BLACK_COLOR; // 선택되지 않은 상태에서 색상 설정
          }),
          checkColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            return WHITE_COLOR; // 체크 아이콘 색상 설정
          }),
        ),
      ),
      builder: (context, child) {
        return Builder(
          builder: (BuildContext context) {
            final mediaQuery = MediaQuery.of(context);
            final constrainedWidth =
                mediaQuery.size.width > 600 ? 600.0 : mediaQuery.size.width;

            return Center(
              child: SizedBox(
                width: constrainedWidth,
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return RootTab();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'display-setting',
          builder: (BuildContext context, GoRouterState state) {
            return const DisplaySettingTab();
          },
        ),
        GoRoute(
          path: 'language-setting',
          builder: (BuildContext context, GoRouterState state) {
            return const LanguageSetting();
          },
        ),
        GoRoute(
          path: 'font-setting',
          builder: (BuildContext context, GoRouterState state) {
            return const FontSetting();
          },
        ),
        // GoRoute(
        //   path: 'levelOne',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const LevelOneView();
        //   },
        // ),
      ],
    ),
  ],
);
