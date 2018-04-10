//
//  Constants.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 7..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

struct Constants {
  //notification
  let NOTI_DRAW_COMPLETED = Notification.Name("drawCompleted")
  let NOTI_PHOTO_SELECTED = Notification.Name(rawValue: "photoSelected")
}
