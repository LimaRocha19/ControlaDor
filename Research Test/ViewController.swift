//
//  ViewController.swift
//  DrawPad
//
//  Created by Jean-Pierre Distler on 13.11.14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit
import ResearchKit
import CoreMotion

class ViewController: ORKStepViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var bodyImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!

    // MARK: - Coloring properties
    var lastPoint = CGPointZero
    var red: CGFloat = 255.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 20.0
    var opacity: CGFloat = 0.3
    var swiped = false

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 3
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1).CGColor
    }

    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if event?.subtype == UIEventSubtype.MotionShake {
            let alertController = UIAlertController(title: "Desfazer desenho", message: "", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                self.reset(self)
            })
            let cancel = UIAlertAction(title: "Cancelar", style: .Cancel, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            alertController.addAction(cancel)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Storyboard init

    class func instantiateViewControllerFromStoryboard(storyboard: UIStoryboard) -> ORKStepViewController? {
        return storyboard.instantiateViewControllerWithIdentifier("HumanBodyPain") as? ORKStepViewController
    }

    // MARK: - Drawing methods

    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        // 3
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, .Normal)
        // 4
        CGContextStrokePath(context)
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        view.bringSubviewToFront(tempImageView)
        UIGraphicsEndImageContext()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(view)
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImageView.image = nil
    }

    // MARK: - Actions

    @IBAction func segmentChanged(sender: UISegmentedControl) {
        reset(self)
        if sender.selectedSegmentIndex == 0 {
            bodyImageView.image = UIImage(named: "HumanBodyFront")
        } else {
            bodyImageView.image = UIImage(named: "HumanBodyBack")
        }
    }

    @IBAction func reset(sender: AnyObject) {
        mainImageView.image = nil
    }

    @IBAction func nextStep(sender: AnyObject) {
        goForward()
    }

    func share() {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
            width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let _ = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

