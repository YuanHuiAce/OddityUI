//
//  ChooseView.swift
//  Pods
//
//  Created by Mister on 16/10/19.
//
//

import UIKit

///  原因按钮
class ReasonButton:UIButton {
    
    var clickSelected = false{
        
        didSet{
            
            self.layer.borderColor = clickSelected ? UIColor.red.withAlphaComponent(0.7).cgColor : UIColor.lightGray.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.clickSelected = !clickSelected
    }
}

protocol ChooseDelegate {
    
    /// 点击不喜欢按钮
    func ClickDisLikeAction()
}

class ChooseView: UIView {
    
    var delegate:ChooseDelegate!

    // 不喜欢按钮集合
    @IBOutlet var button1: ReasonButton!
    @IBOutlet var button2: ReasonButton!
    @IBOutlet var button3: ReasonButton!
    @IBOutlet var button4: ReasonButton!
    
    @IBAction func ClickDisLikeButton(){
    
        self.delegate.ClickDisLikeAction()
    }
}

/// 读取UIViewController的辅助类
public struct ViewLoader<T:UIView> {
    
    static func View(viewIndex:Int) -> T{
        
        guard let view =  Bundle.OddityBundle().loadNibNamed("Choose", owner: nil, options: nil)?[0] as? T else{ fatalError("无获取") }
        
        return view
    }
}
