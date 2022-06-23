//
//  AppDelegate.swift
//  GPLX
//
//  Created by MacOne-YJ4KBJ on 09/06/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var showAnswer = false
    static let nameFolder = "data-ios-gplx"
    static let nameFileData = "data-json.txt"
    static var dataAll = [Items]()
    static var didArrayAnswer = [DidAnswers]()
    let urlString = "https://api.jsonbin.io/b/62a1528f449a1f382101c7bb"
    let manager = FileManager.default
    var dataString = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        checkFileManager()
        return true
    }
    
    func checkFileManager(){
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return
        }
        print(url.path)
        let folder = url.appendingPathComponent("data-ios-gplx")
        let file = folder.appendingPathComponent("data-json.txt")
        if !manager.fileExists(atPath: folder.path){
            do{
                try manager.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
                loadfileJsonRoot(url: urlString,path: file.path)
            }catch{
                
            }
        }
        else{
          
        }
    }
    
    func loadfileJsonRoot(url : String,path: String){
        if !manager.fileExists(atPath: path){
            URLSession.shared.dataTask(with: URL(string: url)!) { [self] data, response, error in
                if error == nil{
                    do{
                        let data2 = try JSONDecoder().decode(Item.self, from: data!)
                        for i in 0..<data2.count{
                            let item = ItemRealm()
                            item.lessions = i
                            DispatchQueue.main.async {
                                ManagerRealm.shareInstance.addData(item)
                            }
                        }
                        let data1 = String(data: data!, encoding: .utf8)!
                        DispatchQueue.main.async {
                            self.manager.createFile(atPath: path, contents: data1.data(using: .utf8), attributes: nil)
                        }
                    }
                    catch{
                        print("Fail Loading")
                    }
                }
                else{
                    print(error!)
                }
            }.resume()
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

