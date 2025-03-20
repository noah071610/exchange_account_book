import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

final iconDictionary = {
  'fastfoodOutlined': Icons.fastfood_outlined,
  'train': Icons.train_outlined,
  'hotel': Icons.hotel,
  'music': FeatherIcons.music,
  'scissors': FeatherIcons.scissors,
  'localDrinkOutlined': Icons.local_drink_outlined,
  'shoppingCart': FeatherIcons.shoppingCart,
  'shirt': Icons.dry_cleaning_outlined,
  'localHospitalOutlined': Icons.local_hospital_outlined,
  'dollarSign': FeatherIcons.dollarSign,
  'receiptLongOutlined': Icons.receipt_long_outlined,
  'moreHorizontal': FeatherIcons.moreHorizontal,
  'plusCircle': FeatherIcons.plusCircle,
  'cash': Icons.money_outlined,
  'card': FeatherIcons.creditCard,
  'qrCode': Icons.qr_code,
  'transfer': Icons.account_balance_wallet_outlined,
  'spend': FeatherIcons.arrowUp, // 지출에 어울리는 아이콘
  'income': FeatherIcons.arrowDown, // 수입에 어울리는 아이콘
  'attachMoney': Icons.attach_money, // 월급에 어울리는 아이콘
  'accountBalanceWallet': Icons.account_balance_wallet, // 계좌이체에 어울리는 아이콘
  'cardGiftcard': Icons.card_giftcard, // 용돈에 어울리는 아이콘
  'savings': Icons.savings, // 저금에 어울리는 아이콘
  'swap_horiz': Icons.swap_horiz, // 환전에 어울리는 아이콘

  // 추가된 Icons
  'home': Icons.home,
  'search': Icons.search,
  'settings': Icons.settings,
  'camera': Icons.camera_alt,
  'alarm': Icons.alarm,
  'email': Icons.email,
  'favorite': Icons.favorite,
  'map': Icons.map,
  'phone': Icons.phone,
  'lock': Icons.lock,

  // 추가된 CupertinoIcons
  'cupertinoHome': CupertinoIcons.home,
  'cupertinoSearch': CupertinoIcons.search,
  'cupertinoSettings': CupertinoIcons.settings,
  'cupertinoCamera': CupertinoIcons.camera,
  'cupertinoAlarm': CupertinoIcons.alarm,
  'cupertinoMail': CupertinoIcons.mail,
  'cupertinoHeart': CupertinoIcons.heart,
  'cupertinoMap': CupertinoIcons.map,
  'cupertinoPhone': CupertinoIcons.phone,
  'cupertinoLock': CupertinoIcons.lock,

  // 추가된 FeatherIcons
  'featherHome': FeatherIcons.home,
  'featherSearch': FeatherIcons.search,
  'featherSettings': FeatherIcons.settings,
  'featherCamera': FeatherIcons.camera,
  'featherBell': FeatherIcons.bell,
  'featherMail': FeatherIcons.mail,
  'featherHeart': FeatherIcons.heart,
  'featherMap': FeatherIcons.map,
  'featherPhone': FeatherIcons.phone,
  'featherLock': FeatherIcons.lock,
};

final iconKeys = iconDictionary.keys.toList();
