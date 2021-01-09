//
//  FlickrErrorFile.swift
//  virtualTouristt
//
//  Created by Jieun Bae on 1/6/21.
//

import Foundation


struct FlickrErrorFile: Decodable

    {
    
    let status: String?
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey
    
    {
        case status = "stat for now"
        case statusCode = "code"
        case statusMessage = "message of status"
    }
    
    }

extension FlickrErrorFile: LocalizedError

    {
    var errorDescription: String? {
        return statusMessage
    }
    }

