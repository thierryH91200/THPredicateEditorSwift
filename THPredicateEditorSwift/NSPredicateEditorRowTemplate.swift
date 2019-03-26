//
//  NSPredicateEditorRowTemplate.swift
//  KSPredicateEditorSwift
//
//  Created by thierryH24 on 28/11/2018.
//  Copyright © 2018 thierryH24. All rights reserved.
//

import AppKit

extension NSPredicateEditorRowTemplate {
    
    convenience init( compoundTypes: [NSCompoundPredicate.LogicalType] ) {
        
        let compoundTypesNSNumber = (0..<compoundTypes.count).map { (i) -> NSNumber in
            return NSNumber(value: compoundTypes[i].rawValue)
        }
        self.init( compoundTypes: compoundTypesNSNumber )
    }
    
    // Constant values
    convenience init( forKeyPath keyPath: String, withValues values: [Any] , operators: [NSComparisonPredicate.Operator]) {
        
        let keyPaths: [NSExpression] = [NSExpression(forKeyPath: keyPath)]
        var constantValues: [NSExpression] = []
        for v in values {
            constantValues.append( NSExpression(forConstantValue: v) )
        }
        
        let operatorsNSNumber = (0..<operators.count).map { (i) -> NSNumber in
            return NSNumber(value: operators[i].rawValue)
        }
        
        self.init( leftExpressions: keyPaths,
                   rightExpressions: constantValues,
                   modifier: .direct,
                   operators: operatorsNSNumber,
                   options: (Int(NSComparisonPredicate.Options.caseInsensitive.rawValue | NSComparisonPredicate.Options.diacriticInsensitive.rawValue)) )
    }
    
    // String
    convenience init( stringCompareForKeyPaths keyPaths: [String] , operators: [NSComparisonPredicate.Operator]) {
        
        let leftExpressions = (0..<keyPaths.count).map { (i) -> NSExpression in
            return NSExpression(forKeyPath: keyPaths[i])
        }
        let operatorsNSNumber = (0..<operators.count).map { (i) -> NSNumber in
            return NSNumber(value: operators[i].rawValue)
        }
        
        self.init( leftExpressions: leftExpressions,
                   rightExpressionAttributeType: .stringAttributeType,
                   modifier: .direct,
                   operators: operatorsNSNumber,
                   options: (Int(NSComparisonPredicate.Options.caseInsensitive.rawValue | NSComparisonPredicate.Options.diacriticInsensitive.rawValue)) )
    }
    
    // Int
    convenience init( IntCompareForKeyPaths keyPaths: [String], operators: [NSComparisonPredicate.Operator] = [.equalTo, .notEqualTo]) {
        
        let leftExpressions = (0..<keyPaths.count).map { (i) -> NSExpression in
            return NSExpression(forKeyPath: keyPaths[i])
        }
        let operatorsNSNumber = (0..<operators.count).map { (i) -> NSNumber in
            return NSNumber(value: operators[i].rawValue)
        }
        
        self.init( leftExpressions: leftExpressions,
                   rightExpressionAttributeType: .integer16AttributeType,
                   modifier: .direct,
                   operators: operatorsNSNumber,
                   options: 0 )
    }
    
    // Date
    convenience init( DateCompareForKeyPaths keyPaths: [String] , operators: [NSComparisonPredicate.Operator]) {
        
        let leftExpressions = (0..<keyPaths.count).map { (i) -> NSExpression in
            return NSExpression(forKeyPath: keyPaths[i])
        }
        let operatorsNSNumber = (0..<operators.count).map { (i) -> NSNumber in
            return NSNumber(value: operators[i].rawValue)
        }
        
        self.init( leftExpressions: leftExpressions,
                   rightExpressionAttributeType: .dateAttributeType,
                   modifier: .direct,
                   operators: operatorsNSNumber,
                   options: 0 )
    }
    
    // Bool
    convenience init( BoolCompareForKeyPaths keyPaths: [String] , operators: [NSComparisonPredicate.Operator]) {
        
        let leftExpressions = (0..<keyPaths.count).map { (i) -> NSExpression in
            return NSExpression(forKeyPath: keyPaths[i])
        }
        let operatorsNSNumber = (0..<operators.count).map { (i) -> NSNumber in
            return NSNumber(value: operators[i].rawValue)
        }
        
        self.init( leftExpressions: leftExpressions,
                   rightExpressionAttributeType: .booleanAttributeType,
                   modifier: .direct,
                   operators: operatorsNSNumber,
                   options: 0 )
    }
    
    
}

class RowTemplateRelationshipAny: NSPredicateEditorRowTemplate {
    
    override func predicate(withSubpredicates subpredicates: [NSPredicate]?) -> NSPredicate{
        
        let predicate: NSComparisonPredicate = super.predicate(withSubpredicates: subpredicates) as! NSComparisonPredicate
        let newPredicate = NSComparisonPredicate(leftExpression: predicate.leftExpression, rightExpression: predicate.rightExpression, modifier: .any, type: predicate.predicateOperatorType, options: predicate.options)
        
        print(#function)
        print(newPredicate.description)
        return newPredicate
    }
    
}

class RowTemplateRelationshipAll: NSPredicateEditorRowTemplate {
    
    override func predicate(withSubpredicates subpredicates: [NSPredicate]?) -> NSPredicate{
        
        let predicate: NSComparisonPredicate = super.predicate(withSubpredicates: subpredicates) as! NSComparisonPredicate
        let p2 = NSPredicate(format: "SUBQUERY(sousOperations, $sousOperation, $sousOperation.category.rubrique.name == %@).@count > 0", predicate.rightExpression)
        print(predicate.rightExpression.description)
        print(predicate.leftExpression.description)

//        let newPredicate = NSComparisonPredicate(leftExpression: predicate.leftExpression, rightExpression: predicate.rightExpression, modifier: .all, type: predicate.predicateOperatorType, options: predicate.options)
        
        return p2
    }
    
}

public extension NSPredicate{
    func stringForSubQuery(prefix:String) -> String{
        var predicateString = ""
        if let predicate = self as? NSCompoundPredicate{
            for (index, subPredicate) in predicate.subpredicates.enumerated(){
                
                if let subPredicate = subPredicate as? NSComparisonPredicate{
                    predicateString = "\(predicateString) \(prefix)\(subPredicate.predicateFormat)"
                }
                else if let subPredicate = subPredicate as? NSCompoundPredicate{
                    predicateString = "\(predicateString) (\(subPredicate.stringForSubQuery(prefix: prefix)))"
                }
                //if its not the last predicate then append the operator string
                if index < predicate.subpredicates.count - 1 {
                    predicateString = "\(predicateString) \(getPredicateOperatorString(predicateType: predicate.compoundPredicateType))"
                }
            }
        }
        return predicateString
    }
    private func getPredicateOperatorString(predicateType: NSCompoundPredicate.LogicalType) -> String{
        switch(predicateType){
        case .not: return "!"
        case .and: return "&&"
        case .or: return "||"
        }
    }
}


// https://stackoverflow.com/questions/38755224/nspredicateeditor-with-core-data-relationship
func updatePredicateEditor() {
    print("updatePredicateEditor")

    let sortDescriptor = NSSortDescriptor(key: "orderIndex", ascending: true)
//    fieldsArrayController.sortDescriptors = [sortDescriptor]
//    let fields = fieldsArrayController.arrangedObjects as! [Field]

    var keyPathsStringArray = [NSExpression]()
    var stringFieldNames = [String]()
    var keyPathsDateArray = [NSExpression]()
    var dateFieldNames = [String]()
    var keyPathsNumberArray = [NSExpression]()
    var numberFieldNames = [String]()
    
    var fields = [String]()

    for i in 0..<fields.count {
        let currentField = fields[i]

        switch currentField.type! {
        case "Text":
            keyPathsStringArray.append(NSExpression(forKeyPath: "fieldText"))
            stringFieldNames.append(currentField.name!)
        case "Date":
            keyPathsDateArray.append(NSExpression(forKeyPath: "fieldDate"))
            dateFieldNames.append(currentField.name!)
        case "Number":
            keyPathsNumberArray.append(NSExpression(forKeyPath: "fieldNumber"))
            numberFieldNames.append(currentField.name!)
        default:
            print("error on field type")
        }
    }

    let stringOperators = [NSNumber(value: NSComparisonPredicate.Operator.contains.rawValue),
                           NSNumber(value: NSComparisonPredicate.Operator.equalTo.rawValue),
                           NSNumber(value: NSComparisonPredicate.Operator.notEqualTo.rawValue),
                           NSNumber(value: NSComparisonPredicate.Operator.beginsWith.rawValue),
                           NSNumber(value: NSComparisonPredicate.Operator.endsWith.rawValue)]

    let numberOperators = [NSNumber(value: NSComparisonPredicate.Operator.equalTo.rawValue),
                           NSNumber(value: NSComparisonPredicate.Operator.notEqualTo.rawValue),
                           NSNumber(value: NSComparisonPredicate.Operator.lessThan.rawValue),
                           NSNumber(value: NSComparisonPredicate.Operator.lessThanOrEqualTo.rawValue),
                           NSNumber(value: NSComparisonPredicate.Operator.greaterThan.rawValue),
                           NSNumber(value: NSComparisonPredicate.Operator.greaterThanOrEqualTo.rawValue)]


    let dateOperators = [NSNumber(value: NSComparisonPredicate.Operator.equalTo.rawValue),
                         NSNumber(value: NSComparisonPredicate.Operator.notEqualTo.rawValue),
                         NSNumber(value: NSComparisonPredicate.Operator.lessThan.rawValue),
                         NSNumber(value: NSComparisonPredicate.Operator.lessThanOrEqualTo.rawValue),
                         NSNumber(value: NSComparisonPredicate.Operator.greaterThan.rawValue),
                         NSNumber(value: NSComparisonPredicate.Operator.greaterThanOrEqualTo.rawValue)]

    var rowTemplatesTemp = [NSPredicateEditorRowTemplate]() // this is a temp array to hold the different popupbuttons

    // add a template for Strings
    let leftExpressionStringButton : NSPopUpButton

    if keyPathsStringArray.count == 0 {
        print("There aren't any text fields in NSPredicateEditor")
    }
    else {
        let stringTemplate = NSPredicateEditorRowTemplate(leftExpressions: keyPathsStringArray,
                                                          rightExpressionAttributeType: NSAttributeType.stringAttributeType,
                                                          modifier: NSComparisonPredicate.Modifier.direct,
                                                          operators: stringOperators,
                                                          options: (Int(NSComparisonPredicate.Options.caseInsensitive.rawValue) |
                                                            Int(NSComparisonPredicate.Options.diacriticInsensitive.rawValue)))

        leftExpressionStringButton = stringTemplate.templateViews[0] as! NSPopUpButton
        let stringButtonArray = leftExpressionStringButton.itemTitles

        for i in 0..<stringButtonArray.count {
            (leftExpressionStringButton.item(at: i)! as NSMenuItem).title = stringFieldNames[i] // set button menu names
        }

        rowTemplatesTemp.append(stringTemplate)
    }

    // add another template for Numbers...
    let leftExpressionNumberButton : NSPopUpButton

    if keyPathsNumberArray.count == 0 {
        print("There aren't any number fields in NSPredicateEditor")
    }
    else {
        let numberTemplate = NSPredicateEditorRowTemplate(leftExpressions: keyPathsNumberArray,
                                                          rightExpressionAttributeType: NSAttributeType.integer32AttributeType,
                                                          modifier: NSComparisonPredicate.Modifier.direct,
                                                          operators: numberOperators,
                                                          options: 0)

        leftExpressionNumberButton = numberTemplate.templateViews[0] as! NSPopUpButton

        let numberButtonArray = leftExpressionNumberButton.itemTitles

        for i in 0..<numberButtonArray.count {
            (leftExpressionNumberButton.item(at: i)! as NSMenuItem).title = numberFieldNames[i] // set button menu names
        }

        rowTemplatesTemp.append(numberTemplate)
    }

    // add another template for Dates...
    let leftExpressionDateButton : NSPopUpButton

    if keyPathsDateArray.count == 0 {
        print("There aren't any date fields in NSPredicateEditor")
    }
    else {
        let dateTemplate = NSPredicateEditorRowTemplate(leftExpressions: keyPathsDateArray,
                                                        rightExpressionAttributeType: NSAttributeType.dateAttributeType,
                                                        modifier: NSComparisonPredicate.Modifier.direct,
                                                        operators: dateOperators,
                                                        options: 0)


        leftExpressionDateButton = dateTemplate.templateViews[0] as! NSPopUpButton

        let dateButtonArray = leftExpressionDateButton.itemTitles

        for i in 0..<dateButtonArray.count {
            (leftExpressionDateButton.item(at: i)! as NSMenuItem).title = dateFieldNames[i] // set button menu names
        }

        rowTemplatesTemp.append(dateTemplate)
    }

    // create the any, all or none thing...
    let compoundTypes = [NSNumber.init(value: NSCompoundPredicate.LogicalType.or.rawValue),
                         NSNumber.init(value: NSCompoundPredicate.LogicalType.and.rawValue),
                         NSNumber.init(value: NSCompoundPredicate.LogicalType.not.rawValue)]

    // add the compoundtypes
    let compoundTemplate = NSPredicateEditorRowTemplate(compoundTypes: compoundTypes)
    rowTemplatesTemp.append(compoundTemplate)

    print("setting row templates \(rowTemplatesTemp)")

//    predicateEditor.rowTemplates = rowTemplatesTemp
//
//    predicateEditor.addRow(self)

}


