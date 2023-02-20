import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StopWatch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StopWatchPage(),
    );
  }
}
class StopWatchPage extends StatefulWidget {
  const StopWatchPage({Key? key}) : super(key: key);

  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
    Timer? _timer; // 타이머

   var _time = 0; // 0.01초 마다 1씩 증가시킬 변수
   var _isRunning = false; // 현재 시작

  List<String> _lapTimes = []; // 랩타임에 표시할 시간을 저장할 리스트

  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StopWatch'),
      ),
      body: _buildBody(), //이 메서드는 후의 단계에서 작성
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>setState((){
          _clickButton(); //이 메서드는 후의 단계에서 작성
        }),
        child: _isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow), //상태에 따라 다른 아이콘
        //삼항연산 활용

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  //내용 부분
  Widget _buildBody(){
    var sec = _time ~/100; //초
    var hundredth = '${_time%100}'.padLeft(2,'0'); // 1/100초

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top:30),
        child: Stack(
          children: [
            Column(
              children: [
                Row( //시간을 표시하는 영역
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$sec', //초
                      style: TextStyle(fontSize: 50.0),
                    ),
                    Text('$hundredth'), //  1/100초
                  ],
                ),
                Container(
                  width: 100,
                  height: 200,
                  child: ListView(
                    children: _lapTimes.map((time) => Text(time)).toList(),
                  ),
                )
              ],
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: FloatingActionButton( // 왼쪽 하단에 위치한 초기화 버튼
                backgroundColor: Colors.deepOrange,
                onPressed: _reset,
                child: Icon(Icons.rotate_left),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: ElevatedButton( // 오른쪽 하단에 위치한 랩타임 버튼
                onPressed: (){
                  setState(() {
                    _recordLapTime('$sec.$hundredth');
                  });
                },
                child: Text('랩타임'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //시작 또는 일시정지 버튼 클릭
  void _clickButton() {
    _isRunning = !_isRunning;

    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }
  // 1/100초에 한번 씩 time변수를 1 증가
  void _start() {
    _timer=Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }
  //타이머 취소
  void _pause() {
    _timer?.cancel();
  }

  //초기화
  void _reset() {
    setState((){
      _isRunning =false;
      _timer?.cancel();
      _lapTimes.clear();
      _time=0;
    });
  }
  //랩타임 기록
  void _recordLapTime(String time) {
    _lapTimes.insert(0, '${_lapTimes.length+1}등 $time');
  }
}


























