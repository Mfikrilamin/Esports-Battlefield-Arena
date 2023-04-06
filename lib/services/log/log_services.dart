import 'package:logger/logger.dart';

class LogService {
  var logger = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: true), // Use the PrettyPrinter to format and print log
    output: null,
    level: Level.debug,
  );

  void debug(String message) {
    Logger().d(message);
  }
}
