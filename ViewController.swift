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

//如果项目中存在左侧的抽屉,会与scrollView的手势产生冲突,重写UIScrollView的这个方法来解决
class HomeScrollView: UIScrollView {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let pan:UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            //scrollView的contentOffset.x为0时,返回false,可以左滑出抽屉
            if pan.translation(in: self).x > 0.0 && self.contentOffset.x == 0.0 {
                return false
            }
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}



class ViewController: UIViewController,UIScrollViewDelegate{
    
    ///导航栏titleView
    var titleView =  UIView()
    ///导航按钮数组
    var titleBtns:[UIButton] = []
    ///是否点击
    var isClick:Bool!
    ///内容视图
    var contentScrollow = UIScrollView()
    ///下滑线
    var lineView = UIView()
    ///保存上一次点击的按钮
    var perBtn = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
     
        setupTitleView()
        
        customScrollview()
        
        addChildCustomViewController()
      
        // 默认点击下标为0的标题按钮
        titleBtnClick(sender: titleBtns[0])
    }

  
    
    func setupTitleView(){
        
        titleView = UIView(frame:CGRect(x:0, y:0, width:GNScreenW/2, height:40))
        titleView.backgroundColor = UIColor.orange
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
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
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

    
    }
    
    func setupUnderLineView(){

        
        //获取下标为0的按钮
        let titleBtn = titleBtns[0]
        lineView.backgroundColor = UIColor.white
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

    
    func addChildCustomViewController(){
        
        
        let firstVC = UIViewController()
        firstVC.view.frame = CGRect(x:0 , y:0 , width:GNScreenW , height:GNScrennH - 64)
        firstVC.view.backgroundColor = UIColor.yellow
        
        let firstLabel = UILabel()
        firstLabel.text = "我是第1️⃣个控制器😁"
        firstLabel.textColor = UIColor.brown
        firstLabel.font = UIFont.systemFont(ofSize: 15)
        firstVC.view.addSubview(firstLabel)
        // 添加约束
        firstLabel.snp.remakeConstraints{ (make) in
            make.center.equalToSuperview()
        }
        contentScrollow.addSubview(firstVC.view)
        
        
        let secondVC = UIViewController()
        secondVC.view.frame = CGRect(x:GNScreenW , y:0 , width:GNScreenW , height:GNScrennH - 64)
        secondVC.view.backgroundColor = UIColor.green
        
        let secondLabel = UILabel()
        secondLabel.text = "我是第2️⃣个控制器😭"
        secondLabel.textColor = UIColor.brown
        secondLabel.font = UIFont.systemFont(ofSize: 15)
        secondVC.view.addSubview(secondLabel)
        secondLabel.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
        }
        contentScrollow.addSubview(secondVC.view)
        contentScrollow.contentSize = CGSize(width:GNScreenW * 2 , height:0)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    /// ScrollView代理方法
    
    //开始拖动的时候
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isClick = false
    }

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

