//
//  ELManager.swift
//  Rockout
//
//  Created by Kostya Lee on 07/01/24.
//

import Foundation

// MARK: Custom localization for exercises: ELManager - ExerciseLanguageManager
/// I need to create custom localization for exercises because there are thousands of them and app will probably support 5-10 languages.

/// will be used with UserDefaults instead
public var currentLanguage = Language.russian

/// Will be called at the onboarding stage. Will retrieve current lang on user's iphone
public func getCurrentLanguage() -> Language { return .russian }

/// Will pick exercise names and descriptions from existing .txt files and assign them accordingly to their ids and save to dictionaries
public func setupDictionaries() {
    var namesFile = "names"
    var descriptionsFile = "dictionaries"

    switch currentLanguage {
    case .english:
        namesFile = "names"
        descriptionsFile = "descriptions"
    case .russian:
        namesFile = "names_ru"
        descriptionsFile = "descriptions_ru"
    }
    
    namesDict = assignIds(from: namesFile)
    descriptionsDict = assignIds(from: descriptionsFile)

    saveDictionaries()
}

private func assignIds(from file: String) -> [String : String] {
    if let ids = readTextFile(fileName: "ids")?.components(separatedBy: "\n") {
        let separator = file.contains("names") ? "\n" : "\n\n"
        let components = readTextFile(fileName: file)?.components(separatedBy: separator)
        guard let components, components.count == ids.count else {
            NSLog(commonLogFormat, "Error: assignIdsToNames(_ file: String)")
            return [:]
        }
        var dict = [String : String]()
        for i in 0...ids.count - 1 {
            dict[ids[i]] = components[i]
        }
        return dict
    } else {
        NSLog(commonLogFormat, "ids are nil: assignIdsToNames(_ file: String)")
    }
    return [:]
}

public func makeUpperased() {
    if let fileURL = Bundle.main.url(forResource: "names_ru", withExtension: "txt") {
        if let names = readTextFile(fileName: "names_ru")?.components(separatedBy: "\n") {
            var uppercasedNames = names
            
            for i in 0...names.count - 1 {
                let str = names[i]
                if let first = str.first {
                    uppercasedNames[i] = String(first).uppercased() + String(str.dropFirst())
                }
            }
            
            // MARK: Uncomment to make function work
            let sasa = fileURL.startAccessingSecurityScopedResource()
            do {
                try uppercasedNames.joined().write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */
                print("ERROR CATCH")
            }
            fileURL.stopAccessingSecurityScopedResource()
        }
    }
}

public func read() {
    readTextFile(fileName: "ids")
    readTextFile(fileName: "names")
    readTextFile(fileName: "names_ru")
    readTextFile(fileName: "descriptions_ru")
}

func readTextFile(fileName: String) -> String? {
    do {
        // Get the file URL for the file in the app's bundle
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "txt") {
            // Read the contents of the file
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            return contents
        } else {
            // File not found
            print("File not found.")
            return nil
        }
    } catch {
        // Error reading the file
        print("Error reading the file: \(error.localizedDescription)")
        return nil
    }
}

public func saveDictionaries() {
    // Save namesDict and descriptionsDict to Core Data
}

public func loadDictionaries() {
    // Load dicts from Core Data. Will be used each time app starts
    let loadedNamesDict = [String : String]()
    let loadedDescriptionsDict = [String : String]()

    namesDict = loadedNamesDict
    descriptionsDict = loadedDescriptionsDict
}
var namesDict: [String : String] = [:]
var descriptionsDict: [String : String] = [:]
