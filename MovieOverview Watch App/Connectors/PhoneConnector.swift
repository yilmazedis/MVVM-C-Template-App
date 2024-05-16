//
//  PhoneConnector.swift
//  MovieOverview Watch App
//
//  Created by yilmaz on 27.04.2024.
//

import WatchConnectivity

class PhoneConnector:NSObject,ObservableObject {
    
    // public variables
    
    static let shared = PhoneConnector()
    
    public let session = WCSession.default
        
    @Published var users: [Movie] = []
        
    private override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        } else {
            print("Not supported")
        }
    }
    
}

// MARK: - WCSessionDelegate methods

extension PhoneConnector: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("session activation failed with error: \(error)")
            return
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        dataReceivedFromPhone(userInfo)
    }
    
    // MARK: use this for testing in simulator
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        dataReceivedFromPhone(message)
    }
}


// MARK: - send data to phone
extension PhoneConnector {
    public func sendDataToPhone(_ movie: Movie) {
        let dict: [String: Any] = ["data": movie.encodeIt()]
        
        //session.transferUserInfo(dict)
        // for testing in simulator we use
        session.sendMessage(dict, replyHandler: nil)
    }
    
}

// MARK: - receive data
extension PhoneConnector {
    public func dataReceivedFromPhone(_ info: [String: Any]) {
        let data: Data = info["data"] as! Data
        let movie = Movie.decodeIt(data)
        DispatchQueue.main.async {
            self.users.append(movie)
        }
    }
}
