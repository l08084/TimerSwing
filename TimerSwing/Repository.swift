//
//  Repository.swift
//  TimerSwing
//
//  Created by 中安拓也 on 2016/04/10.
//  Copyright © 2016年 l08084. All rights reserved.
//

import Foundation
import RealmSwift

/// DBアクセスクラス
public class Repository {
    
    let realm :Realm
    
    // 初期化処理
    init() {
        
        // デフォルトRealmを取得する
        realm = try! Realm()
        
        // Realmファイルが現在配置されている場所を表示
        print("realm:\(realm.path)")
    }
    
    /// DB(Realm)内容読み込み、対象テーブルはMasterWord（指定したpartのWord文字列配列を返す）
    /// - parameter part: 単語の品詞
    /// - returns: 引数の品詞にマッチした単語全て
    func findAlartTime() -> [String] {
        
        var resultList: [String] = []
        
        // 引数で指定した品詞の単語全てをDBから取得
        let alarms = realm.objects(Alarm)
        
        // DPの値を成形
        let format = NSDateFormatter()
        format.dateFormat = "HH:mm"
        
        // Word部分のみを取得
        for alarm in alarms {
            resultList.append(format.stringFromDate(alarm.alartTime))
        }
        
        return resultList
    }
    
    func findMaxId() -> Int {
        // IDをキーに、キャラクターを取得
        let maxId = realm.objects(Alarm).sorted("id").last?.id ?? 0
        
        // 条件に該当するキャラは一つなので、一つだけ戻す
        return maxId
    }
    
    func findAlarm() -> Results<Alarm> {
        
        let alarms = realm.objects(Alarm)
        
        return alarms
    }
    
    func saveAlarmEnable(id: Int) {
        
    }

    
}
