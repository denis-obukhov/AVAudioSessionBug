//
//  ViewController.swift
//  AudioSessionBug
//
//  Created by Denis Obukhov on 04.02.2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  private let player1: AVPlayer? = {
    $0.volume = 0.5
    return $0
  }(AVPlayer())

  private let player2: AVPlayer? = {
    $0.volume = 0.5
    return $0 // return nil for any player to bring back .ended interruption notification
  }(AVPlayer())

  override func viewDidLoad() {
    super.viewDidLoad()
    registerObservers()
    startAudioSession()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    player1?.replaceCurrentItem(with: makePlayerItem(named: "music1"))
    player2?.replaceCurrentItem(with: makePlayerItem(named: "music2"))
    [player1, player2].forEach { $0?.play() }
  }

  private func makePlayerItem(named name: String) -> AVPlayerItem {
    let fileURL = Bundle.main.url(
      forResource: name,
      withExtension: "mp3"
    )!
    return AVPlayerItem(url: fileURL)
  }

  private func registerObservers() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(handleInterruption(_:)),
      name: AVAudioSession.interruptionNotification,
      object: nil
    )
  }

  private func startAudioSession() {
    try? AVAudioSession.sharedInstance().setCategory(.playback)
    try? AVAudioSession.sharedInstance().setActive(true)
  }

  @objc private func handleInterruption(_ notification: Notification) {
    print("GOT INTERRUPTION")
    guard
      let userInfo = notification.userInfo,
      let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
      let type = AVAudioSession.InterruptionType(rawValue: typeValue)
    else {
      return
    }

    switch type {
    case .began:
      print("Interruption BEGAN")
      [player1, player2].forEach { $0?.pause() }
    case .ended:
      // This part isn't called if more than 1 player is playing
      print("Interruption ENDED")
      [player1, player2].forEach { $0?.play() }
    @unknown default:
      print("Unknown value")
    }
  }
}

