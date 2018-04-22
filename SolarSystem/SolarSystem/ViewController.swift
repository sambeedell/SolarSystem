//
//  ViewController.swift
//  SolarSystem
//
//  Created by Sam Beedell on 09/04/2018.
//  Copyright © 2018 Sam Beedell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Create properties
    let innerTrackRadius = 108.2
    let outerTrackRadius = 149.6
    
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
    
    func animateOrbitFor(view: UIView, path: CGPath, duration: CFTimeInterval) {
        
        let orbit = CAKeyframeAnimation(keyPath: "position")
        orbit.duration = duration
        orbit.repeatCount = Float.infinity
        orbit.path = path
        
        view.layer.add(orbit, forKey: "orbit")
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
        return layer
    }()
    
    // Create sun
    let sun: CAShapeLayer = {
        // Init shape layer
        let layer = CAShapeLayer()
        // Colour & settings
        layer.fillColor = UIColor.yellow.cgColor
        layer.strokeColor = UIColor.clear.cgColor
        return layer
    }()
    
    let planetRadius: CGFloat = 20
    
    // Create planet 1
    let venus: UIView = {
        // Init shape layer
        let r: CGFloat = 20 // planetRadius
        let view = UIView(frame:CGRect(x: 0, y: 0, width: r, height: r))
        // Colour & settings
        view.backgroundColor = .blue
        view.layer.cornerRadius = r / 2
        return view
    }()
    
    // Create planet 2
    let earth: UIView = {
        // Init shape layer
        let r: CGFloat = 20 // planetRadius
        let view = UIView(frame:CGRect(x: 0, y: 0, width: r, height: r))
        // Colour & settings
        view.backgroundColor = .red
        view.layer.cornerRadius = r / 2
        return view
    }()
    
    // Create views
    let containerView = UIView()
    var distanceLine: LineView!
    let path = UIBezierPath()
    let pathLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        containerView.frame = view.frame
        containerView.backgroundColor = .clear
        view.backgroundColor = .black
        let center = view.center
        
        // Create & apply paths
        let innerPath = UIBezierPath(arcCenter: center, radius: CGFloat(innerTrackRadius), startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        let outerPath = UIBezierPath(arcCenter: center, radius: CGFloat(outerTrackRadius), startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        // Create & apply sun dimensions
        let sunPath = UIBezierPath(arcCenter: center, radius: CGFloat(20), startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        sun.path = sunPath.cgPath
        trackInner.path = innerPath.cgPath
        trackOuter.path = outerPath.cgPath

        // Add shape layers
        //view.layer.addSublayer(pulsingLayer)
        view.layer.addSublayer(trackInner)
        view.layer.addSublayer(trackOuter)
        view.addSubview(containerView)
        view.layer.addSublayer(sun)
        view.addSubview(venus)
        view.addSubview(earth)
        
        // Add Animations
        let const: Double = 2
        animateOrbitFor(view: venus, path: trackInner.path!, duration: 13.0 / const)
        animateOrbitFor(view: earth, path: trackOuter.path!, duration: 8.0  / const)
        
        // Draw distance lines between planets
//        distanceLine = LineView(frame: view.frame, pointA: getCoordinatesA, pointB: getCoordinatesB)
//        containerView.addSubview(distanceLine)
        
        // Init bezier path stroke
        let rgb: Float = 0.7
        pathLayer.strokeColor = UIColor(colorLiteralRed: rgb, green: rgb, blue: rgb, alpha: 1.0).cgColor
        pathLayer.lineWidth = 0.5
        containerView.layer.addSublayer(pathLayer)
        
        // Start timer
        let fps: TimeInterval = 1 / (30 / const)
        let _ = Timer.scheduledTimer(timeInterval: fps, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            
        
    }
    
    func drawPath(a: CGPoint, b: CGPoint) {
        path.move(to: a)
        path.addLine(to: b)
        
        path.close()
        path.stroke()
        
        pathLayer.path = path.cgPath
    }
    
    @objc func update() {
        // Update distance lines between planets
        //distanceLine.updateLine(x: getCoordinatesA,y: getCoordinatesB)
        drawPath(a: getCoordinatesA, b: getCoordinatesB)
    }
    
    var getCoordinatesA: CGPoint {
        // Get the center of planet 1 during animation
        if let aFrame = venus.layer.presentation()?.frame {
            return CGPoint(x: aFrame.origin.x + planetRadius / 2, y: aFrame.origin.y + venus.frame.height / 2)
        }
        return venus.center
    }
    var getCoordinatesB:CGPoint {
        // Get the center of planet 1 during animation
        if let bFrame = earth.layer.presentation()?.frame {
            return CGPoint(x: bFrame.origin.x + planetRadius / 2, y: bFrame.origin.y + venus.frame.height / 2)
        }
        return earth.center
    }
    
    
}

class LineView : UIView {
    
    var pointA, pointB: CGPoint
    let context = UIGraphicsGetCurrentContext()
    
    init(frame: CGRect, pointA: CGPoint, pointB: CGPoint) {
        self.pointA = pointA
        self.pointB = pointB
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        if let context = context {
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.setLineWidth(1)
            context.beginPath()
            context.move(to: pointA) // This would be oldX, oldY
            context.addLine(to: pointB) // This would be newX, newY
            context.strokePath()
        }
    }
    
    func updateLine(x: CGPoint, y: CGPoint) {
        if let context = context {
            context.move(to: pointA)
            context.addLine(to: pointB)
            context.strokePath()
        }
    }
}



