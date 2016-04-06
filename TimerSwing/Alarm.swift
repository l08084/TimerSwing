//
//  Alarm.swift
//  TimerSwing
//
//  Created by 中安拓也 on 2016/04/06.
//  Copyright © 2016年 l08084. All rights reserved.
//

import Foundation
import RealmSwift

class Alarm: Object {
    
    dynamic var id = 0
    dynamic var alartTime = NSDate()
    dynamic var repeatCalendar = ""
    dynamic var enable = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
