//
//  MediaLibraryModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//


struct MediaLibraryListModel: Codable {
    let content : [Content]?
    let pageable : Pageable?
    let last : Bool?
    let totalElements : Int?
    let totalPages : Int?
    let sort : Sort?
    let first : Bool?
    let numberOfElements : Int?
    let size : Int?
    let number : Int?
    let empty : Bool?
}

struct Content : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let filename : String?
    let contentType : String?
    let location : String?
    let tag : String?
    let socialTags : [SocialTags]?
}

struct LibraryTag : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let isDefault : Bool?
}

struct Pageable : Codable {
    let sort : Sort?
    let pageNumber : Int?
    let pageSize : Int?
    let offset : Int?
    let paged : Bool?
    let unpaged : Bool?
}

struct SocialTags : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let libraryTag : MediaTagListModel?
}

struct Sort : Codable {
    let sorted : Bool?
    let unsorted : Bool?
    let empty : Bool?
}
