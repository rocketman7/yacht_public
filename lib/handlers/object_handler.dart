// List<Object> sortByValues(List<Object> list, dynamic key, {bool reverse: false}) {
// `
//     reverse == true? list.sort((a, b) => a.key!.compareTo(b.key!));
//   return list;
// }

import 'package:flutter_linkify/flutter_linkify.dart';

List<LinkifyElement> linkify(
  String text, {
  LinkifyOptions options = const LinkifyOptions(),
  List<Linkifier> linkifiers = const [UrlLinkifier()],
}) {
  var list = <LinkifyElement>[TextElement(text)];

  if (text.isEmpty) {
    return [];
  }

  if (linkifiers.isEmpty) {
    return list;
  }

  linkifiers.forEach((linkifier) {
    list = linkifier.parse(list, options);
  });

  return list;
}
