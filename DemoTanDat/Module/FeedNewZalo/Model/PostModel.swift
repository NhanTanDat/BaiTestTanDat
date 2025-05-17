//
//  PostModel.swift
//  DemoTanDat
//
//  Created by Đại Lợi Đẹp Trai on 16/5/25.
//

import UIKit

struct PostModel {
    let avatar: UIImage?
    let username: String
    let time: String
    let text: String
    let images: [UIImage]
    let linkTitle: String
    let linkSubtitle: String
    let videoName: String? 
    var isExpandedStates: Bool = false
}

