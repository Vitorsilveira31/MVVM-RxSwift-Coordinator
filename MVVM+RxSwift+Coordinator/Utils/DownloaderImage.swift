//
//  DownloaderImage.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 23/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation
import Kingfisher

class DownloaderImage: NSObject {
    
    var url: URL?
    var imageView: UIImageView
    
    init(url: String, imageView: UIImageView) {
        self.url = URL(string: url)
        self.imageView = imageView
        super.init()
    }
    
    public func commomInit() {
        self.imageView.kf.indicatorType = IndicatorType.activity
        self.imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 1028, height: 768)))])
    }
}
