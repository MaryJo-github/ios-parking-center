//
//  ParkingLot.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/10.
//

struct ParkingLot: Decodable {
    let getParkingInfo: GetParkingInfo

    enum CodingKeys: String, CodingKey {
        case getParkingInfo = "GetParkingInfo"
    }
}

struct GetParkingInfo: Decodable {
    let totalCount: Int
    let result: GetResult
    let information: [ParkingInformation]?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "list_total_count"
        case result = "RESULT"
        case information = "row"
    }
}

struct GetResult: Decodable {
    let code: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

struct ParkingInformation: Decodable, Hashable {
    let name: String
    let address: String
    let type: String
    let typeName: String
    let operationRule: String
    let operationRuleName: String
    let phoneNumber: String
    let queueStatus: String
    let capacity: Double
    let currentParking: Double
    let updatedTime: String
    let payRequired: String
    let payRequiredName: String
    let nightFreeOpen: String
    let nightFreeOpenName: String
    let weekdayBeginTime: String
    let weekdayEndTime: String
    let weekendBeginTime: String
    let weekendEndTime: String
    let holidayBeginTime: String
    let holidayEndTime: String
    let saturdayPayRequired: String
    let saturdayPayRequiredName: String
    let holidayPayRequired: String
    let holidayPayRequiredName: String
    let chargeFullTimeMonthly: String
    let charge: Double
    let chargetimeUnit: Double
    let surcharge: Double
    let surchargeTimeUnit: Double
    let dayMaximumCharge: Double
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case name = "PARKING_NAME"
        case address = "ADDR"
        case type = "PARKING_TYPE"
        case typeName = "PARKING_TYPE_NM"
        case operationRule = "OPERATION_RULE"
        case operationRuleName = "OPERATION_RULE_NM"
        case phoneNumber = "TEL"
        case queueStatus = "QUE_STATUS"
        case capacity = "CAPACITY"
        case currentParking = "CUR_PARKING"
        case updatedTime = "CUR_PARKING_TIME"
        case payRequired = "PAY_YN"
        case payRequiredName = "PAY_NM"
        case nightFreeOpen = "NIGHT_FREE_OPEN"
        case nightFreeOpenName = "NIGHT_FREE_OPEN_NM"
        case weekdayBeginTime = "WEEKDAY_BEGIN_TIME"
        case weekdayEndTime = "WEEKDAY_END_TIME"
        case weekendBeginTime = "WEEKEND_BEGIN_TIME"
        case weekendEndTime = "WEEKEND_END_TIME"
        case holidayBeginTime = "HOLIDAY_BEGIN_TIME"
        case holidayEndTime = "HOLIDAY_END_TIME"
        case saturdayPayRequired = "SATURDAY_PAY_YN"
        case saturdayPayRequiredName = "SATURDAY_PAY_NM"
        case holidayPayRequired = "HOLIDAY_PAY_YN"
        case holidayPayRequiredName = "HOLIDAY_PAY_NM"
        case chargeFullTimeMonthly = "FULLTIME_MONTHLY"
        case charge = "RATES"
        case chargetimeUnit = "TIME_RATE"
        case surcharge = "ADD_RATES"
        case surchargeTimeUnit = "ADD_TIME_RATE"
        case dayMaximumCharge = "DAY_MAXIMUM"
        case latitude = "LAT"
        case longitude = "LNG"
    }
}
