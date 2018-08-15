//
//  JokeApi.swift
//  advanced_alamofire
//
//  Created by Dan Koza on 3/21/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import Foundation
import Alamofire

struct JokeApi { private init() {} }

extension JokeApi
{
    struct GetRandomJoke: NetworkRouter
    {
        var baseURL: String
        {
            return "https://08ad1pao69.execute-api.us-east-1.amazonaws.com/"
        }

        var path: String
        {
            return "dev/random_joke"
        }

        var method: HTTPMethod
        {
            return .get
        }

        var encoding: NetworkEncoding
        {
            return .url
        }

        #if DEBUG
        var stubbedResponseData: Data
        {
            return readFile("randomJoke")
        }
        #endif
    }

    struct GetRandomJokes: NetworkRouter
    {
        var baseURL: String
        {
            return "https://08ad1pao69.execute-api.us-east-1.amazonaws.com/"
        }

        var path: String
        {
            return "dev/random_ten"
        }

        var method: HTTPMethod
        {
            return .get
        }

        var encoding: NetworkEncoding
        {
            return .url
        }

        #if DEBUG
        var stubbedResponseData: Data
        {
            return readFile("jokes")
        }
        #endif
    }

    struct GetChuckNorrisJoke: NetworkRouter
    {
        var allowExplicit: Bool

        var baseURL: String
        {
            return "http://api.icndb.com/"
        }

        var path: String
        {
            return "jokes/random"
        }

        var parameters: [String : Any]?
        {
            guard !allowExplicit else { return nil }

            return ["exclude" : "explicit"]
        }

        var method: HTTPMethod
        {
            return .get
        }

        var encoding: NetworkEncoding
        {
            return .url
        }

        #if DEBUG
        var stubbedResponseData: Data
        {
            return readFile("chuckNorrisJoke")
        }
        #endif
    }
}
