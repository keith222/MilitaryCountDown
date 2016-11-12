//
//  extension.swift
//  MilitaryCountDown
//
//  Created by Yang Tun-Kai on 2015/12/23.
//  Copyright © 2015年 Yang Tun-Kai. All rights reserved.
//

import Foundation

extension DateComponents {
    /** returns the current date plus the receiver's interval */
    var fromNow: Date {
        let cal = Calendar.current
        return cal.date(byAdding: self, to: Date())!
    }
    
    /** returns the current date minus the receiver's interval */
    var ago: Date {
        let cal = Calendar.current
        return cal.date(byAdding: -self, to: Date())!
    }
    
    //return the specific date plus the receiver's interval
    func daysFrom(_ date: Date) -> Date{
        let cal = Calendar.current
        return cal.date(byAdding: self, to: date)!
    }
    
    func daysAgo(_ date: Date) -> Date{
        let cal = Calendar.current
        return cal.date(byAdding: -self, to: date)!
    }
}

/** helper method to DRY the code a little, adds or subtracts two sets of date components */
func combineComponents(_ left: DateComponents,right: DateComponents, multiplier: Int) -> DateComponents{
    var comps = DateComponents()
    comps.second = ((left.second! != NSDateComponentUndefined ? left.second! : 0) +
        (right.second! != NSDateComponentUndefined ? right.second! : 0) * multiplier)
    comps.minute = ((left.minute! != NSDateComponentUndefined ? left.minute! : 0) +
        (right.minute! != NSDateComponentUndefined ? right.minute! : 0) * multiplier)
    comps.hour = ((left.hour! != NSDateComponentUndefined ? left.hour! : 0) +
        (right.hour! != NSDateComponentUndefined ? right.hour! : 0) * multiplier)
    comps.day = ((left.day! != NSDateComponentUndefined ? left.day! : 0) +
        (right.day! != NSDateComponentUndefined ? right.day! : 0) * multiplier)
    comps.month = ((left.month! != NSDateComponentUndefined ? left.month! : 0) +
        (right.month! != NSDateComponentUndefined ? right.month! : 0) * multiplier)
    comps.year = ((left.year! != NSDateComponentUndefined ? left.year! : 0) +
        (right.year! != NSDateComponentUndefined ? right.year! : 0) * multiplier)
    return comps
}

/** adds the two sets of date components */
func +(left: DateComponents, right: DateComponents) -> DateComponents {
    return combineComponents(left, right: right, multiplier: 1)
}

/** subtracts the two sets of date components */
func -(left: DateComponents, right: DateComponents) -> DateComponents {
    return combineComponents(left, right: right, multiplier: -1)
}

/** negates the two sets of date components */
public prefix func -(comps: DateComponents) -> DateComponents {
    var result = DateComponents()
    
    if(comps.second != nil) { result.second = -comps.minute! }
    if(comps.minute != nil) { result.minute = -comps.minute! }
    if(comps.hour != nil) { result.hour = -comps.hour! }
    if(comps.day != nil) { result.day = -comps.day! }
    if(comps.month != nil) { result.month = -comps.month! }
    if(comps.year != nil) { result.year = -comps.year! }
    return result
}


/** functions to convert integers into various time intervals */
extension Int {
    var minutes: DateComponents {
        var comps = DateComponents()
        comps.minute = self;
        return comps
    }
    
    var hours: DateComponents {
        var comps = DateComponents()
        comps.hour = self;
        return comps
    }
    
    var days: DateComponents {
        var comps = DateComponents()
        comps.day = self;
        return comps
    }
    
    var weeks: DateComponents {
        var comps = DateComponents()
        comps.day = 7 * self;
        return comps
    }
    
    var months: DateComponents {
        var comps = DateComponents()
        comps.month = self;
        return comps
    }
    
    var years: DateComponents {
        var comps = DateComponents()
        comps.year = self;
        return comps
    }
}
