//
//  NetworkManager.swift
//  Rockout
//
//  Created by Kostya Lee on 15/01/24.
//

import Foundation

public class NetworkManager {
    private let key = "3869d8b589msh5f1b5a926462fadp12ccfbjsnc6d817872b73"
    private let host = "exercisedb.p.rapidapi.com"
    
    private func createRequest(withURL url: String) -> URLRequest? {
        if let url = URL(string: url) {
            let headers = [
                "X-RapidAPI-Key": key,
                "X-RapidAPI-Host": host
            ]
            
            let request = NSMutableURLRequest(
                url: url,
                cachePolicy: .useProtocolCachePolicy,
                timeoutInterval: 10.0
            )
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            return request as URLRequest
        }
        return nil
    }
    
    public func getImage(_ url: String, completion: @escaping (Data?) -> Void) {
        if let request = createRequest(withURL: url) {
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) -> Void in
                guard let self else { return }
                if (error != nil) {
                    NSLog(commonLogFormat, "\(error?.localizedDescription ?? "")")
                } else {
                    completion(data)
                }
            }.resume()
        } else {
            NSLog(commonLogFormat, "request returned is nil: createRequest(withURL: url)")
        }
    }

    public func getExercise(id: String, completion: @escaping (API.Exercise) -> Void) {
        let url = "https://exercisedb.p.rapidapi.com/exercises/exercise/\(id)"
        if let request = createRequest(withURL: url) {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                guard error == nil, let data else {
                    NSLog(commonLogFormat, "Fell into guard block")
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(API.Exercise.self, from: data)
                    completion(decodedData)
                } catch {
                    NSLog(commonLogFormat, "Fell into catch block")
                }
            }).resume()
        } else {
            NSLog(commonLogFormat, "request returned is nil: NetworkManager.get()")
        }
    }
    
    /// Method below is for debugging
    //"https://exercisedb.p.rapidapi.com/exercises?limit=10"
    public func printExercises() {
        let headers = [
            "X-RapidAPI-Key": key,
            "X-RapidAPI-Host": host
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://exercisedb.p.rapidapi.com/exercises?limit=2000")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let self else { return }
            if (error != nil) {
                print(error as Any)
            } else {
                if let data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(Exercises.self, from: data)

                        var resultString = String()
                        let smallArray = [
                            decodedData[safe: 0],
                            decodedData[safe: 1],
                            decodedData[safe: 2],
                            decodedData[safe: 3],
                            decodedData[safe: 4]
                        ]

                        resultString.append("[")
                        resultString.append("\n")
                        smallArray.forEach { item in
                            if let item {
                                resultString.append("ExerciseDataEntity(")
                                    resultString.append("desc: \"\"\"")       // desc: """
                                    resultString.append("\n")
                                    item.instructions.forEach { instruction in
                                        resultString.append("- \(instruction)\n")
                                    }
                                    resultString.append("\n")
                                    resultString.append("\"\"\",\n")            // """,
                                    resultString.append("equipment: \"\(item.equipment)\",\n")
                                    resultString.append("id: \"\(item.id)\",\n")
                                    resultString.append("media: \"\(item.gifUrl)\",\n")
                                    resultString.append("name: \"\(item.name)\",\n")
                                    resultString.append("secondaryMuscles: \"")
                                    for i in 0...item.secondaryMuscles.count {
                                        /// If item is last, then append just String, else append String + ", "
                                        if i >= item.secondaryMuscles.count {
                                            resultString.append(item.secondaryMuscles[i])
                                        } else {
                                            resultString.append("\(item.secondaryMuscles[i]), ")
                                        }
                                    }
                                    resultString.append("\",\n")
                                    resultString.append("target: \"\(item.target)\",\n")
                                    
                                    resultString.append("\n")
                                    
                                resultString.append("),\n\n")
                            } else {
                                resultString.append("------------------------------------")
                                resultString.append("\n\n\n\n\n\n")
                                resultString.append("  NIL  ")
                                resultString.append("\n\n\n\n\n\n")
                                resultString.append("------------------------------------")
                            }
                        }
                        resultString.append("]")
                        
                        print(resultString)
//                        decodedData.forEach { e in
    //                        print(e.id)
    //                        print(e.name)
    //                        e.instructions.forEach { i in
    //                            print("- \(i)")
    //                        }
    //                        print(e.gifUrl)
    //                        print(e.target)
    //                        e.secondaryMuscles.forEach { m in
    //                            print(m, terminator: ", ")
    //                        }
    //                        print(e.equipment)
    //                        print("")
                            
//                            let newItem = ExerciseDataEntity(context: CoreDataManager.shared.context)
//                            newItem.id = "\(e.id)"
//                            newItem.name = e.name
//
//                            var desc = ""
//                            e.instructions.forEach { str in
//                                desc.append("\n- \(str)")
//                            }
//                            newItem.desc = desc
//                            newItem.media = e.gifUrl
//                            newItem.equipment = e.equipment
//                            newItem.secondaryMuscles = e.secondaryMuscles as NSObject
//                            newItem.target = e.target
//
//                            print(newItem)
//                            print("")
//                            print("")
//                        }
//                        do {
//                            try CoreDataManager.shared.context.save()
//                        } catch {
//                            fatalError()
//                        }
                    } catch {
                        fatalError("could not decode")
                    }
                } else {
                    fatalError("Data is nil")
                }
            }
        })

        dataTask.resume()
    }
}
