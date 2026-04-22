import UIKit

private final class Box<T> {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}

private final class LeakyOwner {
    var timer: Timer?
    var box = Box<LeakyViewController?>(nil)
    var onTick: (() -> Void)?

    init(viewController: LeakyViewController) {
        box.value = viewController

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            self.onTick?()
        }

        onTick = { [self] in
            _ = self.box.value?.view
        }
    }

    deinit {
        print("LeakyOwner deinit")
    }
}

@objc(EAPMDemoLeakyViewController)
final class LeakyViewController: UIViewController {
    let leakName: String
    var nextController: LeakyViewController?

    private var owner: LeakyOwner?
    private var items: [Any] = []
    private var dictionary: [String: Any] = [:]

    init(leakName: String) {
        self.leakName = leakName
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swift Leak \(leakName)"

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        items = [leakName, Int(leakName.utf8.first ?? 0), UIView(), self]
        dictionary["viewController"] = self
        dictionary["items"] = items

        owner = LeakyOwner(viewController: self)
    }

    deinit {
        print("LeakyViewController \(leakName) deinit")
    }
}
