//
//  Constant.swift
//  Libertas
//
//  Created by Jatin Kumar on 9/11/17.
//  Copyright © 2017 Jatin Kumar. All rights reserved.
//

import UIKit


//Base URl for the Application
//live URL
public let baseURL                  = "http://52.15.160.147/resort-ce/Apis/"

//Local URL
// public let baseURL =  "http://202.164.42.226/dev/resort-ce/Apis/"

public struct API {
    public static let signUp                  =           baseURL+"signup_user"
    public static let logIn                   =           baseURL+"login"
    
    public static let userProfileDetail       =    baseURL+"user_profile_details"
    public static let forgetPassword          =           baseURL+"forgot_password"
    public static  let lessons_list           =           baseURL+"lessons_list"
    public static let cardPayment             =           baseURL+"card_payment"
    public static let socialLogin             =           baseURL+"social_login"
    public static let course_listing           =          baseURL+"course_listing"
    public static let one_course_list           =         baseURL+"one_course_list"
    public static let course_add_to_favourite   =      baseURL+"course_add_to_favourite"
    public static let my_course_listing         =         baseURL+"my_course_listing"
    public static let course_in_progress_listing = baseURL+"course_in_progress_listing"
    public static let edituserprofiledetails   = baseURL+"edit_user_profile_details"
    public static let course_add_to_buy             =   baseURL+"course_add_to_buy"
    public static let course_content_listing    =      baseURL+"course_content_listing"
    public static let logout                       = baseURL+"logout"
    public static let profession_listing =          baseURL+"profession_listing"
    public static let getnearbygroups =             baseURL+"get_near_by_groups"
    public static let oneGroupList =                baseURL+"one_group_list"
    public static let subcategory_listing =          baseURL+"subcategory_listing"
    public static let subcategory_course_listing =   baseURL+"subcategory_course_listing"
    public static let completedCourse =              baseURL+"completed_course"
    public static let LockerCourseListing =         baseURL+"locker_course_listing"
    public static let total_credits =         baseURL+"total_credits"
    public static let total_notifications =         baseURL+"total_notifications"
    public static let Notifications =         baseURL+"notifications"
    public static let AddTrip       =         baseURL+"add_trip"
    public static let TripListing       =      baseURL+"my_trip_listing"
    public static let CertificateReport      =      baseURL+"my_profile_data"
    public static let PaymentStripeApplePay     =      baseURL+"payment_using_stripe"
    
    public static let AddExpenses =                     baseURL+"add_expensis"
    public static let EditExpenses =                    baseURL+"edit_expensis"
    
    public static let create_pdf_for_certificate =                baseURL+"create_pdf_for_certificate"
     public static let create_pdf_for_trip_certificate =          baseURL+"create_pdf_for_trip_certificate"
    public static let create_pdf_for_expenses =          baseURL+"create_pdf_for_expenses"
    public static let DeleteExpenses =          baseURL+"delete_expenses"
    
    
    
    
    
    
}


/*********************************  Structures  ********************************/

public struct AppFont {
    public static let helventicaNeue     =     "HelveticaNeue"
    public static let museoSansRegular   =     "MuseoSans-100"
    public static let museoSansBold      =     "MuseoSans-500"
    
}
public struct AppColor {
    //    public static let darkGray        =     UIColor(red: 100.0, green: 100.0, blue: 100.0, alpha: 1.0)
    
}



public struct AppKey {
    public static let status                          = "status"
    public static let message                         = "message"
    public static let userdata                        = "userData"
    public static let data                            = "data"
    public static let accessToken                     = "access_token"
    public static let JWTToken                        = "token"
    public static let main                            = "Main"
    public static let auth                            = "auth"
    
    //Keys for particular Application
    public static let email   = "email"
    public static let fullname = "name"
    public static let  name = "firstname"
    public static let  lastname     = "lastname"
    public static let phone = "phone"
    public static let password   = "password"
    public static let country_code = "country_code"
    public static let AuthorizationKey = "auth_key"
    public static let otp = "otp"
    public static let user_id     = "user_id"
    public static let cardNumber = "card_number"
    public static let cardCvv = "card_cvv"
    public static let cardExpiryMonth = "card_expiry_month"
    public static let cardExpiryYear = "card_expiry_year"
    public  static let LoginStatus = "loginStatus"
    public static let country                             = "country"
    public static let courseId                             = "course_id"
    public static let type                             = "type"
    public static let profession_id = "profession_id"
    public static let professionName    = "Profession_name"
    public static let address = "address"
    public static let gender = "gender"
    public static let dob = "dob"
    public static let latitude = "latitude"
    public static let longitude = "longitude"
    public static let GroupId    = "group_id"
    public static let subcategory_id    = "subcategory_id"
    
    public static let secondary_profession_id    = "secondary_profession_id"
    public static let license                    = "license"
    public static let profession_subspecialty    = "profession_subspecialty"
    public static let second_profession_subspecialty    = "secondary_profession_subspecialty"
    public static let license_number             = "license_number"
    public static let next_renewal_date          = "next_renewal_date"
    public static let renewal_cycle              = "renewal_cycle"
    
    
   
    
    
    
    
    
    
    
    
    public static let tripname    = "trip_name"
    public static let tripdate    = "trip_date"
    public static let trip_end_date              = "trip_end_date"
    public static let tripId    = "trip_id"
    public static let courseids    = "course_ids"
    public static let expensisname    = "expensis_name"
    public static let expensisdate    = "expensis_date"
    public static let expensistype    = "expensis_type"
    public static let expensisamount    = "expensis_amount"
    //////applePay
     public static let token    = "token"
     public static let amount    = "amount"
    
    //// hotel data to store
    public static let HotelId    = "hotel_id"
    public static let Hotelname    = "hotel_name"
    public static let HotelAddress    = "hotel_address"
    public static let HotelPhonenumber    = "hotel_phone"
    public static let HotelWebsite    = "hotel_website"
    public static let HotelLatitude    = "hotel_latitude"
    public static let hotelLongitude    = "hotel_longitude"
    
    
    
    //edit expenses
    public static let expensisId    = "expensis_id" // same parameter with i
    
    public static let expenses_id      =  "expenses_id"
    
    
    
    
    
    
    
   
     
   
    
    
    
    
    
    //Keys for app User Modal Class
    //
    //    public static let  first_name = "first_name"
    //    public static let last_name = "last_name"
    
    
    //    public static let username = "username"
    
    //UserDeafaults
   
    //public static let AuthorizationKey = "Authorization-key"
    
    public static let deviceToken = "device_token"
    public static let device_type =  "device_type"
    //    public static let sender_info = "sender_info"
    //
}




/************************************ Constant ***********************************/

let KAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
public let AppUserDefaults            =      UserDefaults.standard
public let AppNotificationCenter      =      NotificationCenter.default
public typealias KeyValue             =      [String : AnyObject]
public let KPasswordMinLength         =       6
public let KDelayTime                 =       2.0
public let KTimeDuration              =       0.3
public let KOffline                   =       "Offline"
public let KSimulatorToken            =      "simulator123456statatic12345device123456token123456"
public let KLocationServicePath       =      "prefs:root=LOCATION_SERVICES"
public let KPhoneMaxLength            =       12
public let KEmailMaxLength            =       100
public let KPasswordMaxLength         =       20

public let KTankMaxLimit              =       10
public let KAmountMaxLength           =       4
public let KFirstNameLength           =       20
public let KCommentLength             =       300
public var KLoading                   =        "Loading..."
public let KOk                        =        "Ok"
public let kPushDeviceToken            =        "DeviceToken"
/*********************************************************************************/


public let kTextViewPlaceholder          =      "What's Poppin'?"
/************************************ Message ***********************************/
//Commom Messages
public let KAlertTitle                   =      "resortCE"
public let KServerError                  =      "An error occurred, Please try again."
public let KInternetConnection           =      "The Internet connection appears to be offline."
public let kSessionExpired               =       "Session expired. Please login again"
public let KFacebookLoginError           =      "Unable to fetch email."

public let KMinimumPassword              =       "Password length should be minimum \(KPasswordMinLength) characters."
public let KPasswordNotMatch             =       "Password and confirm password does not match."
public let KCheckCameraPermission        =       "You need to provide permission to access camera from settings."
public let KCheckGalleryPermission       =       "You need to provide permission to access gallery from settings."

//Message for Particular Application
//Validation errors
public let KFirstNameTitle                  =      "Please enter first name."
public let KLastNameTitle                   =      "Please enter last name."
public let KUserNameTitle                   =      "Please enter user name."
public let KEmailTitle                      =      "Please enter email."
public let KEnterOTPTitle                      =      "Please enter OTP."
public let kValidEmailTitle                 =      "Please enter valid Email."
public let KPasswordTitle                   =      "Please enter password."
public let kaddTweetAlert                   =      "Please enter your quote."
public let kCountryTitle                    =      "Please enter Country."
public let kSelectCoverPhoto                =      "Please Select Cover Photo."
public let kSelectProfileImage              =      "Please Select Profile Image."
public let KCancel                          =       "Cancel"
public let KYes                             =       "Yes"
//Success Messages
public let kSignUpSuccessMessage            =       "Sign up Successfully. Do you want to Login"
public let kaddBarSuccess                   =       "Bar added Successfully."
public let kProfileUpdatedSuccess           =       "Profile Updated Successfully."
public let kForgotPasswordSuccess           =       "Password has been send to you email. Please check your email."
//Other Messages
public let kUnKnownError                    =       "Server connection is poor"
public let kFollowTitle                     =       "Follow"
public let kUnFollowTitle                   =       "Following"
public let KAddCommentTitle                 =       "Please add Comment."
public let KAddMessageTitle                 =       "Please enter message."
public let KVerifyOTPTitle                   =      "Your account is not verified. Please check your email."
public let KOTPConfirmationTitle                   =      "Your account is verified. Please Login."



