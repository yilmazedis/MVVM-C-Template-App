//
//  WatchConnector.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 27.04.2024.
//

import WatchConnectivity

class WatchConnector: NSObject, ObservableObject {
    static let shared = WatchConnector()
    
    public var session = WCSession.default
    
    @Published var movies: [Movie] = []
    
    // It doesn't send message immediatelly beacause session.activate() takes time.
    // So after activation is completed you can send message.
    // You may setup this inside of AppDelegate.
    private override init(){
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
extension WatchConnector:WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        session.activate()
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        dataReceivedFromWatch(userInfo)
    }
    
    // MARK: use this for testing in simulator
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        dataReceivedFromWatch(message)
    }
    
    
}

// MARK: - send data to watch
extension WatchConnector {
    
    public func sendDataToWatch(_ user: Movie) {
        let dict: [String: Any] = ["data": user.encodeIt()]
        
        //session.transferUserInfo(dict)
        // for testing in simulator we use
        session.sendMessage(dict, replyHandler: nil)
    }
    
}

// MARK: - receive data
extension WatchConnector {
    public func dataReceivedFromWatch(_ info: [String: Any]) {
        let data: Data = info["data"] as! Data
        let movie = Movie.decodeIt(data)
        print("dataReceivedFromWatch")
        DispatchQueue.main.async {
            self.movies.append(movie)
        }
    }
}
