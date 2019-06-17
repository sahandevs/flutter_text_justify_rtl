import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

var _englishSentenceRegex = new RegExp(r"\b((?!=|\.).)+(.)\b");

class TextJustifyRTL extends StatelessWidget {
  final String text;
  final TextDirection textDirection;
  final TextStyle style;
  final Locale locale;
  final String semanticsLabel;
  final StrutStyle strutStyle;
  final double textScaleFactor;
  final TextWidthBasis textWidthBasis;
  final BoxConstraints boxConstraints;

  const TextJustifyRTL(
    this.text, {
    Key key,
    this.textDirection,
    this.style,
    this.locale,
    this.semanticsLabel,
    this.strutStyle,
    this.textScaleFactor,
    this.textWidthBasis,
    @required this.boxConstraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _createJustifiedText(boxConstraints, style, text);
  }

  Widget _createJustifiedText(
    BoxConstraints size,
    TextStyle style,
    String _text,
  ) {
    // reverse english sentences because it will display them in reverse
    String text = _reverseEnglishSentence(_text);
    // calculate number of words in each line with average char size
    var lines = _calcNumberOfWordsInEachLine(size, style, text);
    // calculate each line remaining space
    List<double> remainingSpace = [];
    for (var line in lines)
      remainingSpace
          .add(size.maxWidth - _calculateStringSize(size, style, line));
    // convert each line words to a Text widget
    List<List<Widget>> lineWidgets = lines
        .map((line) => line.split(" "))
        .map((words) => words.map((word) => _createText(word)).toList())
        .toList();
    // put a space in each word with calculated remaining space
    // and merge all widgets to col and rows
    List<Widget> rows = [];
    for (var i = 0; i < lines.length; i++) {
      rows.add(createRow(lineWidgets[i], remainingSpace[i]));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: rows,
    );
  }

  String _reverseEnglishSentence(String text) {
    List<String> sentences = _englishSentenceRegex
        .allMatches(text)
        .map((match) => match.group(0))
        .toList();
    var result = text;

    for (var sentence in sentences) {
      result =
          result.replaceAll(sentence, sentence.split(" ").reversed.join(" "));
    }
    return result;
  }

  Widget createRow(List<Widget> words, double remainingSpace) {
    Widget _row;
    if (remainingSpace > boxConstraints.maxWidth / 3)
      _row = Row(
        children: joinWidget(words, SizedBox(width: 4)),
      );
    else
      _row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: words,
      );
    return Directionality(textDirection: textDirection, child: _row);
  }

  List<Widget> joinWidget(List<Widget> widgets, Widget widget) {
    List<Widget> _widgets = [];
    for (var i = 0; i < widgets.length; i++) {
      _widgets.add(widgets[i]);
      if (i != widgets.length - 1) _widgets.add(widget);
    }
    return _widgets;
  }

  Text _createText(String text) => Text(
        text,
        strutStyle: strutStyle,
        style: style,
        textScaleFactor: textScaleFactor,
        textDirection: textDirection,
      );

  List<String> _calcNumberOfWordsInEachLine(
      BoxConstraints size, TextStyle style, String text) {
    // TODO: add support for new lines
    var _words = text.replaceAll("\n", " ").split(" ");
    List<List<String>> _lines = [[]];
    var _currentLine = 0;
    // create lines with words
    for (var word in _words) {
      var linesSizeWithWord = _calculateStringSize(
          size, style, (_lines[_currentLine] + [word]).join(" "));
      if (linesSizeWithWord >= size.maxWidth) {
        _currentLine += 1;
        _lines.add([]);
        _lines[_currentLine].add(word);
        continue;
      } else
        _lines[_currentLine].add(word);
    }
    return _lines.map((words) => words.join(" ")).toList();
  }

  double _calculateStringSize(
      BoxConstraints size, TextStyle style, String text) {
    var span = TextSpan(style: style, text: text);
    var tp = TextPainter(
      text: span,
      textAlign: TextAlign.right,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor ?? 1,
      maxLines: 1,
    );
    tp.layout(maxWidth: size.maxWidth);
    return tp.width;
  }
}
