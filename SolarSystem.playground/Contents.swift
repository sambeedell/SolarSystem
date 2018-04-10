//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

class Circle: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        // cos(θ) = x / r  ==>  x = r * cos(θ)
        // sin(θ) = y / r  ==>  y = r * sin(θ)
        
        // Radius
        let r: Double = 100
        
        // Center
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        // Origin
        path.move(to: CGPoint(x: center.x + CGFloat(r), y: center.y))
        
        // θ = i
        for i in stride(from: 0, to: 360.1, by: 10) {
            
            // Convert degrees to radians
            // radians = degrees * pi / 180
            let radians = i * Double.pi / 180
            
            let x = Double(center.x) + r * cos(radians)
            let y = Double(center.y) + r * sin(radians)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        // Set line properties
        UIColor.lightGray.setStroke()
        path.lineWidth = 5
        
        path.stroke()
    }
}


//let view = Circle(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

// Setup View
let view = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
view.backgroundColor = .black

// Show in Playgrounds live view
PlaygroundPage.current.liveView = view

// Create properties
let center = view.center
let innerTrackRadius = 100
let outerTrackRadius = 150


// Animations
func animateStroke(shapeLayer: CAShapeLayer) {
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    animation.toValue = 1
    animation.duration = 2
    
    animation.fillMode = kCAFillModeForwards
    animation.isRemovedOnCompletion = false
    
    shapeLayer.add(animation, forKey: "basic")
}

func animatePulsing(shapeLayer: CAShapeLayer) {
    
    let animation = CABasicAnimation(keyPath: "transform.scale")
    
    animation.toValue = 1.5
    animation.duration = 5
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    animation.autoreverses = true
    animation.repeatCount = Float.infinity
    
    
    shapeLayer.add(animation, forKey: "pulsing")
}

func animateOrbitFor(shapeLayer: CAShapeLayer, path: CGPath) {
    
    let orbit = CAKeyframeAnimation(keyPath: "position")
    orbit.duration = 2
    orbit.autoreverses = true
    orbit.repeatCount = Float.infinity
    orbit.path = path
    orbit.isRemovedOnCompletion = false
    
    shapeLayer.add(orbit, forKey: "orbit")
}


//// Create pulsing layer
//let pulsingLayer: CAShapeLayer = {
//    // Init shape layer
//    let layer = CAShapeLayer()
//    // Colour & settings
//    layer.fillColor = UIColor.lightGray.cgColor
//    layer.strokeColor = UIColor.clear.cgColor
//    layer.strokeEnd = 1
//    // Create & Apply path
//    let path = UIBezierPath(arcCenter: center, radius: CGFloat(radius), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true
//    )
//    layer.path = path.cgPath
//    // Anchor Layer
//    layer.anchorPoint = center
//    return layer
//}()

// Create inner track layer
let trackInner: CAShapeLayer = {
    // Init shape layer
    let layer = CAShapeLayer()
    // Colour & settings
    layer.fillColor = UIColor.clear.cgColor
    layer.strokeColor = UIColor.lightGray.cgColor
    layer.lineWidth = 1
    layer.strokeEnd = 1
    // Create & Apply path
    let path = UIBezierPath(arcCenter: center, radius: CGFloat(innerTrackRadius), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true
    )
    layer.path = path.cgPath
    return layer
}()

// Create outer track layer
let trackOuter: CAShapeLayer = {
    // Init shape layer
    let layer = CAShapeLayer()
    // Colour & settings
    layer.fillColor = UIColor.clear.cgColor
    layer.strokeColor = UIColor.lightGray.cgColor
    layer.lineWidth = 1
    layer.strokeEnd = 1
    // Create & Apply path
    let path = UIBezierPath(arcCenter: center, radius: CGFloat(outerTrackRadius), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true
    )
    layer.path = path.cgPath
    return layer
}()

// Create sun
let sun: CAShapeLayer = {
    // Init shape layer
    let layer = CAShapeLayer()
    // Colour & settings
    layer.fillColor = UIColor.yellow.cgColor
    layer.strokeColor = UIColor.clear.cgColor
    // Create & Apply path
    let path = UIBezierPath(arcCenter: center, radius: CGFloat(20), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true
    )
    layer.path = path.cgPath
    return layer
}()

// Create planet 1
let planet1: CAShapeLayer = {
    // Init shape layer
    let layer = CAShapeLayer()
    // Colour & settings
    layer.fillColor = UIColor.blue.cgColor
    layer.strokeColor = UIColor.clear.cgColor
    // Create & Apply path
    let origin = CGPoint(x: center.x, y: center.y + CGFloat(innerTrackRadius))
    let path = UIBezierPath(arcCenter: origin, radius: CGFloat(10), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true
    )
    layer.path = path.cgPath
    return layer
}()

// Create planet 2
let planet2: CAShapeLayer = {
    // Init shape layer
    let layer = CAShapeLayer()
    // Colour & settings
    layer.fillColor = UIColor.red.cgColor
    layer.strokeColor = UIColor.clear.cgColor
    // Create & Apply path
    let origin = CGPoint(x: center.x, y: center.y + CGFloat(outerTrackRadius))
    let path = UIBezierPath(arcCenter: origin, radius: CGFloat(10), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true
    )
    layer.path = path.cgPath
    return layer
}()



// Add shape layers
//view.layer.addSublayer(pulsingLayer)
view.layer.addSublayer(trackInner)
view.layer.addSublayer(trackOuter)
view.layer.addSublayer(sun)
view.layer.addSublayer(planet1)
view.layer.addSublayer(planet2)



// Add Animations
animateOrbitFor(shapeLayer: planet1, path: trackInner.path!)
animateOrbitFor(shapeLayer: planet2, path: trackOuter.path!)


//animatePulsing(shapeLayer: pulsingLayer)









