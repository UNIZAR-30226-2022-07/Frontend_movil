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
  // final String idPagina;
  // final String nomUser;
  // ChatPage({Key? key, required this.autorizacion,required this.idPagina, required this.nomUser}) : super(key: key);
  ChatPage({Key? key, required this.autorizacion}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String mensaje = '';
  String r ='';
  List<String> respuesta = [];
  List<types.Message> _messages = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  final canalGeneral = StreamController.broadcast();

  void onConnect(StompFrame frame) {
    stompClient.subscribe(
        destination: '/topic/chat/36e34003-6de6-4a34-8b08-87d3f598d534',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            r = frame.body!;
            canalGeneral.sink.add(json.decode(frame.body!));
            print(frame.body);
          }
        }
    );

    print("me he suscrito");
    
  }

  late StompClient stompClient = StompClient(
    config: StompConfig.SockJS(
      url: 'https://onep1.herokuapp.com/onep1-game',
      onConnect: onConnect,
      beforeConnect: () async {
        print('waiting to connect...');
        await Future.delayed(const Duration(milliseconds: 200));
        print('connecting...');
      },
      stompConnectHeaders: {
        'Authorization': 'Bearer ${widget.autorizacion}',
        'username': 'paulae'
      },
      webSocketConnectHeaders: {
        'Authorization': 'Bearer ${widget.autorizacion}',
        'username': 'paulae'
      },
      onWebSocketError: (dynamic error) => print(error.toString()),
      onStompError: (dynamic error) => print(error.toString()),
      onDisconnect: (f) => print('disconnected'),
    ),
  );

  @override
  void initState() {
    super.initState();
    if (stompClient == null) {
      StompFrame frame;
      StompClient client = StompClient(
          config: StompConfig.SockJS(
        url: 'wss://onep1.herokuapp.com/onep1-game',
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ));
       stompClient.activate();
    }
    _loadMessages();
  }


  // @override
  // void initState() {
  //   super.initState();
  //   _loadMessages();
  // }

  //para mostrar el mensaje en la interfaz
  void _addMessage(types.Message message) {
    setState(() {
      stompClient.activate();
      _messages.insert(0, message);
    });
  }


  // void _handleMessageTap(BuildContext context, types.Message message) async {
  //   if (message is types.FileMessage) {
  //     await OpenFile.open(message.uri);
  //   }
  // }

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
    mensaje = message.text;
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    // initState();
    // stompClient.activate();
    //enviar mensaje aqui por el socket
    _addMessage(textMessage);
    stompClient.send(
        destination: '/game/message/36e34003-6de6-4a34-8b08-87d3f598d534',
        body: mensaje,
        headers: {
          'Authorization': 'Bearer ${widget.autorizacion}',
          'username': 'paulae'
        });
    print("lo he mandado");
    // stompClient.activate();
    print(mensaje);
  }

  void _loadMessages() {
    // // respuesta = jsonDecode(r); //en respuesta ya esta la respuesta de backend en formato de lista
    // // aqi la funcio de recibir mensajes del socket
    // // final response = await rootBundle.loadString('assets/messages.json');
    // final messages = (jsonDecode(r) as List)
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
        // onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }
}