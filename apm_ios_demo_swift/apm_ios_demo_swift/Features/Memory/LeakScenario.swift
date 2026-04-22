import UIKit

protocol LeakScenarioSimulating: AnyObject {
    func createScenario()
}

final class ViewControllerLeakScenario: LeakScenarioSimulating {
    private var hasCreatedScenario = false

    func createScenario() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.createScenario()
            }
            return
        }

        guard !hasCreatedScenario else {
            return
        }

        hasCreatedScenario = true

        let viewControllerA = LeakyViewController(leakName: "A")
        let viewControllerB = LeakyViewController(leakName: "B")
        let viewControllerC = LeakyViewController(leakName: "C")

        viewControllerA.loadViewIfNeeded()
        viewControllerB.loadViewIfNeeded()
        viewControllerC.loadViewIfNeeded()

        viewControllerA.nextController = viewControllerB
        viewControllerB.nextController = viewControllerC
        viewControllerC.nextController = viewControllerA

        let addressA = Unmanaged.passUnretained(viewControllerA).toOpaque()
        let addressB = Unmanaged.passUnretained(viewControllerB).toOpaque()
        let addressC = Unmanaged.passUnretained(viewControllerC).toOpaque()

        print("已创建 Swift UIViewController ABC 循环引用: A(\(addressA)) -> B(\(addressB)) -> C(\(addressC)) -> A")
    }
}
