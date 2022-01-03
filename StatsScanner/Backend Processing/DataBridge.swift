//
//  DataImporter.swift
//  StatsScanner
//
//  Created by Kamran on 12/27/21.
//

import Foundation

extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

class DataBridge {
    
    func writeData(data:String, fileName: String) {
        let str = data
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            try str.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    

    func readCSV(inputFile: URL, lineSeparator: String = "/n", valSeparator: String = ",") -> [[String]] {
        //Get Data
        print("reading csv")
        var result: [[String]] = []
        do {
            let data = try String(contentsOf: inputFile)
            let rows = data.components(separatedBy: CharacterSet(charactersIn: lineSeparator))
            for row in rows {
                let columns = row.components(separatedBy: valSeparator)
                result.append(columns)
            }
            print("copying cleaned data")
            result = cleanCSVData(data: result)
            return result
        } catch {
            // Any Errors will go here
            return [["ERROR: File Could Not be Found"]]
        }
    }
    
    func writeCSV(fileName:String, data:[[String]]){
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        
        var stringData = ""
        for i in 0...data.count-1 {
            if(data[i].count-1 < 0){
                break
            }
            for j in 0...data[i].count-1 {
                stringData += data[i][j]
                if(j != data[i].count-1) {
                    stringData += ","
                }
            }
            stringData += "\n"
        }
        do {
            try stringData.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func cleanCSVData(data: [[String]]) -> [[String]] {
        var result = data
        print("cleaning data")
        for i in 0...data.count-1 {
            if( data[i].count == 0){
                result.remove(at: i)
            }
            for j in 0...data[i].count-1 {
                result[i][j] = data[i][j].replacingOccurrences(of: "\r", with: "")
                result[i][j] = data[i][j].replacingOccurrences(of: "\r", with: "")
                if (data[i][j] == ""){
                    result[i].remove(at: j)
                }
            }
        }
        return result
    }

}
