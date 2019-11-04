//
//  appUtils.swift
//  BuddyWatch
//
//  Created by Nirbhay Singh on 04/11/19.
//  Copyright © 2019 Nirbhay Singh. All rights reserved.
//

import Foundation
import SCLAlertView

func showAlert(msg:String){
    SCLAlertView().showError("Oops!", subTitle:msg)

}
