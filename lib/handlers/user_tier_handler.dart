// tierString = tierName.replaceAll(new RegExp(r'[0-9]'),''); // '23'
// tierLevel = tierName.replaceAll(new RegExp(r'[^0-9]'),''); // '23'

import 'package:get/get_connect/http/src/utils/utils.dart';
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

List<String> getOnlyTierTitle(List<String> tierNames) {
  Set<String> temp = {};
  tierNames.forEach((element) {
    temp.add(separateStringFromTier(element));
  });
  return temp.toList();
}

List<int> getExpNeededForEachTierTitle(List<String> tierNames, List<int> stops) {
  List<int> temp = [];
  List<int> node = [];
  // int exp = 0;
  for (int i = 0; i < tierNames.length; i++) {
    if (i < tierNames.length - 1) {
      if (separateStringFromTier(tierNames[i]) != separateStringFromTier(tierNames[i + 1])) {
        // exp += stops[i];
        node.add(i);
      } else {}
    } else {
      node.add(i);
    }
  }

  node.forEach((element) {
    temp.add(stops[element]);
  });
  // print(temp);
  return temp;
}

int getNextTierExp(int expNow) {
  int nextTierExp = 0;

  for (int i = 0; i < tierSystemModelRx.value!.tierStops.length; i++) {
    if (expNow > tierSystemModelRx.value!.tierStops[i]) {
      if (i + 1 == tierSystemModelRx.value!.tierStops.length) {
        nextTierExp = expNow;
      } else {
        nextTierExp = tierSystemModelRx.value!.tierStops[i + 1];
      }
    }
  }
  return nextTierExp;
}

int getBeforeTierExp(int expNow) {
  int beforeTierExp = 0;

  for (int i = 0; i < tierSystemModelRx.value!.tierStops.length; i++) {
    if (expNow > tierSystemModelRx.value!.tierStops[i]) {
      if (i == 0) {
        beforeTierExp = 0;
      } else {
        beforeTierExp = tierSystemModelRx.value!.tierStops[i - 1];
      }
    }
  }
  return beforeTierExp;
}
