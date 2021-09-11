// tierString = tierName.replaceAll(new RegExp(r'[0-9]'),''); // '23'
// tierLevel = tierName.replaceAll(new RegExp(r'[^0-9]'),''); // '23'

import 'package:yachtOne/models/tier_system_model.dart';
import 'package:yachtOne/repositories/repository.dart';

String getTierByExp(int exp) {
  String tierName = "";
  if (tierSystemModelRx.value != null) {
    List<int> tierStops = tierSystemModelRx.value!.tierStops;
    List<String> tierNames = tierSystemModelRx.value!.tierNames;
    for (int i = 0; i < tierStops.length; i++) {
      if (exp < tierStops[i]) {
        tierName = tierNames[i];
        break;
      }
    }
  }
  return tierName;
}

String separateStringFromTier(String tierName) {
  return tierName.replaceAll(new RegExp(r'[0-9]'), ''); // '23'
}

int separateIntFromTier(String tierName) {
  return int.parse(tierName.replaceAll(new RegExp(r'[^0-9]'), ''));
}
