
import UIKit
import AVFoundation

struct MediaItem: Codable {
    let url: URL
    let isVideo: Bool

    var fileName: String {
        url.lastPathComponent
    }
}
