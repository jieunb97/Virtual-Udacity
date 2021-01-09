//
//  DataFile.swift
//  virtualTouristt
//
//  Created by Jieun Bae on 1/7/21.
//

import Foundation

    struct DataFile: Decodable
        {
        let photos: FlickrPhotos
        }

    struct FlickrPhotos: Decodable
        {
        let photo: [FlickrPhoto]
        }

    struct FlickrPhoto: Decodable
        {
        let url_n: String
        }

