import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

abstract class AccountVerificationService {
  Future<Object> accOwnerVerification(
      String accNum, String bankCode, String custName);
  Future<Object> accOccupyVerification(
      String accNum, String bankCode, String authText);
  int authTextGenerate();
}

class AccoutVerificationServiceMydata extends AccountVerificationService {
  final String _token = 'ed1ff970f8c64e73857026e430dca5484aa2933e';

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
        'https://datahub-dev.scraping.co.kr/scrap/common/settlebank/accountOwner',
        headers: {
          'Authorization': 'Token $_token',
          'Host': 'datahub-dev.scraping.co.kr',
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(body),
        encoding: Encoding.getByName('utf-8'));

    Map<String, dynamic> respBody;
    respBody = json.decode(resp.body);

    if (resp.statusCode == 200) {
      if (respBody['errCode'] == '0000') if (respBody['data']['OUTSTATCD'] ==
          '0021')
        return [true, 'success'];
      else
        return [false, 'errorO:${respBody['data']['OUTSTATCD']}'];
      else
        return [false, 'errorC:${respBody['errCode']}'];
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
        'https://datahub-dev.scraping.co.kr/scrap/common/settlebank/accountOccupation',
        headers: {
          'Authorization': 'Token $_token',
          'Host': 'datahub-dev.scraping.co.kr',
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
        return [false, 'errorO:${respBody['data']['OUTSTATCD']}'];
      else
        return [false, 'errorC:${respBody['errCode']}'];
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
}
