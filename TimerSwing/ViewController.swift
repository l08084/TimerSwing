//
//  ViewController.swift
//  TimerSwing
//
//  Created by 中安拓也 on 2016/03/31.
//  Copyright © 2016年 l08084. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    private var tempTime: String = "00:00"
    
    // DBアクセスクラスをインスタンス化
    var repo: Repository = Repository()
    
    private var alartTimes: [String] = []
    
    private var enables: [Bool] = []
    
    private var alartId: [Int] = []
    
    private var onAlartTime: [String] = []
    
    // Date Picker
    @IBOutlet weak var dateForm: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 起動した時点の時刻をmyLabelに反映
        timeLabel.text = getNowTime()
        // 時間管理してくれる
        _ = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "update", userInfo: nil, repeats: true)
        
        repo = Repository()
        
        let alarms = repo.findAlarm()
        
        // 値を成形
        let format = NSDateFormatter()
        format.dateFormat = "HH:mm"
        
        for alarm in alarms {
            alartId.append(alarm.id)
            alartTimes.append(format.stringFromDate(alarm.alartTime))
            enables.append(alarm.enable)
        }
        
        for i in 0..<alartTimes.count {
            if enables[i] {
                onAlartTime.append(alartTimes[i])
            }
        }
        
        for time in onAlartTime {
            print("onAlartTime:\(time)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Date Pickerを回すと呼び出し
    @IBAction func DateSetting(sender: AnyObject) {
        
        
    }
    
    /// OKボタン押下すると呼び出し
    @IBAction func DateDecide(sender: AnyObject) {
        // アラームをセット
        //setTime = tempTime
        
        // デフォルトRealmを取得する
        let realm = try! Realm()
        
        let repo = Repository()
        
        // 既存IDの最大値を取得
        let maxId = repo.findMaxId()
        
        let alarm = Alarm()
        // 既存データのID最大値+1
        alarm.id = maxId + 1
        alarm.repeatCalendar = "everyDay"
        alarm.enable = true
        // date pickerでセットした値を代入
        alarm.alartTime = dateForm.date
        
        // Realmファイルが現在配置されている場所を表示
        print("realm:\(realm.path)")
        
        // トランザクションを開始して、オブジェクトをRealmに追加する
        try! realm.write {
            realm.add(alarm, update: true)
        }
    }
    
    func update() {
        // 現在時刻を取得
        let nowTime = getNowTime()
        // timeLabelに反映
        timeLabel.text = nowTime
        print("nowtime:\(nowTime)")
        // アラーム鳴らすか判断
        myAlarm(nowTime)
    }
    
    func myAlarm(nowTime: String) {
        // 現在時刻が設定時刻と一緒なら
        for setTime in onAlartTime {
            if nowTime == setTime {
                alert()
            }
        }
    }
    /// アラートの表示
    func alert() {
        let myAlert = UIAlertController(title: "alert", message: "ring ding", preferredStyle: .Alert)
        let myAction = UIAlertAction(title: "dong", style: .Default) {
            action in print("foo!!")
        }
        myAlert.addAction(myAction)
        presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func getNowTime() -> String {
        // 現在時刻を取得
        let nowTime: NSDate = NSDate()
        // 成形する
        let format = NSDateFormatter()
        format.dateFormat = "HH:mm"
        let nowTimeStr = format.stringFromDate(nowTime)
        // 成形した時刻を文字列として返す
        return nowTimeStr
    }

}

