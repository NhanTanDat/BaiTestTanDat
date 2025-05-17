import UIKit

// MARK: - Protocol delegate cho HeaderResearchView
protocol HeaderResearchViewDelegate: AnyObject {
    func headerResearchView(_ headerView: HeaderResearchView, didChangeSearchText text: String)
}

class HeaderResearchView: UIView {
    
    weak var delegate: HeaderResearchViewDelegate?
    
    let magnifyingglassImg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "magnifyingglass")
        imgView.tintColor = .white
        return imgView
    }()
    
    let img: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "photo")
        imgView.tintColor = .white
        return imgView
    }()
    
    let bellButton = UIButton(type: .system)
    
    let badgeLabel: UILabel = {
        let label = UILabel()
        label.text = "5+"
        label.textColor = .white
        label.backgroundColor = .red
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Tìm kiếm"
        textField.textColor = .white
        textField.tintColor = .white
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.setLeftPaddingPoints(8)
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
        setupView()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupView() {
        bellButton.translatesAutoresizingMaskIntoConstraints = false
        bellButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        bellButton.tintColor = .white
        
        bellButton.addSubview(badgeLabel)
        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: bellButton.topAnchor, constant: -5),
            badgeLabel.trailingAnchor.constraint(equalTo: bellButton.trailingAnchor, constant: 5),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 26),
            badgeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        searchTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        searchTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let stack = UIStackView(arrangedSubviews: [magnifyingglassImg, searchTextField, img, bellButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            magnifyingglassImg.widthAnchor.constraint(equalToConstant: 24),
            magnifyingglassImg.heightAnchor.constraint(equalToConstant: 24),
            
            img.widthAnchor.constraint(equalToConstant: 30),
            img.heightAnchor.constraint(equalToConstant: 30),
            
            bellButton.widthAnchor.constraint(equalToConstant: 30),
            bellButton.heightAnchor.constraint(equalToConstant: 30),
            
            searchTextField.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        delegate?.headerResearchView(self, didChangeSearchText: textField.text ?? "")
    }
    
    // MARK: - Public method to hide/show right icons
    func setRightIconsHidden(_ hidden: Bool, animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.img.alpha = hidden ? 0 : 1
                self.bellButton.alpha = hidden ? 0 : 1
                self.badgeLabel.alpha = hidden ? 0 : 1
            }
        } else {
            img.isHidden = hidden
            bellButton.isHidden = hidden
            badgeLabel.isHidden = hidden
        }
    }
}

// MARK: - Padding Extension
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

