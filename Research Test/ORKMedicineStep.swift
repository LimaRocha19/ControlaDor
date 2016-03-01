//
//  ORKMedicineStep.swift
//  Research Test
//
//  Created by Isaías Lima on 29/02/16.
//  Copyright © 2016 Lima. All rights reserved.
//

import UIKit
import ResearchKit

class ORKMedicineStep: ORKFormStep {

    var medicineItems: [ORKFormItem]?

    override init(identifier: String) {
        super.init(identifier: identifier)
        medicineItems = [ORKFormItem]()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func validateParameters() {
        super.validateParameters()
    }

    func addMedicineItem() {
        let formTuple = newMedicineItem()
        medicineItems?.append(formTuple.0)
        medicineItems?.append(formTuple.1)
        medicineItems?.append(formTuple.2)
        medicineItems?.append(formTuple.3)
        formItems = medicineItems
    }

    func newMedicineItem() -> (ORKFormItem, ORKFormItem, ORKFormItem, ORKFormItem) {
        let titleItem = ORKFormItem(sectionTitle: "")

        let textFormat = ORKTextAnswerFormat()
        textFormat.multipleLines = false
        let nameItem = ORKFormItem(identifier: "Nome do medicamento", text: "", answerFormat: textFormat, optional: false)
        nameItem.placeholder = "Nome"
        let frequencyItem = ORKFormItem(identifier: "Dose/Frequência", text: "", answerFormat: textFormat, optional: false)
        frequencyItem.placeholder = "Dose/Frequência"

        let dateFormat = ORKDateAnswerFormat(style: .Date, defaultDate: NSDate(), minimumDate: nil, maximumDate: NSDate(), calendar: NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian))
        let initDateItem = ORKFormItem(identifier: "Início", text: "", answerFormat: dateFormat, optional: false)
        initDateItem.placeholder = "Data de início"

        return (titleItem, nameItem, frequencyItem, initDateItem)
    }

}

extension ORKFormStepViewController {
    func addMedicine() {
        let medStep = step as? ORKMedicineStep
        medStep?.addMedicineItem()
        viewWillAppear(true)
    }
}

