import 'dart:math';

import 'package:intl/intl.dart';

// 숫자 표현하는 각종 포맷 모음

// 가격
NumberFormat formatPriceKRW = NumberFormat("#,###");
NumberFormat formatPriceUSD = NumberFormat("#,###.00");
// 가격 변동  ex) +56,750 or -27,050
// KRW는 일의 자리까지, USD는 소수 둘째 자리까지
NumberFormat formatPriceChangeKRW = NumberFormat("+#,###; -#,###");
NumberFormat formatPriceChangeUSD = NumberFormat("+#,##0.00; -#,##0.00");
// 퍼센티지
NumberFormat formatPercentage = NumberFormat("##.0%");
NumberFormat formatPercentageChange = NumberFormat("+0.00%;-0.00%");
NumberFormat simplePercentage = NumberFormat("##%");
// 큰 숫자 처리
String parseBigNumberKRW(num bigNumber) {
  bool isNegative = false;
  if (bigNumber < 0) {
    isNegative = true;
  }

  if (bigNumber.abs() >= 1000000000000) {
    num mod = bigNumber.abs() % 1000000000000;

    return (isNegative ? "-" : "") +
        formatPriceKRW.format((bigNumber.abs() / 1000000000000).floor()) +
        "조 " +
        formatPriceKRW.format((mod / 100000000).floor()) +
        "억";
  } else if (bigNumber.abs() >= 100000000) {
    return (isNegative ? "-" : "") + formatPriceKRW.format((bigNumber.abs() / 100000000).floor()) + "억";
  } else if (bigNumber.abs() >= 10000) {
    return (isNegative ? "-" : "") + formatPriceKRW.format((bigNumber.abs() / 10000).floor()) + "만";
  } else {
    return (isNegative ? "-" : "") + formatPriceKRW.format(bigNumber.abs());
  }
}

String parseBigNumberShortKRW(num bigNumber) {
  bool isNegative = false;
  num mod = bigNumber.abs() % 1000000000000;
  if (bigNumber < 0) {
    isNegative = true;
  }

  if (bigNumber.abs() >= 1000000000000) {
    // num mod = bigNumber.abs() % 1000000000000;
    // print(bigNumber);

    return (isNegative ? "-" : "") +
        formatPriceKRW.format((bigNumber.abs() / 1000000000000).floor()) +
        "조 " +
        formatPriceKRW.format((mod / 100000000000).floor()) +
        "천억";
  } else if (bigNumber.abs() >= 100000000) {
    return (isNegative ? "-" : "") + formatPriceKRW.format((bigNumber.abs() / 100000000).floor()) + "억";
  } else if (bigNumber.abs() >= 10000) {
    return (isNegative ? "-" : "") + formatPriceKRW.format((bigNumber.abs() / 10000).floor()) + "만";
  } else {
    return (isNegative ? "-" : "") + formatPriceKRW.format(bigNumber.abs());
  }
}

String parseNumberKRWtoApproxiKorean(num number) {
  int x;
  int y;
  if (number >= 100000000) {
    // 억이 넘어가면 x억y천만원 까지 해준다.
    x = (number / 100000000).floor();
    y = ((number - x * 100000000) / 10000000).round();
    if (y != 10) {
      if (y != 0)
        return parseNumbertoKorean(x) + '억' + parseNumbertoKorean(y) + '천만원';
      else
        return parseNumbertoKorean(x) + '억원';
    } else {
      if (x != 9) {
        return parseNumbertoKorean(x + 1) + '억원';
      } else {
        return '${x + 1}억원';
      }
    }
  } else if (number >= 10000000) {
    // 수천만원단위이면 x천y백만원 까지 해준다.
    x = (number / 10000000).floor();
    y = ((number - x * 10000000) / 1000000).round();
    if (y != 10) {
      if (y != 0) if (x != 1)
        return parseNumbertoKorean(x) + '천' + parseNumbertoKorean(y) + '백만원';
      else
        return '천' + parseNumbertoKorean(y) + '백만원';
      else
        return parseNumbertoKorean(x) + '천만원';
    } else {
      if (x != 9) {
        return parseNumbertoKorean(x + 1) + '천만원';
      } else {
        return '일억원';
      }
    }
  } else if (number >= 1000000) {
    // 수백만원단위이면 x백y십만원 까지 해준다.
    x = (number / 1000000).floor();
    y = ((number - x * 1000000) / 100000).round();
    if (y != 10) {
      if (y != 0) if (x != 1)
        return parseNumbertoKorean(x) + '백' + parseNumbertoKorean(y) + '십만원';
      else
        return '백' + parseNumbertoKorean(y) + '십만원';
      else
        return parseNumbertoKorean(x) + '백만원';
    } else {
      if (x != 9) {
        return parseNumbertoKorean(x + 1) + '백만원';
      } else {
        return '천만원';
      }
    }
  } else if (number >= 100000) {
    // 수십만원단위이면 x십y만원 까지 해준다.
    x = (number / 100000).floor();
    y = ((number - x * 100000) / 10000).round();
    if (y != 10) {
      if (y != 0) if (x != 1)
        return parseNumbertoKorean(x) + '십' + parseNumbertoKorean(y) + '만원';
      else
        return '십' + parseNumbertoKorean(y) + '만원';
      else
        return parseNumbertoKorean(x) + '십만원';
    } else {
      if (x != 9) {
        return parseNumbertoKorean(x + 1) + '십만원';
      } else {
        return '백만원';
      }
    }
  } else if (number >= 10000) {
    // 수만원단위이면 x만y천원 까지 해준다.
    x = (number / 10000).floor();
    y = ((number - x * 10000) / 1000).round();
    if (y != 10) {
      if (y != 0) if (x != 1)
        return parseNumbertoKorean(x) + '만' + parseNumbertoKorean(y) + '천원';
      else
        return '만' + parseNumbertoKorean(y) + '천원';
      else
        return parseNumbertoKorean(x) + '만원';
    } else {
      if (x != 9) {
        return parseNumbertoKorean(x + 1) + '만원';
      } else {
        return '십만원';
      }
    }
  } else {
    // 아니면 걍 몇천원 단위로 반올림
    x = (number / 1000).round();
    if (x != 0 && x != 1 && x != 10)
      return parseNumbertoKorean(x) + '천원';
    else if (x == 10)
      return '만원';
    else if (x == 0)
      return '수백원';
    else
      return '천원';
  }
}

// 상금모듈 약 몇백만원 이런애들 표현해주기 위한 함수
String parseNumbertoKorean(int number) {
  List<String> korean = ['일', '이', '삼', '사', '오', '육', '칠', '팔', '구', '십'];

  return korean[number - 1];
}

// 변환하는 함수. 전역으로 이거 쓰면 됨.
String toPriceKRW(num number) {
  return formatPriceKRW.format(number);
}

String toPriceUSD(num number) {
  return formatPriceUSD.format(number);
}

String toPriceChangeKRW(num number) {
  return formatPriceChangeKRW.format(number);
}

String toPriceChangeUSD(num number) {
  return formatPriceChangeUSD.format(number);
}

String toPercentage(num number) {
  return formatPercentage.format(number);
}

String toPercentageChange(num number) {
  return formatPercentageChange.format(number);
}

String toSimplePercentage(num number) {
  return simplePercentage.format(number);
}

// random 생성기

String randomSmsCode() {
  num intCode = 0;
  String code = '000000';
  for (int i = 0; i < 6; i++) {
    intCode += Random().nextInt(9) * pow(10, i);
  }
  // print(intCode.toString().padLeft(6, '0'));
  code = intCode.toString().padLeft(6, '0');
  return code;
}
