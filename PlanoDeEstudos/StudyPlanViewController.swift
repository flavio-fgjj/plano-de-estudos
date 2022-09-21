import UIKit
import UserNotifications

final class StudyPlanViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private(set) weak var textFieldCourse: UITextField!
    @IBOutlet private(set) weak var textFieldSection: UITextField!
    @IBOutlet private(set) weak var datePickerDate: UIDatePicker!
    
    // MARK: - Properties
    private let studyManager = StudyManager.shared
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerDate.minimumDate = Date()
    }

    // MARK: - IBActions
    @IBAction func schedule(_ sender: UIButton) {
		let id = UUID().uuidString
        let studyPlan = StudyPlan(course: textFieldCourse.text!,
								  section: textFieldSection.text!,
								  date: datePickerDate.date,
								  done: false,
								  id: id)
        
        let content = UNMutableNotificationContent()
        content.title = "Lembrete"
        content.subtitle = "Matéria: \(studyPlan.course)"
        content.body = "Estudar \(studyPlan.section)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "ring.caf"))
        content.categoryIdentifier = NotificationIdentifier.category
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                             from: datePickerDate.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Deu ruim! Erro: ", error.localizedDescription)
            }
        }
        
        studyManager.addPlan(studyPlan)
        navigationController!.popViewController(animated: true)
    }
    
}
