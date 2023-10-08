//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Lixing Zheng on 10/7/23.
//

import Foundation

func fetchTriviaQuestions(completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
    // Construct the API URL for fetching trivia questions
    let apiUrlString = "https://opentdb.com/api.php?amount=5"

    guard let apiUrl = URL(string: apiUrlString) else {
        completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: nil))
        return
    }

    URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
        if let error = error {
            print("Error fetching trivia questions: \(error)")
            completion(nil, error)
            return
        }

        guard let data = data else {
            print("No data received")
            completion(nil, NSError(domain: "NoData", code: 0, userInfo: nil))
            return
        }

        do {
            let jsonString = String(data: data, encoding: .utf8)
            print("Received JSON: \(jsonString ?? "")")

            let decoder = JSONDecoder()
            let response = try decoder.decode(TriviaQuestionsResponse.self, from: data)
            completion(response.results, nil)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil, error)
        }
    }.resume()
}



private func parseTriviaQuestions(from json: [String: Any]) -> [TriviaQuestion]? {
        // Check if the "results" key is present in the JSON
        guard let results = json["results"] as? [[String: Any]] else {
            return nil
        }
        
        // Initialize an empty array to store the trivia questions
        var triviaQuestions: [TriviaQuestion] = []
        
        for result in results {
            // Extract data from each trivia question dictionary
            if
                let category = result["category"] as? String,
                let question = result["question"] as? String,
                let type = result["typw"] as? String,
                let correctAnswer = result["correct_answer"] as? String,
                let incorrectAnswers = result["incorrect_answers"] as? [String]
            {
                // Create a TriviaQuestion object and append it to the array
                let triviaQuestion = TriviaQuestion(
                    category: category,
                    question: question,
                    type: type,
                    correctAnswer: correctAnswer,
                    incorrectAnswers: incorrectAnswers
                )
                triviaQuestions.append(triviaQuestion)
            }
        }
        
        return triviaQuestions
        
    }

