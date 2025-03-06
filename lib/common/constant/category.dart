import 'package:currency_exchange/common/model/account_book_btn_model.dart';

final defaultCategoryList = [
  [
    AccountBookBtnModel(
      label: '식비',
      icon: 'fastfoodOutlined', // 식비에 어울리는 아이콘
      color: '#FF8A9A', // 핑크색 (30% 더 진하게)
      favorite: false,
    ),
    AccountBookBtnModel(
      label: '교통비',
      icon: 'train', // 교통비에 어울리는 아이콘
      color: '#7FB8D6', // 파란색 (30% 더 진하게)
      favorite: false,
    ),
  ],
  [
    AccountBookBtnModel(
      label: '숙박비',
      icon: 'hotel', // 숙박비에 어울리는 아이콘
      color: '#B3B3E6', // 라벤더색 (30% 더 진하게)
      favorite: false,
    ),
    AccountBookBtnModel(
      label: '문화생활',
      icon: 'music', // 문화생활에 어울리는 아이콘
      color: '#CCF2A3', // 레몬색 (30% 더 진하게)
      favorite: false,
    ),
  ],
  [
    AccountBookBtnModel(
      label: '미용비',
      icon: 'scissors', // 미용비에 어울리는 아이콘
      color: '#FFB08A', // 복숭아색 (30% 더 진하게)
      favorite: false,
    ),
    AccountBookBtnModel(
      label: '유흥비',
      icon: 'localDrinkOutlined', // 유흥비에 어울리는 아이콘
      color: '#B3FFFF', // 청록색 (30% 더 진하게)
      favorite: false,
    ),
  ],
  [
    AccountBookBtnModel(
      label: '생필품비',
      icon: 'shoppingCart', // 생필품비에 어울리는 아이콘
      color: '#B3FFB3', // 민트색 (30% 더 진하게)
      favorite: false,
    ),
    AccountBookBtnModel(
      label: '의류비',
      icon: 'shirt', // 의류비에 어울리는 아이콘
      color: '#BFBF9C', // 베이지색 (30% 더 진하게)
      favorite: false,
    ),
  ],
  [
    AccountBookBtnModel(
      label: '병원비',
      icon: 'localHospitalOutlined', // 병원비에 어울리는 아이콘
      color: '#FFB3B0', // 장미색 (30% 더 진하게)
      favorite: false,
    ),
    AccountBookBtnModel(
      label: '수수료',
      icon: 'dollarSign', // 수수료에 어울리는 아이콘
      color: '#BFBF63', // 카키색 (30% 더 진하게)
      favorite: false,
    ),
  ],
  [
    AccountBookBtnModel(
      label: '고정비용',
      icon: 'receiptLongOutlined', // 고정비용에 어울리는 아이콘
      color: '#B38FB3', // 보라색 (30% 더 진하게)
      favorite: false,
    ),
    AccountBookBtnModel(
      label: '그외 지출',
      icon: 'moreHorizontal', // 그외 지출에 어울리는 아이콘
      color: '#A6A6A6', // 회색 (30% 더 진하게)
      favorite: false,
    ),
  ],
  [
    AccountBookBtnModel(
      label: 'add',
      icon: 'plusCircle', // 추가에 어울리는 아이콘
      color: '#B38FB3', // 보라색 (30% 더 진하게)
      favorite: false,
    ),
  ]
];

final spendingCategory = [
  AccountBookBtnModel(
    label: 'cash',
    icon: 'cash', // 추가에 어울리는 아이콘
    color: '#FFD700', // 금색
    favorite: false,
  ),
  AccountBookBtnModel(
    label: 'card',
    icon: 'card', // 추가에 어울리는 아이콘
    color: '#00FF7F', // 스프링 그린
    favorite: false,
  ),
  AccountBookBtnModel(
    label: 'qrCode',
    icon: 'qrCode', // 추가에 어울리는 아이콘
    color: '#FF4500', // 오렌지 레드
    favorite: false,
  ),
  AccountBookBtnModel(
    label: 'transfer',
    icon: 'transfer', // 추가에 어울리는 아이콘
    color: '#1E90FF', // 다저 블루
    favorite: false,
  ),
];
