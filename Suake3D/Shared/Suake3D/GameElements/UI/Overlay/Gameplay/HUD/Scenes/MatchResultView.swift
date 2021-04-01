//
//  MatchResultView.swift
//  Suake3D-swift
//
//  Created by dave on 07.03.20.
//  Copyright © 2020 ch.kimhauser. All rights reserved.
//

import Foundation
import SceneKit



class MatchResultsView : NSView, LoadableNib {
    
    @IBOutlet var contentView: NSView!
    
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var table: NSTableView!
    var loaded:Bool = false
    
    var scene:MatchResultsSkScene!
    
    @IBAction func onButtonTap(sender:Any) {
        self.closeResultsView()
    }
    
    func closeResultsView(){
        self.removeFromSuperview()
        if(scene != nil){
            scene.closeView()
        }
        self.loaded = false
        _ = self.scene.game.stateMachine.enter(SuakeStateReadyToPlay.self)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.frame = frameRect
        loadViewFromNib()
        let _:Timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
            self.loaded = true
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
}
