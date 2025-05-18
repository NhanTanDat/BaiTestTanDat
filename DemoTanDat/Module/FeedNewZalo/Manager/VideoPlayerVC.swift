import UIKit
import GSPlayer
import AVFoundation

class VideoPlayerVC: UIViewController {
    var videoURL: URL!
    var videoView: VideoPlayerView!
    
    private var progressSlider: UISlider!
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupVideoView()
        setupProgressSlider()
        
        videoView.play(for: videoURL)
        startTimer()
    }
    
    func setupVideoView() {
        videoView = VideoPlayerView()
        videoView.frame = view.bounds
        videoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        videoView.playerLayer.videoGravity = .resizeAspect
        view.addSubview(videoView)
    }
    
    func setupProgressSlider() {
        progressSlider = UISlider(frame: CGRect(x: 20, y: view.bounds.height - 60, width: view.bounds.width - 40, height: 30))
        progressSlider.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.tintColor = .systemBlue
        progressSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(progressSlider)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        guard let player = videoView.playerLayer.player,
              let duration = player.currentItem?.duration else { return }
        
        let durationSeconds = CMTimeGetSeconds(duration)
        let newTime = CMTimeMakeWithSeconds(Double(sender.value) * durationSeconds, preferredTimescale: duration.timescale)
        videoView.seek(to: newTime)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateProgressSlider()
        }
    }
    
    func updateProgressSlider() {
        guard let player = videoView.playerLayer.player,
              let duration = player.currentItem?.duration else { return }
        
        let durationSeconds = CMTimeGetSeconds(duration)
        if durationSeconds <= 0 { return }
        
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        progressSlider.value = Float(currentTimeSeconds / durationSeconds)
    }
    
    deinit {
        timer?.invalidate()
    }
}

