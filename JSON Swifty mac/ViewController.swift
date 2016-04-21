//
//  ViewController.swift
//  JSON Swifty mac
//
//  Created by Kent Drescher on 12/3/15.
//  Copyright © 2015 Kent_Drescher. All rights reserved.
//

import Cocoa

extension String
{
    func substringWithRange(start: Int, end: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.characters.count
        {
            print("end index \(end) out of bounds")
            return ""
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(end))
        return self.substringWithRange(range)
    }
    
    func substringWithRange(start: Int, location: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if location < 0 || start + location > self.characters.count
        {
            print("end index \(start + location) out of bounds")
            return ""
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(start + location))
        return self.substringWithRange(range)
    }
}

class record {
    
    var userInviteCode: String!
    var timestamp: String!
    var date: String!
    var time: String!
    var buttonID: String!
    var appId: String!
    var sessionId: String!
    var event: String!
    var subjectId: String!
    var parentId: String!
    var authorId: String!
    var createdAt: String!
    var updatedAt: String!
    var entryId: String!
    
    var buttonName: String!
    var name: String!
    var question: String!
    var answer: String!
    var location: String!
    var displayName: String!
    var uniqueID: String!
    var from: String!
    var exportCompleted: String!
    var assessments: String!
    var pss01: String!
    var pss02: String!
    var pss03: String!
    var pss04: String!
    var pss05: String!
    var pss06: String!
    var pss07: String!
    var pss08: String!
    var pss09: String!
    var pss10: String!
    var pssTotal: String!
    var userSafetyState: String!
    var suds: String!
    var resuds: String!
    var sleep: String!
    var anonymousUsage: String!
    var lastScore: String!
    var completed: String!
    var score: String!
    var remindAssess: String!
    var remindWake: String!
    var remindBed: String!
    var remindWorry: String!
    var remindReset: String!
    var remindSleep: String!
    var remindWindDn: String!
    var remindCaffeine: String!
    var remindRx: String!
    var isiProvider: String!
    
    init(userInviteCode: String) {
        self.userInviteCode = userInviteCode
    }
}

var records = [record]()
var myFilteredRecs = [record]()
var objects = [[String: String]]()
var buttons = [String]()
var times = [String]()
var sessions = [String]()
var currentSession = ""


class ViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet weak var inviteCodeText: NSTextField!
    @IBOutlet weak var pageSizeText: NSTextField!
    @IBOutlet weak var pageNumText: NSTextField!
    @IBOutlet weak var startDtText: NSTextField!
    @IBOutlet weak var endDtText: NSTextField!
    @IBOutlet weak var startTmText: NSTextField!
    @IBOutlet weak var endTmText: NSTextField!
    @IBOutlet weak var filenameText: NSTextField!

    @IBOutlet weak var warningLabel: NSTextField!
    @IBOutlet weak var warningLabel2: NSTextField!

    @IBOutlet var myTextView: NSTextView!
    
    var apiSelected = false
    var apiCode = ""
    var output = String()
    var summaryOutput = String()
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func saveOutput(sender: AnyObject) {
        
        var filename = String()
        var filename2 = String()
        
        print("Save Output Pressed")
        
        if (filenameText.stringValue != "") {
            filename = filenameText.stringValue + ".csv"
            filename2 = filenameText.stringValue + "_summary.csv"
            
        }  else {
            
            filename = "JSONData.csv"
            filename2 = "JSONData_Summary.csv"
            print("filename = \(filename)")
        }
        
        
        let wholeFilename = getDocumentsDirectory().stringByAppendingPathComponent(filename)
        
        do {
            try output.writeToFile(wholeFilename, atomically: true, encoding: NSUTF8StringEncoding)
            warningLabel.stringValue = "File \(filename) created in Documents"
        } catch let error as NSError {
            print("Error: \(error)")
            warningLabel.stringValue = "Error: \(error)"
        }

        let wholeFilename2 = getDocumentsDirectory().stringByAppendingPathComponent(filename2)
        
        do {
            try summaryOutput.writeToFile(wholeFilename2, atomically: true, encoding: NSUTF8StringEncoding)
            warningLabel2.stringValue = "File \(filename2) created in Documents"

        } catch let error as NSError {
            print("Error: \(error)")
            warningLabel.stringValue = "Error: \(error)"
            
        }
        
    }
    
    
    @IBAction func cbtiPress(sender: AnyObject) {
        
        print("CBTi Press")
        apiSelected = true
        apiCode = "969ad33b-fcc9-494a-acc6-66bfe2f2d1b6"
    }
    

    @IBAction func familyPress(sender: AnyObject) {
        
        print("Family Press")
        apiSelected = true
        apiCode = "f411c0fb-ba04-4580-a828-3b4b5eef192d"
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func searchPress(sender: AnyObject) {
    
        print("Search Press")
        let urlStem = "http://104.236.6.220/queryCode/"
        let urlStem2 = "?X-Api-Key="
        var urlText = ""
        var pgNm = ""
        var pgSz = ""
    
        //var stTm = "00:00:00"
        var stEndDtTm = ""
        
        let inviteCode = inviteCodeText!
        let pgNumTxt =  pageNumText!
        let pgSizeTxt = pageSizeText!
        let stDtTxt = startDtText!
        let stTmTxt = startTmText!
        let endDtTxt = endDtText!
        let endTmTxt = endTmText!

        if (pgNumTxt.stringValue != "") { pgNm = "&pageNum=" + pgNumTxt.stringValue; print(pgNumTxt.stringValue) }
        if (pgSizeTxt.stringValue != "") { pgSz = "&pageSize=" + pgSizeTxt.stringValue; print(pgSizeTxt.stringValue) }
        
        if (stDtTxt.stringValue != "") && (endDtTxt.stringValue != "") { stEndDtTm = "&startDate=" + stDtTxt.stringValue + "T" + stTmTxt.stringValue + "Z&endDate=" + endDtTxt.stringValue + "T" + endTmTxt.stringValue + "Z" }

        if (apiSelected == true) && (inviteCode.stringValue != "") {
            //urlText = urlStem + inviteCode.stringValue + urlStem2 + apiCode + pgSz + pgNm + stEndDtTm
            urlText = urlStem + inviteCode.stringValue + urlStem2 + apiCode + pgSz + pgNm + stEndDtTm
            
            print(urlText)
            
            //urlText = "http://104.236.6.220/queryCode/7jmi5u?X-Api-Key=969ad33b-fcc9-494a-acc6-66bfe2f2d1b6"
            
            //inviteText.resignFirstResponder()
            inviteCodeText.stringValue = ""
   
            //Load JSON from URL
            if let url = NSURL(string: urlText) {
                if let data = try? NSData(contentsOfURL: url, options: []) {
                    let json = JSON(data: data)
                    
                    //print(json)
                    for i in 0 ..< json.count
                    {
                        if (json[i]["content"]["sessionId"] != nil) {
                           buttons.append(json[i]["content"]["sessionId"].stringValue)
                            times.append(json[i]["content"]["timestamp"].stringValue)
                        }
                        var rec = record(userInviteCode: "")
                        rec.userInviteCode = json[i]["content"]["userInviteCode"].stringValue
                        
                        let index1 = json[i]["content"]["timestamp"].stringValue.startIndex.advancedBy(10)
                        let date = json[i]["content"]["timestamp"].stringValue.substringToIndex(index1)
                        let index2 = json[i]["content"]["timestamp"].stringValue.startIndex.advancedBy(11)
                        let tmp = json[i]["content"]["timestamp"].stringValue.substringFromIndex(index2)
                        let index3 = tmp.startIndex.advancedBy(8)
                        let time = tmp.substringToIndex(index3)
                        rec.timestamp = date + " " + time
                        rec.date = date
                        rec.time = time
                        rec.buttonID = json[i]["content"]["buttonID"].stringValue
                        rec.appId = json[i]["content"]["appId"].stringValue
                        rec.sessionId = json[i]["content"]["sessionId"].stringValue
                        rec.event = json[i]["content"]["event"].stringValue
                        rec.subjectId = json[i]["content"]["subjectId"].stringValue
                        rec.parentId = json[i]["content"]["parentId"].stringValue
                        rec.authorId = json[i]["content"]["authorId"].stringValue
                        rec.createdAt = json[i]["content"]["createdAt"].stringValue
                        rec.updatedAt = json[i]["content"]["updatedAt"].stringValue
                        rec.entryId = json[i]["content"]["entryId"].stringValue
                        
                        rec.buttonName = json[i]["content"]["metadata"]["buttonName"].stringValue
                        rec.name = json[i]["content"]["metadata"]["name"].stringValue
                        rec.question = json[i]["content"]["metadata"]["question"].stringValue
                        rec.answer = json[i]["content"]["metadata"]["answer"].stringValue
                        rec.location = json[i]["content"]["metadata"]["location"].stringValue
                        rec.displayName = json[i]["content"]["metadata"]["displayName"].stringValue
                        rec.uniqueID = json[i]["content"]["metadata"]["uniqueID"].stringValue
                        rec.from = json[i]["content"]["metadata"]["from"].stringValue
                        rec.exportCompleted = json[i]["content"]["metadata"]["Export Completed"].stringValue
                        rec.assessments = json[i]["content"]["metadata"]["Assessments"].stringValue
                        rec.sleep = json[i]["content"]["metadata"]["Sleep"].stringValue
                        rec.anonymousUsage = json[i]["content"]["metadata"]["Anonymous Usage"].stringValue
                        rec.lastScore = json[i]["content"]["metadata"]["lastScore"].stringValue
                        rec.completed = json[i]["content"]["metadata"]["completed"].stringValue
                        rec.score = json[i]["content"]["metadata"]["score"].stringValue
                        rec.suds = json[i]["content"]["metadata"]["buttonName"].stringValue
                        rec.remindAssess = json[i]["content"]["metadata"]["Take Assessment Reminder"].stringValue
                        rec.remindWake = json[i]["content"]["metadata"]["Wake Reminder"].stringValue
                        rec.remindBed = json[i]["content"]["metadata"]["Bed Time Reminder"].stringValue
                        rec.remindWorry = json[i]["content"]["metadata"]["Worry Time Reminder"].stringValue
                        rec.remindReset = json[i]["content"]["metadata"]["Reset All Reminders"].stringValue
                        rec.remindSleep = json[i]["content"]["metadata"]["Sleep Diary Entry Reminder"].stringValue
                        rec.remindWindDn = json[i]["content"]["metadata"]["Wind Down Reminder"].stringValue
                        rec.remindCaffeine = json[i]["content"]["metadata"]["Stop Caffeine Reminder"].stringValue
                        rec.remindRx = json[i]["content"]["metadata"]["Rx Update Reminder"].stringValue
                        rec.isiProvider = json[i]["content"]["metadata"]["ISI Provider"].stringValue

                        rec.pss01 = json[i]["content"]["metadata"]["pss01"].stringValue
                        rec.pss02 = json[i]["content"]["metadata"]["pss02"].stringValue
                        rec.pss03 = json[i]["content"]["metadata"]["pss03"].stringValue
                        rec.pss04 = json[i]["content"]["metadata"]["pss04"].stringValue
                        rec.pss05 = json[i]["content"]["metadata"]["pss05"].stringValue
                        rec.pss06 = json[i]["content"]["metadata"]["pss06"].stringValue
                        rec.pss07 = json[i]["content"]["metadata"]["pss07"].stringValue
                        rec.pss08 = json[i]["content"]["metadata"]["pss08"].stringValue
                        rec.pss09 = json[i]["content"]["metadata"]["pss09"].stringValue
                        rec.pss10 = json[i]["content"]["metadata"]["pss10"].stringValue
                        rec.pssTotal = json[i]["content"]["metadata"]["pssTotal"].stringValue
                        rec.userSafetyState = json[i]["content"]["metadata"]["userSafetyState"].stringValue
                        
                        
                        
                        records.append(rec)
                        
                        //print("record is \(i) and \(records[i].event)")
                        
                        rec = record(userInviteCode: "")
                        
                    }
                    //print("There are \(records.count) and rec 10 is \(records[10].timestamp)")
                    
                    //print("\(records[10].timestamp.substringToIndex(index1))")
                    
                    //("Buttons=\(buttons.count)")
                    //print("Times=\(times.count)")
                    //print(json)
                    
                } else {
                    //showError()
                }
            } else {
                //showError()
            }
            
        } else {
            //displayAlert("Error in form", message: "Please enter a valid invite code")
            
        }
        
        myFilteredRecs = records.filter({
            $0.event != "CONTENT_TIMED"
        })
        //print("myFilteredRecs has \(myFilteredRecs.count) records")
        

        //output = "Report for \(records[0].userInviteCode)"
        
        output += "InviteCode" + "," + "session#" + "," + "event" + "," + "timestamp" + "," + "name" + "," + "buttonName" + "," + "location" + "," + "displayName" + "," + "question" + "," + "answer" + "," + "Assessments" + "," + "lastScore" + "," + "completed" + "," + "score" + "," + "pss01" + "," + "pss02" + "," + "pss03" + "," + "pss04" + "," + "pss05" + "," + "pss06" + "," + "pss07" + "," + "pss08" + "," + "pss09" + "," + "pss10" + "," + "pssTotal"  + "," + "remindAssess" + "," + "remindWake" + "," + "remindBed" + "," + "remindWorry" + "," + "remindReset" + "," + "remindSleep" + "," + "remindWindDn" + "," + "remindCaffeine" + "," + "remindRx" + "," + "isiProvider" + "," + "userSafetyState"
        
        summaryOutput += "InviteCode" + "," + "session#" + "," + "sessionActivities" + "," + "sessionDate" + "," + "startTime" + "," + "endTime" + "," + "elapsedSecs"
        
        var currentSession = myFilteredRecs[0].sessionId
        var count = 0
        var sessionActivities = 0
        var stTime = myFilteredRecs[0].time
        var endTime = ""
        var curTime = ""
        var oldStart = ""
        var okToOutputSummary = 0
        var elapsedSecs = 0
        var hrs = 0
        var min = 0
        var secs = 0
        var stSecs = 0
        var endSecs = 0
        var sessionDate = myFilteredRecs[0].date
        //var oldDate = ""
        
        // begin creating csv files
        for n in 0 ..< myFilteredRecs.count
        {
            endTime = curTime
            curTime = myFilteredRecs[n].time
            
            if (myFilteredRecs[n].sessionId != currentSession) {
                count += 1
                currentSession = myFilteredRecs[n].sessionId
                oldStart = stTime
                stTime = myFilteredRecs[n].time
                //oldDate = sessionDate
                sessionDate = myFilteredRecs[n].date
                
                //print(" Date = \(sessionDate)")
                
                okToOutputSummary = 1
            }
            
            output += "\n" + myFilteredRecs[n].userInviteCode + ",Session\(count)," + myFilteredRecs[n].event + "," + myFilteredRecs[n].timestamp + "," + myFilteredRecs[n].name + "," + myFilteredRecs[n].buttonName + "," + myFilteredRecs[n].location + "," + myFilteredRecs[n].displayName
                
            output += "," + myFilteredRecs[n].question + "," + myFilteredRecs[n].answer + "," + myFilteredRecs[n].assessments + "," + myFilteredRecs[n].lastScore + "," + myFilteredRecs[n].completed + "," + myFilteredRecs[n].score + "," + myFilteredRecs[n].pss01 + "," + myFilteredRecs[n].pss02 + "," + myFilteredRecs[n].pss03 + "," + myFilteredRecs[n].pss04 + "," + myFilteredRecs[n].pss05 + "," + myFilteredRecs[n].pss06 + "," + myFilteredRecs[n].pss07 + "," + myFilteredRecs[n].pss08 + "," + myFilteredRecs[n].pss09 + "," + myFilteredRecs[n].pss10 + "," + myFilteredRecs[n].pssTotal
            
            output += "," + myFilteredRecs[n].remindAssess + "," + myFilteredRecs[n].remindWake + "," + myFilteredRecs[n].remindBed + "," + myFilteredRecs[n].remindWorry + "," + myFilteredRecs[n].remindReset + "," + myFilteredRecs[n].remindSleep + "," + myFilteredRecs[n].remindWindDn + "," + myFilteredRecs[n].remindCaffeine + "," + myFilteredRecs[n].remindRx + "," + myFilteredRecs[n].isiProvider + "," + myFilteredRecs[n].userSafetyState
            
            
            if (okToOutputSummary == 1) {
                
                //print("Session\(count-1) = \(sessionActivities)")
                hrs = Int(oldStart.substringWithRange(0, location: 2))!
                min = Int(oldStart.substringWithRange(3, location: 2))!
                secs =  Int(oldStart.substringWithRange(6, location: 2))!
                stSecs = (hrs * 60 * 60) + (min * 60) + secs
                
                hrs = Int(endTime.substringWithRange(0, location: 2))!
                min = Int(endTime.substringWithRange(3, location: 2))!
                secs =  Int(endTime.substringWithRange(6, location: 2))!
                endSecs = (hrs * 60 * 60) + (min * 60) + secs
                
                elapsedSecs = endSecs - stSecs
                
                //print("Start time = \(oldStart), EndTime = \(endTime), elapsed = \(elapsedSecs)")
                
                summaryOutput += "\n" + myFilteredRecs[n].userInviteCode + ", Session\(count-1), \(sessionActivities), " + "\(sessionDate), " + "\(oldStart), " + "\(endTime), " + "\(elapsedSecs)"
                
                okToOutputSummary = 0
                sessionActivities = 0

            }
            
            sessionActivities += 1


        
        }
        //print("Session\(count) = \(sessionActivities)")
        hrs = Int(stTime.substringWithRange(0, location: 2))!
        min = Int(stTime.substringWithRange(3, location: 2))!
        secs =  Int(stTime.substringWithRange(6, location: 2))!
        stSecs = (hrs * 60 * 60) + (min * 60) + secs
        
        hrs = Int(curTime.substringWithRange(0, location: 2))!
        min = Int(curTime.substringWithRange(3, location: 2))!
        secs =  Int(curTime.substringWithRange(6, location: 2))!
        endSecs = (hrs * 60 * 60) + (min * 60) + secs
        
        elapsedSecs = endSecs - stSecs

        //print("Start time = \(stTime), EndTime = \(endTime), elapsed = \(elapsedSecs)")
        
        summaryOutput += "\n" + myFilteredRecs[count].userInviteCode + ", Session\(count), \(sessionActivities), " + "\(sessionDate), " + "\(stTime), " + "\(endTime), " + "\(elapsedSecs)"

        //print(output)
        
        var myAttributedText = NSMutableAttributedString()

        myAttributedText = NSMutableAttributedString(string: output, attributes: [NSFontAttributeName:NSFont(name: "HelveticaNeue-Thin", size: 16.0)!])
        

        myTextView.textStorage?.appendAttributedString(myAttributedText)
    
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

