//
//  XibLoadable.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 12.03.2024.
//

import UIKit

public protocol NibLoadable {
  static var nibName: String { get }
}

public extension NibLoadable where Self: UIView {

  static var nibName: String {
    String(describing: Self.self)
  }

  static var nib: UINib {
    let bundle = Bundle(for: Self.self)
    return UINib(nibName: Self.nibName, bundle: bundle)
  }

  func setupFromNib() {
    guard let view = Self.nib.instantiate(
      withOwner: self,
      options: nil).first as? UIView else {
      fatalError("Error loading \(self) from nib")
    }
    addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
