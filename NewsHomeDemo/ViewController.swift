//
//  ViewController.swift
//  NewsHomeDemo
//
//  Created by SoulJa on 16/6/23.
//  Copyright © 2016年 SoulJa. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var titleScrollView: UIScrollView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    let radio:CGFloat = 1.3
    let labelW:CGFloat = 100//设置titleLabel的宽度
    var selLabel = UILabel()
    var titleLabels:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //设置子控制器
        self.setupChildViewController()
        
        // 添加所有子控制器对应标题
        self.setupTitleLabel()
        
        self.setupScrollView()
    }
    
    func setupScrollView() {
        let count = self.childViewControllers.count;
        self.titleScrollView.contentSize = CGSizeMake(CGFloat(CGFloat(count) * labelW), 0);
        self.titleScrollView.showsHorizontalScrollIndicator = false;
        
        // 设置内容滚动条
        self.contentScrollView.contentSize = CGSizeMake(CGFloat(count) * UIScreen.mainScreen().bounds.size.width , 0);
        // 开启分页
        self.contentScrollView.pagingEnabled = true;
        // 没有弹簧效果
        self.contentScrollView.bounces = false;
        // 隐藏水平滚动条
        self.contentScrollView.showsHorizontalScrollIndicator = false;
        
        self.contentScrollView.delegate = self;
    }
    
    //MARK:设置自控制器
    func setupChildViewController() {
        //头条
        let topLine = TopLineViewController()
        topLine.title = "头条"
        self.addChildViewController(topLine)
        
        //热点
        let hot = HotViewController()
        hot.title = "热点"
        self.addChildViewController(hot)
        
        //视频
        let vedio = VedioViewController()
        vedio.title = "视频"
        self.addChildViewController(vedio)
        
        //社会
        let society = SocietyViewController()
        society.title = "社会"
        self.addChildViewController(society)
        
        //阅读
        let reader = ReaderViewController()
        reader.title = "阅读"
        self.addChildViewController(reader)
        
        //科技
        let science = ScienceViewController()
        science.title = "科技"
        self.addChildViewController(science)
    }
    
    //MARK:添加所有子控制器对应标题
    func setupTitleLabel() {
        let count = self.childViewControllers.count
        
        var labelX:CGFloat = 0
        let labelY:CGFloat = 0
        let labelH:CGFloat = 44
        
        for (var i=0;i<count;i += 1) {
            let vc = self.childViewControllers[i]
            let label = UILabel()
            labelX = CGFloat(i) * labelW
            label.frame = CGRectMake(labelX, labelY, labelW, labelH)
            label.text = vc.title
            label.highlightedTextColor = UIColor.redColor()
            label.tag = i
            label.userInteractionEnabled = true
            label.textAlignment = .Center
            self.titleLabels.addObject(label)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.titleClick(_:)))
            label.addGestureRecognizer(tapGesture)
            if (i==0) {
                self.titleClick(tapGesture);
            }
            self.titleScrollView.addSubview(label)
        }
        
    }
    
    func titleClick(tap:UITapGestureRecognizer)->(){
        let label:UILabel = tap.view as! UILabel
        self.selectView(label)
        
        let index = tap.view?.tag
        let offsetX = CGFloat(Float(index!)) * UIScreen.mainScreen().bounds.width
        self.contentScrollView.contentOffset = CGPointMake(offsetX, 0)
        
        self.showVc(index!)
        self.setupTitleCenter(label)
    }
    
    func setupTitleCenter(label:UILabel)->() {
        var offsetX = label.center.x - UIScreen.mainScreen().bounds.size.width * 0.5
        if (offsetX < 0) {
            offsetX = 0
        }
        
        let maxOffsetX = self.titleScrollView.contentSize.width - UIScreen.mainScreen().bounds.size.width
        
        if (offsetX > maxOffsetX) {
            offsetX = maxOffsetX
        }
        
        self.titleScrollView.setContentOffset(CGPointMake(offsetX, 0), animated: true)
    }
    
    func showVc(index:Int)->() {
        let offsetX = CGFloat(Float(index)) * UIScreen.mainScreen().bounds.width
        let vc = self.childViewControllers[index]
        if (vc.isViewLoaded()) {
            return;
        }
        vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height)
        self.contentScrollView.addSubview(vc.view)
    }
    
    func selectView(label:UILabel)->() {
        self.selLabel.highlighted = false
        self.selLabel.transform = CGAffineTransformIdentity
        
        label.highlighted = true
        label.transform = CGAffineTransformMakeScale(radio, radio)
        label.textColor = UIColor.blackColor()
        self.selLabel = label
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
        
        let leftIndex = curPage
        let rightIndex = leftIndex + 1
        
        let leftLabel = self.titleLabels[Int(leftIndex)]
        var rightLabe = UILabel()
        
        if  (rightIndex < CGFloat(self.titleLabels.count - 1)) {
           rightLabe = self.titleLabels[Int(rightIndex)] as! UILabel
        }
        
        let rightScale = curPage - leftIndex
        let leftScale = 1 - rightScale
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.bounds.size.width
        self.showVc(Int(index))
        let selLabel = self.titleLabels[Int(index)]
        self.selectView(selLabel as! UILabel)
        self.setupTitleCenter(selLabel as! UILabel)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

