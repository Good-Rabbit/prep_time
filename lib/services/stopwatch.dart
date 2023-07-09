class StopWatch extends Stopwatch {
  int _starterMilliseconds = 0;

  StopWatch({int seconds = 0}) {
    _starterMilliseconds = seconds ~/ 1000;
  }

  @override
  get elapsed {
    return Duration(
        microseconds:
            super.elapsedMicroseconds + (_starterMilliseconds * 1000));
  }

  get elapsedSeconds {
    return elapsedMilliseconds ~/ 1000;
  }

  @override
  get elapsedMilliseconds {
    return super.elapsedMilliseconds + _starterMilliseconds;
  }

  set seconds(int timeInSeconds) {
    _starterMilliseconds = timeInSeconds * 1000;
  }
}
