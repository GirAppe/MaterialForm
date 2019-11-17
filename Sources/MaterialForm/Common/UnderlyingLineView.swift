#if os(iOS) || os(tvOS)

import UIKit

// MARK: - Underlying View

@available(iOS 10, *)
final internal class UnderlyingLineView: UIStackView {

    // MARK: - State

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

    // MARK: - Properties

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

        mainLine.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
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

    func animateStateChange(animate: Bool, _ change: (UnderlyingLineView.State) -> Void)  {
        animateChange = animate
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
            animateLineHorizontally(from: from, to: to)
        case (_, 0):
            animateLineHorizontally(from: from, to: to)
        default:
            animateLineVertical(to: to)
        }
    }

    private func animateLineVertical(to: CGFloat) {
        animate { self.heightContraint.constant = to }
    }

    private func animateLineHorizontally(from: CGFloat, to: CGFloat) {
        layer.removeAllAnimations()
        
        func show() {
            let initialTransform = CGAffineTransform(scaleX: 0, y: 1)
            let finalTransform = CGAffineTransform.identity

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

        func hide() {
            let initialTransform = CGAffineTransform.identity
            let finalTransform = CGAffineTransform(scaleX: 0.00001, y: 1)

            heightContraint.constant = from
            transform = initialTransform
            layoutSubviews()

            animate(change: {
                self.transform = finalTransform
            }, completion: {
                self.heightContraint.constant = to
                self.transform = .identity
            })
        }

        if to != 0 {
            show()
        } else {
            hide()
        }
    }

    // MARK: - General animation blocks

    private func animate(_ change: @escaping () -> Void) {
        animate(change: change, completion: nil)
    }

    private func animate(change: @escaping () -> Void, completion: (() -> Void)?) {
        layoutSubviews()
        let animation = { change(); self.layoutSubviews() }

        guard animateChange else {
            animation(); completion?(); return
        }

        UIView.animate(withDuration: animationDuration, animations: animation) { finished in
            finished ? completion?() : ()
        }
    }
}

#endif
