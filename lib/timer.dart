import 'dart:async';
import './models/timermodel.dart';

// ignore: slash_for_doc_comments
/**
 * _radius is used to express the percentage of completed time
 * _isActive states if the counter is active or not
 * _time express the remaining time
 * _fullTime is beginning time
 * work is the default number of minutes for the work time
 */
class CountDownTimer {
  double _radius = 1;
  bool _isActive = true;
  Timer timer;
  Duration _time;
  Duration _fullTime;
  int work = 30;
  int shortBreak = 3;
  int longBreak = 20;

  void startWork() {
    _radius = 1;
    _time = Duration(minutes: this.work, seconds: 0);
    _fullTime = _time;
  }

  void startTimer() {
    if (_time.inSeconds > 0) {
      this._isActive = true;
    }
  }

  void stopTimer() {
    this._isActive = false;
  }

  void startBreak(bool isShort) {
    _radius = 1;
    _time = Duration(minutes: isShort ? shortBreak : longBreak, seconds: 0);
    _fullTime = _time;
  }

  String returnTime(Duration t) {
    String minutes = t.inMinutes < 10
        ? '0' + t.inMinutes.toString()
        : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds =
        numSeconds < 10 ? '0' + numSeconds.toString() : numSeconds.toString();
    String formattedTime = minutes + ":" + seconds;
    return formattedTime;
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (this._isActive) {
        _time = _time - Duration(seconds: 1);
        _radius = _time.inSeconds / _fullTime.inSeconds;
        if (_time.inSeconds <= 0) {
          _isActive = false;
        }
      }
      time = returnTime(_time);
      return TimerModel(time: time, percent: _radius);
    });
  }
}