// import 'package:pusher_client/pusher_client.dart';
//
// import '../../../../utility/database/local/cache_helper.dart';
//
// class PusherHelper {
//   late PusherClient pusher;
//
//   PusherHelper._();
//
//   // single Tone
//   static PusherHelper pusherHelper = PusherHelper._();
//   Channel? channel;
//   Channel? channel2;
//   Channel? channel3;
//
//   Future<void> getPusherInit() async {
//     PusherOptions options = PusherOptions(
//       auth: PusherAuth(
//         'https://refactored-value-api.valuclean.co/api/broadcasting/auth',
//         headers: {
//           'Authorization': 'Bearer ${CacheHelper.getDataString(key: 'token')}',
//           // 'Content-Type': 'application/json',
//         },
//       ),
//       host: 'https://refactored-value-api.valuclean.co',
//       cluster: 'eu',
//       encrypted: true,
//     );
//     pusher = PusherClient('ca9a6c5505a76f88720c', options,
//         enableLogging: true, autoConnect: true);
//     await pusher.connect();
//
//     pusher.onConnectionStateChange((state) {
//       print(state!.currentState);
//     });
//
//     pusher.onConnectionError((error) {
//       // ignore: avoid_print
//       print("error: ${error!.message}");
//     });
//   }
//
//   Future<void> subscribe(String channelName) async {
//     channel = pusher.subscribe(channelName);
//   }
//
//   Future<void> subscribe2(String name) async {
//     channel2 = pusher.subscribe(name);
//   }
//
//   Future<void> subscribe3(String name) async {
//     channel3 = pusher.subscribe(name);
//   }
//
//   void bind2(String eventName, void Function(PusherEvent? event) onEvent) {
//     channel2!.bind(eventName, onEvent);
//   }
//
//   void bind3(String eventName, void Function(PusherEvent? event) onEvent) {
//     channel3!.bind(eventName, onEvent);
//   }
//
//   void bind(String eventName, void Function(PusherEvent? event) onEvent) {
//     channel!.bind(eventName, onEvent);
//   }
//
//   void disconnect() {
//     pusher.disconnect();
//   }
// }
