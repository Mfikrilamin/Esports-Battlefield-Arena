import 'dart:convert';

import 'package:esports_battlefield_arena/app/failures.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/services/game_database/valorant/valorant.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:http/http.dart' as http;

class ValorantHenrikdevAPI extends ValorantDatabase {
  final LogService _log = locator<LogService>();
  @override
  Future<Map<String, dynamic>> verifyPlayer(
      String userName, String playerTag) async {
    try {
      //Make post request to our cloud function
      var response = await http.get(
        Uri.parse(
            'https://api.henrikdev.xyz/valorant/v1/account/$userName/$playerTag'),
      );

      // if (response.statusCode != 200) {
      //   throw Failure('Failed to verify user',
      //       message: response.body.toString(),
      //       location: 'StripePaymentService.createPaymentIntent');
      // }
      _log.debug('Response is:---> ${response.body}');
      Map<String, dynamic> returnData = {};
      Map<String, dynamic> _response = json.decode(response.body);
      if (_response['status'] != 200) {
        returnData.putIfAbsent('status', () => false);
        returnData.putIfAbsent(
            'message', () => _response['errors'][0]['message']);
        returnData.putIfAbsent('data', () => []);
      } else {
        var playerInformation = {
          'puuid': _response['data']['puuid'],
          'username': _response['data']['name'],
          'tagline': _response['data']['tag'],
          'region': _response['data']['region'],
        };
        returnData.putIfAbsent('status', () => true);
        returnData.putIfAbsent('message', () => 'Valorant player found');
        returnData.putIfAbsent('data', () => playerInformation);
      }

      return returnData;
    } catch (err) {
      throw Failure('Something went wrong',
          message: err.toString(),
          location: 'ValorantHenrikdevAPI.verifyPlayer');
    }
  }
}
