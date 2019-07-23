//
//  Networking.swift
//  Overview
//
//  Created by Scott OToole on 7/22/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class NetworkingState : BindableObject {
	
	var willChange: PassthroughSubject<Void, Never> = PassthroughSubject()
	
	var data : Token? = nil {
		willSet {
			willChange.send()
		}
	}
	
	var errorCode : Int? = nil {
		willSet {
			willChange.send()
		}
	}

	func getTokenOldSchool() {
		_ = TokenDataTasks().getGuestToken()?
			.sink(receiveCompletion: { (done) in
				switch done {
				case .failure(let error):
					print("error?: \(error)")
				case .finished:
					break
				}
			}, receiveValue: { (self.errorCode, self.data) = ($0.errorCode, $0.data) }
		)
	}
}

enum GuestTokenEndpoint {
	case post
}

extension GuestTokenEndpoint : EndPointType {
	var baseURL: URL {
			guard let url = URL(string: "https://api.invoicehome.com") else {fatalError("Base URL Could not be configured")}
			return url
		}
		
		var path: String {
			switch self {
			case .post:
				return "/guest"
			}
		}
		
		//list all types of getting, patching, deleting here? so requests can be unique and stable
		var httpMethod: HTTPMethod {
			switch self {
			case .post:
				return .post
			}
		}
		
		var task: HTTPTask {
			//when passing data, just add data to 'body Parameters' and send it over here. ma
			//when callend endpoint to router.request(.signing(someDataHere)), then let the constant, and pass it
			switch self {
				//anything sending only an auth header with no body goes here
				
			case .post:
				return .requestParametersAndHeaders(
					bodyParameters: nil,
					bodyEncoding: .urlEncoding,
					urlParameters: nil,
					additionalHeaders: localeHeader)
			}
		}
		
		//sends locale and auth token
		var authLocaleHeader: HTTPHeaders? {
			return  [
				"Authorization": "Bearer",
				"X-Locale": "en"
//				"Authorization": "Bearer \(TokenSource.shared.token())",
//				"X-Locale": LocaleSource.shared.returnPreferredLocalization()
			]
		}
		
		var localeHeader: HTTPHeaders? {
			return [
				"X-Locale": "en"
//				"X-Locale": LocaleSource.shared.returnPreferredLocalization()
			]
		}
}

struct Token : Codable {
	let token : String
	let expires_at : String
}

struct PublishedNetworkResponse<T> {
	var data : T
	var errorCode : Int?
}

class TokenDataTasks {
	
	lazy var router = Router<GuestTokenEndpoint>()

	func getGuestToken() -> AnyPublisher<PublishedNetworkResponse<Token>, Error>? {
		return router.requestViaPublisher(.post)
	}
}

public enum HTTPMethod : String {
    case get    = "GET"
    case put    = "PUT"
    case post   = "POST"
    case patch  = "PATCH"
    case delete = "DELETE"
}

protocol EndPointType {
    var baseURL: URL {get}
    var path: String {get}
    var httpMethod: HTTPMethod {get}
    var task: HTTPTask {get}
    var authLocaleHeader: HTTPHeaders? {get}
    var localeHeader: HTTPHeaders? {get}
}

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
	func requestViaPublisher<T : Codable>(_ route: EndPoint) -> AnyPublisher<PublishedNetworkResponse<T>, Error>?
    func cancel()
}

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    
    case requestParameters(
        bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(
        bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionalHeaders: HTTPHeaders?)
}

class Router<EndPoint: EndPointType>: NetworkRouter {
	
    private var task: URLSessionTask?
    
    private var session : URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func cancel() {
        self.task?.cancel()
    }
	
	func requestViaPublisher<T : Codable>(_ route: EndPoint) -> AnyPublisher<PublishedNetworkResponse<T>, Error>?  {
			do {
				let a = try self.buildRequest(from: route)
				return session.dataTaskPublisher(for: a)
					.tryMap({ (data, response) -> PublishedNetworkResponse<T> in
						var a: Int? = nil
						if let r = response as? HTTPURLResponse {
							a = r.statusCode
						}
						return try PublishedNetworkResponse(data: JSONDecoder().decode(T.self, from: data), errorCode: a)
						
					})
					.receive(on: RunLoop.main)
					.eraseToAnyPublisher()
			} catch {
				print("fail")
			}
			return nil
		}
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
			
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters,
                                    urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

public struct JSONParameterEncoder : ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}

public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum ParameterEncoding {
    
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    
    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: Parameters?,
                       urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                
            }
        }catch {
            throw error
        }
    }
}

public enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

public struct URLParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
