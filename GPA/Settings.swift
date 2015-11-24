//
//  Settings.swift
//  GPA
//
//  Created by Pedro on 23/11/15.
//  Copyright © 2015 Pedro. All rights reserved.
//

import Foundation

struct SettingItem {
    let name: String
    let hasLink: Bool
    
    init(title: String, link: Bool) {
        name = title
        hasLink = link
    }
}

struct Setting {
    let name: String
    let items: [SettingItem]
    
    init(header: String, objects: [SettingItem]) {
        name = header
        items = objects
    }
}

class SettingsData {
    func getSettingsFromData() -> [Setting] {
        var settings = [Setting]()
        
        let accounts = Setting(header: "Accounts", objects: [
            SettingItem(title: "Facebook", link: false),
            SettingItem(title: "Add new account...", link: true)
        ])
        let notifications = Setting(header: "Notifications", objects: [
            SettingItem(title: "One", link: false),
            SettingItem(title: "Two", link: false)
        ])
        
        settings.append(accounts)
        settings.append(notifications)
        
        return settings
    }
}