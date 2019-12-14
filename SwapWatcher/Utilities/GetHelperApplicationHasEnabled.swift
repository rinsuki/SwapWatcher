//
//  GetHelperApplicationHasEnabled.swift
//  SwapWatcher
//
//  Created by user on 2019/12/14.
//  Copyright © 2019 rinsuki. All rights reserved.
//

import Foundation
import ServiceManagement

func getHelperApplicationHasEnabled(_ bundleId: String) -> Bool {
    let jobs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue()
    for job in (jobs as! [NSDictionary]) {
        guard let label = job["Label"] as? String else { continue }
        guard label == bundleId else { continue }
        return (job["OnDemand"] as? Bool) ?? false
    }
    return false
}
