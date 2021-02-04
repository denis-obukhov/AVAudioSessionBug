# AVAudioSessionBug
For some reason AVAudioSession.interruptionNotification doesn't fire .ended event if more than one AVPlayer instance is playing.
That prevents us from recovering playing state after an interruption.
To switch between working and non-working states you can set nil to any of two players.
To interrupt the current audio session you can call Siri or receive a regular call from a cellular network/skype/etc.
