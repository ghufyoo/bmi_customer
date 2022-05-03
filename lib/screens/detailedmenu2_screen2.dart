// ignore_for_file: public_member_api_docs

// FOR MORE EXAMPLES, VISIT THE GITHUB REPOSITORY AT:
//
//  https://github.com/ryanheise/audio_service
//
// This example implements a minimal audio handler that renders the current
// media item and playback state to the system notification and responds to 4
// media actions:
//
// - play
// - pause
// - seek
// - stop
//
// To run this example, use:
//
// flutter run

// import 'dart:async';

// import 'package:audio_service/audio_service.dart';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:rxdart/rxdart.dart';
// import 'dart:math';

// // You might want to provide this using dependency injection rather than a
// // global variable.
// AudioHandler _audioHandler = AudioPlayerHandler();

// Future<void> main() async {
//   _audioHandler = await AudioService.init(
//     builder: () => AudioPlayerHandler(),
//     config: const AudioServiceConfig(
//       androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
//       androidNotificationChannelName: 'Audio playback',
//       androidNotificationOngoing: true,
//     ),
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Audio Service Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatelessWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Audio Service Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Show media item title
//             StreamBuilder<MediaItem?>(
//               stream: _audioHandler.mediaItem,
//               builder: (context, snapshot) {
//                 final mediaItem = snapshot.data;
//                 return Text(mediaItem?.title ?? '');
//               },
//             ),
//             // Play/pause/stop buttons.
//             StreamBuilder<bool>(
//               stream: _audioHandler.playbackState
//                   .map((state) => state.playing)
//                   .distinct(),
//               builder: (context, snapshot) {
//                 final playing = snapshot.data ?? false;
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _button(Icons.fast_rewind, _audioHandler.rewind),
//                     if (playing)
//                       _button(Icons.pause, _audioHandler.pause)
//                     else
//                       _button(Icons.play_arrow, _audioHandler.play),
//                     _button(Icons.stop, _audioHandler.stop),
//                     _button(Icons.fast_forward, _audioHandler.fastForward),
//                   ],
//                 );
//               },
//             ),
//             // A seek bar.
//             StreamBuilder<MediaState>(
//               stream: _mediaStateStream,
//               builder: (context, snapshot) {
//                 final mediaState = snapshot.data;
//                 return SeekBar(
//                   duration: mediaState?.mediaItem?.duration ?? Duration.zero,
//                   position: mediaState?.position ?? Duration.zero,
//                   onChangeEnd: (newPosition) {
//                     _audioHandler.seek(newPosition);
//                   },
//                 );
//               },
//             ),
//             // Display the processing state.
//             StreamBuilder<AudioProcessingState>(
//               stream: _audioHandler.playbackState
//                   .map((state) => state.processingState)
//                   .distinct(),
//               builder: (context, snapshot) {
//                 final processingState =
//                     snapshot.data ?? AudioProcessingState.idle;
//                 return Text(
//                     "Processing state: ${describeEnum(processingState)}");
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// A stream reporting the combined state of the current media item and its
//   /// current position.
//   Stream<MediaState> get _mediaStateStream =>
//       Rx.combineLatest2<MediaItem?, Duration, MediaState>(
//           _audioHandler.mediaItem,
//           AudioService.position,
//           (mediaItem, position) => MediaState(mediaItem, position));

//   IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
//         icon: Icon(iconData),
//         iconSize: 64.0,
//         onPressed: onPressed,
//       );
// }

// class MediaState {
//   final MediaItem? mediaItem;
//   final Duration position;

//   MediaState(this.mediaItem, this.position);
// }

// /// An [AudioHandler] for playing a single item.
// class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
//   static final _item = MediaItem(
//     id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
//     album: "Science Friday",
//     title: "A Salute To Head-Scratching Science",
//     artist: "Science Friday and WNYC Studios",
//     duration: const Duration(milliseconds: 5739820),
//     artUri: Uri.parse(
//         'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
//   );

//   final _player = AudioPlayer();

//   /// Initialise our audio handler.
//   AudioPlayerHandler() {
//     // So that our clients (the Flutter UI and the system notification) know
//     // what state to display, here we set up our audio handler to broadcast all
//     // playback state changes as they happen via playbackState...
//     _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
//     // ... and also the current media item via mediaItem.
//     mediaItem.add(_item);

//     // Load the player.
//     _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
//   }

//   // In this simple example, we handle only 4 actions: play, pause, seek and
//   // stop. Any button press from the Flutter UI, notification, lock screen or
//   // headset will be routed through to these 4 methods so that you can handle
//   // your audio playback logic in one place.

//   @override
//   Future<void> play() => _player.play();

//   @override
//   Future<void> pause() => _player.pause();

//   @override
//   Future<void> seek(Duration position) => _player.seek(position);

//   @override
//   Future<void> stop() => _player.stop();

//   /// Transform a just_audio event into an audio_service state.
//   ///
//   /// This method is used from the constructor. Every event received from the
//   /// just_audio player will be transformed into an audio_service state so that
//   /// it can be broadcast to audio_service clients.
//   PlaybackState _transformEvent(PlaybackEvent event) {
//     return PlaybackState(
//       controls: [
//         MediaControl.rewind,
//         if (_player.playing) MediaControl.pause else MediaControl.play,
//         MediaControl.stop,
//         MediaControl.fastForward,
//       ],
//       systemActions: const {
//         MediaAction.seek,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       },
//       androidCompactActionIndices: const [0, 1, 3],
//       processingState: const {
//         ProcessingState.idle: AudioProcessingState.idle,
//         ProcessingState.loading: AudioProcessingState.loading,
//         ProcessingState.buffering: AudioProcessingState.buffering,
//         ProcessingState.ready: AudioProcessingState.ready,
//         ProcessingState.completed: AudioProcessingState.completed,
//       }[_player.processingState]!,
//       playing: _player.playing,
//       updatePosition: _player.position,
//       bufferedPosition: _player.bufferedPosition,
//       speed: _player.speed,
//       queueIndex: event.currentIndex,
//     );
//   }
// }

// class PositionData {
//   final Duration position;
//   final Duration bufferedPosition;
//   final Duration duration;

//   PositionData(this.position, this.bufferedPosition, this.duration);
// }

// class SeekBar extends StatefulWidget {
//   final Duration duration;
//   final Duration position;
//   final Duration bufferedPosition;
//   final ValueChanged<Duration>? onChanged;
//   final ValueChanged<Duration>? onChangeEnd;

//   const SeekBar({
//     Key? key,
//     required this.duration,
//     required this.position,
//     this.bufferedPosition = Duration.zero,
//     this.onChanged,
//     this.onChangeEnd,
//   }) : super(key: key);

//   @override
//   _SeekBarState createState() => _SeekBarState();
// }

// class _SeekBarState extends State<SeekBar> {
//   double? _dragValue;
//   bool _dragging = false;
//   late SliderThemeData _sliderThemeData;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     _sliderThemeData = SliderTheme.of(context).copyWith(
//       trackHeight: 2.0,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final value = min(
//       _dragValue ?? widget.position.inMilliseconds.toDouble(),
//       widget.duration.inMilliseconds.toDouble(),
//     );
//     if (_dragValue != null && !_dragging) {
//       _dragValue = null;
//     }
//     return Stack(
//       children: [
//         SliderTheme(
//           data: _sliderThemeData.copyWith(
//             thumbShape: HiddenThumbComponentShape(),
//             activeTrackColor: Colors.blue.shade100,
//             inactiveTrackColor: Colors.grey.shade300,
//           ),
//           child: ExcludeSemantics(
//             child: Slider(
//               min: 0.0,
//               max: widget.duration.inMilliseconds.toDouble(),
//               value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
//                   widget.duration.inMilliseconds.toDouble()),
//               onChanged: (value) {},
//             ),
//           ),
//         ),
//         SliderTheme(
//           data: _sliderThemeData.copyWith(
//             inactiveTrackColor: Colors.transparent,
//           ),
//           child: Slider(
//             min: 0.0,
//             max: widget.duration.inMilliseconds.toDouble(),
//             value: value,
//             onChanged: (value) {
//               if (!_dragging) {
//                 _dragging = true;
//               }
//               setState(() {
//                 _dragValue = value;
//               });
//               if (widget.onChanged != null) {
//                 widget.onChanged!(Duration(milliseconds: value.round()));
//               }
//             },
//             onChangeEnd: (value) {
//               if (widget.onChangeEnd != null) {
//                 widget.onChangeEnd!(Duration(milliseconds: value.round()));
//               }
//               _dragging = false;
//             },
//           ),
//         ),
//         Positioned(
//           right: 16.0,
//           bottom: 0.0,
//           child: Text(
//               RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
//                       .firstMatch("$_remaining")
//                       ?.group(1) ??
//                   '$_remaining',
//               style: Theme.of(context).textTheme.caption),
//         ),
//       ],
//     );
//   }

//   Duration get _remaining => widget.duration - widget.position;
// }

// class HiddenThumbComponentShape extends SliderComponentShape {
//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   }) {}
// }

// class LoggingAudioHandler extends CompositeAudioHandler {
//   LoggingAudioHandler(AudioHandler inner) : super(inner) {
//     playbackState.listen((state) {
//       _log('playbackState changed: $state');
//     });
//     queue.listen((queue) {
//       _log('queue changed: $queue');
//     });
//     queueTitle.listen((queueTitle) {
//       _log('queueTitle changed: $queueTitle');
//     });
//     mediaItem.listen((mediaItem) {
//       _log('mediaItem changed: $mediaItem');
//     });
//     ratingStyle.listen((ratingStyle) {
//       _log('ratingStyle changed: $ratingStyle');
//     });
//     androidPlaybackInfo.listen((androidPlaybackInfo) {
//       _log('androidPlaybackInfo changed: $androidPlaybackInfo');
//     });
//     customEvent.listen((dynamic customEventStream) {
//       _log('customEvent changed: $customEventStream');
//     });
//     customState.listen((dynamic customState) {
//       _log('customState changed: $customState');
//     });
//   }

//  
//   // ignore: avoid_print
//   void _log(String s) => print('----- LOG: $s');

//   @override
//   Future<void> prepare() {
//     _log('prepare()');
//     return super.prepare();
//   }

//   @override
//   Future<void> prepareFromMediaId(String mediaId,
//       [Map<String, dynamic>? extras]) {
//     _log('prepareFromMediaId($mediaId, $extras)');
//     return super.prepareFromMediaId(mediaId, extras);
//   }

//   @override
//   Future<void> prepareFromSearch(String query, [Map<String, dynamic>? extras]) {
//     _log('prepareFromSearch($query, $extras)');
//     return super.prepareFromSearch(query, extras);
//   }

//   @override
//   Future<void> prepareFromUri(Uri uri, [Map<String, dynamic>? extras]) {
//     _log('prepareFromSearch($uri, $extras)');
//     return super.prepareFromUri(uri, extras);
//   }

//   @override
//   Future<void> play() {
//     _log('play()');
//     return super.play();
//   }

//   @override
//   Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]) {
//     _log('playFromMediaId($mediaId, $extras)');
//     return super.playFromMediaId(mediaId, extras);
//   }

//   @override
//   Future<void> playFromSearch(String query, [Map<String, dynamic>? extras]) {
//     _log('playFromSearch($query, $extras)');
//     return super.playFromSearch(query, extras);
//   }

//   @override
//   Future<void> playFromUri(Uri uri, [Map<String, dynamic>? extras]) {
//     _log('playFromUri($uri, $extras)');
//     return super.playFromUri(uri, extras);
//   }

//   @override
//   Future<void> playMediaItem(MediaItem mediaItem) {
//     _log('playMediaItem($mediaItem)');
//     return super.playMediaItem(mediaItem);
//   }

//   @override
//   Future<void> pause() {
//     _log('pause()');
//     return super.pause();
//   }

//   @override
//   Future<void> click([MediaButton button = MediaButton.media]) {
//     _log('click($button)');
//     return super.click(button);
//   }

//   @override
//   Future<void> stop() {
//     _log('stop()');
//     return super.stop();
//   }

//   @override
//   Future<void> addQueueItem(MediaItem mediaItem) {
//     _log('addQueueItem($mediaItem)');
//     return super.addQueueItem(mediaItem);
//   }

//   @override
//   Future<void> addQueueItems(List<MediaItem> mediaItems) {
//     _log('addQueueItems($mediaItems)');
//     return super.addQueueItems(mediaItems);
//   }

//   @override
//   Future<void> insertQueueItem(int index, MediaItem mediaItem) {
//     _log('insertQueueItem($index, $mediaItem)');
//     return super.insertQueueItem(index, mediaItem);
//   }

//   @override
//   Future<void> updateQueue(List<MediaItem> queue) {
//     _log('updateQueue($queue)');
//     return super.updateQueue(queue);
//   }

//   @override
//   Future<void> updateMediaItem(MediaItem mediaItem) {
//     _log('updateMediaItem($mediaItem)');
//     return super.updateMediaItem(mediaItem);
//   }

//   @override
//   Future<void> removeQueueItem(MediaItem mediaItem) {
//     _log('removeQueueItem($mediaItem)');
//     return super.removeQueueItem(mediaItem);
//   }

//   @override
//   Future<void> removeQueueItemAt(int index) {
//     _log('removeQueueItemAt($index)');
//     return super.removeQueueItemAt(index);
//   }

//   @override
//   Future<void> skipToNext() {
//     _log('skipToNext()');
//     return super.skipToNext();
//   }

//   @override
//   Future<void> skipToPrevious() {
//     _log('skipToPrevious()');
//     return super.skipToPrevious();
//   }

//   @override
//   Future<void> fastForward() {
//     _log('fastForward()');
//     return super.fastForward();
//   }

//   @override
//   Future<void> rewind() {
//     _log('rewind()');
//     return super.rewind();
//   }

//   @override
//   Future<void> skipToQueueItem(int index) {
//     _log('skipToQueueItem($index)');
//     return super.skipToQueueItem(index);
//   }

//   @override
//   Future<void> seek(Duration position) {
//     _log('seek($position)');
//     return super.seek(position);
//   }

//   @override
//   Future<void> setRating(Rating rating, [Map<String, dynamic>? extras]) {
//     _log('setRating($rating, $extras)');
//     return super.setRating(rating, extras);
//   }

//   @override
//   Future<void> setCaptioningEnabled(bool enabled) {
//     _log('setCaptioningEnabled($enabled)');
//     return super.setCaptioningEnabled(enabled);
//   }

//   @override
//   Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) {
//     _log('setRepeatMode($repeatMode)');
//     return super.setRepeatMode(repeatMode);
//   }

//   @override
//   Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) {
//     _log('setShuffleMode($shuffleMode)');
//     return super.setShuffleMode(shuffleMode);
//   }

//   @override
//   Future<void> seekBackward(bool begin) {
//     _log('seekBackward($begin)');
//     return super.seekBackward(begin);
//   }

//   @override
//   Future<void> seekForward(bool begin) {
//     _log('seekForward($begin)');
//     return super.seekForward(begin);
//   }

//   @override
//   Future<void> setSpeed(double speed) {
//     _log('setSpeed($speed)');
//     return super.setSpeed(speed);
//   }

//   @override
//   Future<dynamic> customAction(String name,
//       [Map<String, dynamic>? extras]) async {
//     _log('customAction($name, extras)');
//     final dynamic result = await super.customAction(name, extras);
//     _log('customAction -> $result');
//     return result;
//   }

//   @override
//   Future<void> onTaskRemoved() {
//     _log('onTaskRemoved()');
//     return super.onTaskRemoved();
//   }

//   @override
//   Future<void> onNotificationDeleted() {
//     _log('onNotificationDeleted()');
//     return super.onNotificationDeleted();
//   }

//   @override
//   Future<List<MediaItem>> getChildren(String parentMediaId,
//       [Map<String, dynamic>? options]) async {
//     _log('getChildren($parentMediaId, $options)');
//     final result = await super.getChildren(parentMediaId, options);
//     _log('getChildren -> $result');
//     return result;
//   }

//   @override
//   ValueStream<Map<String, dynamic>> subscribeToChildren(String parentMediaId) {
//     _log('subscribeToChildren($parentMediaId)');
//     final result = super.subscribeToChildren(parentMediaId);
//     result.listen((options) {
//       _log('$parentMediaId children changed with options $options');
//     });
//     return result;
//   }

//   @override
//   Future<MediaItem?> getMediaItem(String mediaId) async {
//     _log('getMediaItem($mediaId)');
//     final result = await super.getMediaItem(mediaId);
//     _log('getMediaItem -> $result');
//     return result;
//   }

//   @override
//   Future<List<MediaItem>> search(String query,
//       [Map<String, dynamic>? extras]) async {
//     _log('search($query, $extras)');
//     final result = await super.search(query, extras);
//     _log('search -> $result');
//     return result;
//   }

//   @override
//   Future<void> androidSetRemoteVolume(int volumeIndex) {
//     _log('androidSetRemoteVolume($volumeIndex)');
//     return super.androidSetRemoteVolume(volumeIndex);
//   }

//   @override
//   Future<void> androidAdjustRemoteVolume(AndroidVolumeDirection direction) {
//     _log('androidAdjustRemoteVolume($direction)');
//     return super.androidAdjustRemoteVolume(direction);
//   }
// }

// void showSliderDialog({
//   required BuildContext context,
//   required String title,
//   required int divisions,
//   required double min,
//   required double max,
//   String valueSuffix = '',
//   
//   required double value,
//   required Stream<double> stream,
//   required ValueChanged<double> onChanged,
// }) {
//   showDialog<void>(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text(title, textAlign: TextAlign.center),
//       content: StreamBuilder<double>(
//         stream: stream,
//         builder: (context, snapshot) => SizedBox(
//           height: 100.0,
//           child: Column(
//             children: [
//               Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
//                   style: const TextStyle(
//                       fontFamily: 'Fixed',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24.0)),
//               Slider(
//                 divisions: divisions,
//                 min: min,
//                 max: max,
//                 value: snapshot.data ?? value,
//                 onChanged: onChanged,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }


// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Animation',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PushNotificationApp(),
//     );
//   }
// }

// /// Entry point for the example application.
// class PushNotificationApp extends StatefulWidget {
//   static const routeName = "/firebase-push";

//   @override
//   _PushNotificationAppState createState() => _PushNotificationAppState();
// }

// class _PushNotificationAppState extends State<PushNotificationApp> {
//   @override
//   void initState() {
//     getPermission();
//     messageListener(context);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       // Initialize FlutterFire
//       future: Firebase.initializeApp(),
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.hasError) {
//           return Center(
//             child: Text(snapshot.error.toString()),
//           );
//         }
//         // Once complete, show your application
//         if (snapshot.connectionState == ConnectionState.done) {
//           print('android firebase initiated');
//           return NotificationPage();
//         }
//         // Otherwise, show something whilst waiting for initialization to complete
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }

//   Future<void> getPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     print('User granted permission: ${settings.authorizationStatus}');
//   }

//   void messageListener(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');

//       if (message.notification != null) {
//         print(
//             'Message also contained a notification: ${message.notification!.body}');
//         showDialog(
//             context: context,
//             builder: ((BuildContext context) {
//               return DynamicDialog(
//                   title: message.notification!.title,
//                   body: message.notification!.body);
//             }));
//       }
//     });
//   }
// }

// class NotificationPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _Application();
// }

// class _Application extends State<NotificationPage> {
//   String? _token ;
//   Stream<String>? _tokenStream;
//   int notificationCount = 0;

//   FutureOr setToken(String? token) {
//     print('FCM TokenToken: $token');
//     setState(() {
//       _token = token;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     //get token
//     FirebaseMessaging.instance.getToken().then(setToken);
//     _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
//     _tokenStream!.listen(setToken);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Firebase push notification'),
//         ),
//         body: Container(
//           child: Center(
//             child: Card(
//               margin: EdgeInsets.all(10),
//               elevation: 10,
//               child: ListTile(
//                 title: Center(
//                   child: OutlinedButton.icon(
//                     label: Text('Push Notification',
//                         style: TextStyle(
//                             color: Colors.blueAccent,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16)),
//                     onPressed: () {
//                       sendPushMessageToWeb();
//                     }, icon: Icon(Icons.notifications),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }

//   //send notification
//   sendPushMessageToWeb() async {
//     if (_token == null) {
//       print('Unable to send FCM message, no token exists.');
//       return;
//     }
//     try {
//       await http
//           .post(
//             Uri.parse('https://fcm.googleapis.com/fcm/send'),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization':
//                   'key=YOUR SERVER KEY'
//             },
//             body: json.encode({
//               'to': _token,
//               'message': {
//                 'token': _token,
//               },
//               "notification": {
//                 "title": "Push Notification",
//                 "body": "Firebase  push notification"
//               }
//             }),
//           )
//           .then((value) => print(value.body));
//       print('FCM request for web sent!');
//     } catch (e) {
//       print(e);
//     }
//   }
// }

// //push notification dialog for foreground
// class DynamicDialog extends StatefulWidget {
//   final title;
//   final body;
//   DynamicDialog({this.title, this.body});
//   @override
//   _DynamicDialogState createState() => _DynamicDialogState();
// }

// class _DynamicDialogState extends State<DynamicDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.title),
//       actions: <Widget>[
//         OutlinedButton.icon(
//             label: Text('Close'),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.close))
//       ],
//       content: Text(widget.body),
//     );
//   }
// }