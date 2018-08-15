//
//  Joke.swift
//  advanced_alamofire
//
//  Created by Dan Koza on 3/21/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import Foundation

struct Joke: Model
{
    var id: Int
    var type: String
    var setup: String
    var punchline: String

    init(json: JSON?) throws
    {
        guard let json = json,
            let id = json["id"] as? Int,
            let type = json["type"] as? String,
            let setup = json["setup"] as? String,
            let punchline = json["punchline"] as? String else { throw ParsingError.failed }

        self.id = id
        self.type = type
        self.setup = setup
        self.punchline = punchline
    }
}
