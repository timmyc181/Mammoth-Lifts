import Foundation
import UserNotifications

class Notifications {
    static private func registerForNotifications(then completionHandler: @escaping () -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                completionHandler()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static private func checkStatus(ifEnabled action: @escaping () -> ()) {
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                registerForNotifications(then: action)
            case .denied:
                print("no notification, denied")
                break
            default:
                action()
            }
        })
    }
    
    static func setupNextWorkoutNotification(at date: Date) {
        checkStatus {
            let content = UNMutableNotificationContent()
            
            // Remove current notification if it exists
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [Constants.streakNotificationIdentifier])
            
            content.title = "You gotta lift today"
            content.body = "Lift today or you will lose your streak"
            content.sound = .default
            
            var dateComponents = Calendar.current.dateComponents([.day, .month, .year, .calendar, .timeZone], from: date)
//            var dateComponents = Calendar.current.dateComponents([.day, .month, .year, .calendar, .timeZone, .minute, .hour], from: Date())
            dateComponents.hour = 10
//            dateComponents.minute = (dateComponents.minute ?? 0) + 1
               
            let trigger = UNCalendarNotificationTrigger(
                     dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: Constants.streakNotificationIdentifier,
                        content: content, trigger: trigger)
            
            print("Setting next workout notification at \(dateComponents.date?.formatted() ?? "error")")

            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
               if error != nil {
                   fatalError("Error with notifications")
                  // Handle any errors.
               }
            }
        }
        
    }
    
    static func removeNextWorkoutNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [Constants.streakNotificationIdentifier])
    }
}
