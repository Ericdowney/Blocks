
import Foundation

public struct Request: Codable {
    public enum Method: String, Codable {
        case get, post
    }
    
    public var url: String
    public var method: Method
    public var params: [String: String]
    
    func urlRequest() throws -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpBody = try JSONEncoder().encode(params)
        request.httpMethod = method.rawValue
        return request
    }
}

public struct ApiResponse<ApiResult: Decodable> {
    
    var value: ApiResult
    var response: URLResponse?
}

public struct ApiBlock<ApiResult: Decodable>: Block {
    public typealias Output = ApiResponse<ApiResult>
    
    var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func run(_ input: Request, _ completion: @escaping Completion) throws {
        urlSession.dataTask(with: try input.urlRequest()) { data, response, error in
            do {
                if let error = error {
                    try completion(.failed(error))
                } else {
                    if let data = data {
                        try completion(
                            .done(
                                ApiResponse(value: JSONDecoder().decode(ApiResult.self, from: data),
                                            response: response)
                            )
                        )
                    } else {
                        try completion(.failed(nil))
                    }
                }
            } catch {
                try! completion(.failed(error))
            }
        }
    }
}

public struct BuildLoginRequestBlock: Block {
    public typealias Output = Request
    
    public func run(_ input: (username: String, password: String), _ completion: @escaping Completion) throws {
        try completion(
            .done(
                Request(url: "https://mydomain.a/api/login", method: .post, params: ["username": input.username, "password": input.password])
            )
        )
    }
}

public struct BuildLogoutRequestBlock: Block {
    public typealias Output = Request
    
    public func run(_: Void, _ completion: @escaping Completion) throws {
        try completion(
            .done(
                Request(url: "https://mydomain.a/api/logout", method: .post, params: [:])
            )
        )
    }
}

struct Profile: Codable {
    var name: String
}
struct EmptyResponse: Codable {}

let loginSequence: BlockSequence<(String, String), Profile> = BuildLoginRequestBlock() --> ApiBlock<Profile>()
let logoutSequence: BlockSequence<Void, EmptyResponse> = BuildLogoutRequestBlock() --> ApiBlock<EmptyResponse>()
