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
