//
//  UnderlyingLineView.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 30/09/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

final internal class UnderlyingLineView: UIStackView {

    class State {
        var width: CGFloat {
            get { return underlyingView?.width ?? 0 }
            set { underlyingView?.width = newValue }
        }
        var color: UIColor {
            get { return underlyingView?.color ?? .clear }
            set { underlyingView?.color = newValue }
        }

        weak var underlyingView: UnderlyingLineView?

        init(_ underlyingView: UnderlyingLineView) {
            self.underlyingView = underlyingView
        }
    }
    private var state: State { return State(self) }

    private var mainLine = UIView()
    private var accessoryLine = UIView()
    private var heightContraint: NSLayoutConstraint!
    private var animateChange: Bool = false

    var width: CGFloat = 1 { didSet { animateLineWidth(from: oldValue, to: width) } }
    var color: UIColor = .darkText { didSet { animateColor(to: color) } }
    var underAccessory: Bool = true { didSet { updateUnderAccessory() } }
    var animationDuration: TimeInterval = 0.3

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        update()
    }

    // MARK: - Build phase

    func buildAsUnderline(for field: UIView) {
        axis = .horizontal
        alignment = .fill
        heightContraint = heightAnchor.constraint(equalToConstant: width)
        heightContraint.isActive = true

        mainLine.removeFromSuperview()
        accessoryLine.removeFromSuperview()
        mainLine = UIView()
        accessoryLine = UIView()

        addArrangedSubview(mainLine)
        addArrangedSubview(accessoryLine)

        mainLine.widthAnchor.constraint(equalTo: field.widthAnchor).isActive = true
        update()
    }

    // MARK: - Instan Updates

    func update() {
        heightContraint?.constant = width
        mainLine.backgroundColor = color
        updateUnderAccessory()
    }

    private func updateUnderAccessory() {
        accessoryLine.backgroundColor = underAccessory ? color : .clear
    }

    // MARK: - Actions

    func animateStateChange(_ change: (UnderlyingLineView.State) -> Void)  {
        animateChange = true
        change(self.state)
        animateChange = false
    }

    // MARK: - Color animations

    private func animateColor(to color: UIColor) {
        animate {
            self.mainLine.backgroundColor = color
            self.accessoryLine.backgroundColor = self.underAccessory ? color : .clear
        }
    }

    // MARK: - Line animations

    private func animateLineWidth(from: CGFloat, to: CGFloat) {
        guard from != to else { return }

        switch (from, to) {
        case (0, _):
            animateLineHorizontally(to: to)
        case (_, 0):
            animateLineHorizontally(to: to)
        default:
            animateLineVertical(to: to)
        }
    }

    private func animateLineVertical(to: CGFloat) {
        animate { self.heightContraint.constant = to }
    }

    private func animateLineHorizontally(to: CGFloat) {
        let initialTransform = to == 0 ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0, y: 1)
        let finalTransform = to != 0 ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0, y: 1)

        heightContraint.constant = to
        transform = initialTransform
        layoutSubviews()

        animate(change: {
            self.transform = finalTransform
        }, completion: {
            self.heightContraint.constant = to
            self.transform = .identity
        })
    }

    // MARK: - General animation blocks

    private func animate(_ change: @escaping () -> Void) {
        animate(change: change, completion: nil)
    }

    private func animate(change: @escaping () -> Void, completion: (() -> Void)?) {
        layoutSubviews()
        let animation = { change(); self.layoutSubviews() }

        guard animateChange else {
            return animation()
        }

        UIView.animate(withDuration: animationDuration, animations: animation) { finished in
            finished ? completion?() : ()
        }
    }
}
