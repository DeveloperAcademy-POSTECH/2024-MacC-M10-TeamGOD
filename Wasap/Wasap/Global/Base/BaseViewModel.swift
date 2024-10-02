//
//  BaseViewModel.swift
//  Wasap
//
//  Created by chongin on 9/28/24.
//

import RxSwift
import RxCocoa

public protocol BaseViewModelProtocol {
    var viewDidLoad: PublishRelay<Void> { get }
    var viewWillAppear: PublishRelay<Void> { get }
    var viewDidAppear: PublishRelay<Void> { get }
    var viewWillDisappear: PublishRelay<Void> { get }
    var viewDidDisappear: PublishRelay<Void> { get }
    var disposeBag: DisposeBag { get }
}

public class BaseViewModel: BaseViewModelProtocol {
    public let viewDidLoad = PublishRelay<Void>()
    public let viewWillAppear = PublishRelay<Void>()
    public let viewDidAppear = PublishRelay<Void>()
    public let viewWillDisappear = PublishRelay<Void>()
    public let viewDidDisappear = PublishRelay<Void>()
    public let disposeBag = DisposeBag()

    public init() {
        Log.debug("[VM LifeCycle] \(Self.self) init")
    }

    deinit {
        Log.debug("[VM LifeCycle] \(Self.self) deinit")
    }
}
