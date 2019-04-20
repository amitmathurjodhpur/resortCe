//
//  Trip+CourseObj.swift
//  ResortCeApp
//
//  Created by Amit Mathur on 2/4/19.
//  Copyright © 2019 AJ12. All rights reserved.
//

import Foundation

class Course {
    var courseId: String = ""
    var courseName: String = ""
    var status: String = ""
    var courseDate: String = ""
    
    init(courseId: String, courseName: String, status: String, courseDate: String) {
        self.courseId = courseId
        self.courseName = courseName
        self.status = status
        self.courseDate = courseDate
    }
}

class Trip {
    var tripeId: String = ""
    var tripName: String = ""
    var status: String = ""
    var tripDate: String = ""
    
    init(tripeId: String, tripName: String, status: String, tripDate: String) {
        self.tripeId = tripeId
        self.tripName = tripName
        self.status = status
        self.tripDate = tripDate
    }
}

class Expense {
    var expenseId: String = ""
    var expenseName: String = ""
    var expenseType: String = ""
    var expenseAmount: String = ""
    var expenseDate: String = ""
    var receiptPath: String = ""
    
    init(expenseId: String, expenseName: String, expenseType: String, expenseAmount: String, expenseDate: String, receiptPath: String) {
        self.expenseName = expenseName
        self.expenseId = expenseId
        self.expenseType = expenseType
        self.expenseAmount = expenseAmount
        self.expenseDate = expenseDate
        self.receiptPath = receiptPath
    }
}

class Hotel {
    var hotelId: String = ""
    var hotelName: String = ""
    var hotelAddress: String = ""
    var hotelLat: String = ""
    var hotelLong: String = ""
    var hotelPhoneNo: String = ""
    var hotelWebsite: String = ""
    var coursesInHotel: [Course] = []
   
    init(hotelId: String, hotelName: String, hotelAddress: String, hotelLat: String, hotelLong: String, hotelPhoneNo: String, hotelWebsite: String, coursesInHotel: [Course]) {
        self.hotelId = hotelId
        self.hotelName = hotelName
        self.hotelAddress = hotelAddress
        self.hotelLat = hotelLat
        self.hotelLong = hotelLong
        self.hotelPhoneNo = hotelPhoneNo
        self.hotelWebsite = hotelWebsite
        self.coursesInHotel = coursesInHotel
    }
}
    class GroupLecture {
        var groupId: String = ""
        var groupName: String = ""
        var groupAddress: String = ""
        var groupLat: String = ""
        var groupLong: String = ""
        var groupDate: String = ""
        var groupImage: String = ""
        var groupDesc: String = ""
        
        init(groupId: String, groupName: String, groupAddress: String, groupLat: String, groupLong: String, groupDate: String, groupImage: String, groupDesc: String) {
            self.groupId = groupId
            self.groupName = groupName
            self.groupAddress = groupAddress
            self.groupLat = groupLat
            self.groupLong = groupLong
            self.groupDate = groupDate
            self.groupImage = groupImage
            self.groupDesc = groupDesc
        }
    }
