import UIKit

extension UIView {
    func forAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func pin(to edgeInsets: UIEdgeInsets) {
        guard let superview = superview else { fatalError() }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -edgeInsets.right),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: edgeInsets.left),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: edgeInsets.top),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -edgeInsets.bottom)
        ])
    }

    func pinToSuperview() {
        guard let superview = superview else { fatalError() }
        
        translatesAutoresizingMaskIntoConstraints = false 

        superview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        superview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        superview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        superview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
