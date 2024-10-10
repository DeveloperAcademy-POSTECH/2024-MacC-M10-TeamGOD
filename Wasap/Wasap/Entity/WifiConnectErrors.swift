//
//  WifiConnectErrors.swift
//  Wasap
//
//  Created by 김상준 on 10/10/24.
//

enum WiFiConnectionErrors: Error {
    case failedToConnect(String)
    
    var localizedDescription: String {
        switch self {
        case .failedToConnect(let ssid):
            return "Failed to connect to \(ssid)"
        }
    }
}
