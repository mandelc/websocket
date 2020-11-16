import 'dart:async';

import 'dart:io';
import 'dart:convert';

void main() {
  runZoned(() async {
    var i = 0;

    HttpServer.bind(InternetAddress.loopbackIPv4, 12345).then((server) {
      server.forEach((req) {
        WebSocketTransformer.upgrade(req).then((socket) {
          socket.listen((data) async {
            var args = (data as String).split(" ");
            args.insert(0, "/c");
            try {
              Process.start("cmd", args).then((result) {
                result.stdout.transform(utf8.decoder).listen((data) {
                  print(data);
                  socket.add(data);
                });
              });
            } catch (err) {
              socket.add(err);
            }
          });
        });
      });
    });
  });
}
