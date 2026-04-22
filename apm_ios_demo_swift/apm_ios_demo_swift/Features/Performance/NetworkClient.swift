import Foundation

typealias NetworkClientResult = Result<(Data, HTTPURLResponse), Error>

protocol NetworkClient {
    func data(for request: URLRequest, completion: @escaping @MainActor (NetworkClientResult) -> Void)
}
