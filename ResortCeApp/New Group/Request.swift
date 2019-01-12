//
//  Request.swift
//  Libertas
//
//  Created by Jatin Kumar on 9/11/17.
//  Copyright © 2017 Jatin Kumar. All rights reserved.
//

import UIKit

class Request: NSObject {

//     // Signup Request
    static func editProfile(_ authorization_key: String,_ name: String, _ email: String,_ phoneNumber: String,_ Address: String,_ Profession: String,_ lastname : String,_ Latitude:String,_ longitude:String,_ license:String,_ secondProfeesionId:String,_ ProfessionSubspeaciality:String,_ SecondProfesionSubspeciality:String,_ LicenseNumber:String,_ NextRenewalDate:String,_ RenewalCycle:String) -> [String: Any] {
        return [AppKey.AuthorizationKey:authorization_key,AppKey.name: name, AppKey.email : email, AppKey.address : Address, AppKey.phone : phoneNumber, AppKey.profession_id : Profession,AppKey.lastname : lastname,AppKey.latitude:Latitude,AppKey.longitude:longitude,AppKey.license:license,AppKey.secondary_profession_id:secondProfeesionId,AppKey.profession_subspecialty:ProfessionSubspeaciality,AppKey.license_number:LicenseNumber,AppKey.next_renewal_date:NextRenewalDate,AppKey.renewal_cycle:RenewalCycle,AppKey.second_profession_subspecialty:SecondProfesionSubspeciality]
    }
//    //imageData Request
//    static func imageMultipart(_ imgData: Data) -> [String: Any] {
//        return ["photo" : imgData]
//    }
//
//    // otp Request
//    static func otp(_ otp: String) -> [String:Any] {
//        return [AppKey.otp: otp]
//    }
//    // otp Resend OTP
//    static func resendOtp(_ auth_key: String) -> [String:Any] {
//        return [AppKey.AuthorizationKey: auth_key]
//    }
    // Set Authrisation Key Request
    static func setauthKey(_ authorization_key: String) -> [String: Any] {
        return [AppKey.AuthorizationKey : authorization_key]
    }
    //One Course List ID
    static func oneCourseId(_ authorization_key: String,_ course_id:String) -> [String: Any] {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.courseId:course_id]
    }
    
    static func AddtoFav(_ authorization_key: String,_ id:String,_ type:String) -> [String: Any] {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.courseId:id,AppKey.type:type]
    }
    
    static func AddtoBuy(_ authorization_key: String,_ id:String,_ type:String,_ GroupId:String,_ HotelId:String,_ HotelName:String,_ hotelAddress:String,_ hotelLat:String,_ HotelLongi:String,_ Hotelwebsite:String,_ hotelphone:String) -> [String: Any] {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.courseId:id,AppKey.type:type,AppKey.GroupId:GroupId,AppKey.HotelId:HotelId,AppKey.Hotelname:HotelName,AppKey.HotelAddress:hotelAddress,AppKey.HotelLatitude:hotelLat,AppKey.hotelLongitude:HotelLongi,AppKey.HotelWebsite:Hotelwebsite,AppKey.HotelPhonenumber:hotelphone]
    }
    
    static func GetNearGroups(_ authorization_key: String,_ lat:String,_ long:String) -> [String: Any] {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.latitude:lat,AppKey.longitude:long]
    }
    
    static func OneGroupList(_ authorization_key: String,_ GroupId:String) -> [String: Any]
    {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.GroupId:GroupId]
    }
   
    static func SubCategoryCourseListing(_ authorization_key: String,_ subcategory_id:String) -> [String: Any]
    {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.subcategory_id:subcategory_id]
    }
    
    //create a trip
    static func AddTrip(_ authorization_key: String,_ TripName:String,_ TripDate:String,
                        _ TripEndDate:String,_ selectedCourseId:String) -> [String: Any]
    {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.tripname:TripName,AppKey.tripdate:TripDate,AppKey.courseids:selectedCourseId,AppKey.trip_end_date:TripEndDate]
    }
    //
    static func StripeApplePay(_ authorization_key: String,_ courseId:String,_ token:String,_ amount:String)-> [String: Any]
    {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.courseId:courseId,AppKey.token:token,AppKey.amount:amount]
    }
    
    //AddExpense
    
    static func AddExpenses(_ authorization_key: String,_ TripId:String,_ ExpenseName:String,_ ExpenseDate:String,_ ExpenseType:String,_ ExpenseAmount:String) -> [String: Any]
    {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.tripId:TripId,AppKey.expensisname:ExpenseName,AppKey.expensisdate:ExpenseDate,AppKey.expensistype:ExpenseType,AppKey.expensisamount:ExpenseAmount]
    }
    
    static func EditExpenses(_ authorization_key: String,_ ExpenseId:String,_ TripId:String,_ ExpenseName:String,_ ExpenseDate:String,_ ExpenseType:String,_ ExpenseAmount:String) -> [String: Any]
    {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.expensisId:ExpenseId,AppKey.tripId:TripId,AppKey.expensisname:ExpenseName,AppKey.expensisdate:ExpenseDate,AppKey.expensistype:ExpenseType,AppKey.expensisamount:ExpenseAmount]
    }
    
    //certificates for completed courses
    static func CreatePdfCertificateOfCourses(_ authorization_key: String,_ courseId:String) -> [String: Any]
    {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.courseId:courseId]
    }
     //certificates for Trips
    static func CreatePdfCertificateOfTrips(_ authorization_key: String,_ tripId:String,_ hotelNameAndAddress:String) -> [String: Any]
    {
        return [AppKey.AuthorizationKey : authorization_key,AppKey.tripId:tripId,AppKey.Hotelname:hotelNameAndAddress]
    }
    
    static func DeleteExpenses(_ authorization_key: String,_ TripId:String,_ ExpenseId:String) -> [String: Any]
    {
        return [AppKey.AuthorizationKey:authorization_key,AppKey.tripId:TripId,AppKey.expenses_id:ExpenseId]
    }
    
    
    
    
    
//    // signin
//    static func login(_ email: String,_ password: String,_ deviceToken: String) -> [String: Any] {
//        return[AppKey.email: email,AppKey.password: password,AppKey.deviceToken:deviceToken]
//    }
//    // ForgetPassword
//    static func ForgetPassword(_ email: String) -> [String: Any] {
//        return[AppKey.email: email]
//    }
//    // lessons_list
//    static func lessonslist(_ user_id: String)-> [String: Any] {
//        return[AppKey.user_id: user_id]
//    }
//    // payment
//    static func paymentRequest(_ user_id: String,_card_number: String,_card_cvv: String,_card_expiry_month: String,_card_expiry_year:String)-> [String: Any] {
//        return[AppKey.user_id: user_id,AppKey.cardNumber: _card_number,AppKey.cardCvv: _card_cvv,AppKey.cardExpiryMonth: _card_expiry_month,AppKey.cardExpiryYear: _card_expiry_year]
//    }
}

