import 'dart:html' as html;

Future<bool> checkInternetConnection() async {
  return html.window.navigator.onLine!;
}
