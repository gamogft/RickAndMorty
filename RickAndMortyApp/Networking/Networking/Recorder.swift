//
//  Recorder.swift
//
//  Created by Megdadi, Omar on 03/04/2020.
//

import Foundation

public protocol NetworkRecorderProtocol {
    func record<T: APIRequest>(request: T, data: Data)
}

public class Recorder: NetworkRecorderProtocol {

    let folderName: String

    public init(_ folderName: String = "Recordings") {
        self.folderName = folderName
    }

    public func record<T: APIRequest>(request: T, data: Data) {
        let text = data.prettyPrintedJSONString ?? "{}"
        save(string: text, fileName: request.stubName)
    }

    private func save(string: String, fileName: String) {

        guard let documentsDirectoryURL = try? FileManager.default.url(for: .documentDirectory,
                                                                       in: .userDomainMask,
                                                                       appropriateFor: nil,
                                                                       create: false)
        else { fatalError("no document directory found") }
        let recordingPath = documentsDirectoryURL.appendingPathComponent(folderName)
        try? FileManager.default.createDirectory(at: recordingPath, withIntermediateDirectories: true, attributes: nil)
        let recordingFilePath = recordingPath.appendingPathComponent("\(fileName).json")
        do {
            try string.write(to: recordingFilePath,
                             atomically: true,
                             encoding: .utf8)
            print("[Recorder LOG] save \(fileName) file in \(recordingFilePath)")
        } catch {
            print("[Recorder LOG] Error saving recorder file", error)
            return
        }
    }
}

extension Data {
    
    public var prettyPrintedJSONString: String? {
        if APILogger.prettyPrintJSON {
            guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
                  let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
                  let prettyPrintedString = String(data:data, encoding: .utf8) else { return nil }
            
            return prettyPrintedString
        } else {
            return String(data: self, encoding: .utf8)
        }
    }
}
