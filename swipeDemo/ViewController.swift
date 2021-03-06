//
//  ViewController.swift
//  swipeDemo
//
//  Created by dida on 2018/3/13.
//  Copyright © 2018年 given6. All rights reserved.
//

import UIKit
import SnapKit

let GNScreenW = UIScreen.main.bounds.size.width
let GNScrennH = UIScreen.main.bounds.size.height

class ViewController: UIViewController,UIScrollViewDelegate{

    var titleView =  UIView()
    var titleBtns:[UIButton] = []
    var isClick:Bool!
    ///内容视图
    var contentScrollow = UIScrollView()
    ///下滑线
    var lineView = UIView()
    ///保存上一次点击的按钮
    var perBtn = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.orange
     
        setupTitleView()
        
        customScrollview()
        
        addChildCustomViewController()
      
        // 默认点击下标为0的标题按钮
        titleBtnClick(sender: titleBtns[0])
    }

    func addChildCustomViewController(){
        
        
        let VC1 = UIViewController()
        VC1.view.backgroundColor = UIColor.yellow
        addChildViewController(VC1)
        
        let VC2 = UIViewController()
        VC2.view.backgroundColor = UIColor.gray
        addChildViewController(VC2)
        
        let count = childViewControllers.count
        contentScrollow.contentSize = CGSize(width:CGFloat(count) * GNScreenW , height:0)
  
    }
    
    
    
    func setupTitleView(){
        
        titleView = UIView(frame:CGRect(x:0, y:0, width:GNScreenW/2, height:40))
        titleView.backgroundColor = UIColor.red
        navigationItem.titleView = titleView
        
        //添加按钮
        addAllTitleBtns()
        
        //添加下滑线
        setupUnderLineView()
        
    
    }
    
    func addAllTitleBtns() {
        
        let titles = ["推荐","关注"]
        
        let btnW = titleView.bounds.size.width/2
        let btnH = titleView.bounds.size.height
        for (index,_) in titles.enumerated(){
            
            let button = UIButton(frame:CGRect(x:btnW * CGFloat(index), y:0, width:btnW, height:btnH))
            button.tag = index
            button.setTitle(titles[index], for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.yellow, for: .selected)
            titleView.addSubview(button)
            titleBtns.append(button)
            button.addTarget(self, action: #selector(titleBtnClick(sender:)), for:.touchDown)
            
   
        }
        
    }
    
    
    @objc func titleBtnClick(sender : UIButton)  {
        
        isClick = true
        
        ///点击
        perBtn.isSelected = false
        sender.isSelected = true
        perBtn = sender
        let tag = sender.tag
        
        //处理下滑线移动
        UIView.animate(withDuration:0.25) {
            self.lineView.width = (sender.titleLabel?.width)!
            self.lineView.centerX = sender.centerX
            ///修改contentScrollView的偏移量，点击标题按钮的时候显示对应子控制器的view
            self.contentScrollow.contentOffset = CGPoint(x: CGFloat(tag) * GNScreenW , y:0)
        }
        
        ///添加子控制器view
        let vc = childViewControllers[tag]
        ///如果添加过就不用重复添加
        if ((vc.view.superview) != nil) {
            return
        }
        vc.view.frame = CGRect(x:CGFloat(tag) * GNScreenW , y:0 , width:GNScreenW , height:GNScrennH - 64)
        contentScrollow.addSubview(vc.view)
    
    }
    
    func setupUnderLineView(){

        
        //获取下标为0的按钮
        let titleBtn = titleBtns[0]
        lineView.backgroundColor = UIColor.green
        //下滑线高度
        let lineViewH:CGFloat = 2
        let lineViewY:CGFloat = titleView.height - lineViewH
        lineView.height = lineViewH
        lineView.y = lineViewY
        //设置下滑线的宽度比文本内容宽度大10
        titleBtn.titleLabel?.sizeToFit()
        lineView.width = (titleBtn.titleLabel?.width)! + 2
        lineView.centerX = titleBtn.centerX
        //添加到titleView里
        titleView.addSubview(lineView)
    
    }
    
    func customScrollview(){

        contentScrollow.frame = CGRect(x:0 , y:64 , width:GNScreenW , height:GNScrennH-64)
        view.addSubview(contentScrollow)
        contentScrollow.delegate = self
        contentScrollow.isPagingEnabled = true
        contentScrollow.bounces = false
        contentScrollow.showsHorizontalScrollIndicator = false
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //开始拖动的时候
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isClick = false
    }

    
 
    /// ScrollView delegateFunc
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //计算拖拽比例
        var retio:CGFloat = scrollView.contentOffset.x / scrollView.width
        //将整数部分减掉，保留小数部分的比例（控制器比例的范围0~1.0）
        retio -= CGFloat(perBtn.tag)
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        
        if isClick{
           
            let titleBtn = titleBtns[index]
            lineView.x = (titleBtn.titleLabel?.x)!
            lineView.width = (titleBtn.titleLabel?.width)!
            lineView.centerX = titleBtn.centerX
            
            isClick = true
        }else{
            //设置下滑线centerX

            if (retio > 0){
                
                lineView.x = (perBtn.titleLabel?.x)!
                lineView.width = perBtn.centerX + scrollView.contentOffset.x / 2.5 + 15
                
                if (scrollView.contentOffset.x > 180){
                    
                    let btn = titleBtns[1]
                    lineView.x = scrollView.contentOffset.x / 2.5 + 15 - perBtn.centerX
                    lineView.width = (btn.centerX + btn.width) - (scrollView.contentOffset.x / 2.5) - 45
                    
                }
                
                
            }else{
                
                lineView.x = 15 + scrollView.contentOffset.x / 5
                lineView.width = perBtn.centerX - scrollView.contentOffset.x / 5
                if(scrollView.contentOffset.x < 180){
                    
                    let btn = titleBtns[0]
                    lineView.x = (btn.titleLabel?.x)!
                    lineView.width = btn.width + (scrollView.contentOffset.x / 5) - 20
                    
                    
                }
                
                
            }

        }
        
    }

    
    //减速时调用
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    //结束拖动时调用
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        let titleBtn = titleBtns[index]
        
        //调用标题按钮的点击事件
        titleBtnClick(sender: titleBtn)
    }
    
    
}

