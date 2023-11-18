//
//  Constants.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/13/23.
//

import Foundation
import SwiftUI

class Constants {
    static let sidePadding: CGFloat = 25
    static let sheetPadding: CGFloat = 30
    static let tabBarSafeArea: CGFloat = 80 // Height of tab bar gradient to pad content
    
//    static let sheetPresentationAnimation: Animation = .snappy(duration: 0.35)
    static let sheetPresentationAnimation: Animation = .smooth(duration: 0.3)
    static let sheetPresentationStiffAnimation: Animation = .bouncy(duration: 0.35, extraBounce: -0.03)
    static let datePickerAnimation: Animation = .bouncy(duration: 0.3)
    
    static let setsRange: ClosedRange = 1...10
    static let repsRange: ClosedRange = 1...10
    
    static let restTimeMinutesRange: ClosedRange = 0...10
    static let secondsRange: ClosedRange = 0...59
    
    static let weightRange: Range = 0..<1000
    
//    static let streaksDays: Int = 3
    static let minStreak: Int = 3
    
    static let streakNotificationIdentifier: String = "streak notification"

}


class UserSettings {
    static let streakDaysKey = "streakDays"
    
    static func prepare() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(ubiquitousKeyValueStoreDidChange(_:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: NSUbiquitousKeyValueStore.default)
        /** Note: By passing the default key-value store object as "object" it tells iCloud that
            this is the object whose notifications you want to receive.
        */
        
        // Get any KVStore change since last launch.
        
        /** This will spark the notification "NSUbiquitousKeyValueStoreDidChangeExternallyNotification",
            to ourselves to listen for iCloud KVStore changes.
        
            It is important to only do this step *after* registering for notifications,
            this prevents a notification arriving before code is ready to respond to it.
        */
        if NSUbiquitousKeyValueStore.default.synchronize() == false {
            fatalError("This app was not built with the proper entitlement requests.")
        }
    }
    
    @objc
    static private func ubiquitousKeyValueStoreDidChange(_ notification: Notification) {
        
        /** We get more information from the notification, by using:
            NSUbiquitousKeyValueStoreChangeReasonKey or NSUbiquitousKeyValueStoreChangedKeysKey
            constants on the notification's useInfo.
         */
        guard let userInfo = notification.userInfo else { return }
        
        // Get the reason for the notification (initial download, external change or quota violation change).
        guard let reasonForChange = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int else { return }
        
        /** Reasons can be:
            NSUbiquitousKeyValueStoreServerChange:
            Value(s) were changed externally from other users/devices.
            Get the changes and update the corresponding keys locally.
         
            NSUbiquitousKeyValueStoreInitialSyncChange:
            Initial downloads happen the first time a device is connected to an iCloud account,
            and when a user switches their primary iCloud account.
            Get the changes and update the corresponding keys locally.

            Do the merge with our local user defaults.
            But for this sample we have only one value, so a merge is not necessary here.

            Note: If you receive "NSUbiquitousKeyValueStoreInitialSyncChange" as the reason,
            you can decide to "merge" your local values with the server values.

            NSUbiquitousKeyValueStoreQuotaViolationChange:
            Your app’s key-value store has exceeded its space quota on the iCloud server of 1mb.

            NSUbiquitousKeyValueStoreAccountChange:
            The user has changed the primary iCloud account.
            The keys and values in the local key-value store have been replaced with those from the new account,
            regardless of the relative timestamps.
         */
        
        // Check if any of the keys we care about were updated, and if so use the new value stored under that key.
        guard let keys =
            userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] else { return }
        
        guard keys.contains(streakDaysKey) else { return }

        if reasonForChange == NSUbiquitousKeyValueStoreAccountChange {
            // User changed account, so fall back to use UserDefaults (last color saved).
            streakDays = UserDefaults.standard.integer(forKey: streakDaysKey)
            return
        }
        
        /** Replace the "selectedColor" with the value from the cloud, but *only* if it's a value we know how to interpret.
            It is important to validate any value that comes in through iCloud, because it could have been generated
            by a different version of your app.
         */
        let possibleStreakDaysFromiCloud =
            NSUbiquitousKeyValueStore.default.longLong(forKey: streakDaysKey)
        
//        if let valueInt64 = Int(possibleStreakDaysFromiCloud) {
        streakDays = Int(possibleStreakDaysFromiCloud)
        
        print("setting to \(streakDays)")
//        }

        /** The value isn't something we can understand.
             The best way to handle an unexpected value depends on what the value represents, and what your app does.
              good rule of thumb is to ignore values you can not interpret and not apply the update.
         */
        Swift.debugPrint("WARNING: Invalid \(streakDaysKey) value,")
        Swift.debugPrint("of \(possibleStreakDaysFromiCloud) received from iCloud. This value will be ignored.")
    }
    
    static var streakDays: Int {
        get {
            if UserDefaults.standard.integer(forKey: streakDaysKey) == 0 {
                UserDefaults.standard.set(3, forKey: streakDaysKey) // Setting default
            }
            return UserDefaults.standard.integer(forKey: streakDaysKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: streakDaysKey)
            NSUbiquitousKeyValueStore.default.set(newValue, forKey: streakDaysKey)
        }
    }}
