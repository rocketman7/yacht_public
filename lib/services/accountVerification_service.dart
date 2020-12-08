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
  final String _token = 'a65548647c7b477786f6b20a9413bbef60014c6f';

  //나중에 DB로 옮기는게..?
  final Map<String, String> bankList = {
    '교보증권': '261',
    '대신증권': '267',
    '미래에셋대우': '238',
    '메리츠증권': '287',
    '부국증권': '290',
    '삼성증권': '240',
    '상상인증권': '221',
    '신영증권': '291',
    '신한금융투자': '278',
    '유안타증권': '209',
    '유진투자증권': '280',
    '이베스트투자증권': '265',
    '키움증권': '264',
    '케이프투자증권': '292',
    '하나금융투자': '270',
    '하이투자증권': '262',
    '한국투자증권': '243',
    '한화투자증권': '269',
    '현대차증권': '263',
    'BNK투자증권': '224',
    'DB금융투자': '279',
    'IBK투자증권': '225',
    'KB증권': '218',
    'KTB투자증권': '227',
    'NH투자증권': '247',
    'SK증권': '266',
  };

  //나중에 DB로 옮기는게..?
  final Map<String, String> bankLogoList = {
    '교보증권': 'assets/images/secLogo/kyobo.png',
    '대신증권': 'assets/images/secLogo/dashin.png',
    '미래에셋대우': 'assets/images/secLogo/mirae.png',
    '메리츠증권': 'assets/images/secLogo/meritz.png',
    '부국증권': 'assets/images/secLogo/bookook.png',
    '삼성증권': 'assets/images/secLogo/samsung.png',
    '상상인증권': 'assets/images/secLogo/ssin.png',
    '신영증권': 'assets/images/secLogo/sinyoung.png',
    '신한금융투자': 'assets/images/secLogo/shiv.png',
    '유안타증권': 'assets/images/secLogo/yuanta.png',
    '유진투자증권': 'assets/images/secLogo/eugene.png',
    '이베스트투자증권': 'assets/images/secLogo/ebest.png',
    '키움증권': 'assets/images/secLogo/kiwom.png',
    '케이프투자증권': 'assets/images/secLogo/cape.png',
    '하나금융투자': 'assets/images/secLogo/hana.png',
    '하이투자증권': 'assets/images/secLogo/hi.png',
    '한국투자증권': 'assets/images/secLogo/korea.png',
    '한화투자증권': 'assets/images/secLogo/hanhwa.png',
    '현대차증권': 'assets/images/secLogo/hyundai.png',
    'BNK투자증권': 'assets/images/secLogo/bnk.png',
    'DB금융투자': 'assets/images/secLogo/db.png',
    'IBK투자증권': 'assets/images/secLogo/ibk.png',
    'KB증권': 'assets/images/secLogo/kb.png',
    'KTB투자증권': 'assets/images/secLogo/ktb.png',
    'NH투자증권': 'assets/images/secLogo/nh.png',
    'SK증권': 'assets/images/secLogo/sk.png',
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
