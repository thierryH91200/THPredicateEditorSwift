//
//  KSDepartmentsRowTemplate.swift
//  KSPredicateEditorSwift
//
//  Created by thierryH24 on 26/11/2018.
//  Copyright © 2018 thierryH24. All rights reserved.
//

import AppKit

final class THDepartmentsRowTemplate: NSPredicateEditorRowTemplate {
    
    init(leftExpressions: [NSExpression]) {
        let operators = [ NSComparisonPredicate.Operator.equalTo.rawValue,  NSComparisonPredicate.Operator.notEqualTo.rawValue]
        let departmentList = [NSExpression(forConstantValue: "Human Resources"), NSExpression(forConstantValue: "Finance"), NSExpression(forConstantValue: "Information Technology"), NSExpression(forConstantValue: "Sales")]
        
        super.init(leftExpressions: leftExpressions, rightExpressions: departmentList, modifier: .direct, operators: operators as [NSNumber], options: 0)
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var templateViews: [NSView] {
        var views = super.templateViews
        views.append(validationView()!)
        return views
    }
    
    func validationView() -> NSView? {
        let view = NSView(frame: NSMakeRect(0, 0, 400, 22.0))
        
        let button = NSButton(frame: NSMakeRect(0.0, 2.0, 70.0, 18.0))
        button.title = "Validate"
        button.target = self
        button.action = #selector(self.validationAction(_:))
        button.bezelStyle = .recessed
        
        let textField = NSTextField(frame: NSMakeRect(80.0, 2.0, 220.0, 18.0))
        textField.isBordered = false
        textField.stringValue = "This is a custom message"
        textField.isEditable = false
        textField.drawsBackground = false
        textField.textColor = NSColor.red
        
        view.addSubview(button)
        view.addSubview(textField)
        return view
    }
    
    @IBAction func validationAction(_ sender: Any) {
        print( #function, #line)
    }
    
}

