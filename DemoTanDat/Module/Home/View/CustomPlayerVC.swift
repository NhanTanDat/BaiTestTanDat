
import UIKit
import AVKit

class CustomPlayerVC: AVPlayerViewController {

    private let speedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("x1.0", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var speedList: [Float] = [0.5,1.0,1.5,2.0]
    private var currentSpeedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentOverlayView!.addSubview(speedButton)

        NSLayoutConstraint.activate([
            speedButton.trailingAnchor.constraint(equalTo: contentOverlayView!.trailingAnchor, constant: 0),
            speedButton.bottomAnchor.constraint(equalTo: contentOverlayView!.bottomAnchor, constant: -100),
            speedButton.widthAnchor.constraint(equalToConstant: 60),
            speedButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        speedButton.addTarget(self, action: #selector(changeSpeed), for: .touchUpInside)
    }

    @objc private func changeSpeed() {
        currentSpeedIndex = (currentSpeedIndex + 1) % speedList.count
        let newRate = speedList[currentSpeedIndex]
        player?.rate = newRate
        speedButton.setTitle("x\(newRate)", for: .normal)
        if player?.timeControlStatus != .playing {
            player?.playImmediately(atRate: newRate)
        }
    }
}

