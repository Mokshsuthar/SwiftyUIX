//
//  ForceViewModel.swift
//  SwiftyUIX
//
//  Created by Moksh on 04/11/24.
//
#if os(iOS)
import Foundation
import UIKit
 

enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
}

class LookupResult: Decodable {
    var results: [AppInfo]
}


public class forceUpdateModel {
    
    static public let shared = forceUpdateModel()
    
    var showDefaultDisplay : Bool = true
    var doesAppNeedUpdate : ((Bool) -> Void)?
    var appID : String?
    var showCloseButton : Bool = false
    
    public init() {}
    
    public func checkVersion(appID : String,showCloseButton: Bool = false) {
        self.appID = appID
        self.showCloseButton = showCloseButton
        if let currentVersion = self.getBundle(key: "CFBundleShortVersionString") {
            _ = getAppInfo { (info, error) in
                if let appStoreAppVersion = info?.version {
                    if let error = error {
                        self.doesAppNeedUpdate?(false)
                        print("error getting app store version: ", error)
                    } else if appStoreAppVersion == currentVersion {
                        self.doesAppNeedUpdate?(false)
                        print("Already on the last app version: ",currentVersion)
                   } else   {
                        print("Needs update: AppStore Version: \(appStoreAppVersion) > Current version: ",currentVersion)
                       self.doesAppNeedUpdate?(true)
                       if self.showDefaultDisplay {
                           DispatchQueue.main.async {
                               if let rootViewController = UIApplication.topViewController() {
                                   let forceUpdateViewController = ForceUpdateViewController()
                                   forceUpdateViewController.appID = self.appID
                                   forceUpdateViewController.modalPresentationStyle = .overFullScreen
                                   rootViewController.present(forceUpdateViewController, animated: true, completion: nil)
                               }
                              
                            }
                       }
                      
                    }
                }
            }
        }
    }
    
    func getBundle(key: String) -> String? {
        
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2 - Add the file to a dictionary
        let plist = NSDictionary(contentsOfFile: filePath)
        // Check if the variable on plist exists
        guard let value = plist?.object(forKey: key) as? String else {
          fatalError("Couldn't find key '\(key)' in 'Info.plist'.")
        }
        return value
    }
    
    private func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
    
      // You should pay attention on the country that your app is located, in my case I put Brazil */br/*
      // Você deve prestar atenção em que país o app está disponível, no meu caso eu coloquei Brasil */br/*
      
        guard let identifier = self.getBundle(key: "CFBundleIdentifier"),
              let url = URL(string: "http://itunes.apple.com/br/lookup?bundleId=\(identifier)") else {
            
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
                return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                
                guard let data = data else { throw VersionError.invalidResponse }
                
                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                print(result.results)
                guard let info = result.results.first else {
                    throw VersionError.invalidResponse
                }
                print(response)
                print(info)
                print(info.trackViewUrl)
                print(info.version)
                
                completion(info, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
        return task

    }
}
#endif
