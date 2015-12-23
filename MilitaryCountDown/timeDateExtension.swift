//
//  extension.swift
//  MilitaryCountDown
//
//  Created by Yang Tun-Kai on 2015/12/23.
//  Copyright © 2015年 Yang Tun-Kai. All rights reserved.
//

import Foundation

extension NSDateComponents {
    /** returns the current date plus the receiver's interval */
    var fromNow: NSDate {
        let cal = NSCalendar.currentCalendar()
        return cal.dateByAddingComponents(self, toDate: NSDate(), options: [])!
    }
    
    /** returns the current date minus the receiver's interval */
    var ago: NSDate {
        let cal = NSCalendar.currentCalendar()
        return cal.dateByAddingComponents(self, toDate: NSDate(), options: [])!
    }
}

/** functions to convert integers into various time intervals */
extension Int {
    var minutes: NSDateComponents {
        let comps = NSDateComponents()
        comps.minute = self;
        return comps
    }
    
    var hours: NSDateComponents {
        let comps = NSDateComponents()
        comps.hour = self;
        return comps
    }
    
    var days: NSDateComponents {
        let comps = NSDateComponents()
        comps.day = self;
        return comps
    }
    
    var weeks: NSDateComponents {
        let comps = NSDateComponents()
        comps.day = 7 * self;
        return comps
    }
    
    var months: NSDateComponents {
        let comps = NSDateComponents()
        comps.month = self;
        return comps
    }
    
    var years: NSDateComponents {
        let comps = NSDateComponents()
        comps.year = self;
        return comps
    }
}