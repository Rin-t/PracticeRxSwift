//
//  ViewController.swift
//  PracticeRxSwift
//
//  Created by Rin on 2021/09/16.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    // Views
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "名前"
        return textField
    }()
    private let nameLimitTextLabel: UILabel = {
        let label = UILabel()
        label.text = "あと10文字"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let addressTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "住所"
        return textField
    }()
    private let addressLimitTextLabel: UILabel = {
        let label = UILabel()
        label.text = "あと50文字"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let maxNameFieldSize = 10
    private let maxAddressFieldSize = 50

    private let limitText: (Int) -> String = {
        "あと\($0)文字"
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }

    private func setupLayout() {
        let views = [[nameTextField, nameLimitTextLabel], [addressTextField, addressLimitTextLabel]]
        let stackViews = views.map { view -> UIStackView in
            let textField = view.first as? UITextField ?? UITextField()
            let label = view.last as? UILabel ?? UILabel()
            let stackView = UIStackView(arrangedSubviews: [textField, label])
            stackView.axis = .vertical
            stackView.spacing = 10
            textField.anchor(height: 40)
            label.anchor(height: 20)
            return stackView
        }

        let baseStackView = UIStackView(arrangedSubviews: stackViews)
        baseStackView.axis = .vertical
        baseStackView.spacing = 40

        view.addSubview(baseStackView)
        baseStackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, topPadding: 100, leftPadding: 40, rightPadding: 40)

    }

    private func setupBindings() {
        nameTextField.rx.text
            .map({ [weak self] text -> String? in
                guard let text = text,
                      let maxNameFieldSize = self?.maxNameFieldSize else { return nil}
                let limitCount = maxNameFieldSize - text.count
                return self?.limitText(limitCount)
            })
            .bind(to: nameLimitTextLabel.rx.text)
            .disposed(by: disposeBag)

        addressTextField.rx.text
            .map({ [weak self] text -> String? in
                guard let text = text,
                      let maxAddressFieldSize = self?.maxAddressFieldSize else { return nil}
                let limitCount = maxAddressFieldSize - text.count
                return self?.limitText(limitCount)
            })
            .bind(to: addressLimitTextLabel.rx.text)
            .disposed(by: disposeBag)
    }


}

extension UIView {
    fileprivate func anchor(top: NSLayoutYAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                centerY: NSLayoutYAxisAnchor? = nil,
                centerX: NSLayoutXAxisAnchor? = nil,
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                topPadding: CGFloat = 0,
                bottomPadding: CGFloat = 0,
                leftPadding: CGFloat = 0,
                rightPadding: CGFloat = 0
                ) {

        self.translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -rightPadding).isActive = true
        }
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

