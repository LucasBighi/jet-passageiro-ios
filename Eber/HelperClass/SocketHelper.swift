//
//  SocketHelper.swift
//  Moby App
//
//  Created by Elluminati on 13.03.19.
//  Copyright © 2019 Elluminati. All rights reserved.
//

import Foundation
import SocketIO

class SocketHelper:NSObject
{
    
    let manager = SocketManager(socketURL: URL(string:WebService.BASE_URL)!, config: [.log(true), .compress])
    
    var socket:SocketIOClient? = nil
    let tripDetailNotify:String = "trip_detail_notify"
    let joinTrip:String = "join_trip"
    static let shared = SocketHelper()
    
    private override init()
    {
        super.init()
    }
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    func connectSocket()
    {
        socket = manager.defaultSocket
        socket?.on(clientEvent: .connect)
        { (data, ack) in
            printE("Socket Connection Connected")
        }
        socket?.on(clientEvent: .error) { (data, ack) in
            printE("Socket Connection Error")
            self.disConnectSocket()
        }
        
        socket?.on(clientEvent: .pong) { (data, ack) in
            printE("Socket Connection Pong \(data) Ack \(ack)")
        }
        socket?.connect()
        
    }
    func disConnectSocket()
    {
        if self.socket?.status == .connected
        {
            self.socket?.disconnect()
        }
        
    }
}
