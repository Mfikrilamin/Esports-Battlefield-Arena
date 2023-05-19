import 'dart:convert';
import 'package:esports_battlefield_arena/app/failures.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/services/game_database/apex_legend/apex_legend.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';

class ApexLegendStatusAPI extends ApexLegendDatabase {
  final LogService _log = locator<LogService>();
  final _functions = FirebaseFunctions.instance;

  @override
  Future<Map<String, dynamic>> verifyPlayer(
      String userName, String platform) async {
    try {
      if (platform == ApexLegendPlatform.Playstation.name) {
        platform = "PS4";
      } else if (platform == ApexLegendPlatform.Xbox.name) {
        platform = "X1";
      }
      //Make post request to our cloud function
      final response = await _functions.httpsCallable('verifyApexPlayer').call({
        'username': userName,
        'platform': platform,
      });

      _log.debug('Response is:---> ${response.data}');

      return response.data;
    } on FirebaseFunctionsException catch (error) {
      _log.debug(error.code);
      _log.debug(error.details.toString());
      _log.debug(error.message!);
      throw Failure('Firebase function error',
          message: error.message!,
          location: 'ApexLegendStatusAPI.verifyPlayer');
    } catch (err) {
      throw Failure('Something went wrong',
          message: err.toString(),
          location: 'ApexLegendStatusAPI.verifyPlayer');
    }
  }
}
