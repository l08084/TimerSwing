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
    private var setTime: String = "00:00"
    
    // Date Picker
    @IBOutlet weak var dateForm: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    
    // Date Pickerを回すと呼び出し
    @IBAction func DateSetting(sender: AnyObject) {
        
    }
    
    /// OKボタン押下すると呼び出し
    @IBAction func DateDecide(sender: AnyObject) {
        // アラームをセット
        setTime = tempTime
        
        // デフォルトRealmを取得する
        let realm = try! Realm()
        
        // 既存IDの最大値を取得
        var maxId: Int { return realm.objects(Alarm).sorted("id").last?.id ?? 0 }
        
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
            //realm.add(alarm)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 起動した時点の時刻をmyLabelに反映
        timeLabel.text = getNowTime()
        // 時間管理してくれる
        _ = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "update", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        // 現在時刻を取得
        let str = getNowTime()
        // timeLabelに反映
        timeLabel.text = str
        // アラーム鳴らすか判断
        myAlarm(str)
    }
    
    func myAlarm(str: String) {
        // 現在時刻が設定時刻と一緒なら
        if str == setTime {
            alert()
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

