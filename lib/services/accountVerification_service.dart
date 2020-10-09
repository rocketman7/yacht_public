import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

abstract class AccountVerificationService {
  Future<Object> accOwnerVerification(
      String accNum, String bankCode, String custName);
  Future<Object> accOccupyVerification(
      String accNum, String bankCode, String authText);
  int authTextGenerate();
  int getBankListLength();
  Map<String, String> getBankList();
  Map<String, String> getBankLogoList();
}

class AccoutVerificationServiceMydata extends AccountVerificationService {
  //나중에 DB로 옮기는게..?
  //test token
  // final String _token = 'ed1ff970f8c64e73857026e430dca5484aa2933e';
  //real token
  final String _token = '98179f2e46aa498bacd828857eab5273ed539e34';

  //나중에 DB로 옮기는게..?
  final Map<String, String> bankList = {
    '유안타증권': '209',
    'KB증권': '218',
    '미래에셋대우': '238',
    '삼성증권': '240',
    '한국투자증권': '243',
    'NH투자증권': '247',
    '교보증권': '261',
    '하이투자증권': '262',
    '현대차투자증권': '263',
    '키움증권': '264',
    '이베스트투자증권': '265',
    'SK증권': '266',
    '대신증권': '267',
    '한화투자증권': '269',
    '하나금융투자': '270',
    '신한금융투자': '278',
    '동부증권': '279',
    '유진투자증권': '280',
    '메리츠종합금융증권': '287',
    '부국증권': '290',
    '신영증권': '291',
    '케이프투자증권': '292',
  };

  //나중에 DB로 옮기는게..?
  final Map<String, String> bankLogoList = {
    '유안타증권': 'assets/images/logo1.png',
    'KB증권': 'assets/images/logo1.png',
    '미래에셋대우': 'assets/images/logo1.png',
    '삼성증권': 'assets/images/logo1.png',
    '한국투자증권': 'assets/images/logo1.png',
    'NH투자증권': 'assets/images/logo1.png',
    '교보증권': 'assets/images/logo1.png',
    '하이투자증권': 'assets/images/logo1.png',
    '현대차투자증권': 'assets/images/logo1.png',
    '키움증권': 'assets/images/logo1.png',
    '이베스트투자증권': 'assets/images/logo1.png',
    'SK증권': 'assets/images/logo1.png',
    '대신증권': 'assets/images/logo1.png',
    '한화투자증권': 'assets/images/logo1.png',
    '하나금융투자': 'assets/images/logo1.png',
    '신한금융투자': 'assets/images/logo1.png',
    '동부증권': 'assets/images/logo1.png',
    '유진투자증권': 'assets/images/logo1.png',
    '메리츠종합금융증권': 'assets/images/logo1.png',
    '부국증권': 'assets/images/logo1.png',
    '신영증권': 'assets/images/logo1.png',
    '케이프투자증권': 'assets/images/logo1.png',
  };

  @override
  Future<Object> accOwnerVerification(
      String accNum, String bankCode, String custName) async {
    http.Response resp;
    Map<String, dynamic> body = {
      'OID': null,
      'CUSTID': '123456',
      'ACCTNO': accNum,
      'BANKCODE': bankCode,
      'CUSTNM': custName,
    };

    resp = await http.post(
        // 'https://datahub-dev.scraping.co.kr/scrap/common/settlebank/accountOwner',
        'https://api.mydatahub.co.kr/scrap/common/settlebank/accountOwner',
        headers: {
          'Authorization': 'Token $_token',
          // 'Host': 'datahub-dev.scraping.co.kr',
          'Host': 'api.mydatahub.co.kr',
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(body),
        encoding: Encoding.getByName('utf-8'));

    Map<String, dynamic> respBody;
    respBody = json.decode(resp.body);
    print('$respBody');

    if (resp.statusCode == 200) {
      if (respBody['errCode'] == '0000') if (respBody['data']['OUTSTATCD'] ==
          '0021')
        return [true, 'success'];
      else
        return [false, '다시 시도해주세요:${respBody['data']['OUTRSLTMSG']}'];
      else
        return [false, '다시 시도해주세요:${respBody['errCode']}'];
    } else {
      return [false, 'connect error'];
    }
  }

  @override
  Future<Object> accOccupyVerification(
      String accNum, String bankCode, String authText) async {
    http.Response resp;
    Map<String, dynamic> body = {
      'OID': null,
      'CUSTID': '654321',
      'ACCTNO': accNum,
      'BANKCODE': bankCode,
      'AUTHTEXT': '꾸욱$authText',
    };

    resp = await http.post(
        // 'https://datahub-dev.scraping.co.kr/scrap/common/settlebank/accountOccupation',
        'https://api.mydatahub.co.kr/scrap/common/settlebank/accountOccupation',
        headers: {
          'Authorization': 'Token $_token',
          // 'Host': 'datahub-dev.scraping.co.kr',
          'Host': 'api.mydatahub.co.kr',
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(body),
        encoding: Encoding.getByName('utf-8'));

    Map<String, dynamic> respBody;
    respBody = json.decode(resp.body);
    print('$respBody');

    if (resp.statusCode == 200) {
      if (respBody['errCode'] == '0000') if (respBody['data']['OUTSTATCD'] ==
          '0021') {
        return [true, 'success'];
      } else
        return [false, '다시 시도해주세요:${respBody['data']['OUTRSLTMSG']}'];
      else
        return [false, '다시 시도해주세요:${respBody['errCode']}'];
    } else {
      return [false, 'connect error'];
    }
  }

  @override
  int authTextGenerate() {
    Random random = Random();
    int randomAuthNum = random.nextInt(9000) + 1000;

    return randomAuthNum;
  }

  @override
  int getBankListLength() {
    return bankList.length;
  }

  @override
  Map<String, String> getBankList() {
    return bankList;
  }

  @override
  Map<String, String> getBankLogoList() {
    return bankLogoList;
  }
}
