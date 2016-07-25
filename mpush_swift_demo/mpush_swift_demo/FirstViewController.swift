//
//  FirstViewController.swift
//  mpush_swift_demo
//
//  Created by fuyuan.lfy on 16/7/19.
//  Copyright © 2016年 alibaba.qa. All rights reserved.
//

import UIKit

class Student {
    init(name : String) {
        self.name = name
        self.nickname = name
    }
    var nickname : String
    var name : String {
        willSet {
            nickname = "nick: " + newValue
        }
    }
}
enum Rank : Int {
    case Ace
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    func SimpleDesc() -> String {
        switch self {
        case .Ace:
            return "Ace"
        case .Two:
            return "Two"
        default:
            return String(self.rawValue)
        }
    }
}
class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(getAvg(1, 2, 3))
        
        let numbers = [1, 2, 3, 4];
        let anoNumbers = numbers.map({
            (num: Int) -> Double in
            3 * Double(num)
        })
        print(anoNumbers)
        print(numbers)
        print(getBigger(3, b: 4) { $0 > $1 })
        let s = Student(name: "aaa")
        s.name = "bbb"
        print(s.nickname)
        print(s.name)
        
        let rank1 = Rank.Ace, rank2 = Rank.Jack
        if (rank2.rawValue > rank1.rawValue){
            print("Jack win")
        } else {
            print("Ace win")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getAvg(numbers: Int...) -> Double {
        var sum = 0.0
        for num in numbers {
            sum += Double(num)
        }
        return sum/Double(numbers.count)
    }
    
    func getBigger(a: Int, b: Int, comp:(Int, Int) -> Bool) -> Int {
        if comp(a, b) {
            return a
        } else {
            return b
        }
    }
}

protocol ExamProtocol {
    var simpleDesc : String {get}
    mutating func adjust()
}


