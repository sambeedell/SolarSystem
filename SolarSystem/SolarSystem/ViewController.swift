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
    
    // Create planet 1
    let planet1: UIView = {
        // Init shape layer
        let r: CGFloat = 20
        let view = UIView(frame:CGRect(x: 0, y: 0, width: r, height: r))
        // Colour & settings
        view.backgroundColor = .blue
        view.layer.cornerRadius = r / 2
        return view
    }()
    
    // Create planet 2
    let planet2: UIView = {
        // Init shape layer
        let r: CGFloat = 20
        let view = UIView(frame:CGRect(x: 0, y: 0, width: r, height: r))
        // Colour & settings
        view.backgroundColor = .red
        view.layer.cornerRadius = r / 2
        return view
    }()
    
    
    
    
    
    let containerView = UIView()


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
        view.addSubview(planet1)
        view.addSubview(planet2)
        
        // Add Animations
        animateOrbitFor(view: planet1, path: trackInner.path!, duration: 20)
        animateOrbitFor(view: planet2, path: trackOuter.path!, duration: 30)
        
        
        
        
        // Start timer
        let _ = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            
        
    }
    
    @objc func update() {
        // Update planet locations
        var a = CGPoint(), b = CGPoint()
        if let aFrame = planet1.layer.presentation()?.frame {
            a = CGPoint(x: aFrame.origin.x + planet1.frame.width / 2, y: aFrame.origin.y + planet1.frame.height / 2)
        }
        if let bFrame = planet2.layer.presentation()?.frame {
            b = CGPoint(x: bFrame.origin.x + planet1.frame.width / 2, y: bFrame.origin.y + planet1.frame.height / 2)
        }
        
        // Draw distance lines between planets
        let distanceLine = LineView(frame: view.frame, pointA: a, pointB: b)
        containerView.addSubview(distanceLine)
    }
    
    
}

class LineView : UIView {
    
    var pointA, pointB: CGPoint
    
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
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.setLineWidth(1)
            context.beginPath()
            context.move(to: CGPoint(x: pointA.x, y: pointA.y)) // This would be oldX, oldY
            context.addLine(to: CGPoint(x: pointB.x, y: pointB.y)) // This would be newX, newY
            context.strokePath()
        }
    }
}



