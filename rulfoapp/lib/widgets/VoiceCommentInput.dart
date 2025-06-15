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
  List<stt.LocaleName> _locales = [];
  String _selectedLocaleId = 'es-MX';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: \$status'),
      onError: (error) => print('Error: \$error'),
    );
    if (available) {
      _locales = await _speech.locales();
      print('Idiomas disponibles:');
      for (var locale in _locales) {
        print('\${locale.localeId} - \${locale.name}');
      }
      setState(() {});
    } else {
      print('Speech recognition no está disponible');
    }
  }

  void _startListening() async {
    if (!_speech.isAvailable) {
      print('No se puede iniciar: speech no está disponible');
      return;
    }

    setState(() {
      _isListening = true;
      _text = ""; // limpia el texto al iniciar
    });

    _speech.listen(
      localeId: _selectedLocaleId,
      partialResults: true, // permite resultados parciales en tiempo real
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      onResult: (result) {
        print(
          'Final? \${result.finalResult} - Texto: \${result.recognizedWords}',
        );
        setState(() {
          _text = result.recognizedWords;
        });
        if (result.finalResult) {
          widget.onResult(result.recognizedWords);
        }
      },
    );
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
        DropdownButton<String>(
          value: _selectedLocaleId,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLocaleId = newValue;
              });
            }
          },
          items: _locales.map((locale) {
            return DropdownMenuItem<String>(
              value: locale.localeId,
              child: Text(locale.name),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
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
