# AVAudioSessionBug
For some reason AVAudioSession.interruptionNotification doesn't fire .ended event if more than one AVPlayer instance is playing.
That prevents us from recovering playing state after an interruption.
To switch between working and non-working states you can set nil to any of two players.
