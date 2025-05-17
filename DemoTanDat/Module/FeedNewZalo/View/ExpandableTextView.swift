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

    private var shouldShowSeeMore: Bool = false

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
        shouldShowSeeMore = isTextExceedingMaxLines(text: fullText)

        if !shouldShowSeeMore {
            // Hiển thị đầy đủ, không thêm "Xem thêm"
            attributedText = NSAttributedString(string: fullText, attributes: [.font: font, .foregroundColor: UIColor.label])
            return
        }

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

    func isTextExceedingMaxLines(text: String) -> Bool {
        let font = self.font ?? .systemFont(ofSize: 14)
        let maxHeight = CGFloat(maxLines) * font.lineHeight
        let constraintSize = CGSize(width: self.frame.width, height: .greatestFiniteMagnitude)
        let bounding = (text as NSString).boundingRect(
            with: constraintSize,
            options: [.usesLineFragmentOrigin],
            attributes: [.font: font],
            context: nil
        )
        return bounding.height > maxHeight
    }

    func trimmedText(_ text: String, maxLines: Int) -> String {
        let nsText = text as NSString
        let size = CGSize(width: frame.width, height: .greatestFiniteMagnitude)
        var low = 0, high = nsText.length, best = nsText.length
        let font = self.font ?? .systemFont(ofSize: 14)
        let attr: [NSAttributedString.Key: Any] = [.font: font]

        while low <= high {
            let mid = (low + high) / 2
            let substring = nsText.substring(to: mid)
            let bounding = substring.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: attr, context: nil)
            let lines = Int(bounding.height / font.lineHeight)

            if lines <= maxLines {
                best = mid
                low = mid + 1
            } else {
                high = mid - 1
            }
        }

        return nsText.substring(to: best)
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

