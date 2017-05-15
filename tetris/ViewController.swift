//
//  ViewController.swift
//  tetris
//
//  Created by 加藤 舞子 on 2017/04/17.
//  Copyright © 2017年 加藤 舞子. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let BLOCK_SIZE = 20
    
    var startY:Int = 0
    
    var startX:Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        var block:Mino = Mino()
        print(block.element)
        
        var matrix:[[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [99,99,99, 0, 0, 0, 0, 0, 0,99,99,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,99],
                              [99,99,99,99,99,99,99,99,99,99,99,99]]
        
        var px:Int = 0
        var py:Int = 0
        
        for y in 0...22{
            px = 0
            for x in 0...11{
                
                if matrix[y][x] == 99 {
                    let rect = CAShapeLayer()
                    rect.strokeColor = UIColor.black.cgColor
                    rect.fillColor = UIColor.black.cgColor
                    //枠線サイズ
                    rect.lineWidth = 1.0
                    rect.path = UIBezierPath(rect:CGRect(x:px,y:py,width:BLOCK_SIZE,height:BLOCK_SIZE)).cgPath
                    self.view.layer.addSublayer(rect)
                } else if(y<4 && x<4 && block.element[y][x] == 1){
                    let rect = CAShapeLayer()
                    rect.strokeColor = UIColor.green.cgColor
                    rect.fillColor = UIColor.green.cgColor
                    //枠線サイズ
                    rect.lineWidth = 1.0
                    rect.path = UIBezierPath(rect:CGRect(x:px,y:py,width:BLOCK_SIZE,height:BLOCK_SIZE)).cgPath
                    self.view.layer.addSublayer(rect)
                }
                
                px += BLOCK_SIZE
            }
            py += BLOCK_SIZE
            
        }
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.onUpdate(_:)), userInfo: nil, repeats: true)
        
    }
    func drow(mino:[[Int]]){
        var px:Int = 0
        var py:Int = 0
        var ield = fieldMapping(data: self.matrix,mino: mino,startX: self.startX,startY: self.startY)
        for y in 0...FIELD_HEIGHT {
            px = 0
            for x in 0...FIELD_WIDTH {
                //四角インスタンス
                if (ield[y][x] != 0  && matrix[y][x] != WALL && self.matrix[y][x] < 10) {
                    self.matrix[y][x] = ield[y][x]
                    
                    let imageView = UIImageView(frame: CGRect(x: px, y: py, width: BLOCK_SIZE, height: BLOCK_SIZE))
                    imageView.image = UIImage(named: block.image)!
                    // UIImageViewのインスタンスをビューに追加
                    self.view.addSubview(imageView)
                }else if (self.matrix[y][x] > 9 && matrix[y][x] < WALL) {
                    self.matrix[y][x] = 100
                }
                
                //20px横にずらす
                px += BLOCK_SIZE
            }
            //20px縦に基準をずらす
            py += BLOCK_SIZE
        }
    }
    
    func fieldMapping( data:[[Int]],mino:[[Int]],startX:Int,startY:Int)-> [[Int]] {
        var px:Int
        var py:Int
        var code:Int
        
        var tmpData:[[Int]] = data
        for y in startY..<startY + mino[0].count{
            for x in startX..<startX + mino[0].count{
                px = x - startX // テトロミノパターンデータ配列用のインデックス
                py = y - startY // テトロミノパターンデータ配列用のインデックス
                code = mino[py][px]
                if(code != 0 && data[y][x] == 0){
                    tmpData[y][x] = code
                }
            }
        }
        
        return tmpData;
        
    }
    func onUpdate(_ timer:Timer) {
        self.startY = self.startY+1
        print(self.startY)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

