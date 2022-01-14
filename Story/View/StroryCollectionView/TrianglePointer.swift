import UIKit

class TrianglePointer: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let line = UIBezierPath()
        line.move(to: CGPoint(x: 0, y: 0))
        line.addLine(to: CGPoint(x: frame.width, y: frame.height / 2))
        line.addLine(to: CGPoint(x: 0, y: frame.height))
        line.addLine(to: CGPoint(x: 0, y: 0))
        line.close()
        
        UIColor.customGreen().setFill()
        line.fill()
    }
}
