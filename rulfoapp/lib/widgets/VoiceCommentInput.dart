import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceCommentInput extends StatefulWidget {
  final Function(String) onResult;

  const VoiceCommentInput({super.key, required this.onResult});

  @override
  State<VoiceCommentInput> createState() => _VoiceCommentInputState();
}

class _VoiceCommentInputState extends State<VoiceCommentInput> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Mantén presionado para grabar";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    widget.onResult(_text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_text),
        const SizedBox(height: 16),
        GestureDetector(
          onLongPress: _startListening,
          onLongPressUp: _stopListening,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: _isListening ? Colors.red : Colors.grey,
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
