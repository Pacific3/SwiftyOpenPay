//
//  SwiftyOpenPay.swift
//  SwiftyOpenPay
//
//  Created by Oscar Swanros on 1/13/16.
//  Copyright © 2016 Pacific3. All rights reserved.
//

public let OpenPayErrorDomain = "com.openpay.ios.lib"

private let api_url           = "https://api.openpay.mx/"
private let sandbox_api_url   = "https://sandbox-api.openpay.mx/"
private let api_version       = "v1"

extension SwiftyOpenPay.SwiftyOpenPayError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .MalformedResponse: return "Could not parse server's response."
        }
    }
}

public struct SwiftyOpenPay {
    public enum SwiftyOpenPayError: Int, ErrorConvertible {
        case MalformedResponse = 1
        
        public var code: Int {
            return self.rawValue
        }
        
        public var errorDescription: String {
            return self.description
        }
        
        public var domain: String {
            return OpenPayErrorDomain
        }
    }
    
    private static let internalQueue = OperationQueue()
    
    public let merchantId: String
    public let apiKey: String
    public let productionMode: Bool
    
    private var URLBase: String {
        let base = productionMode ? api_url : sandbox_api_url
        
        return base + api_version + "/" + merchantId + "/"
    }
    
    public init(merchantId: String, apiKey: String, productionMode: Bool = false) {
        self.merchantId     = merchantId
        self.apiKey         = apiKey
        self.productionMode = productionMode
    }
    
    public func createTokenWithCard(card: Card, completion: Token -> Void, error: NSError -> Void) throws {
        try card.isValid()
        
        guard let url = NSURL(string: URLBase + "tokens") else {
            return
        }
        
        let request = requestForURL(url, method: .POST, payload: card.backingData())
        
        sendRequest(request, type: Token.self, completionClosure: completion, errorClosure: error)
    }
    
    public func getTokenWithId(id: String, completion: Token -> Void, error: NSError -> Void) {
        guard let url = NSURL(string: URLBase + "tokens/" + id) else {
            return
        }
        
        let request = requestForURL(url, method: .GET)
        
        sendRequest(request, type: Token.self, completionClosure: completion, errorClosure: error)
    }
}

extension SwiftyOpenPay {
    private func requestForURL(url: NSURL, method: HTTPMethod, payload: [String:AnyObject]? = nil) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        
        request.setValue("application/json;revision=1.1", forKey: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("OpenPay-iOS/1.0.0", forKey: "User-Agent")
        request.HTTPMethod = method.rawValue
        
        let authStr = "\(apiKey):"
        let data = authStr.dataUsingEncoding(NSASCIIStringEncoding)
        let value = data?.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
        
        request.setValue("Basic \(value)", forKey: "Authorization")
        
        if let payload = payload {
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(payload, options: .PrettyPrinted)
                request.HTTPBody = data
            } catch {}
        }
        
        return request
    }
    
    private func sendRequest<T: JSONParselable>(request: NSURLRequest, type: T.Type, completionClosure: (T -> Void)? = nil, errorClosure: (NSError -> Void)? = nil) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { data, reponse, error in
            guard
                error != nil,
                let data = data
                else {
                    errorClosure?(error!)
                    return
            }
            
            var json = [String:AnyObject]?()
            
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String:AnyObject]
            } catch let jsonError as NSError {
                errorClosure?(jsonError)
            }
            
            guard
                let _json = json,
                let model = type.withData(_json)
                else {
                    errorClosure?(NSError(error: ErrorSpecification(ec: SwiftyOpenPayError.MalformedResponse)))
                    return
            }
            
            completionClosure?(model)
        }
        
        let taskOp = URLSessionTaskOperation(task: task)
        taskOp.addObserver(NetworkActivityObserver())
        
        SwiftyOpenPay.internalQueue.addOperation(taskOp)
    }
}
