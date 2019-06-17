import 'package:flutter/material.dart';
import 'package:flutter_text_justify_rtl/flutter_text_justify_rtl.dart';

void main() => runApp(MyApp());

var para = """
لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است. چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است و برای شرایط فعلی تکنولوژی مورد نیاز و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد. کتابهای زیادی در شصت و سه درصد گذشته، حال و آینده شناخت فراوان جامعه و متخصصان را می طلبد تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی و فرهنگ پیشرو در زبان فارسی ایجاد کرد. در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها و شرایط\n\n سخت تایپ به پایان رسد\n و زمان مورد نیاز شامل حروفچینی دستاوردهای اصلی و جوابگوی nturies , but also the leap into  سوالات پیوسته اهل  اساسا مورد استفاده قرار گیرد. 
"""
    .trim();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: ListView(children: [
            LayoutBuilder(
              builder: (context, c) => TextJustifyRTL(
                para,
                textDirection: TextDirection.rtl,
                style: Theme.of(context).textTheme.subtitle,
                boxConstraints: c,
              ),
            ),
          ])),
    );
  }
}
