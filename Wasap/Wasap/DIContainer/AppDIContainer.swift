//
//  AppDIContainer.swift
//  Wasap
//
//  Created by chongin on 9/29/24.
//

final public class AppDIContainer {
    let apiClient: APIClient
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}
