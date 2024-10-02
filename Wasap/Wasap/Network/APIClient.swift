//
//  APIClient.swift
//  Wasap
//
//  Created by chongin on 10/1/24.
//

import Moya
import Foundation

public protocol APIClient {
    func resolve<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target>
}

final public class DefaultAPIClient: APIClient {
    public func resolve<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target> {
        return MoyaProvider<Target>() // 추후 플러그인이나 interceptor 등이 들어갈 예정
    }
}

final public class TestAPIClient: APIClient {
    public enum TestType: Int {
        case success = 200
        case authError = 401

        var httpCode: Int {
            self.rawValue
        }
    }
    let testType: TestType
    public init(testType: TestType) {
        self.testType = testType
    }
    public func resolve<Target: TargetType>(for target: Target.Type) -> MoyaProvider<Target> {
        let customEndpointClosure = { [weak self] (target: Target) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(self?.testType.httpCode ?? 200, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )

        }
        return MoyaProvider<Target>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.delayedStub(0.5)) // 0.5초 딜레이 후 응답 받음
    }
}
