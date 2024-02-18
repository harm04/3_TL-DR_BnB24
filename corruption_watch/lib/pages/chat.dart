// ignore_for_file: unnecessary_new

import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';
import 'package:http/http.dart' as http;


class ChatPage extends StatefulWidget {
   final String title;
    final String ministry;
  const ChatPage({super.key, required this.title, required this.ministry});

 

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? myUser;
  String? targetUser;
  List<String> users = [];
  IOWebSocketChannel? ws;
  final List<String> messages = [];
  bool hasSetInfo = false;
  PreKeyBundle? preKeyBundle;
  final Map<String, String> textFieldValues = {
    "myUser": "",
    "targetUser": "",
    "message": ""
  };

  // Stores
  var preKeyStore = InMemoryPreKeyStore();
  var signedPreKeyStore = InMemorySignedPreKeyStore();
  var sessionStore = InMemorySessionStore();
  var identityKeyStore;

  @override
  void initState() {
    super.initState();
  }

  void connectToServer() async {
    WebSocket.connect("ws://localhost:3000", headers: {
      "authorization": myUser,
    }).then((ws) {
      setState(() {
        this.ws = IOWebSocketChannel(ws);
      });

      this.ws?.stream.listen((params) {
        processSocketMessageFromServer(params);
      });
    });
  }

  processSocketMessageFromServer(params) async {
    final jsonParams = jsonDecode(params);

    if (jsonParams["event"] == "users") {
      setState(() {
        users = List<String>.from(jsonParams["data"]);
      });
    } else if (jsonParams["event"] == "message") {
      final info = await getUserInfo(jsonParams["data"]["userId"]);

      var signalProtocolStore =
          InMemorySignalProtocolStore(info.identityKey, info.registrationId);
      var aliceAddress =
          SignalProtocolAddress(jsonParams["data"]["userId"], info.deviceId);
      var remoteSessionCipher =
          SessionCipher.fromStore(signalProtocolStore, aliceAddress);

      signalProtocolStore.storePreKey(info.preKey.id, info.preKey);

      signalProtocolStore.storeSignedPreKey(
          info.signedPreKey.id, info.signedPreKey);

      final messageBytes = await remoteSessionCipher.decrypt(PreKeySignalMessage(
          Uint8List.fromList(jsonParams["data"]["message"].cast<int>())));

      final message = utf8.decode(List.from(messageBytes));

      setState(() {
        messages.add(message);
      });
    }
  }

  void setMyUserInfo() {
    var registrationId = generateRegistrationId(false);

    // Keys
    var identityKey = generateIdentityKeyPair(); // Long term key
    var signedPreKey =
        generateSignedPreKey(identityKey, 0); // Medium term key
    var preKeys = generatePreKeys(0, 110); // One time key

    // Store keys
    for (var p in preKeys) {
      preKeyStore.storePreKey(p.id, p);
    }
    signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);

    identityKeyStore = InMemoryIdentityKeyStore(identityKey, registrationId);

    final userInfo = UserInfo(
      registrationId,
      1,
      identityKey,
      signedPreKey,
      preKeys[0],
    );

    ws!.sink.add(jsonEncode({
          "event": "set_info",
          "data": userInfo.toMap(),
        }));

    setState(() {
      hasSetInfo = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Builder(builder: (context) {
                if (myUser == null) {
                  return Column(children: [
                    const Text('Insert your name:'),
                    TextField(
                      onChanged: (val) {
                        textFieldValues["myUser"] = val;
                      },
                    ),
                    MaterialButton(
                      key: const Key('myUserInput'),
                      child: const Text('Set my name'),
                      onPressed: () {
                        setState(() {
                          myUser = textFieldValues["myUser"];
                        });
                      },
                    ),
                  ]);
                }

                if (targetUser == null) {
                  return Column(children: [
                    const Text('Insert target name:'),
                    TextField(
                      key: const Key('targetUserInput'),
                      onChanged: (val) {
                        textFieldValues["targetUser"] = val;
                      },
                    ),
                    MaterialButton(
                      child: const Text('Set target name'),
                      onPressed: () {
                        setState(() {
                          targetUser = textFieldValues["targetUser"];
                        });
                      },
                    ),
                  ]);
                }

                if (ws == null) {
                  return MaterialButton(
                    child: Text('Connect as "$myUser"'),
                    onPressed: () {
                      connectToServer();
                    },
                  );
                }

                if (hasSetInfo == false)
                  return Column(
                    children: [
                      MaterialButton(
                        child: const Text('Set your bundle and info'),
                        onPressed: () {
                          setMyUserInfo();
                        },
                      )
                    ],
                  );

                if (hasSetInfo) {
                  return Column(
                    children: [
                      Text('Using $myUser'),
                      Column(children: [
                        const Text('Messages:'),
                        ...messages.map((u) => Text(u)),
                      ]),
                      TextField(
                        onChanged: (val) {
                          textFieldValues["message"] = val;
                        },
                      ),
                      MaterialButton(
                        child: Text('Send message to $targetUser'),
                        onPressed: () {
                          sendMessage();
                        },
                      ),
                    ],
                  );
                }

                return Container();
              })
            ],
          ),
        ));
  }

  void sendMessage() async {
    final userInfo = await getUserInfo(myUser!);
    final bundle = PreKeyBundle(
      userInfo.registrationId,
      userInfo.deviceId,
      userInfo.preKey.id,
      userInfo.preKey.getKeyPair().publicKey,
      userInfo.signedPreKey.id,
      userInfo.signedPreKey.getKeyPair().publicKey,
      userInfo.signedPreKey.signature,
      userInfo.identityKey.getPublicKey(),
    );

    setState(() {
      preKeyBundle = bundle;
    });

    var targetAddress = SignalProtocolAddress(targetUser!, 1);
    var sessionBuilder = SessionBuilder(sessionStore, preKeyStore,
        signedPreKeyStore, identityKeyStore, targetAddress);

    sessionBuilder.processPreKeyBundle(bundle);

    var sessionCipher = SessionCipher(sessionStore, preKeyStore,
        signedPreKeyStore, identityKeyStore, targetAddress);
    var ciphertext = await sessionCipher.encrypt(
        Uint8List.fromList(utf8.encode(textFieldValues["message"]!)));

    final message = ciphertext.serialize(); 

    ws!.sink.add(jsonEncode({
          "event": "message",
          "data": {
            "userId": targetUser,
            "deviceId": 1,
            "message": message,
          }
        }));
  }

  Future<UserInfo> getUserInfo(String user) async {
    final client = new http.Client();

    final response =
        await client.get(Uri.parse('http://localhost:3000/keys/$user'));

    final json = jsonDecode(response.body);

    return UserInfo.fromMap(json);
  }
}

class UserInfo {
  final int registrationId;
  final int deviceId;
  final IdentityKeyPair identityKey;
  final SignedPreKeyRecord signedPreKey;
  final PreKeyRecord preKey;

  UserInfo(this.registrationId, this.deviceId, this.identityKey,
      this.signedPreKey, this.preKey);

  Map<String, dynamic> toMap() {
    return {
      "registrationId": registrationId,
      "deviceId": deviceId,
      "bundle": {
        "identityKey": identityKey.serialize(),
        "signedPreKey": signedPreKey.serialize(),
        "preKey": preKey.serialize(),
      }
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> json) {
    return UserInfo(
      json["registrationId"],
      json["deviceId"],
      IdentityKeyPair.fromSerialized(
          Uint8List.fromList(json["bundle"]["identityKey"].cast<int>())),
      SignedPreKeyRecord.fromSerialized(
          Uint8List.fromList(json["bundle"]["signedPreKey"].cast<int>())),
      PreKeyRecord.fromBuffer(
          Uint8List.fromList(json["bundle"]["preKey"].cast<int>())),
    );
  }
}