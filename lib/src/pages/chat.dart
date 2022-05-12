import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/pages/pagina_invitar_amigos.dart';
import 'package:flutter_unogame/src/pages/partida.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'dart:convert';
import '../pages/home_page.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:async';
import "dart:async";
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

// void main() {
//   initializeDateFormatting().then((_) => runApp(const chat()));
// }

// class chat extends StatelessWidget {
//   const chat({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: ChatPage(),
//     );
//   }
// }

class ChatPage extends StatefulWidget {
  final String autorizacion;
  // final String idPartida;
  ChatPage({Key? key, required this.autorizacion}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  final canalUser = StreamController.broadcast();
  final canalGeneral = StreamController.broadcast();

  // void onConnect(StompFrame frame) {
  //   stompClient.subscribe(
  //       destination: '/user/${widget.nomUser}/msg',
  //       callback: (StompFrame frame) {
  //         if (frame.body != null) {
  //           canalUser.sink.add(json.decode(frame.body!));
  //           print(frame.body);
  //           //canalUser = json.decode(frame.body!);
  //           // canalUser = json.decode(frame.body!);
  //           // print(canalUser);
  //         }
  //       });

  //   stompClient.subscribe(
  //     destination: '/topic/game/chat/{roomId}',
  //     callback: (StompFrame frame) {
  //       if (frame.body != null) {
  //         canalGeneral.sink.add(json.decode(frame.body!));
  //         //print(canalGeneral);
  //         print(frame.body);
  //         //Map<String, dynamic> result = json.decode(frame.body!);
  //         // canalGeneral = json.decode(frame.body!);
  //         // print(canalGeneral);
  //       }
  //     },
  //   );

  //   print("me he suscrito");
  //   // Timer.periodic(Duration(seconds: 10), (_) {
  //   //   stompClient.send(
  //   //       destination: '/game/connect/${widget.idPagina}', body: 'widget.nomUser');
  //   // });
  //   stompClient.send(
  //       destination: '/game/begin/${widget.idPagina}',
  //       body: '',
  //       headers: {
  //         'Authorization': 'Bearer ${widget.autorization}',
  //         'username': widget.nomUser
  //       });
  //   print("lo he mandado");
  // }

  // late StompClient stompClient = StompClient(
  //   config: StompConfig.SockJS(
  //     url: 'https://onep1.herokuapp.com/onep1-game',
  //     onConnect: onConnect,
  //     beforeConnect: () async {
  //       print('waiting to connect...');
  //       await Future.delayed(const Duration(milliseconds: 200));
  //       print('connecting...');
  //     },
  //     stompConnectHeaders: {
  //       'Authorization': 'Bearer ${widget.autorization}',
  //       'username': widget.nomUser
  //     },
  //     webSocketConnectHeaders: {
  //       'Authorization': 'Bearer ${widget.autorization}',
  //       'username': widget.nomUser
  //     },
  //     onWebSocketError: (dynamic error) => print(error.toString()),
  //     onStompError: (dynamic error) => print(error.toString()),
  //     onDisconnect: (f) => print('disconnected'),
  //   ),
  // );

  // @override
  // void initState() {
  //   super.initState();
  //   if (stompClient == null) {
  //     StompFrame frame;
  //     StompClient client = StompClient(
  //         config: StompConfig.SockJS(
  //       url: 'wss://onep1.herokuapp.com/onep1-game',
  //       onConnect: onConnect,
  //       onWebSocketError: (dynamic error) => print(error.toString()),
  //     ));
  //     stompClient.activate();
  //   }
  //   _loadMessages();
  // }


  // @override
  // void initState() {
  //   super.initState();
  //   _loadMessages();
  // }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }


  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    // final response = await rootBundle.loadString('assets/messages.json');
    // final messages = (jsonDecode(response) as List)
    //     .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
    //     .toList();

    // setState(() {
    //   _messages = messages;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        messages: _messages,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }
}