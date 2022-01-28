import UIKit

class TriangleView : UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let triangle = UIBezierPath()
        triangle.move(to: CGPoint(x: frame.width / 2, y: 0))
        triangle.addLine(to: CGPoint(x: frame.width, y: frame.height))
        triangle.addLine(to: CGPoint(x: 0, y: frame.height))
        triangle.addLine(to: CGPoint(x: frame.width / 2, y: 0))
        triangle.close()
        
        UIColor.customGreen().setFill()
        triangle.fill()
    }
}
