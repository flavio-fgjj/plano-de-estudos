import Foundation
import UserNotifications

final class StudyManager {
    
    // MARK: - Properties
    static let shared = StudyManager()
    private let userDefaults = UserDefaults.standard
	private var studyPlans: [StudyPlan] = []
	private let userDefaultKey = "studyPlans"
	
	var count: Int {
		studyPlans.count
	}
    
    // MARK: - Initializer
    private init() {
        if let data = userDefaults.data(forKey: userDefaultKey),
            let plans = try? JSONDecoder().decode([StudyPlan].self, from: data) {
            self.studyPlans = plans
        }
    }
	
	// MARK: - Methods
	func getStudyPlanAt(_ indexPath: IndexPath) -> StudyPlan {
		studyPlans[indexPath.row]
	}

    func savePlans() {
        if let data = try? JSONEncoder().encode(studyPlans) {
            userDefaults.set(data, forKey: userDefaultKey)
        }
    }
    
    func addPlan(_ studyPlan: StudyPlan) {
        studyPlans.append(studyPlan)
        savePlans()
    }
    
    func removePlan(at index: Int) {
        let id = studyPlans[index].id
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        studyPlans.remove(at: index)
        
        savePlans()
    }
    
    func setPlanDone(id: String) {
        if let studyPlan = studyPlans.first(where: {$0.id == id}) {
			studyPlan.done = true
            savePlans()
        }
    }
}
