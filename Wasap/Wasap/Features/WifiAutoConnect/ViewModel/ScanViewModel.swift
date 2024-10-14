//
//  ScanViewModel.swift
//  Wasap
//
//  Created by Chang Jonghyeon on 10/10/24.
//

import RxSwift
import RxCocoa
import UIKit

public class ScanViewModel: BaseViewModel {
    // MARK: - Coordinator
    private weak var coordinatorController: ScanCoordinatorController?
    
    // MARK: - Input
    
    // MARK: - Output
    public var updatedImage: Driver<UIImage>
    public var ssidText: Driver<String>
    public var passwordText: Driver<String>
    public var isWiFiConnected: Driver<Bool>
    
    public init(imageAnalysisUseCase: ImageAnalysisUseCase, wifiConnectUseCase: WiFiConnectUseCase, coordinatorController: ScanCoordinatorController, previewImage: UIImage) {
        
        let ssidRelay = BehaviorRelay<String>(value: "")
        self.ssidText = ssidRelay.asDriver(onErrorJustReturn: "")
        
        let passwordRelay = BehaviorRelay<String>(value: "")
        self.passwordText = passwordRelay.asDriver(onErrorJustReturn: "")
        
        let updatedImageRelay = BehaviorRelay<UIImage?>(value: nil)
        self.updatedImage = updatedImageRelay.asDriver(onErrorJustReturn: nil).compactMap { $0 }
        
        let isWiFiConnectedRelay = BehaviorRelay<Bool>(value: false)
        self.isWiFiConnected = isWiFiConnectedRelay.asDriver(onErrorJustReturn: false)
        
        self.coordinatorController = coordinatorController
        super.init()
        
        self.viewDidLoad
            .flatMapLatest { _ in
                return imageAnalysisUseCase.performOCR(on: previewImage)
            }
            .flatMapLatest { boundingBoxes, ssid, password in
                print("OCR 후 SSID: \(ssid), Password: \(password)")
                
                ssidRelay.accept(ssid)
                passwordRelay.accept(password)
                updatedImageRelay.accept(self.drawBoundingBoxes(boundingBoxes, on: previewImage))
                
                return Observable<Int>.timer(.seconds(2), scheduler: MainScheduler.instance)
                    .flatMap { _ -> Observable<Bool> in
                        
                        if !ssid.isEmpty && !password.isEmpty {
                            print("Wi-Fi 연결 시도: SSID = \(ssid), Password = \(password)")
                            return wifiConnectUseCase.connectToWiFi(ssid: ssid, password: password)
                                .asObservable()
                                .do(onNext: { success in
                                    print("Wi-Fi 연결 성공 여부: \(success)")
                                }, onError: { error in
                                    print("Wi-Fi 연결 중 에러 발생: \(error.localizedDescription)")
                                })
                                .catch { error in
                                    print("Connection failed: \(error.localizedDescription)")
                                    return .just(false)
                                }
                        } else {
                            print("누락 - 현재SSID:\(ssid), 현재Password:\(password)")
                            return .just(false)
                        }
                    }
            }
            .do(onNext: { [weak self] success in
                guard let self = self else { return }
                
                print("이 부분에 도달했습니다.")
                if success {
                    if self.coordinatorController == nil {
                        print("Error: coordinatorController is nil")
                    } else {
                        print("뷰 전환")
                        self.coordinatorController?.performTransition(to: .connecting)
                    }
                } else {
                    print("빠꾸!!")
                }
            })
            .subscribe(onNext: { success in
                isWiFiConnectedRelay.accept(success)
            }, onError: { error in
                print("OCR 또는 Wi-Fi 연결 중 에러 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    // bounding box를 이미지 위에 그리는 함수
    private func drawBoundingBoxes(_ boxes: [(CGRect, CGColor)], on image: UIImage) -> UIImage? {
        let imageSize = image.size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        image.draw(at: .zero)
        
        for (box, color) in boxes {
            let rect = CGRect(
                x: box.origin.x * imageSize.width,
                y: (1 - box.origin.y - box.height) * imageSize.height,
                width: box.width * imageSize.width,
                height: box.height * imageSize.height
            )
            context?.setStrokeColor(color)
            context?.setLineWidth(2.0)
            context?.stroke(rect)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
