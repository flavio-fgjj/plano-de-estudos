import UIKit

struct NotificationIdentifier {
    static let confirm = "Confirm"
    static let cancel = "Cancel"
    static let category = "Lembrete"
    static let confirmed = "Confirmed"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        center.delegate = self
        center.getNotificationSettings { setting in
            switch setting.authorizationStatus {
            case .notDetermined:
                self.center.requestAuthorization(options: [.sound, .alert, .badge, .carPlay]) { authorized, error in
                    if let error = error {
                        print("Deu ruim! Erro: ", error.localizedDescription)
                    }
                    
                    print("O usuário autorizou?", authorized)
                }
            case .authorized:
                print("O usuário já aceitou. Só alegria!")
            default:
                print("Provavelmente o usuário não aceitou.")
            }
        }
        
        let confirmAction = UNNotificationAction(identifier: NotificationIdentifier.confirm,
                                                 title: "Já estudei 👍🏻",
                                                 options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: NotificationIdentifier.cancel,
                                                title: "Cancelar",
                                                options: [])
        
        let category = UNNotificationCategory(identifier: NotificationIdentifier.category,
                                              actions: [confirmAction, cancelAction],
                                              intentIdentifiers: [])
        
        center.setNotificationCategories([category])
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("O app foi registrado para receber push notifications")
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("Aqui está o seu token:", token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Errrooouuuuuuuuu", error)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let title = response.notification.request.content.title
        
        switch response.actionIdentifier {
        case NotificationIdentifier.confirm:
            print("O usuário apertou o botão de confirmar.")
            let id = response.notification.request.identifier
            
            // central de notificações interna do app
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationIdentifier.confirmed),
                                            object: nil,
                                            userInfo: ["id": id])
        case NotificationIdentifier.cancel:
            print("O usuário apertou o botão de cancelar.")
        case UNNotificationDefaultActionIdentifier:
            print("O usuário apertou na notificação")
        case UNNotificationDismissActionIdentifier:
            print("O usuário dismissou na notificação")
        default:
            print("alguma outra coisa")
        }
        
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner])
    }
}
