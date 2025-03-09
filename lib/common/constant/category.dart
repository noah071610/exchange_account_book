import 'package:currency_exchange/common/model/account_book_btn_model.dart';

final defaultSpendCategories = [
  AccountBookBtnModel(
    label: 'food',
    icon: 'fastfoodOutlined', // 식비에 어울리는 아이콘
    color: '#E57373', // 핑크색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'transportation',
    icon: 'train', // 교통비에 어울리는 아이콘
    color: '#64B5F6', // 파란색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'accommodation',
    icon: 'hotel', // 숙박비에 어울리는 아이콘
    color: '#BA68C8', // 라벤더색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'culture',
    icon: 'music', // 문화생활에 어울리는 아이콘
    color: '#DCE775', // 레몬색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'beauty',
    icon: 'scissors', // 미용비에 어울리는 아이콘
    color: '#FF8A65', // 복숭아색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'entertainment',
    icon: 'localDrinkOutlined', // 유흥비에 어울리는 아이콘
    color: '#4DD0E1', // 청록색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'necessities',
    icon: 'shoppingCart', // 생필품비에 어울리는 아이콘
    color: '#81C784', // 민트색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'clothing',
    icon: 'shirt', // 의류비에 어울리는 아이콘
    color: '#A1887F', // 베이지색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'medical',
    icon: 'localHospitalOutlined', // 병원비에 어울리는 아이콘
    color: '#E57373', // 장미색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'fee',
    icon: 'dollarSign', // 수수료에 어울리는 아이콘
    color: '#C5E1A5', // 카키색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'fixedCost',
    icon: 'receiptLongOutlined', // 고정비용에 어울리는 아이콘
    color: '#BA68C8', // 보라색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'etc',
    icon: 'moreHorizontal', // 그외 지출에 어울리는 아이콘
    color: '#BDBDBD', // 회색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'add',
    icon: 'plusCircle', // 추가에 어울리는 아이콘
    color: '#BA68C8', // 보라색 (70% 밝기)
  )
];

final defaultIncomeCategories = [
  AccountBookBtnModel(
    label: 'salary',
    icon: 'attachMoney', // 월급에 어울리는 아이콘
    color: '#4CAF50', // 초록색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'transfer',
    icon: 'accountBalanceWallet', // 계좌이체에 어울리는 아이콘
    color: '#FF9800', // 주황색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'allowance',
    icon: 'cardGiftcard', // 용돈에 어울리는 아이콘
    color: '#FFEB3B', // 노란색 (70% 밝기)
  ),
  AccountBookBtnModel(
    label: 'savings',
    icon: 'savings', // 저금에 어울리는 아이콘
    color: '#2196F3', // 파란색 (70% 밝기)
  ),
];

final spendingCategoryLabels = ['cash', 'card', 'qrCode', 'transfer'];

final accountTypeLabels = ['spend', 'income', 'exchange'];
