import 'package:iamhere/core/constants/host.dart';

String photoUrl(String path) {
  final p = path.startsWith('/') ? path.substring(1) : path;
  return 'http://$host/$p';
}