//
//  TheObserver.swift
//  FinalTestRoman
//
//  Created by MCS on 10/13/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation

public class TheObserver<ObservedType>{
    public typealias Observer = (_ observable: TheObserver<ObservedType>, ObservedType) -> Void
    private var observers: [Observer]
    public var value: ObservedType?{
        didSet{
            if let value = value{
                notifyObservers(value)
            }
        }
    }
    public init(_ value: ObservedType? = nil){
        self.value = value
        observers = []
    }
    public func bind(observer: @escaping Observer){
        self.observers.append(observer)
    }
    public func notifyObservers(_ value: ObservedType){
        self.observers.forEach{[unowned self] (observer) in
            observer(self, value)
        }
    }
}
