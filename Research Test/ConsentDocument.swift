//
//  ConsentDocument.swift
//  Research Test
//
//  Created by Isaías Lima on 04/02/16.
//  Copyright © 2016 Lima. All rights reserved.
//

import ResearchKit

public var ConsentDocument: ORKConsentDocument {

    let consentDocument = ORKConsentDocument()
    consentDocument.title = "Example Consent"

    let consentSectionTypes: [ORKConsentSectionType] = [
        .Overview,
        .DataGathering,
        .Privacy,
        .DataUse,
        .TimeCommitment,
        .StudySurvey,
        .StudyTasks,
        .Withdrawing
    ]

    let consentSections: [ORKConsentSection] = consentSectionTypes.map  { contentSectionType in
        let contentSection = ORKConsentSection(type: contentSectionType)
        contentSection.summary = "Se você quiser completar esse estudo..."
        contentSection.content = "Nesse estudo você responderá cinco perguntas. Você também gravará sua voz por 10 segundos."
        return contentSection
    }

    consentDocument.sections = consentSections
    consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))

    return consentDocument
}
