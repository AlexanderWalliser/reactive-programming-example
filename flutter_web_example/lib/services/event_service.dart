import 'dart:async';
import 'dart:convert';
import 'package:flutter_web_example/entities/to_do_event.dart';
import 'package:universal_html/html.dart' as html;

class EventService {
  static Uri connection = Uri.parse("http://localhost:8080/todos/stream");
  final html.EventSource eventSource;
  final StreamController<ToDoEvent> streamController;

  EventService._internal(this.eventSource, this.streamController);

  factory EventService.connect() {
    Uri uri = connection;
    bool withCredentials = false;
    bool closeOnError = true;
    final streamController = StreamController<ToDoEvent>();
    final eventSource = html.EventSource(uri.toString(), withCredentials: withCredentials);

    eventSource.addEventListener('message', (html.Event message) {
      streamController.add(ToDoEvent.fromJson(json.decode((message as html.MessageEvent).data as String)));
    });

    if (closeOnError) {
      eventSource.onError.listen((event) {
        eventSource?.close();
        streamController.addError(event);
        streamController?.close();
      });
    }
    return EventService._internal(eventSource, streamController);
  }

  Stream get stream => streamController.stream;

  bool isClosed() =>
      this.streamController == null || this.streamController.isClosed;

  void close() {
    this.eventSource?.close();
    this.streamController?.close();
  }
}
