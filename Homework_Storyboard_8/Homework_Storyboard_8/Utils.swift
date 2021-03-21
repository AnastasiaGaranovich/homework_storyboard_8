import UIKit

extension UIViewController {
    func getControllerFrom(storyboard: String, name: String) -> UIViewController {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: storyboard, bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: name)
    }
    func pushController(storyboard: String, name: String) {
        navigationController?.pushViewController(getControllerFrom(storyboard: storyboard, name: name), animated: true)
    }
    func pushController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
