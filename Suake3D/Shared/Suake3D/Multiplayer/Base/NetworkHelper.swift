//
//  NetworkHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 30.03.21.
//

import Foundation

class NetworkHelper: SuakeGameClass {
    
    var testData:BaseNetworkData!
    
    override init(game: GameController) {
        super.init(game: game)
        
        print("\n ===== NetTest START ===== ")
        self.testData = BaseNetworkData(id: "1", msgType: 689)
        self.encodeAndSend()
        print(" =====  NetTest END  ===== \n")
    }
    
    func encodeAndSend(){
        do{
            let encoder:JSONEncoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // TODO Debug
            let encData:Data = try encoder.encode(self.testData)
            print(String(data: encData, encoding: .utf8)!)
            
            self.receiveAndDecoder(data: encData)
        }catch{
            print("Could not encode testData!")
        }
    }
    
    func receiveAndDecoder(data:Data){
        let decoder:JSONDecoder = JSONDecoder()
        let newObject:BaseNetworkData = try! decoder.decode(BaseNetworkData.self, from: data)//{
        
            print("newObject.id: \(newObject.id)")
            print("newObject.msgType: \(newObject.msgType)")
            
//        } else { return }
    }
}
