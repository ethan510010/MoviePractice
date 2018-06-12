//
//  APIManager.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/10.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import Foundation
import UIKit

class APIManager{
    static let shared = APIManager()
    
    //GET請求
    func getRequest(url:String, queryParameters:[String:Any]?,headerParameters:[String:String]?,completion: @escaping((NSDictionary)?)->Void){
        guard var url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = []
        if queryParameters != nil{
            for (key,value) in queryParameters!{
                urlComponents?.queryItems?.append(URLQueryItem(name: key, value: value as! String))
            }
        }
        url = (urlComponents?.url)!
        request = URLRequest(url: url)
        if headerParameters != nil{
            for (key,value) in headerParameters!{
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            if let response = response as? HTTPURLResponse, let data = data{
                if response.statusCode == 200{
                    do{
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                        completion(jsonData as? (NSDictionary))
                    }catch{
                        completion(nil)
                        print(error.localizedDescription)
                    }
                }else{
                    print("status code is wrong")
                }
            }
        }
        task.resume()
    }
    
    //decode型的GET請求
    func fetchMovie(url:String, queryParameters:[String:Any]?, headerParameters:[String:String]?,completion: @escaping(([Movie])?)->Void){
        guard var url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = []
        if queryParameters != nil{
            for (key,value) in queryParameters!{
                urlComponents?.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }
        
        url = (urlComponents?.url)!
        request = URLRequest(url: url)
        if headerParameters != nil{
            for (key,value) in headerParameters!{
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            if let response = response as? HTTPURLResponse, let data = data{
                if response.statusCode == 200{
                    do{
                        print(data)
                        let decodeData = try JSONDecoder().decode(MovieApiResponse.self, from: data)
                        completion(decodeData.movies)
                    }catch{
                        completion(nil)
                        print("Decode Error")
                        print(error.localizedDescription)
                    }
                }else{
                    print("status code is wrong")
                }
            }
        }
        task.resume()
    }
    
    //下載圖片
    let imageCache = NSCache<NSURL, UIImage>()
    func downloadImage(imageURL:String, completion: @escaping (UIImage)->Void){
        guard let url = URL(string: imageURL) else {
            completion(UIImage())
            return
        }
        if let imageFromCache = imageCache.object(forKey: url as NSURL){
            completion(imageFromCache)
        }else{
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!.localizedDescription)
                    return
                }
                guard let imageData = data, let downloadedImage = UIImage(data: imageData) else {
                    completion(UIImage())
                    return
                }
                self.imageCache.setObject(downloadedImage, forKey: url as NSURL)
                completion(downloadedImage)
            }
            task.resume()
        }
    }
    
    //POST請求 application/json格式
    func postRate(postURL:String,queryParameter:[String:Any]?,bodyParameters:[String:Any] ,headerParameter:[String:String]?, completion: @escaping(NSDictionary?)->Void){
        guard var postURL = URL(string: postURL) else {return}
        var request = URLRequest(url: postURL)
        var urlComponents = URLComponents(url: postURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = []
        if queryParameter != nil{
            for (key,value) in queryParameter!{
                urlComponents?.queryItems?.append(URLQueryItem(name: key, value: value as! String))
            }
        }
        postURL = (urlComponents?.url)!
        print(postURL)
        request = URLRequest(url: postURL)
        if headerParameter != nil{
            for (key,value) in headerParameter!{
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
            
        } catch  {
            print(error.localizedDescription)
        }
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse, let data = data{
                if response.statusCode == 201{
                    do{
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        completion(responseJSON as? (NSDictionary))
                    }catch{
                        print(error.localizedDescription)
                        completion(nil)
                        return
                    }
                }
            }
        }
        task.resume()
    }
    
}
