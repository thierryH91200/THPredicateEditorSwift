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
        
        let predicate = super.predicate(withSubpredicates: subpredicates) as! NSComparisonPredicate
        let newPredicate = NSComparisonPredicate(leftExpression: predicate.leftExpression, rightExpression: predicate.rightExpression, modifier: .any, type: predicate.predicateOperatorType, options: predicate.options)
        
        print(#function)
        print(newPredicate.description)
        return newPredicate
    }
    
}

class RowTemplateRelationshipAll: NSPredicateEditorRowTemplate {
    
    override func predicate(withSubpredicates subpredicates: [NSPredicate]?) -> NSPredicate{
        
        let predicate = super.predicate(withSubpredicates: subpredicates) as! NSComparisonPredicate
        let newPredicate = NSPredicate(format: "SUBQUERY(sousOperations, $sousOperation, $sousOperation.category.rubrique.name == %@).@count > 0", predicate.rightExpression)

        print(predicate.rightExpression.description)
        print(predicate.leftExpression.description)

        return newPredicate
    }
    
}

public extension NSPredicate{
    func stringForSubQuery(prefix:String) -> String {
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
        @unknown default:
            fatalError()
        }
    }
}


