//
//  EndpointsPoints.swift
//  Growth99
//
//  Created by nitin auti on 18/10/22.
//

import Foundation

struct EndPoints {
    static let baseURL = "https://api.growthemr.com"
    static let auth = "/api/auth"
    static let register = "/api/account/register"
    static let forgotPassword = "/api/public/users/forgot-password"
    static let VerifyforgotPassword = "/api/public/users/forgot-password"
    static let userProfile = "/api/v1/user/"
    static let allClinics = "/api/v1/clinics/allClinics"
    static let changePassword = "/api/users/change-password"
    static let serviceCategories = "/api/v1/clinics/serviceCategories?clinicId="
    static let service = "/api/v1/services/serviceCategories?categoryId="
    static let vacationSendRequest = "/api/provider/"
    static let getLeadList = "/api/questionnaire/contact-submissions/filter/pagination"
    static let createLead = "/api/public/popup/questionnaire/"
    static let getQuestionnaireId = "/api/public/questionnaire"
    static let getQuestionnaireList = "/api/public/questionnaire/"
    static let updateQuestionnaireSubmissionAmmount = "/api/questionnaire-submission/lead/"
    static let updateQuestionnaireSubmission = "/api/questionnaire-submission/lead/"
    static let userList = "/api/v1/users/all"
    static let getQuestionnaireListDetail = "/api/questionnaire-submissions/"
    static let getSMStemplatesListDetail = "/api/smstemplates/templateFor/Lead"
    static let getEmailTemplatesListDetail = "/api/emailTemplates/templateFor/Lead"
    static let sendCustomsms = "/api/v1/lead/send-custom-sms"
    static let sendCustomEmail = "/api/v1/lead/send-custom-email"
    static let leadCreation = "/api/questionnaire-submissions/"
    static let auditleadCreation = "/api/v1/audit/lead?"
    static let patientsList = "/api/v1/patients/all?tag=&status="
    static let crearePatients = "/api/patients"
    static let patientsStatus = "/api/patient/"
    static let patientsDetailList = "/api/v1/patients/"
    static let smstemplates = "/api/smstemplates/templateFor/Appointment"
    static let emailTemplates = "/api/emailTemplates/templateFor/Appointment"
    static let updatePatientsInfo = "/api/patient/"
    static let categoriesList = "/api/v1/serviceCategories/all"
    static let createCategories = "/api/servicecategories"
    static let getAllServices = "/api/v1/services/all"
    static let getAllTriggers = "/api/trigger"
    static let workflowtasks = "/api/workflowtasks/all"
    static let usersAll = "/api/v1/users/all"
    static let taskPatientsList = "/api/v1/patients/all"
    static let taskQuestionnaireSubmissionList = "/api/questionnaire-submission/list"
    static let createTaskUser = "/api/workflowtasks"
    static let consentList = "/api/v1/consents"
    static let questionnaireList = "/api/v1/questionnaire"
    static let taskDetail = "/api/workflowtasks/"
    static let providerList = "/api/v1/users/services/providers?serviceId="
    static let calenderInfo = "/api/v1/appointments/calendar/filter?clinicId="
    static let bussinessInfo = "/api/businesses/"
    static let getBussinessInfo = "/api/public/v1/businesses/"
    static let newAppointment = "/api/appointments/new"
    static let patientsEditDetail = "/api/v1/patients/"
    static let patientsQuestionnaire = "/api/v1/patient/"
    static let getPatientsQuestionnaire = "/api/patient/"
    static let submitPatientQuestionnnaire = "/api/patient/questionnaire"
    static let patientsQuestionnaireList =  "/api/v1/questionnaire"
}

struct ApiUrl {
    static let auth = EndPoints.baseURL.appending(EndPoints.auth)
    static let register = EndPoints.baseURL.appending(EndPoints.register)
    static let forgotPassword = EndPoints.baseURL.appending(EndPoints.forgotPassword)
    static let VerifyforgotPassword = EndPoints.baseURL.appending(EndPoints.VerifyforgotPassword)
    static let userProfile = EndPoints.baseURL.appending(EndPoints.userProfile)
    static let allClinics = EndPoints.baseURL.appending(EndPoints.allClinics)
    static let changeUserPassword = EndPoints.baseURL.appending(EndPoints.changePassword)
    static let serviceCategories = EndPoints.baseURL.appending(EndPoints.serviceCategories)
    static let service = EndPoints.baseURL.appending(EndPoints.service)
    static let vacationSubmit = EndPoints.baseURL.appending(EndPoints.vacationSendRequest)
    static let getLeadList = EndPoints.baseURL.appending(EndPoints.getLeadList)
    static let createLead = EndPoints.baseURL.appending(EndPoints.createLead)
    static let getQuestionnaireId = EndPoints.baseURL.appending(EndPoints.getQuestionnaireId)
    static let getQuestionnaireList = EndPoints.baseURL.appending(EndPoints.getQuestionnaireList)
    static let updateQuestionnaireSubmissionAmmount = EndPoints.baseURL.appending(EndPoints.updateQuestionnaireSubmissionAmmount)
    static let updateQuestionnaireSubmission = EndPoints.baseURL.appending(EndPoints.updateQuestionnaireSubmission)
    static let getUserList = EndPoints.baseURL.appending(EndPoints.userList)
    static let getQuestionnaireDetailList = EndPoints.baseURL.appending(EndPoints.getQuestionnaireListDetail)
    static let getSMStemplatesListDetail = EndPoints.baseURL.appending(EndPoints.getSMStemplatesListDetail)
    static let getEmailTemplatesListDetail = EndPoints.baseURL.appending(EndPoints.getEmailTemplatesListDetail)
    static let sendCustomsms = EndPoints.baseURL.appending(EndPoints.sendCustomsms)
    static let sendCustomEmail = EndPoints.baseURL.appending(EndPoints.sendCustomEmail)
    static let leadCreation = EndPoints.baseURL.appending(EndPoints.leadCreation)
    static let auditleadCreation = EndPoints.baseURL.appending(EndPoints.auditleadCreation)
    
    //patients api end Point
    static let patientsList = EndPoints.baseURL.appending(EndPoints.patientsList)
    static let crearePatients = EndPoints.baseURL.appending(EndPoints.crearePatients)
    static let patientsStatus = EndPoints.baseURL.appending(EndPoints.patientsStatus)
    static let patientsDetailList = EndPoints.baseURL.appending(EndPoints.patientsDetailList)
    static let patientsEditDetail = EndPoints.baseURL.appending(EndPoints.patientsEditDetail)
    static let  patientsQuestionnaire = EndPoints.baseURL.appending(EndPoints.patientsQuestionnaire)
    static let getPatientsQuestionnaire = EndPoints.baseURL.appending(EndPoints.getPatientsQuestionnaire)
    static let submitPatientQuestionnnaire = EndPoints.baseURL.appending(EndPoints.submitPatientQuestionnnaire)
    static let patientsQuestionnaireList = EndPoints.baseURL.appending(EndPoints.patientsQuestionnaireList)

    
    static let smstemplates = EndPoints.baseURL.appending(EndPoints.smstemplates)
    static let emailTemplates = EndPoints.baseURL.appending(EndPoints.emailTemplates)
    static let updatePatientsInfo = EndPoints.baseURL.appending(EndPoints.updatePatientsInfo)
    static let categoriesList = EndPoints.baseURL.appending(EndPoints.categoriesList)
    static let createCategories = EndPoints.baseURL.appending(EndPoints.createCategories)
    static let getAllServices = EndPoints.baseURL.appending(EndPoints.getAllServices)
    static let getAllTriggers = EndPoints.baseURL.appending(EndPoints.getAllTriggers)
    static let workflowtasks = EndPoints.baseURL.appending(EndPoints.workflowtasks)
    static let usersAll = EndPoints.baseURL.appending(EndPoints.usersAll)
    static let taskPatientsList = EndPoints.baseURL.appending(EndPoints.taskPatientsList)
    static let taskQuestionnaireSubmissionList = EndPoints.baseURL.appending(EndPoints.taskQuestionnaireSubmissionList)
    static let createTaskUser = EndPoints.baseURL.appending(EndPoints.createTaskUser)
    static let consentList = EndPoints.baseURL.appending(EndPoints.consentList)
    static let questionnaireList = EndPoints.baseURL.appending(EndPoints.questionnaireList)
    static let taskDetail = EndPoints.baseURL.appending(EndPoints.taskDetail)
    static let providerList = EndPoints.baseURL.appending(EndPoints.providerList)
    static let calenderInfo = EndPoints.baseURL.appending(EndPoints.calenderInfo)
    static let bussinessInfo = EndPoints.baseURL.appending(EndPoints.bussinessInfo)
    static let getBussinessInfo = EndPoints.baseURL.appending(EndPoints.getBussinessInfo)
    static let newAppointment = EndPoints.baseURL.appending(EndPoints.newAppointment)
}
