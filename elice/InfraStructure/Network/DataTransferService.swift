//
//  DataTransferService.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import Alamofire
import RxSwift

protocol DataTransferService {
    var config: NetworkConfigurable { get }
    func request<T: Decodable>(
        with endpoint: Endpoint<T>
    ) -> Observable<Result<T, Error>>
}

class DefaultDataTransferService {
    let config: NetworkConfigurable
    let session: Session
    
    init(with config: NetworkConfigurable) {
        self.config = config
        self.session = Session()
    }
}

extension DefaultDataTransferService: DataTransferService {
    // TODO: Logging, Error Handling 구현하여 Repository에는 성공하는 경우만 넘어가도록 개선하는 것이 깔끔할 듯.
    
    func request<T>(
        with endpoint: Endpoint<T>
    ) -> Observable<Result<T, Error>> {
        guard let request = try? endpoint.urlRequest(with: config) else {
            fatalError("check for \(endpoint) config \(config)")
        }
        
        return Observable.create { [weak self] observer -> Disposable in
            self?.session.request(request)
                .responseDecodable(of: T.self) {
                    response in
                    
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}

