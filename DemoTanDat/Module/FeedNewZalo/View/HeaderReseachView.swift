//
//  HeaderResearchView.swift
//  DemoTanDat
//
//  Created by Đại Lợi Đẹp Trai on 15/5/25.
//

import UIKit

class HeaderResearchView: UIView {
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
    
    lazy var SearchLable: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Search"
        return label
    }()
    
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
    
    let bellButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
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
    
        SearchLable.setContentHuggingPriority(.defaultLow, for: .horizontal)
        SearchLable.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let stack = UIStackView(arrangedSubviews: [magnifyingglassImg, SearchLable, img, bellButton])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            magnifyingglassImg.widthAnchor.constraint(equalToConstant: 30),
            magnifyingglassImg.heightAnchor.constraint(equalToConstant: 30),
            
            img.widthAnchor.constraint(equalToConstant: 30),
            img.heightAnchor.constraint(equalToConstant: 30),
            
            bellButton.widthAnchor.constraint(equalToConstant: 30),
            bellButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}

