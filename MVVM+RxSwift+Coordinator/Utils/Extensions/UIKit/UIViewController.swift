//
//  UIViewController.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 22/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit
import SnapKit
import Lottie
import RxSwift
import RxCocoa

public extension UIViewController {
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private var dimViewTag: Int { return 00002 }
    
    private func showDimView() {
        guard let window = UIApplication.shared.keyWindow else { return }
        if !window.subviews.filter({ $0.tag == self.dimViewTag }).isEmpty {
            return
        }
        let view = UIView(frame: window.frame)
        view.backgroundColor = .black
        view.tag = self.dimViewTag
        view.alpha = 0.3
        
        DispatchQueue.main.async {
            window.addSubview(view)
        }
    }
    
    private func dismissDimView() {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        window.subviews.forEach { item in
            if item.tag == self.dimViewTag {
                DispatchQueue.main.async {
                    item.removeFromSuperview()
                }
            }
        }
    }
    
    private var loaderViewTag: Int { return 00003 }
    
    public func showLoading(message: String = "carregando...") {
        guard let window = UIApplication.shared.keyWindow else { return }
        if !window.subviews.filter({ $0.tag == self.loaderViewTag }).isEmpty {
            return
        }
        self.showDimView()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        view.backgroundColor = .white
        view.tag = self.loaderViewTag
        view.center = window.center
        view.cornerRadius = 2
        
        let loadingView = LOTAnimationView(name: "loader.json")
        loadingView.play()
        loadingView.loopAnimation = true
        
        let msg = message.replacingOccurrences(of: ".", with: "")
        let messageLabel = UILabel(withSize: 12.0, withColor: .darkGrey, withText: msg, withTextAlignment: .center)
        
        DispatchQueue.main.async {
            
            view.addSubview(loadingView)
            
            loadingView.snp.makeConstraints {
                $0.leading.equalTo(view.snp.leadingMargin)
                $0.trailing.equalTo(view.snp.trailingMargin)
                $0.centerX.equalTo(view.snp.centerX)
                $0.centerY.equalTo(view.snp.centerY)
                $0.height.equalTo(view.snp.height).multipliedBy(0.4)
            }
            
            view.addSubview(messageLabel)
            
            messageLabel.snp.makeConstraints {
                $0.leading.equalTo(view.snp.leadingMargin)
                $0.trailing.equalTo(view.snp.trailingMargin)
                $0.bottom.equalTo(view.snp.bottomMargin)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if messageLabel.text?.contains("...") ?? true {
                    messageLabel.text = msg
                    return
                }
                messageLabel.text?.append(".")
            }
            
            window.addSubview(view)
        }
    }
    
    public func dismissLoading() {
        self.dismissDimView()
        guard let window = UIApplication.shared.keyWindow else { return }
        window.subviews.forEach { item in
            if item.tag == self.loaderViewTag {
                DispatchQueue.main.async {
                    item.removeFromSuperview()
                }
            }
        }
    }
    
    private var emptyViewTag: Int { return 00004 }
    
    public func showEmptyView(image: UIImage?, title: String?, message: String?,
                              titleButton: String = "Tentar novamente", disposeBag: DisposeBag,
                              completion: @escaping () -> Void) {
        if !self.view.subviews.filter({ $0.tag == self.emptyViewTag }).isEmpty {
            return
        }
        DispatchQueue.main.async {
            let view = UIView(frame: self.view.frame)
            view.backgroundColor = .white
            view.tag = self.emptyViewTag
            
            let stack = UIStackView()
            stack.alignment = .center
            stack.distribution = .fill
            stack.axis = .vertical
            stack.spacing = 20
            stack.center = view.center
            
            if let image = image {
                let imageView = UIImageView(image: image, contentMode: .scaleAspectFit)
                stack.addArrangedSubview(imageView)
                
                imageView.snp.makeConstraints {
                    $0.height.equalTo(120)
                    $0.width.equalTo(120)
                }
            }
            
            if let title = title, !title.isEmpty {
                let titleLabel = UILabel(font: .bold, withText: title, withTextAlignment: .center, withLines: 1)
                stack.addArrangedSubview(titleLabel)
            }
            
            if let message = message, !message.isEmpty {
                let messageLabel = UILabel(withSize: 14.0, withText: message, withTextAlignment: .center, withLines: 3)
                stack.addArrangedSubview(messageLabel)
            }
            
            let buttonRetry = UIButton(type: .system, withTitle: titleButton, withTitleColor: .darkGrey)
            
            buttonRetry.borderColor = .gray
            buttonRetry.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)

            buttonRetry.borderWidth = 1
            buttonRetry.layer.cornerRadius = 2
            buttonRetry.rx.tap.bind {
                completion()
                self.dismissEmptyView()
                }.disposed(by: disposeBag)
            
            stack.addArrangedSubview(buttonRetry)
            
            view.addSubview(stack)
            
            stack.snp.makeConstraints {
                $0.leading.equalTo(view.snp.leadingMargin).offset(10)
                $0.trailing.equalTo(view.snp.trailingMargin).inset(10)
                $0.centerY.equalTo(view.snp.centerY)
            }
            self.view.addSubviewAttachingEdges(view,
                                               topConstraint: self.view.snp.topMargin,
                                               bottomConstraint: self.view.snp.bottomMargin)
        }
    }
    
    public func dismissEmptyView() {
        self.view.subviews.forEach { item in
            if item.tag == self.emptyViewTag {
                DispatchQueue.main.async {
                    item.removeFromSuperview()
                }
            }
        }
    }
}
