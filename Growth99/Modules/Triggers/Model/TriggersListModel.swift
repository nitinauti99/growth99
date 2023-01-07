//
//  TriggersListModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

struct TriggersListModel: Codable {
    let bpmnTasks: [JSONAny]
    let bpmnEmails: [Bpmn]
    let updatedBy: String?
    let triggerActionName: String?
    let executionStatus: String?
    let smsFlag: Bool
    let moduleName: String?
    let createdAt: String
    let triggerConditions: [String]?
    let emailFlag: Bool
    let createdBy: String?
    let taskFlag: Bool
    let name: String
    let id: Int
    let bpmnSMS: [Bpmn]
    let updatedAt: String
    let status: String
}

// MARK: - Bpmn
struct Bpmn: Codable {
    let createdAt, updatedAt: String
    let createdBy, updatedBy: CreatedByClass?
    let deleted: Bool
    let tenantID, id: Int
    let triggerFrequency: TriggerFrequency
    let bpmnTriggerType: BpmnTriggerType
    let emailTemplate: EmailTemplate?
    let triggerTime: Int
    let scheduledDateTime: JSONNull?
    let orderOfCondition, actionIndex: Int
    let addNew, showBorder: Bool
    let triggerTarget: TriggerTarget
    let dateType: DateType
    let smsTemplate: SMSTemplate?

    enum CodingKeys: String, CodingKey {
        case createdAt, updatedAt, createdBy, updatedBy, deleted
        case tenantID = "tenantId"
        case id, triggerFrequency, bpmnTriggerType, emailTemplate, triggerTime, scheduledDateTime, orderOfCondition, actionIndex, addNew, showBorder, triggerTarget, dateType, smsTemplate
    }
}

enum BpmnTriggerType: String, Codable {
    case email = "EMAIL"
    case sms = "SMS"
}

// MARK: - CreatedByClass
struct CreatedByClass: Codable {
    let firstName: FirstName
    let lastName: LastName
    let email, username: Email
}

enum Email: String, Codable {
    case nitinauti99GmailCOM = "nitinauti99@gmail.com"
    case systemuserGrowth99COM = "systemuser@growth99.com"
}

enum FirstName: String, Codable {
    case nitin = "Nitin"
    case system = "System"
}

enum LastName: String, Codable {
    case auti = "Auti"
    case user = "User"
}

enum DateType: String, Codable {
    case appointmentAfter = "APPOINTMENT_AFTER"
    case appointmentBefore = "APPOINTMENT_BEFORE"
    case appointmentCreated = "APPOINTMENT_CREATED"
    case na = "NA"
}

// MARK: - EmailTemplate
struct EmailTemplate: Codable {
    let createdAt, updatedAt: String
    let createdBy, updatedBy: CreatedByClass
    let deleted: Bool
    let tenantID, id, defaultEmailTemplateID: Int
    let name, body, subject: String
    let emailTemplateName: JSONNull?
    let defaultEmailTemplate, active: Bool
    let templateFor: TemplateFor
    let emailTarget: Target
    let questionnaire: JSONNull?
    let identifier: String
    let isCustom: JSONNull?
    let isCloneTemplate: Bool

    enum CodingKeys: String, CodingKey {
        case createdAt, updatedAt, createdBy, updatedBy, deleted
        case tenantID = "tenantId"
        case id
        case defaultEmailTemplateID = "defaultEmailTemplateId"
        case name, body, subject, emailTemplateName, defaultEmailTemplate, active, templateFor, emailTarget, questionnaire, identifier, isCustom, isCloneTemplate
    }
}

enum Target: String, Codable {
    case clinic = "Clinic"
    case lead = "Lead"
    case patient = "Patient"
}

enum TemplateFor: String, Codable {
    case appointment = "Appointment"
    case lead = "Lead"
}

// MARK: - SMSTemplate
struct SMSTemplate: Codable {
    let createdAt, updatedAt: String
    let createdBy, updatedBy: CreatedByClass
    let deleted: Bool
    let tenantID, id, defaultSMSTemplateID: Int
    let name, body: String
    let subject: Subject
    let smsTemplateName: JSONNull?
    let templateFor: TemplateFor
    let smsTarget: Target
    let defaultSMSTemplate, active: Bool
    let isCustom: JSONNull?
    let isCloneTemplate: Bool

    enum CodingKeys: String, CodingKey {
        case createdAt, updatedAt, createdBy, updatedBy, deleted
        case tenantID = "tenantId"
        case id
        case defaultSMSTemplateID = "defaultSmsTemplateId"
        case name, body, subject, smsTemplateName, templateFor, smsTarget
        case defaultSMSTemplate = "defaultSmsTemplate"
        case active, isCustom, isCloneTemplate
    }
}

enum Subject: String, Codable {
    case empty = ""
    case test = "Test"
}

enum TriggerFrequency: String, Codable {
    case day = "DAY"
    case hour = "HOUR"
    case min = "MIN"
}

enum TriggerTarget: String, Codable {
    case appointmentClinic = "AppointmentClinic"
    case appointmentPatient = "AppointmentPatient"
    case clinic = "Clinic"
    case lead = "lead"
}

enum CreatedByEnum: String, Codable {
    case nitinAuti = "Nitin Auti"
    case systemUser = "System User"
}

enum ModuleName: String, Codable {
    case appointment = "Appointment"
    case leads = "leads"
}

enum Status: String, Codable {
    case active = "ACTIVE"
    case inactive = "INACTIVE"
}

enum TriggerActionName: String, Codable {
    case canceled = "Canceled"
    case empty = ""
    case pending = "Pending"
}

typealias Welcome = [TriggersListModel]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
