//
//  DataManager.swift
//  Agenda CPBR
//
//  Created by Bruno Patrocinio on 17/01/15.
//  Copyright (c) 2015 Skynet. All rights reserved.

import Foundation

let agendaURL = "http://beta.campus-party.org/static/js/stages/cpbr8-schedule.json"

class DataManager {
    
    class func getAgendaWithSuccess(success: ((agendaData: NSData!) -> Void)) {
        //1
        loadDataFromURL(NSURL(string: agendaURL)!, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                //3
                success(agendaData: urlData)
            }
        })
    }
    

    
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        var session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.raywenderlich", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
    
    class func loadData(completion:(data: NSData?, error: NSError?) -> NSData) {
        var session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(NSURL(string: agendaURL)!, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.raywenderlich", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
}