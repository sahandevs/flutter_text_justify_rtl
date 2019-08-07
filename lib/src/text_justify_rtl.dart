import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

var _matchEnglishAndNumbers = new RegExp(r"\b(\w*[a-zA-Z0-9]\w*)\b");
var _matchEnglishSentence = new RegExp(r"\b((?!=|\,|\.)[a-zA-Z\s])+(.)\b");

class TextJustifyRTL extends StatefulWidget {
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
  _TextJustifyRTLState createState() => _TextJustifyRTLState();
}

class _TextJustifyRTLState extends State<TextJustifyRTL>
    with AutomaticKeepAliveClientMixin {
  Widget _widget;

  @override
  void didUpdateWidget(TextJustifyRTL oldWidget) {
    if (oldWidget.text != widget.text)
      setState(() {
        _widget = null;
      });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_widget == null)
      _widget = _createJustifiedText(
          widget.boxConstraints, widget.style, widget.text);
    return _widget;
  }

  Widget _createJustifiedText(
    BoxConstraints size,
    TextStyle style,
    String _text,
  ) {
    // reverse english sentences because it will display them in reverse
    String text = _reverseNumbersAndEnglishWords(_text);
    // calculate number of words in each line with average char size
    var lines = _calcNumberOfWordsInEachLine(size, style, text);
    // calculate each line remaining space
    List<int> remainingSpace = [];
    for (var line in lines)
      remainingSpace
          .add(size.maxWidth.floor() - _calculateStringSize(size, style, line));
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

  String _reverseNumbersAndEnglishWords(String text) {
    List<String> words = _matchEnglishAndNumbers
        .allMatches(text)
        .map((match) => match.group(0))
        .toList();

    List<String> splitted = text.split(_matchEnglishAndNumbers);

    var result = "";

    for (int i = 0; i < words.length; i++) {
      result += splitted[i] + words[i];
    }

    // reverse english sentences
    List<String> englishSentences = _matchEnglishSentence
        .allMatches(result)
        .map((match) => match.group(0))
        .toList();

    for (var sentence in englishSentences) {
      result = result.replaceAll(
        sentence,
        sentence.split(" ").reversed.join(" "),
      );
    }

    return result;
  }

  Widget createRow(List<Widget> words, int remainingSpace) {
    Widget _row;
    if (remainingSpace > widget.boxConstraints.maxWidth.floor() / 3)
      _row = Row(
        children: joinWidget(words, SizedBox(width: 4)),
      );
    else
      _row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: words,
      );
    return Directionality(textDirection: widget.textDirection, child: _row);
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
        strutStyle: widget.strutStyle,
        style: widget.style,
        textScaleFactor: widget.textScaleFactor,
        textDirection: widget.textDirection,
      );

  List<String> _calcNumberOfWordsInEachLine(
    BoxConstraints size,
    TextStyle style,
    String text,
  ) {
    // TODO: add support for new lines
    var _words = text.replaceAll("\n", " ").split(" ");
    List<List<String>> _lines = [[]];
    var _currentLine = 0;
    // create lines with words
    for (var word in _words) {
      var linesSizeWithWord = _calculateStringSize(
          size, style, (_lines[_currentLine] + [word]).join(" "));
      if (linesSizeWithWord >= size.maxWidth.floor()) {
        _currentLine += 1;
        _lines.add([]);
        _lines[_currentLine].add(word);
        continue;
      } else
        _lines[_currentLine].add(word);
    }
    return _lines.map((words) => words.join(" ")).toList();
  }

  int _calculateStringSize(BoxConstraints size, TextStyle style, String text) {
    var span = TextSpan(style: style, text: text);
    var tp = TextPainter(
      text: span,
      textAlign: TextAlign.right,
      textDirection: widget.textDirection,
      textScaleFactor: widget.textScaleFactor ?? 1,
      maxLines: 1,
    );
    tp.layout(maxWidth: size.maxWidth.round().toDouble());
    return tp.width.floor();
  }

  @override
  bool get wantKeepAlive => true;
}
