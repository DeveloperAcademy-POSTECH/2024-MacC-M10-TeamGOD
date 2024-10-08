//
//  WifiConnectErrors.swift
//  Wasap
//
//  Created by 김상준 on 10/10/24.
//

enum WiFiConnectionErrors: Error {
    case failedToConnect(String)
    case wrongInformation
    
    var localizedDescription: String {
        switch self {
        case .failedToConnect(let ssid):
            return "Failed to connect to \(ssid)"
        case .wrongInformation:
            return "SSid or Password is wrong"
        }
    }
}
