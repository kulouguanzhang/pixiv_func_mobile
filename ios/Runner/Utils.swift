//
// Created by 夏侯臻 on 2022/1/29.
//

import Foundation

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

typealias ByteArray = Array<UInt8>

func convertToDictionary(data: Data) -> [String: Any]? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    } catch {
        print(error.localizedDescription)
    }
    return nil
}

typealias Handler = (_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void

struct GetQueryParameterError: Error {
}

extension URL {
    func getQueryStringParameter(key: String) throws -> String {
        if let param = NSURLComponents(string: absoluteString)?.queryItems?.filter({ $0.name == key }).first?.value {
            return param
        }
        throw GetQueryParameterError()
    }
}

extension FlutterStandardTypedData{
    var byteArray:ByteArray{
        Array(data)
    }
    var string:String{
        String(decoding: self.data, as: UTF8.self)
    }
    var intArray:Array<Int>{
        Array(data) as! Array<Int>
    }
}
