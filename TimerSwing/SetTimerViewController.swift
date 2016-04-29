//
//  SetTimerViewController.swift
//  TimerSwing
//
//  Created by 中安拓也 on 2016/04/09.
//  Copyright © 2016年 l08084. All rights reserved.
//

import UIKit

class SetTimerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var myTableView: UITableView!
    
    // Tableで使用する配列を設定する
    private var alartTimes: [String] = []
    
    private var enables: [Bool] = []
    
    private var alartId: [Int] = []
    
    var repo: Repository = Repository()
    
    private var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        
        // Cell名の登録をおこなう.
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceの設定をする.
        myTableView.dataSource = self
        
        // Delegateを設定する.
        myTableView.delegate = self
        
        repo = Repository()
        
        let alarms = repo.findAlarm()
        
        // DPの値を成形
        let format = NSDateFormatter()
        format.dateFormat = "HH:mm"
        
        for alarm in alarms {
            alartId.append(alarm.id)
            alartTimes.append(format.stringFromDate(alarm.alartTime))
            enables.append(alarm.enable)
        }
        
        // Viewに追加する
        self.view.addSubview(myTableView)
        
        myButton = UIButton()
        
        // ボタンを生成する.
        myButton.frame = CGRectMake(0, 0, 60, 60)
        myButton.backgroundColor = UIColor.redColor()
        myButton.setTitle("Back", forState: .Normal)
        myButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myButton.layer.masksToBounds = true
        myButton.layer.cornerRadius = 30.0
        myButton.layer.position = CGPointMake(self.view.frame.width/2, self.view.frame.height-100)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // ボタンを追加する.
        self.view.addSubview(myButton)
    }
    
    /*
    ボタンのアクション時に設定したメソッド.
    */
    internal func onClickMyButton(sender: UIButton){
        performSegueWithIdentifier("beforeView", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    Cellが選択された際に呼び出されるデリゲートメソッド.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(alartTimes[indexPath.row])")
        
        performSegueWithIdentifier("beforeView", sender: nil)
    }
    
    /*
    Cellの総数を返すデータソースメソッド.
    (実装必須)
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alartTimes.count
    }
    
    /*
    Cellに値を設定するデータソースメソッド.
    (実装必須)
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(alartTimes[indexPath.row])"
        
        // Switchを作成する
        let mySwitch: UISwitch = UISwitch()
        
        // SwitchをOnに設定する
        mySwitch.on = enables[indexPath.row]
        
        // SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する
        mySwitch.addTarget(self, action: "onClickMySwitch:", forControlEvents: UIControlEvents.ValueChanged)
        
        // cellの右端にSwitchをレイアウト
        cell.accessoryView = mySwitch
        
        return cell
    }
    
    
    /// UISwitchを切り替えたインデックスを取得
    internal func onClickMySwitch(sender: UISwitch) {
        
        var hoge = sender.superview
        
        while(hoge!.isKindOfClass(UITableViewCell) == false) {
            hoge = hoge!.superview
        }
        
        let cell = hoge as! UITableViewCell
        
        // touchIndexは選択したセルが何番目かを記録しておくプロパティ
        // indexPathForCellの引数が、UITableViewCellでなければいけないので、
        // 上の処理でUISwitchをUITableViewCellに変換している
        // 正直コピペなのでよくわかっていない
        let touchIndex = self.myTableView.indexPathForCell(cell)
        
        // UISitchを切り替えたセルがどれかを表示
        print("\(touchIndex!.row)番目のUISwitchを切り替えました")
        print("時間は、\(alartTimes[touchIndex!.row])")
        print("IDは、\(alartId[touchIndex!.row])")
        
        let alarm = Alarm()
        alarm.id = alartId[touchIndex!.row]
        // スイッチを切り替えると、enableが反転される
        alarm.enable = !enables[touchIndex!.row]
        
        repo.saveAlarmEnable(alarm)
        
    }
    
}
