import Foundation

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession

    init(session: URLSession = URLSessionNetworkClient.makeSession()) {
        self.session = session
    }

    func data(for request: URLRequest, completion: @escaping @MainActor (NetworkClientResult) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: NetworkClientResult

            if let error {
                result = .failure(error)
            } else if
                let data,
                let httpResponse = response as? HTTPURLResponse
            {
                result = .success((data, httpResponse))
            } else {
                result = .failure(URLError(.badServerResponse))
            }

            Task { @MainActor in
                completion(result)
            }
        }

        task.resume()
    }

    private static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 20
        return URLSession(configuration: configuration)
    }
}
