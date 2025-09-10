import 'dart:developer';

///green coloured log
void showlog(String msg) {
  log('\x1B[32m$msg\x1B[0m');
}
