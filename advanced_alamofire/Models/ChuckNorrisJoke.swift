//
//  ChuckNorrisJoke.swift
//  advanced_alamofire
//
//  Created by Dan Koza on 3/21/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import Foundation

struct ChuckNorrisJoke: Model
{
    var id: Int
    var joke: String

    init(json: JSON?) throws
    {
        guard let json = json,
            let jokeData = json["value"] as? JSON,
            let id = jokeData["id"] as? Int,
            let joke = jokeData["joke"] as? String else { throw ParsingError.failed }

        self.id = id
        self.joke = joke
    }
}
