//
//  MainWindowController.swift
//
//  Created by thierryH24 on 14/11/2018.
//  Copyright © 2018 thierryH24. All rights reserved.
//

import AppKit

final class MainWindowController: NSWindowController {
    
    @IBOutlet weak var predicateEditor: NSPredicateEditor!
    @IBOutlet var queryTextField: NSTextView!
    @IBOutlet weak var myTableView: NSTableView!
    @IBOutlet var arrayController: NSArrayController!
    
    var predicate : NSPredicate!
    var operators = [NSComparisonPredicate.Operator]()
        
    @objc dynamic var arrayPerson = [Person]()
    
//    let DEFAULT_PREDICATE = "firstName ==[cd] 'John' OR lastName ==[cd] 'doe' OR (dateOfBirth <= CAST('11/18/2018 00:00', 'NSDate') AND dateOfBirth >= CAST('01/01/2018', 'NSDate')) OR Department == 'Human Resources' OR country ==[cd] 'United States' OR age = 25"
    let DEFAULT_PREDICATE = "firstName ==[cd] 'John' OR lastName ==[cd] 'doe' OR (dateOfBirth <= CAST('11/18/2018 00:00', 'NSDate') AND dateOfBirth >= CAST('01/01/2018', 'NSDate')) OR country ==[cd] 'United States' OR age = 25"

    override var windowNibName: NSNib.Name? {
        return NSNib.Name( "MainWindowController")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.addArrayPerson()
        self.addRowPredicateEditor()

    }
    
    func addArrayPerson() {
        arrayPerson.append(Person(firstName: "John", lastName: "Doe", dateOfBirth: Date(), age: 24, department: "Finance", country: "Canada", isBool: true))
        arrayPerson.append(Person(firstName: "Peter", lastName: "Martin", dateOfBirth: Date(), age: 25, department: "Sales", country: "Mexico", isBool: false))
        arrayPerson.append(Person(firstName: "John", lastName: "Trump", dateOfBirth: Date(), age: 26, department: "Finance", country: "Brazil", isBool: true))
        arrayPerson.append(Person(firstName: "Mary", lastName: "Doe", dateOfBirth: Date(), age: 27, department: "Finance", country: "United States", isBool: true))
        arrayPerson.append(Person(firstName: "Leo", lastName: "Doe", dateOfBirth: Date(), age: 28, department: "Sales", country: "Mexico", isBool: false))
        arrayPerson.append(Person(firstName: "John", lastName: "Doe", dateOfBirth: Date(), age: 29, department: "Finance", country: "United States", isBool: true))
        arrayPerson.append(Person(firstName: "John", lastName: "Leo", dateOfBirth: Date(), age: 30, department: "Finance", country: "Brazil", isBool: false))
    }
    
    func addRowPredicateEditor() {
        
        predicateEditor.rowTemplates.removeAll()
        
        let compound = NSPredicateEditorRowTemplate( compoundTypes: [.and, .or, .not] )
        
        // String
        operators = [.equalTo, .notEqualTo]
        let firstNameRowTemplate = NSPredicateEditorRowTemplate(stringCompareForKeyPaths: ["firstName"] , operators: operators)
        let lastNameRowTemplate = NSPredicateEditorRowTemplate(stringCompareForKeyPaths: ["lastName"] , operators: operators)
        
        // Int
        operators = [.equalTo, .notEqualTo, .greaterThan, .greaterThanOrEqualTo, .lessThan, .lessThanOrEqualTo]
        let ageTemplate = NSPredicateEditorRowTemplate( IntCompareForKeyPaths: ["age"] , operators: operators)
        
        // Date
        operators = [.equalTo, .greaterThanOrEqualTo, .lessThanOrEqualTo, .greaterThan, .lessThan]
        let dateOfBirthTemplate = NSPredicateEditorRowTemplate(DateCompareForKeyPaths: ["dateOfBirth"] , operators: operators)
        
        // Custom
//        let leftExpressions = [NSExpression(forKeyPath: "Department")]
//        let departmentCustomRowTemplate = THDepartmentsRowTemplate(leftExpressions: leftExpressions)
        
        // Constant values
        operators = [.equalTo, .notEqualTo]
        let country = ["United States","Mexico", "Canada", "Brazil"]
        let countryTemplate = NSPredicateEditorRowTemplate( forKeyPath: "country", withValues: country, operators: operators )
        
        // Bool
        operators = [.equalTo, .notEqualTo]
        let boolTemplate = NSPredicateEditorRowTemplate( BoolCompareForKeyPaths: ["isBool"], operators: operators )
        
        // internationalize
        let stringsFile = Bundle.main.path(forResource: "Predicate", ofType: "strings")
        let strings = try? String(contentsOfFile: stringsFile ?? "", encoding: .utf16)
        let formattingDictionary = strings?.propertyListFromStringsFileFormat()
        predicateEditor.formattingDictionary = formattingDictionary
        
        // Feed predicateEditor
        predicateEditor.rowTemplates = [compound, firstNameRowTemplate, lastNameRowTemplate, ageTemplate, dateOfBirthTemplate, countryTemplate, boolTemplate]
        
        predicate = NSPredicate(format:DEFAULT_PREDICATE)
        predicateEditor.objectValue = predicate
    }
    
    @IBAction func generateQuery(_ sender: Any) {
        queryTextField.font = NSFont(name: "Helvetica", size: 18.0)
        queryTextField.string = predicateEditor.predicate?.description ?? ""
        
//        print(queryTextField.string)
//        print(#function)
        arrayController.filterPredicate = predicateEditor.predicate
        
//        let numberOfRows = predicateEditor.numberOfRows
//        print(numberOfRows)
//        for i in 0..<numberOfRows {
//            let result = predicateEditor.predicate(forRow: i)
//            let str = result?.description ?? ""
//            print(str)
//        }
    }
    
    @IBAction func predicateEditorAction(_ sender: Any) {
        print(#function)
    }
    
}

@objcMembers
class Person : NSObject {
    var firstName:String
    var lastName:String
    var dateOfBirth = Date()
    var age = 0
    var department = ""
    var country = ""
    var isBool = false
    
    override init() {
        firstName = "given"
        lastName = "family"
        super.init()
    }
    
    
    init(firstName:String, lastName:String, dateOfBirth : Date, age:Int, department : String, country : String, isBool: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.age = age
        self.department = department
        self.country = country
        self.isBool = isBool
        super.init()
    }
    
    private func emojiFlag(countryCode: String) -> String {
        var string = ""
        var country = countryCode.uppercased()
        for uS in country.unicodeScalars {
            if let scalar = UnicodeScalar(127_397 + uS.value) {
                string.append(String(scalar))
            }
        }
        return string
    }

}

