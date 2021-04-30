//
//  RedeemerCrosshairLayer.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class RedeemerCrosshairView:SuakeGameClass {

    private var shapes = [RedeemerCrosshairLayer]()
    private let minimalSize = CGSize(width: 15, height: 15)
    
    var step: CGFloat = 12.0
    var shapeWidth: CGFloat = 1
    var shapesCount:Int = 3
    var animDuration:TimeInterval = 0.21
    
    override init(game:GameController) {
        super.init(game: game)
    }
    
    func generate(daView:NSView) {
        if shapes.count == 0 {
            generateShapes(daView: daView)
        }
        self.hide()
    }
    
    func animate(animated:Bool = false, completed block: @escaping (() -> Void)) {
        for i in 0..<shapes.count {
            if(i == shapes.count - 1){
                shapes[i].setupAnimation(duration: self.animDuration, delay: Double(i+1)/6.0, animated: animated, completed: block)
            }else{
                shapes[i].setupAnimation(duration: self.animDuration, delay: Double(i+1)/6.0, animated: animated)
            }
        }
    }

    private func generateShapes(daView:NSView) {
        let center:CGPoint = CGPoint(x: daView.frame.width / 2, y: daView.frame.height / 2)
        for i in 0..<shapesCount {
            let shape = RedeemerCrosshairLayer(game: self.game, id: i)
            shape.setup(size: CGSize(width: minimalSize.width + (step * CGFloat(i)), height: minimalSize.height + (step * CGFloat(i))), center: center, thickness: shapeWidth)
            //shape.setupAnimation(duration: 0.0, delay: 0, animated: true)
            if(i == 0){
                shape.drawStrokePaths()
            }
            shapes.append(shape)
            daView.layer!.addSublayer(shape)
        }
    }
    
    func hide(hide:Bool = true) {
        for shape in shapes{
            shape.isHidden = hide
        }
    }
}

class RedeemerCrosshairLayer: CAShapeLayer {
    
    var game:GameController!
    var animation = CAKeyframeAnimation(keyPath: "path")
    var animated:Bool = false
    var id:Int = 0
    var animationCompletionHandler: (()->Void)?
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    init(game:GameController, id:Int = 0) {
        self.game = game
        self.id = id
        super.init()
    }
    
    func setup(size:CGSize, center:CGPoint, thickness: CGFloat) {
        frame = CGRect(origin: CGPoint.zero, size: size)
        position = center
        self.initShapePaths()
        path = rectanglePath
        lineWidth = thickness
        strokeColor = NSColor.orange.cgColor
        fillColor = NSColor.clear.cgColor
        backgroundColor = .clear
        //self.transform = CATransform3DRotate(self.transform, 1.57, 0, 1, 0)
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "path" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    func setupAnimation(duration:TimeInterval, delay:TimeInterval, animated:Bool = false, completed block: (() -> Void)? = nil) {
        self.animationCompletionHandler = block
        DispatchQueue.main.async {
        self.animated = animated
        
        self.animation = CAKeyframeAnimation(keyPath: "path")
        self.animation.duration = 0.65
        self.animation.beginTime = CACurrentMediaTime() + delay
        
        self.animation.keyTimes = [0.0, 0.2, 0.6, 1.0]
        self.animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.66, 0.86, 0.11, 0.95)
        self.animation.speed = 1.0
        if(animated){
            self.path = self.circlePath!
            self.animation.values = [self.circlePath!, self.circlePath!, self.rectanglePath!, self.rectanglePath!]
            self.strokeColor = NSColor.orange.cgColor
        }else{
            self.path = self.rectanglePath!
            self.animation.values = [self.rectanglePath!, self.rectanglePath!, self.circlePath!, self.circlePath!]
//            self.strokeColor = NSColor.green.cgColor
        }
        self.animation.fillMode = .forwards
        self.animation.isRemovedOnCompletion = false
        self.animation.delegate = self
        self.add(self.animation, forKey: "path")
        self.game.showDbgMsg(dbgMsg: "Inside Redeemer cs animate to: " + animated.description, dbgLevel: .Info)
        }
    }
    
    private var circlePath:CGPath!
    private var rectanglePath:CGPath!
    private var crosshairPath:NSBezierPath!
    
    func initShapePaths(){
        let width2 = frame.size.width
        let height2 = frame.size.height
        let myPath2 = NSBezierPath()
//            myPath.lineCapStyle = .butt
//            myPath.lineJoinStyle = .miter
        
        // LEFT-DOWN TO MIDDLE (RIGHT-UP)
        myPath2.move(to: CGPoint.zero)
        myPath2.line(to: CGPoint(x: (width2 / 2) - 6.0, y: (height2 / 2) - 6.0))
        
        // RIGHT-UP TO MIDDLE (LEFT-DOWN)
        myPath2.move(to: CGPoint(x: (width2 / 2) + 18.0, y: (height2 / 2) + 18.0))
        myPath2.line(to: CGPoint(x: (width2 / 2) + 6.0, y: (height2 / 2) + 6.0))
        
        // LEFT-UP TO MIDDLE (RIGHT-DOWN)
        myPath2.move(to: CGPoint(x: 0, y: (height2 / 2) + 18.0))
        myPath2.line(to: CGPoint(x: (width2 / 2) - 6.0, y: (height2 / 2) + 6.0))
        
        // RIGHT-DOWN TO MIDDLE (LEFT-UP)
        myPath2.move(to: CGPoint(x: width2, y: (height2 / 2) - 18.0))
        myPath2.line(to: CGPoint(x: (width2 / 2) + 6.0, y: (height2 / 2) - 6.0))
        
        //myPath.addQuadCurve(to: CGPoint(x:width,y:0), controlPoint:CGPoint(x:width/2.0,y:0))
//            myPath.addQuadCurve(to: CGPoint(x:width,y:height), controlPoint:CGPoint(x:width,y:height/2.0))
//            myPath.addQuadCurve(to: CGPoint(x:0,y:frame.size.height), controlPoint:CGPoint(x:width/2.0,y:height))
//            myPath.addQuadCurve(to: CGPoint.zero, controlPoint:CGPoint(x:0,y:height/2.0))
        //myPath.close()
            
    //        //self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    //        let transform = NSAffineTransform(transform: .identity)
    //        //transform.translateX(by: -width, yBy: CGPoint.zero.y)
    //        transform.rotate(byRadians: CGFloat.pi / -4)// -CGFloat(M_PI_2))
    //        transform.translateX(by: width / -2, yBy: (width / 4))
    //        myPath.transform(using: transform as AffineTransform)
            
        self.crosshairPath = myPath2
        
        let circle = NSBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: frame.size))
        circle.close()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let transform = NSAffineTransform(transform: .identity)
        transform.translateX(by: center.x, yBy: center.y)
        transform.rotate(byRadians: CGFloat.pi / -2)// -CGFloat(M_PI_2))
        transform.translateX(by: -center.x, yBy: -center.y)
        circle.transform(using: transform as AffineTransform)
        
        if(id == 2){
            circle.append(self.crosshairPath)
        }
        
        self.circlePath = circle.cgPath
        
        let width = frame.size.width
        let height = frame.size.height
        let myPath = NSBezierPath()
        myPath.lineCapStyle = .butt
        myPath.lineJoinStyle = .miter
        myPath.move(to: CGPoint.zero)
        myPath.addQuadCurve(to: CGPoint(x:width,y:0), controlPoint:CGPoint(x:width/2.0,y:0))
        myPath.addQuadCurve(to: CGPoint(x:width,y:height), controlPoint:CGPoint(x:width,y:height/2.0))
        myPath.addQuadCurve(to: CGPoint(x:0,y:frame.size.height), controlPoint:CGPoint(x:width/2.0,y:height))
        myPath.addQuadCurve(to: CGPoint.zero, controlPoint:CGPoint(x:0,y:height/2.0))
        myPath.close()
        
        if(id == 2){
            myPath.append(self.crosshairPath)
        }
        self.rectanglePath = myPath.cgPath
        
        
    }
    
//    private var circlePath: CGPath {
//        let circle = NSBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: frame.size))
//        circle.close()
//
//        let center = CGPoint(x: bounds.midX, y: bounds.midY)
//        let transform = NSAffineTransform(transform: .identity)
//        transform.translateX(by: center.x, yBy: center.y)
//        transform.rotate(byRadians: CGFloat.pi / -2)// -CGFloat(M_PI_2))
//        transform.translateX(by: -center.x, yBy: -center.y)
//        circle.transform(using: transform as AffineTransform)
//
//        if(id == 2){
//            circle.append(self.crosshairPath)
//        }
//
//        return circle.cgPath
//    }
//
//    private var rectanglePath: CGPath {
//        let width = frame.size.width
//        let height = frame.size.height
//        let myPath = NSBezierPath()
//        myPath.lineCapStyle = .butt
//        myPath.lineJoinStyle = .miter
//        myPath.move(to: CGPoint.zero)
//        myPath.addQuadCurve(to: CGPoint(x:width,y:0), controlPoint:CGPoint(x:width/2.0,y:0))
//        myPath.addQuadCurve(to: CGPoint(x:width,y:height), controlPoint:CGPoint(x:width,y:height/2.0))
//        myPath.addQuadCurve(to: CGPoint(x:0,y:frame.size.height), controlPoint:CGPoint(x:width/2.0,y:height))
//        myPath.addQuadCurve(to: CGPoint.zero, controlPoint:CGPoint(x:0,y:height/2.0))
//        myPath.close()
//
//        if(id == 2){
//            myPath.append(self.crosshairPath)
//        }
////        //self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
////        let transform = NSAffineTransform(transform: .identity)
////        //transform.translateX(by: -width, yBy: CGPoint.zero.y)
////        transform.rotate(byRadians: CGFloat.pi / -4)// -CGFloat(M_PI_2))
////        transform.translateX(by: width / -2, yBy: (width / 4))
////        myPath.transform(using: transform as AffineTransform)
//
//        return myPath.cgPath
//    }
    
//    private var crosshairPath: NSBezierPath {
//        let width = frame.size.width
//        let height = frame.size.height
//        let myPath = NSBezierPath()
////            myPath.lineCapStyle = .butt
////            myPath.lineJoinStyle = .miter
//
//        // LEFT-DOWN TO MIDDLE (RIGHT-UP)
//        myPath.move(to: CGPoint.zero)
//        myPath.line(to: CGPoint(x: (width / 2) - 6.0, y: (height / 2) - 6.0))
//
//        // RIGHT-UP TO MIDDLE (LEFT-DOWN)
//        myPath.move(to: CGPoint(x: (width / 2) + 18.0, y: (height / 2) + 18.0))
//        myPath.line(to: CGPoint(x: (width / 2) + 6.0, y: (height / 2) + 6.0))
//
//        // LEFT-UP TO MIDDLE (RIGHT-DOWN)
//        myPath.move(to: CGPoint(x: 0, y: (height / 2) + 18.0))
//        myPath.line(to: CGPoint(x: (width / 2) - 6.0, y: (height / 2) + 6.0))
//
//        // RIGHT-DOWN TO MIDDLE (LEFT-UP)
//        myPath.move(to: CGPoint(x: width, y: (height / 2) - 18.0))
//        myPath.line(to: CGPoint(x: (width / 2) + 6.0, y: (height / 2) - 6.0))
//
//        //myPath.addQuadCurve(to: CGPoint(x:width,y:0), controlPoint:CGPoint(x:width/2.0,y:0))
////            myPath.addQuadCurve(to: CGPoint(x:width,y:height), controlPoint:CGPoint(x:width,y:height/2.0))
////            myPath.addQuadCurve(to: CGPoint(x:0,y:frame.size.height), controlPoint:CGPoint(x:width/2.0,y:height))
////            myPath.addQuadCurve(to: CGPoint.zero, controlPoint:CGPoint(x:0,y:height/2.0))
//        //myPath.close()
//
//    //        //self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//    //        let transform = NSAffineTransform(transform: .identity)
//    //        //transform.translateX(by: -width, yBy: CGPoint.zero.y)
//    //        transform.rotate(byRadians: CGFloat.pi / -4)// -CGFloat(M_PI_2))
//    //        transform.translateX(by: width / -2, yBy: (width / 4))
//    //        myPath.transform(using: transform as AffineTransform)
//
//            return myPath
//        }
    
    var strokeNodes:[SKShapeNode] = [SKShapeNode]()
    var centerPoint:CGPoint = CGPoint(x: 0, y: 0)
    var innerDist:CGFloat = 19.0
    var outerDist:CGFloat = 29.0
    var startColor:SKColor = SKColor.orange
    var endColor:SKColor = SKColor.green
    var nodeContainer:SKSpriteNode = SKSpriteNode()
    
    func drawStrokePaths(){
        
        // RIGHT 0
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x + innerDist, y: self.centerPoint.y), to: CGPoint(x: self.centerPoint.x + outerDist, y: self.centerPoint.y))))

        // LEFT 1
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - innerDist, y: self.centerPoint.y), to: CGPoint(x: self.centerPoint.x - outerDist, y: self.centerPoint.y))))

        // DOWN 2
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y - innerDist), to: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y - outerDist))))

        // UP 3
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y + innerDist), to: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y + outerDist))))
        
        var idx:Int = 0
        for stroke in self.strokeNodes{
            if(idx <= 1){
                stroke.xScale = 0.0
            }else{
                stroke.yScale = 0.0
            }
            idx += 1
        }
        
        //self.nodeContainer.addChild(self.nodeCrosshairShapes)
    }
    
    func createShapeFromPath(path:CGMutablePath)->SKShapeNode{
        let shapeNode = SKShapeNode()
        shapeNode.isAntialiased = false
        shapeNode.lineWidth = 1.0
        shapeNode.path = path
        shapeNode.strokeColor = self.startColor
        self.nodeContainer.addChild(shapeNode)
        return shapeNode
    }
    
    func drawStrokePath(from:CGPoint, to:CGPoint)->CGMutablePath{
        let path = CGMutablePath()
        path.move(to: from)
        path.addLine(to: to)
        path.closeSubpath()
        return path
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RedeemerCrosshairLayer: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
//        print("RedeemerCrosshairLayer - Animation started")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        print("RedeemerCrosshairLayer - Animation stopped")
//        self.removeAllAnimations()
        if(!self.animated){
            self.strokeColor = NSColor.green.cgColor
//            self.path = rectanglePath
//            self.animation.path = rectanglePath
        }else{
//            self.path = circlePath
//            self.animation.path = circlePath
        }
        if(self.animationCompletionHandler != nil){
            self.animationCompletionHandler!()
        }
    }
}
