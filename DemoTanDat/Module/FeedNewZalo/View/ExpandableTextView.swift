import UIKit

protocol ExpandableTextViewDelegate: AnyObject {
    func didTapSeeMore()
    func didTapCollapse()
}

class ExpandableTextView: UITextView, UITextViewDelegate {
    var fullText: String = "" {
        didSet { updateText() }
    }
    var isExpanded: Bool = false {
        didSet { updateText() }
    }
    var maxLines: Int = 3
    weak var expandDelegate: ExpandableTextViewDelegate?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
        isEditable = false
        isScrollEnabled = false
        textContainerInset = .zero
        textContainer?.lineFragmentPadding = 0
        font = .systemFont(ofSize: 14)
        linkTextAttributes = [.foregroundColor: UIColor.gray, .underlineStyle: 0]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateText() {
        let font = self.font ?? .systemFont(ofSize: 14)
        if isExpanded {
            let text = NSMutableAttributedString(string: fullText, attributes: [.font: font, .foregroundColor: UIColor.label])
            let collapse = NSAttributedString(string: " Thu gọn", attributes: [.font: font, .foregroundColor: UIColor.gray, .link: URL(string: "action://collapse")!])
            text.append(collapse)
            attributedText = text
        } else {
            let trimmed = trimmedText(fullText, maxLines: maxLines)
            let text = NSMutableAttributedString(string: trimmed, attributes: [.font: font, .foregroundColor: UIColor.label])
            text.append(NSAttributedString(string: "… ", attributes: [.font: font]))
            let more = NSAttributedString(string: "Xem thêm", attributes: [.font: font, .foregroundColor: UIColor.gray, .link: URL(string: "action://seeMore")!])
            text.append(more)
            attributedText = text
        }
    }

    func trimmedText(_ text: String, maxLines: Int) -> String {
        let nsText = text as NSString
        let size = CGSize(width: frame.width, height: .greatestFiniteMagnitude)
        var low = 0, high = nsText.length, mid = high
        let font = self.font ?? .systemFont(ofSize: 14)
        let attr: [NSAttributedString.Key: Any] = [.font: font]

        while low < high {
            mid = (low + high) / 2
            let bounding = nsText.substring(to: mid).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: attr, context: nil)
            let lines = Int(bounding.height / font.lineHeight)
            if lines > maxLines {
                high = mid - 1
            } else {
                low = mid + 1
            }
        }

        return nsText.substring(to: min(mid, nsText.length))
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        switch URL.host {
        case "seeMore": expandDelegate?.didTapSeeMore()
        case "collapse": expandDelegate?.didTapCollapse()
        default: return true
        }
        return false
    }
}

