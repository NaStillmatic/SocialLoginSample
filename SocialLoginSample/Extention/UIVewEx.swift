//
//  UIVewEx.swift
//  SocialLoginSample
//
//  Created by HwangByungJo  on 2022/05/26.
//

import UIKit

@IBDesignable extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get { return layer.cornerRadius }
    set {
      layer.cornerRadius = newValue
      // If masksToBounds is true, subviews will be
      // clipped to the rounded corners.
      layer.masksToBounds = (newValue > 0)
    }
  }
}
