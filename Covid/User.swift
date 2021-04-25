/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import UIKit

public class User {
	public var id : String?
    public var serverId : Int?
	public var name : String?
	public var email : String?
	public var phonenumber : Int?

    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let user = User(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: User Instance.
*/
	required public init?(dictionary: NSDictionary) {

		serverId = dictionary["id"] as? Int
		name = dictionary["name"] as? String
		email = dictionary["email"] as? String
		phonenumber = dictionary["phonenumber"] as? Int

	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.serverId, forKey: "id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.phonenumber, forKey: "phonenumber")


		return dictionary
	}

    //MARK: Properties

    
    init(){}

    
    class func RegisterUserAPI(withEmail email: String, password: String,name:String, birthdate:String, phone:String, completion :@escaping (_ status: NetworkStatus) -> Void){
        
        URLCache.shared.removeAllCachedResponses()
        let url: Foundation.URL = Foundation.URL(string: "\(Constants.mainURL)user/register")!
        var request:URLRequest = URLRequest(url:url)
        
        request.httpMethod = "POST"
        
        
        
        let bodyData = "email=\(email)&password=\(password)&first_name=\(name)&dob=\(birthdate)&phone=\(phone)&last_name=\(name)"
        
        
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            
            (data, response, error) in
            
            let httpResponse = response as! HTTPURLResponse
            let status = httpResponse.statusCode
            print(status)
            
            do{
                if status==200{
                    
                    do {
                        // make sure this JSON is in the format we expect
                        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            // try to read out a string array
                            if let token = json["access_token"] as? String {
                                UserDefaults.standard.setValue(token, forKey: "token")
                            }
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                    completion(.success)
                    

                }
                    
                else if status==400{
                    
                    completion( NetworkStatus.failed)
                    
                }
                    
                else  if status==403{
                    
                    completion(NetworkStatus.tokenExpired)
                    
                }else{
                    
                    completion( NetworkStatus.failed)}
                
            }
            
        })
        
        task.resume()
        
    }
    
    class func loginUserAPI(withEmail email: String, password: String, completion :@escaping (_ status: NetworkStatus) -> Void){
      
        URLCache.shared.removeAllCachedResponses()
        let url: Foundation.URL = Foundation.URL(string: "\(Constants.mainURL)user/login")!
        var request:URLRequest = URLRequest(url:url)
//         request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
 
        let bodyData = "email=\(email)&password=\(password)"
        
        
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            
            (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse{
            let status = httpResponse.statusCode
            print(status)
            
            do{
                if status==200{
                    
//                    UserDefaults.standard.value(forKey: "token")
                    
                    
                    do {
                        // make sure this JSON is in the format we expect
                        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            // try to read out a string array
                            if let token = json["access_token"] as? String {
                                UserDefaults.standard.setValue(token, forKey: "token")
                            }
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                    completion(NetworkStatus.success)
                }
                    
                else if status==400{
                    
                    completion( NetworkStatus.failed)
                    
                }
                    
                else  if status==403{
                    
                    completion(NetworkStatus.tokenExpired)
                    
                }else{completion( NetworkStatus.failed)}
                
            }
            }else{
                completion( NetworkStatus.noConnection)
            }
        })
       
        
        task.resume()
        
    }

    
   
    
    
    //MARK: Inits
    init(name: String, email: String, id: String) {
        self.name = name
        self.email = email
        self.id = id
    }
}
