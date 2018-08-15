//
//  NetworkRouter.swift
//  advanced_alamofire
//
//  Created by Dan Koza on 3/21/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkEncoding
{
    case json, url
}

protocol NetworkRouter: URLRequestConvertible
{
    var baseURL: String { get }
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var encoding: NetworkEncoding { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }

    #if DEBUG
    var stubbedResponseData: Data { get }
    var responseTime: TimeInterval { get }
    #endif
}

extension NetworkRouter
{
    var method: Alamofire.HTTPMethod
    {
        return .get
    }

    var encoding: NetworkEncoding
    {
        return .url
    }

    var parameters: [String: Any]?
    {
        return nil
    }

    var headers: [String: String]?
    {
        return nil
    }

    func asURLRequest() throws -> URLRequest
    {
        let url = Foundation.URL(string: baseURL)!.appendingPathComponent(path)
        var mutableRequest = URLRequest(url: url)
        mutableRequest.httpMethod = method.rawValue

        switch encoding
        {
        case .json:
            mutableRequest = try JSONEncoding.default.encode(mutableRequest, with: parameters)
        case .url:
            mutableRequest = try URLEncoding.default.encode(mutableRequest, with: parameters)
        }

        headers?.forEach { mutableRequest.addValue($0.value, forHTTPHeaderField: $0.key) }

        #if DEBUG
            stubRequests(url: url)
        #endif

        return mutableRequest
    }
}

extension NetworkRouter
{
    @discardableResult
    func request<ResultType: Model>(sessionManager: SessionManager = Alamofire.SessionManager.default, completion: @escaping (Outcome<ResultType>) -> Void) -> Request
    {
        return sessionManager.request(self).validate().responseModel(completionHandler: completion)
    }

    @discardableResult
    func request<ResultType: Model>(sessionManager: SessionManager = Alamofire.SessionManager.default, completion: @escaping (Outcome<[ResultType]>) -> Void) -> Request
    {
        return sessionManager.request(self).validate().responseModels(completionHandler: completion)
    }
}

#if DEBUG
import OHHTTPStubs
#endif

extension NetworkRouter
{
    func readFile(_ fileName: String, fileType: String = "json") -> Data
    {
        let path = Bundle.main.path(forResource: fileName, ofType: fileType)!
        return (try? Data(contentsOf: URL(fileURLWithPath: path)))!
    }

    #if DEBUG
    var stubbedResponseData: Data
    {
        return readFile("emptyResponse")
    }

    var responseTime: TimeInterval
    {
        return 0.5
    }
    #endif

    #if DEBUG
    func stubRequests(url: URL)
    {
        print("***Stubbing: \(url)***")
        stub(condition: OHHTTPStubs.urlsMatch(url: url), response: { (_) -> OHHTTPStubsResponse in
            let response = OHHTTPStubsResponse(data: self.stubbedResponseData, statusCode: 200, headers: nil)
            response.requestTime = self.responseTime
            return response
        }).name = url.absoluteString + method.rawValue

        OHHTTPStubs.afterStubFinish { (_, descriptor, _, _) in
            OHHTTPStubs.removeStub(descriptor)
        }
    }
    #endif
}

#if DEBUG
extension OHHTTPStubs
{
    class func urlsMatch(url: URL) -> OHHTTPStubsTestBlock
    {
        return { request in
            return request.url?.path == url.path
        }
    }
}
#endif
