//
//  SurveyTask.swift
//  Research Test
//
//  Created by Isaías Lima on 04/02/16.
//  Copyright © 2016 Lima. All rights reserved.
//

import ResearchKit

let path = NSBundle.mainBundle().pathForResource("inventory", ofType: "json")
let JSONData = NSData(contentsOfFile: path!)

public var SurveyTask: ORKOrderedTask {

    var scaleQuestions = [String  : AnyObject]()
    do {
        let json = try NSJSONSerialization.JSONObjectWithData(JSONData!, options: .MutableContainers) as! [String : AnyObject]
        scaleQuestions = json
    } catch {
        print(error)
    }
    var questions = [(String , AnyObject)]()
    for scaleQuestion in scaleQuestions {
        questions.append(scaleQuestion)
    }
    questions.sortInPlace { $0.0 < $1.0 }

    var steps = [ORKStep]()

    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Inventário breve de dor"
    instructionStep.text = "Preencha os dados seguintes relativos à intensidade"
    steps.append(instructionStep)

    let questQuestionStepTitle = "Durante a vida, a maioria das pessoas apresenta dor de vez em quando (dor de cabeça, dor de dente, etc). Você teve uma dor diferente dessas?"
    let textChoices = [
        ORKTextChoice(text: "Não", value: 0),
        ORKTextChoice(text: "Sim", value: 1)
    ]
    let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    let questQuestionStep = ORKQuestionStep(identifier: "Teve dor diferente hoje?", title: questQuestionStepTitle, answer: questAnswerFormat)
    steps.append(questQuestionStep)

    for question in questions {
        let dictionary = question.1 as! [String : String]
        let scaleAnswerFormat = ORKAnswerFormat.continuousScaleAnswerFormatWithMaximumValue(10, minimumValue: 0, defaultValue: 0, maximumFractionDigits: 2, vertical: false, maximumValueDescription: "", minimumValueDescription: "")
        let scaleQuestionStep = ORKQuestionStep(identifier: dictionary["identifier"]!, title: dictionary["question"]!, answer: scaleAnswerFormat)
        steps.append(scaleQuestionStep)
    }

    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Fim"
    summaryStep.text = "Seus dados estão atualizados"
    steps.append(summaryStep)

    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
