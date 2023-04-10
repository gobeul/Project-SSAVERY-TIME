import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:ssafytime/controllers/councel_controller.dart';
import 'package:ssafytime/utils/call_signaling.dart';

class CallCounsel extends StatefulWidget {
  const CallCounsel(
      {Key? key, required this.sessionName, required this.userName, required this.rezIdx})
      : super(key: key);

  final String sessionName;
  final String userName;
  final int rezIdx;
  final String server = "i8a602.p.ssafy.io";
  final String secret = "ssafytime";

  @override
  _CallCounselState createState() => _CallCounselState();
}

class _CallCounselState extends State<CallCounsel> {
  final _localRenderer = new RTCVideoRenderer();
  final _remoteRenderer = new RTCVideoRenderer();
  CallSignaling? _signaling = null;
  bool isAudioOn = true;

  MyCouncelController councelController = Get.find<MyCouncelController>();

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  @override
  void dispose() {
    super.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _signaling?.close();
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    _connect();
  }

  Future<void> _connect() async {
    if (_signaling == null) {
      _signaling = new CallSignaling(
          url: widget.server,
          secret: widget.secret,
          sessionId: widget.sessionName,
          userName: widget.userName);

      final String? token = await _signaling?.createWebRtcToken();


      if (token != null) {
        await _signaling!.connect(token);

        _signaling?.onStateChange = (SignalingState state) {
          print('_signaling.onStateChange: $state');
          switch (state) {
            case SignalingState.CallStateNew:
              break;
            case SignalingState.CallStateBye:
              break;
            default:
              break;
          }
        };

        _signaling?.onLocalStream = ((stream) {
          setState(() {
            _localRenderer.srcObject = stream;
          });
        });

        _signaling?.onAddRemoteStream = ((stream) {
          setState(() {
            _remoteRenderer.srcObject = stream;
          });
        });

        _signaling?.onRemoveRemoteStream = ((stream) {
          setState(() {
            _remoteRenderer.srcObject = null;
          });
        });
      } else {
        _signaling?.close();
        councelController.endCouncel(widget.rezIdx); // 상담 끌때 종료 요청
        Get.back();
      }
    }
  }

  void _hangUp() {
    councelController.endCouncel(widget.rezIdx); // 상담 끌때 종료 요청
    Get.back();
  }

  void _switchCamera() {
    _signaling!.switchCamera();
  }

  void _muteMic() {
    setState(() {
      isAudioOn = _signaling!.muteMic(isAudioOn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return new Container(
          child: new Stack(children: <Widget>[
            new Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: new Container(
                  margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: new RTCVideoView(_remoteRenderer),
                  decoration: new BoxDecoration(color: Colors.black54),
                )),
            new Positioned(
              left: 20.0,
              top: 40.0,
              child: new Container(
                width: orientation == Orientation.portrait ? 90.0 : 120.0,
                height: orientation == Orientation.portrait ? 120.0 : 90.0,
                child: new RTCVideoView(_localRenderer),
                decoration: new BoxDecoration(color: Colors.black54),
              ),
            ),
          ]),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new SizedBox(
        // width: 200.0,
        width: MediaQuery.of(context).size.width * ( 200 / 392.7),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              child: const Icon(Icons.switch_camera),
              onPressed: _switchCamera,
              heroTag: "btn_switchCamera",
            ),
            FloatingActionButton(
              onPressed: _hangUp,
              heroTag: "btn_hangUp",
              tooltip: 'Hangup',
              child: new Icon(Icons.call_end),
              backgroundColor: Colors.pink,
            ),
            FloatingActionButton(
              child: isAudioOn
                  ? const Icon(Icons.mic_outlined)
                  : const Icon(Icons.mic_off),
              onPressed: _muteMic,
              heroTag: "btn_muteMic",
            )
          ],
        ),
      ),
    );
  }
}
