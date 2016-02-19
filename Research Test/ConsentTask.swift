//
//  ConsentTask.swift
//  Research Test
//
//  Created by Isaías Lima on 04/02/16.
//  Copyright © 2016 Lima. All rights reserved.
//

import ResearchKit

public var ConsentTask: ORKOrderedTask {

    var steps = [ORKStep]()

    let consentDocument = ConsentDocument
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
    steps.append(visualConsentStep)

    let signature = consentDocument.signatures!.first

    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, inDocument: consentDocument)

    reviewConsentStep.text = "Review Consent!"
    reviewConsentStep.reasonForConsent = "Consent to join study"

    steps.append(reviewConsentStep)

    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}