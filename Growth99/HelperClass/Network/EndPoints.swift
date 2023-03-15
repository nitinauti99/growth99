//
//  EndpointsPoints.swift
//  Growth99
//
//  Created by nitin auti on 18/10/22.
//

import Foundation

struct EndPoints {
    static let baseURL = "https://api.growthemr.com"
    static let auth = "/api/user/auth"
    static let register = "/api/account/register"
    static let forgotPassword = "/api/public/users/forgot-password"
    static let VerifyforgotPassword = "/api/public/users/forgot-password"
    static let userProfile = "/api/v1/user/"
    static let allClinics = "/api/v1/clinics/allClinics"
    static let selectedClinic = "/api/clinics/"
    static let creatClinic = "/api/clinics"
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
    static let paymentRefund = "/api/paymentRefund/businesses/"
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
    static let createService = "/api/services"
    static let editService = "/api/services/"
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
    static let editAppointment = "/api/appointments/"
    static let patientsEditDetail = "/api/v1/patients/"
    static let patientsQuestionnaire = "/api/v1/patient/"
    static let getPatientsQuestionnaire = "/api/patient/"
    static let submitPatientQuestionnnaire = "/api/patient/questionnaire"
    static let patientsQuestionnaireList =  "/api/v1/questionnaire"
    static let removePatient = "/api/public/users/delete?"
    static let removeProfileAppointment = "/api/appointments/"
    static let workflowPatientTasks = "/api/workflowtasks/patient/"
    static let patientTagList = "/api/ptag/list"
    static let leadTagList = "/api/tag/list"
    static let patientAddTags = "/api/ptag/"
    static let patientCreateTags = "/api/ptag"
    static let consentsList = "/api/v1/patients/"
    static let PatientAppointmenList = "/api/v1/patients/"
    static let userByEmail = "/api/v1/userByEmail/"
    static let userByPhone = "/api/v1/userByPhone/"
    static let editAppoints =  "/api/v1/appointments/"
    static let patientsConsentsList =  "/api/v1/consents"
    static let removePatientsTags = "/api/ptag/"
    static let emailTemplatesList = "/api/v1/emailTemplates"
    static let smsTemplatesList = "/api/v1/smsTemplates"
    static let consentsTemplatesList = "/api/v1/consents"
    static let questionnaireTemplatesList = "/api/v1/questionnaire"
    static let profileAppointments = "/api/v1/appointment/user/"
    static let removeConsents = "/api/consents/"
    static let removeQuestionnaire = "/api/questionnaire/"
    static let FormsList = "/api/v1/questionnaire"
    static let createFrom = "/api/questionnaire"
    static let timezonesList = "/api/timezones"
    static let fromDetail = "/api/questionnaire/"
    static let questionnaireFormURL = "/api/questionnaire/"
    static let notificationList = "/api/questionnaire/"
    static let patientsQuestionnaireDetail = "/api/patient/"
    static let createConsentPatients = "/api/patients/"
    static let getBussinessSelection = "/api/public/v1/users/"
    static let getAllEmailandSMS = "/api/trigger?query=%27BroadCast%27"
    static let patentsTimeLine = "/api/v1/audit/patient?patientId="
    static let patientsByTenantId = "/api/v1/patientsByTenantId"
    static let leadTaskList = "/api/workflowtasks/lead/"
    static let getAnnouncementsList = "/api/productionRelease/all"
    static let getLeadHistory = "/api/questionnaire/contact-submissions/email/"
    static let combineLeadTimeLine = "/api/v1/audit/lead/all?leadEmail="
    static let deleteLead = "/api/questionnaire-submissions/"
    static let removeLeadTags = "/api/tag/"
    static let getLeadTagDetail = "/api/tag/"
    static let creatLeadTags = "/api/tag"
    static let updateLeadTags = "/api/tag/"
    static let getDeletedLeadList = "/api/questionnaire-submission/history/pagination?page=0&size=50"
    static let getLeadsourceurls = "/api/leadsourceurls/list"
    static let removeLeadsourceurls = "/api/leadsourceurls/"
    static let updateLeadSourceUrl = "/api/leadsourceurls/"
    static let creatLeadSourceUrl = "/api/leadsourceurls"
    static let getLeadSourceUrl = "/api/leadsourceurls/"
    static let chatconfigs = "/api/chatconfigs"
    static let updateChatConfig = "/api/chatconfigs"
    static let scrapeURL = "/api/chatconfigs/scrap"
    static let chatQuestionare = "/api/chatquestionnaire"
    static let createChatQuestionnaire = "/api/chatquestionnaire/"
    static let getChatquestionnaire = "/api/chatquestionnaire/"
    static let getChatQuestionnaireQuestion = "/api/chatquestionnaire/"
    static let removeChatQuestionnaireQuestion = "/api/chatquestionnaire/"
    static let createChatQuestion = "/api/chatquestionnaire/"
    static let questionnaireSubmissions = "/api/questionnaire/questionnaire-submissions/"
    static let massEmailTrigerList = "/api/v1/trigger/edit"
    static let massEmailBusinessSMSQuota = "/api/v1/business/email-sms/quota"
    static let massEmailAuditEmailSMSQuota = "/api/v1/audit/email-sms/count"
    static let massEmailLeadStatus = "/api/v1/leads/count?"
    static let massEmailAppointmentStatus = "/api/v1/patients/count?"
    static let chatSessions = "/api/chatsessions"
    static let chatBotTemplates = "/api/chatbottemplates"
    static let triggerLandingPageNames = "/api/v1/landingPage/pageNames"
    static let triggerQuestionnaire = "/api/v1/trigger/questionnaire"
    static let chatBotTsSetDefaultemplates = "/api/chatbottemplates/"
    static let chatsessionsDetail = "/api/chatsessions/"
    static let UnansweredQuestionList = "/api/chatquestions"
    static let getMassSMSVariable = "/api/smstemplatenames/MassSMS/variables"
    static let createSMSTemplates = "/api/smstemplates"
    static let getLeadVariable = "/api/smstemplatenames/Lead/variables"
    static let getAppointMEntVariable = "/api/smstemplatenames/Appointment/variables"
    static let getSMSTemplate = "/api/smstemplates/"
    static let deleteUser = "/api/public/users/delete?userId="
    static let marketingMassLead = "/api/trigger/mass-lead"
    static let marketingMassPatient = "/api/trigger/mass-patient"
    static let marketingMassLeadPatient = "/api/trigger/mass-lead-patient"
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
    static let removePatient = EndPoints.baseURL.appending(EndPoints.removePatient)
    static let workflowPatientTasks = EndPoints.baseURL.appending(EndPoints.workflowPatientTasks)
    static let patientTagList = EndPoints.baseURL.appending(EndPoints.patientTagList)
    static let patientAddTags = EndPoints.baseURL.appending(EndPoints.patientAddTags)
    static let patientCreateTags = EndPoints.baseURL.appending(EndPoints.patientCreateTags)
    static let  consentsList = EndPoints.baseURL.appending(EndPoints.consentsList)
    static let  PatientAppointmenList = EndPoints.baseURL.appending(EndPoints.PatientAppointmenList)
    static let editAppoints = EndPoints.baseURL.appending(EndPoints.editAppoints)
    static let patientsConsentsList = EndPoints.baseURL.appending(EndPoints.patientsConsentsList)
    static let removePatientsTags = EndPoints.baseURL.appending(EndPoints.removePatientsTags)
    static let patientsQuestionnaireDetail = EndPoints.baseURL.appending(EndPoints.patientsQuestionnaireDetail)

    static let emailTemplatesList = EndPoints.baseURL.appending(EndPoints.emailTemplatesList)
    static let smsTemplatesList = EndPoints.baseURL.appending(EndPoints.smsTemplatesList)
    static let consentsTemplatesList = EndPoints.baseURL.appending(EndPoints.consentsTemplatesList)
    static let questionnaireTemplatesList = EndPoints.baseURL.appending(EndPoints.questionnaireTemplatesList)
    static let removeConsents = EndPoints.baseURL.appending(EndPoints.removeConsents)
    static let removeQuestionnaire = EndPoints.baseURL.appending(EndPoints.removeQuestionnaire)

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
    static let editAppointment = EndPoints.baseURL.appending(EndPoints.editAppointment)
    static let userByEmail = EndPoints.baseURL.appending(EndPoints.userByEmail)
    static let userByPhone = EndPoints.baseURL.appending(EndPoints.userByPhone)
    static let profileAppointments = EndPoints.baseURL.appending(EndPoints.profileAppointments)
    static let FormsList = EndPoints.baseURL.appending(EndPoints.FormsList)
    static let createFrom = EndPoints.baseURL.appending(EndPoints.createFrom)
    static let fromDetail = EndPoints.baseURL.appending(EndPoints.fromDetail)
    static let notificationList = EndPoints.baseURL.appending(EndPoints.notificationList)
    static let removeProfileAppointment = EndPoints.baseURL.appending(EndPoints.removeProfileAppointment)
    static let timezonesList = EndPoints.baseURL.appending(EndPoints.timezonesList)
    static let selectedClinic = EndPoints.baseURL.appending(EndPoints.selectedClinic)
    static let createService = EndPoints.baseURL.appending(EndPoints.createService)
    static let editService = EndPoints.baseURL.appending(EndPoints.editService)
    static let paymentRefund = EndPoints.baseURL.appending(EndPoints.paymentRefund)
    static let creatClinic = EndPoints.baseURL.appending(EndPoints.creatClinic)
    static let questionnaireFormURL = EndPoints.baseURL.appending(EndPoints.questionnaireFormURL)
    static let createConsentPatients = EndPoints.baseURL.appending(EndPoints.createConsentPatients)
    static let getBussinessSelection = EndPoints.baseURL.appending(EndPoints.getBussinessSelection)
    static let getAllEmailandSMS = EndPoints.baseURL.appending(EndPoints.getAllEmailandSMS)
    static let patentsTimeLine = EndPoints.baseURL.appending(EndPoints.patentsTimeLine)
    static let patientsByTenantId = EndPoints.baseURL.appending(EndPoints.patientsByTenantId)
    static let leadTaskList = EndPoints.baseURL.appending(EndPoints.leadTaskList)
    static let getAnnouncementsList = EndPoints.baseURL.appending(EndPoints.getAnnouncementsList)
    static let getLeadHistory = EndPoints.baseURL.appending(EndPoints.getLeadHistory)
    static let combineLeadTimeLine = EndPoints.baseURL.appending(EndPoints.combineLeadTimeLine)
    static let deleteLead = EndPoints.baseURL.appending(EndPoints.deleteLead)
    static let leadTagList = EndPoints.baseURL.appending(EndPoints.leadTagList)
    static let removeLeadTags = EndPoints.baseURL.appending(EndPoints.removeLeadTags)
    static let getLeadTagDetail = EndPoints.baseURL.appending(EndPoints.getLeadTagDetail)
    static let creatLeadTags = EndPoints.baseURL.appending(EndPoints.creatLeadTags)
    static let updateLeadTags = EndPoints.baseURL.appending(EndPoints.updateLeadTags)
    static let getDeletedLeadList = EndPoints.baseURL.appending(EndPoints.getDeletedLeadList)
    static let getLeadsourceurls = EndPoints.baseURL.appending(EndPoints.getLeadsourceurls)
    static let removeLeadsourceurls = EndPoints.baseURL.appending(EndPoints.removeLeadsourceurls)
    static let creatLeadSourceUrl = EndPoints.baseURL.appending(EndPoints.creatLeadSourceUrl)
    static let updateLeadSourceUrl = EndPoints.baseURL.appending(EndPoints.updateLeadSourceUrl)
    static let getLeadSourceUrl = EndPoints.baseURL.appending(EndPoints.getLeadSourceUrl)
    static let chatconfigs = EndPoints.baseURL.appending(EndPoints.chatconfigs)
    static let updateChatConfig = EndPoints.baseURL.appending(EndPoints.updateChatConfig)
    static let scrapeURL = EndPoints.baseURL.appending(EndPoints.scrapeURL)
    static let chatQuestionare = EndPoints.baseURL.appending(EndPoints.chatQuestionare)
    static let createChatQuestionnaire = EndPoints.baseURL.appending(EndPoints.createChatQuestionnaire)
    static let getChatquestionnaire = EndPoints.baseURL.appending(EndPoints.getChatquestionnaire)
    static let getChatQuestionnaireQuestion = EndPoints.baseURL.appending(EndPoints.getChatQuestionnaireQuestion)
    static let removeChatQuestionnaireQuestion = EndPoints.baseURL.appending(EndPoints.removeChatQuestionnaireQuestion)
    static let createChatQuestion = EndPoints.baseURL.appending(EndPoints.createChatQuestion)
    static let questionnaireSubmissions = EndPoints.baseURL.appending(EndPoints.questionnaireSubmissions)
    static let massEmailTrigerList = EndPoints.baseURL.appending(EndPoints.massEmailTrigerList)
    static let massEmailBusinessSMSQuota = EndPoints.baseURL.appending(EndPoints.massEmailBusinessSMSQuota)
    static let massEmailAuditEmailSMSQuota = EndPoints.baseURL.appending(EndPoints.massEmailAuditEmailSMSQuota)
    static let massEmailLeadStatus = EndPoints.baseURL.appending(EndPoints.massEmailLeadStatus)
    static let massEmailAppointmentStatus = EndPoints.baseURL.appending(EndPoints.massEmailAppointmentStatus)
    static let chatSessions = EndPoints.baseURL.appending(EndPoints.chatSessions)
    static let chatBotTemplates = EndPoints.baseURL.appending(EndPoints.chatBotTemplates)
    static let triggerLandingPageNames = EndPoints.baseURL.appending(EndPoints.triggerLandingPageNames)
    static let triggerQuestionnaire = EndPoints.baseURL.appending(EndPoints.triggerQuestionnaire)
    static let chatBotTsSetDefaultemplates = EndPoints.baseURL.appending(EndPoints.chatBotTsSetDefaultemplates)
    static let chatsessionsDetail = EndPoints.baseURL.appending(EndPoints.chatsessionsDetail)
    static let UnansweredQuestionList = EndPoints.baseURL.appending(EndPoints.UnansweredQuestionList)
    static let getMassSMSVariable = EndPoints.baseURL.appending(EndPoints.getMassSMSVariable)
    static let createSMSTemplates = EndPoints.baseURL.appending(EndPoints.createSMSTemplates)
    static let getLeadVariable = EndPoints.baseURL.appending(EndPoints.getLeadVariable)
    static let getAppointMEntVariable = EndPoints.baseURL.appending(EndPoints.getAppointMEntVariable)
    static let getSMSTemplate = EndPoints.baseURL.appending(EndPoints.getSMSTemplate)
    static let deleteUser = EndPoints.baseURL.appending(EndPoints.deleteUser)
    static let marketingMassLead = EndPoints.baseURL.appending(EndPoints.marketingMassLead)
    static let marketingMassPatient = EndPoints.baseURL.appending(EndPoints.marketingMassPatient)
    static let marketingMassLeadPatient = EndPoints.baseURL.appending(EndPoints.marketingMassLeadPatient)
}

