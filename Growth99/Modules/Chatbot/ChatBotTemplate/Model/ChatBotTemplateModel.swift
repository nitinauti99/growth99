//
//  ChatBotTemplateModel.swift
//  Growth99
//
//  Created by Nitin Auti on 11/03/23.
//

import Foundation

struct ChatBotTemplateModel: Codable {
    let code : String?
    let deleted : Bool?
    let name : String?
    let defaultTemplate : Bool?
    let isCustom : String?
    let tenantId : Int?
    let appPreviewUrl : String?
    let id : Int?
    let chatBotId : Int?
    let previewIframeUrl : String?
}
