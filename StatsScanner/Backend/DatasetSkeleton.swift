//
//  DatasetSkeleton.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 7/22/22.
//

import Foundation
import CoreData
import UIKit

@objc(Dataset)
public class Dataset: NSObject, NSCoding {
    
// MARK: Field Variables
    
    private var rawData : [[String]]!
    private var keys : [[String]]!
    private var numericalData : [Double]!
    private var calculations : [Double]!
    
    private var creationDate : String!
    private var name : String!
    private var icon : UIImage!
    
    private let db = DataBridge()
    private let formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter
    }()

// MARK: CoreData Configuration
    
    public func encode(with coder: NSCoder) {
        coder.encode(rawData, forKey: "rawData")
        coder.encode(keys, forKey: "keys")
        coder.encode(numericalData, forKey: "numericalData")
        coder.encode(calculations, forKey: "calculations")
        coder.encode(creationDate, forKey: "creationDate")
        coder.encode(name, forKey: "name")
        coder.encode(icon, forKey: "icon")
    }
    
    required convenience public init?(coder decoder: NSCoder) {
        self.init()
        
        self.rawData = decoder.decodeObject(forKey:"rawData") as? [[String]] ?? [[]]
        self.keys = decoder.decodeObject(forKey: "keys") as? [[String]] ?? [[""],[""],[""]]
        self.numericalData = decoder.decodeObject(forKey:"numericalData") as? [Double] ?? []
        self.calculations = decoder.decodeObject(forKey: "calculations") as? [Double] ?? []
        self.creationDate = decoder.decodeObject(forKey: "creationDate") as? String ?? ""
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.icon = decoder.decodeObject(forKey: "icon") as? UIImage
    }
    
//MARK: Initializers
    
    override init() {
        super.init()
        
        self.name = "New Unnamed Dataset"
        self.creationDate = formatter.string(from: Date())
        self.rawData = []
        self.keys = [[""],[""],[""]]
        self.numericalData = []
        self.calculations = Array<Double>(repeating: 0.0, count: 9)
    }
    
    init(name : String, appendable: [[String]]) {
        super.init()
        
        self.name = name
        self.creationDate = formatter.string(from: Date())
        self.rawData = appendable
        self.cleanRaw()
        self.keys = self.solveKeys(self.rawData)
        self.calculations = Array<Double>(repeating: 0.0, count: 9)
        self.updateNumData()
        self.calculations = Calculations(dataset : numericalData).calculate()
    }
    
    init(name : String) {
        super.init()
        print("New Dataset")
        self.name = name
        let rows = Int(UIScreen.main.bounds.height/50)
        self.rawData = Array<Array<String>>(repeating: Array<String>(repeating: "", count: 4), count: rows)
        self.creationDate = formatter.string(from: Date())
        self.numericalData = []
        self.keys = [[""], [""], [""]]
        self.calculations = Array<Double>(repeating: 0.0, count: 9)
        self.calculations = Calculations(dataset: numericalData).calculate()
    }
    
// MARK: Data Pre-Processing
    
    /// Resolves which axis of the CSV array are keys and adds those keys to a key array, the
    /// method always assumes the top header contains keys.
    /// @Return A 2D String array where the indices are Top, Left, and Right, respectively
    private func solveKeys(_ data:[[String]]) -> [[String]] {
        var res : [[String]] = [[""],[""],[""]]
        res[0] = data[0]
        
        var left : [String] = [""]
        var right : [String] = [""]
        
        for i in 0...data.count-1 {
            left.append(data[i][0])
        }
        
        for i in 0...data[data[0].count-1].count-1 {
            right.append(data[data[0].count-1][i])
        }
        
        return res
    }
    
    /// Cleans the raw CSV data and extracts the numerical values for calculation and visualization
    private func updateNumData() {
        var result = Array<Double>()
        for i in 0...self.rawData.count-1 {
            for j in 0...self.rawData[0].count-1 {
                if(self.rawData[i][j].isNumeric) {
                    result.append(Double(self.rawData[i][j])!)
                }
            }
        }
        
        self.numericalData = result
    }
    
   /// Clean rawData array
    private func cleanRaw() {
        print("cleaning raw data")
        for i in 0...self.rawData.count-1 {
            var count = 0
            for j in 0...self.rawData[0].count-1 {
                if (rawData[i][j].isEmpty) {
                    count+=1
                }
            }
            if (count == self.rawData[0].count) {
                self.rawData.remove(at: i)
            }
        }
        for j in 0...self.rawData[0].count-1 {
            var count = 0
            for i in 0...self.rawData.count-1 {
                let str = rawData[i][j].trimmingCharacters(in: .whitespacesAndNewlines)
                if (str.isEmpty) {
                    count+=1
                }
            }
            if (count == self.rawData.count) {
                for x in 0...rawData.count-1 {
                    self.rawData[x].remove(at: j)
                }
            }
        }
    }
    
    private func reCalculate() {
        self.calculations = Calculations(dataset:numericalData).calculate()
    }
    
// MARK: Getters
    
    func getName() -> String {
        return self.name
    }
    
    func getCreationDate() -> String {
        return self.creationDate
    }
    
    func getData() -> [[String]] {
        return self.rawData
    }
    
    func getNumericalData() -> [Double] {
        return self.numericalData
    }
    
    func getKeys() -> [String] {
        if(self.isEmpty() || self.keys.isEmpty) {
            return [""]
        }
        return self.keys[0]
    }
    
    func getGraphData() -> [[Double]] {
        return cleanData(array: self.rawData)

    }
    
    private func cleanData(array: [[String]]) -> [[Double]] {
        var result : Array<Array<Double>> = [[]]
        
        for e in array {
            result.append(e.doubleArray)
        }
        result.remove(at: 0)

        return result
    }
    
    func getCalculations() -> [Double] {
        return self.calculations
    }
    
    func getTotalNumItems() -> Int {
        var counter = 0
        if (!self.isEmpty()) {
            for i in 0...rawData.count-1 {
                for j in 0...rawData[i].count-1 {
                    if (!rawData[i][j].isEmpty || rawData[i][j] != "") {
                        counter+=1
                    }
                }
            }
        }
        if (!self.keys.isEmpty) {
            for i in 0...keys.count-1 {
                for j in 0...keys[i].count-1 {
                    if (!keys[i][j].isEmpty || keys[i][j] != "") {
                        counter-=1
                    }
                }
            }
        }
        return counter
    }
    
// MARK: Setters
    
    func updateVal(x : Int, y : Int, val : String) {
        if (true) {
            self.rawData[y][x] = val
            self.updateNumData()
            self.reCalculate()
        }
    }
    
    func updateKey(x: Int, y: Int = 0, val : String) { //assuming top row key
        self.keys[y][x] = val
        self.rawData[y][x] = val
    }
    
    func setName(name : String) {
        self.name = name
    }
    
// MARK: TO CSV

    func toCSV() {
        if (self.isEmpty()) {
            return
        }
        
        let fileName = self.name.replacingOccurrences(of: " ", with: "") + self.creationDate.replacingOccurrences(of: "/", with: "-") + ".csv"
        db.writeCSV(fileName: fileName, data: self.rawData)
    }
    
    func isEmpty() -> Bool{
        //return (numericalData.count) < 2
        var counter = 0
        for i in 0...rawData.count-1 {
            for j in 0...rawData[i].count-1 {
                if (rawData[i][j].isEmpty || rawData[i][j] == "") {
                    counter+=1
                }
            }
        }
        if (counter == rawData.count*rawData[0].count) {
            return true
        }
        return false
    }
}

// MARK: DATA EXTENSIONS
extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}

extension Collection where Iterator.Element == Double {
    var stringArray : [String] {
        return compactMap{ String($0) }
    }
}

extension Collection where Iterator.Element == String {
    var doubleArray: [Double] {
        return compactMap{ Double($0) }
    }
}
