//
//  CreditsSkScene.swift
//  Suake3D
//
//  Created by dave on 01.08.18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import SpriteKit

class MatchResultsSkScene : SuakeBaseOverlay, NSTableViewDataSource, NSTableViewDelegate {
    
    var customView:MatchResultsView!
    var topLevelObjects : NSArray?
    var tableView:NSTableView!
    
    override init(size: CGSize) {
        super.init(size: size)
        self.sceneNode = self.scene
    }
    
    convenience init(game:GameController) {
        self.init(size: (game.scnView.window?.frame.size)!)
        self.game = game
        self.sceneNode = self.scene
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func showOverlayScene() {
        super.showOverlayScene()
    }
    
    override func didMove(to view: SKView) {
        DispatchQueue.main.async {
            if(!self.isLoaded){
                self.isLoaded = true
                self.customView = self.loadView()!
                var f:NSRect = self.customView.contentView!.frame
                f.size.width = self.game.gameWindowSize.width
                f.size.height = self.game.gameWindowSize.height
                self.customView.contentView!.frame = f
                view.addSubview(self.customView)
                
                self.tableView = self.customView.table
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                self.tableView.backgroundColor = .clear
                let restSize = self.tableView.frame.size.width - (self.tableView.tableColumns[0] as NSTableColumn).width - 10
                (self.tableView.tableColumns[1] as NSTableColumn).width = restSize / 2
                (self.tableView.tableColumns[2] as NSTableColumn).width = restSize / 2
            }
        }
    }
    
    private func loadView()->MatchResultsView?{
        let f:NSRect = NSRect(x: 0, y: 0, width: game.gameWindowSize.width, height: game.gameWindowSize.height)
        let ret = MatchResultsView(frame: f)
        ret.scene = self
        return ret
    }
    
    fileprivate enum CellIdentifiers {
        static let TopicCell = "TopicCell"
        static let RedCell = "RedCell"
        static let BlueCell = "BlueCell"
    }
    
    @objc func closeView(){
        self.unloadView()
        self.removeFromParent()
        self.game.stateMachine.stateMatchOver.resultsShowIng = false
        self.game.cameraHelper.blurVision(blurOn: .BlurOff)
        _ = self.game.stateMachine.returnToOldState()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        var textColor:NSColor = NSColor.black
        let newRow:Int = row

        if tableColumn == tableView.tableColumns[0] {
            if(row == 0){
                text = "Topic"
            }else{
                text = SuakeStatsType.allCases[newRow - 1].rawValue
            }
            cellIdentifier = CellIdentifiers.TopicCell
            textColor = NSColor.suake3DTextColor
        } else if tableColumn == tableView.tableColumns[1] {
            if(newRow <= 0){
                text = "Red"
            }else{
                text = self.game.playerEntityManager.ownPlayerEntity.statsComponent.suakeStats.getStatsValue(suakeStatsType: SuakeStatsType.allCases[newRow - 1]).description
            }
            cellIdentifier = CellIdentifiers.RedCell
            textColor = NSColor.suake3DRed
        } else if tableColumn == tableView.tableColumns[2] {
            if(newRow <= 0){
                text = "Blue"
            }else{
                text = self.game.playerEntityManager.oppPlayerEntity.statsComponent.suakeStats.getStatsValue(suakeStatsType: SuakeStatsType.allCases[newRow - 1]).description // "T3S3T" //""
            }
            textColor = NSColor.suake3DOppBlue// NSColor(named: "Suake3DOpponentBlue")!
            cellIdentifier = CellIdentifiers.BlueCell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.textField?.font = NSFont(name: SuakeVars.defaultFontName, size: 24.0)
            cell.textField?.sizeToFit()
            cell.setFrameSize((cell.textField?.frame.size)!)
            cell.textField?.setFrameOrigin(NSZeroPoint)
            cell.textField?.backgroundColor = NSColor.clear
            cell.textField?.textColor = textColor
            tableView.rowHeight = (cell.textField?.frame.height)! + 2
            
            return cell
        }
        return nil
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return SuakeStatsType.allCases.count + 1
    }
    
    public func unloadView() {
        if(self.isLoaded){
            self.isLoaded = false
            customView.removeFromSuperview()
        }
    }
}
