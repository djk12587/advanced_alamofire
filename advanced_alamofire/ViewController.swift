//
//  ViewController.swift
//  advanced_alamofire
//
//  Created by Dan Koza on 3/21/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var setupLabel: UILabel!
    @IBOutlet weak var punchlineLabel: UILabel!

    var joke: Joke?
    {
        didSet
        {
            if let joke = joke
            {
                activityIndicator.stopAnimating()
                setupLabel.text = joke.setup
            }
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        newJokeTapped(UIButton())
    }

    func getRandomJoke()
    {
        JokeApi.GetRandomJoke().request { [weak self] (outcome: Outcome<Joke>) in
            guard let strongSelf = self else { return }
            switch outcome
            {
            case .success(let joke):
                strongSelf.joke = joke
            case .failure(let error):
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ok", style: .cancel))
                strongSelf.present(alertController, animated: true)
            }
        }
    }

    @IBAction func newJokeTapped(_ sender: UIButton)
    {
        setupLabel.text = ""
        punchlineLabel.text = ""
        activityIndicator.startAnimating()
        getRandomJoke()
    }

    @IBAction func punchlineTapped(_ sender: UIButton)
    {
        punchlineLabel.text = joke?.punchline
    }
}
