import Foundation

final class Api {
    
    static let shared = Api()
    
    struct Constants {
        static let newsURL = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2022-01-17&to=2022-01-17&sortBy=popularity&apiKey=b272662b0a9445f9b5786183133080a6")
    }
    
    private init() {
        
    }
    
    public func getStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.newsURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

/// MODEL
struct APIResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
}

struct Source: Codable {
    let name: String
}
