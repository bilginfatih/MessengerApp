//
//  StorageManager.swift
//  MessengerApp
//
//  Created by Fatih Bilgin on 4.11.2022.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureComplation = (Result<String, Error>) -> Void
    
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureComplation ) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                //failed
                print("Failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownload))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url string: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownload
    }
}
