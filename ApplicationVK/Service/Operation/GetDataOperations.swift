//
//  GetDataOperations.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 27.06.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import Foundation
import Alamofire

class GetDataOperation : AsyncOperation {
    private var request: DataRequest 
    var data: Data?
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
    
}

