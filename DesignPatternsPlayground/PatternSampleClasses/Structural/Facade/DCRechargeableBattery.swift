//
//  DCRechargeableBattery.swift
//  DesignPatternsPlayground
//
//  Created by Ricardo Pramana Suranta on 2/15/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Foundation

protocol DCRechargeableBatteryDelegate: class {
    
    /// Called when passed `battery`'s `numberOfCurrents` updated.
    func battery(_ battery: DCRechargeableBattery, numberOfCurrentsUpdated: Int)
}

class DCRechargeableBattery {
    
    internal let maximumCurrents = 100
    internal fileprivate(set) var voltage: Double
    
    weak internal var delegate: DCRechargeableBatteryDelegate?
    
    fileprivate var currents = [DCCurrent]() {
        didSet {
            delegate?.battery(self, numberOfCurrentsUpdated: currents.count)
        }
    }
    
    internal var numberOfCurrents: Int {
        return currents.count
    }
    
    init(voltage: Double) {
        self.voltage = voltage
    }
    
    
    /// Returns array of `DCCurrent`s regarding with requested `numberOfCurrents`.
    /// If there's not enough current available, it will return the remaining
    /// `DCCurrent`s.
    internal func retrieveCurrents(_ numberOfCurrents: Int) -> [DCCurrent] {
        
        var passedCurrents = [DCCurrent]()
        var remainingCurrents = [DCCurrent]()
        
        if numberOfCurrents > currents.count {
            
            passedCurrents = currents
            remainingCurrents = []
            
        } else {
        
            passedCurrents = Array( currents[0 ..< numberOfCurrents] )
            remainingCurrents = Array( currents[numberOfCurrents ..< currents.count] )
        
        }
        
        currents = remainingCurrents
        return passedCurrents
    }
    
    /// Recharge this battery with passed `numberOfCurrents`. It wont charge battery past its `maximumCurrents`.
    internal func rechargeCurrents(_ numberOfCurrents: Int) {
        
        var generatedCurrentsCount = 0
        
        if numberOfCurrents + currents.count > maximumCurrents {
            generatedCurrentsCount = maximumCurrents - currents.count
        } else {
            generatedCurrentsCount = numberOfCurrents
        }
        
        var newCurrents = [DCCurrent]()
        for _ in 0 ..< generatedCurrentsCount  {
            let newCurrent = DCCurrent(voltage: voltage)
            newCurrents.append(newCurrent)
        }
        
        currents.append(contentsOf: newCurrents)
    }
    
}
