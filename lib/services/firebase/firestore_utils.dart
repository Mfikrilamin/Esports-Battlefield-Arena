import 'package:esports_battlefield_arena/models/User.dart';
import 'package:esports_battlefield_arena/models/apex_match_result.dart';
import 'package:esports_battlefield_arena/models/invoice.dart';
import 'package:esports_battlefield_arena/models/nickname.dart';
import 'package:esports_battlefield_arena/models/organizer.dart';
import 'package:esports_battlefield_arena/models/player.dart';
import 'package:esports_battlefield_arena/models/player_stats.dart';
import 'package:esports_battlefield_arena/models/team.dart';
import 'package:esports_battlefield_arena/models/match.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/tournament_participant.dart';
import 'package:esports_battlefield_arena/models/valorant_match_result.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';

//Map to store the collection name in firestore
//If the collection name is changed in firestore, it will be changed here
final Map<FirestoreCollections, Map<FirestoreDeclration, String>>
    firestoreCollectionsName = {
  FirestoreCollections.users: {
    FirestoreDeclration.collectionName: 'Users',
    FirestoreDeclration.id: 'userId'
  },
  FirestoreCollections.player: {
    FirestoreDeclration.collectionName: 'Players',
    FirestoreDeclration.id: 'userId'
  },
  FirestoreCollections.organizer: {
    FirestoreDeclration.collectionName: 'Organizers',
    FirestoreDeclration.id: 'userId'
  },
  FirestoreCollections.team: {
    FirestoreDeclration.collectionName: 'Teams',
    FirestoreDeclration.id: 'teamId'
  },
  FirestoreCollections.tournament: {
    FirestoreDeclration.collectionName: 'Tournaments',
    FirestoreDeclration.id: 'tournamentId'
  },
  FirestoreCollections.tournamentParticipant: {
    FirestoreDeclration.collectionName: 'TournamentParticipants',
    FirestoreDeclration.id: 'participantId'
  },
  FirestoreCollections.nickname: {
    FirestoreDeclration.collectionName: 'Nicknames',
    FirestoreDeclration.id: 'userId'
  },
  FirestoreCollections.match: {
    FirestoreDeclration.collectionName: 'Matches',
    FirestoreDeclration.id: 'matchId'
  },
  FirestoreCollections.apexMatchResult: {
    FirestoreDeclration.collectionName: 'ApexMatchResults',
    FirestoreDeclration.id: 'resultId'
  },
  FirestoreCollections.valorantMatchResult: {
    FirestoreDeclration.collectionName: 'ValorantMatchResults',
    FirestoreDeclration.id: 'resultId'
  },
  FirestoreCollections.playerStats: {
    FirestoreDeclration.collectionName: 'PlayerStats',
    FirestoreDeclration.id: 'userId'
  },
  FirestoreCollections.invoice: {
    FirestoreDeclration.collectionName: 'Invoices',
    FirestoreDeclration.id: 'invoiceId'
  }
};

//This function is to ensure that all the key value pairs in the data map are valid
//For example in User class, the data map should only contain the following key value pairs:
// {
//   "userId": "123",
//   "country": "country",
//   "address": "address",
//   "email": "email",
//   "name": "name",
//   "password": "password",
//   "role": "role",
// }
// If the data map contains any other key value pairs, it will throw an error
//Also
//This function will return the instance object of the class that is associated with the collection name
//For example, if the collection name is FirestoreCollections.users, it will return an instance of User class
//However the type return is dynamic, not sure whether flutter will trigger the intellisense
dynamic checkCollectionNameAndgetModelData(
    FirestoreCollections collectionName, Map<String, dynamic> data) {
  try {
    switch (collectionName) {
      case FirestoreCollections.users:
        return User.fromJson(data);
      case FirestoreCollections.player:
        return Player.fromJson(data);
      case FirestoreCollections.organizer:
        return Organizer.fromJson(data);
      case FirestoreCollections.team:
        return Team.fromJson(data);
      case FirestoreCollections.tournament:
        return Tournament.fromJson(data);
      case FirestoreCollections.tournamentParticipant:
        return TournamentParticipant.fromJson(data);
      case FirestoreCollections.nickname:
        return Nickname.fromJson(data);
      case FirestoreCollections.match:
        return Match.fromJson(data);
      case FirestoreCollections.apexMatchResult:
        return ApexMatchResult.fromJson(data);
      case FirestoreCollections.valorantMatchResult:
        return ValorantMatchResult.fromJson(data);
      case FirestoreCollections.playerStats:
        return PlayerStats.fromJson(data);
      case FirestoreCollections.invoice:
        return Invoice.fromJson(data);
      default:
        throw ArgumentError('Collection name is not valid');
    }
  } on Exception {
    rethrow;
  }
}
