//
//  DataSectionViewModel.swift
//  bla
//
//  Created by Dennis Forster on 23.01.25.
//

import Foundation

class DataSectionViewModel: ObservableObject {
    @Published var section: DataSection

    init(section: DataSection) {
        self.section = section
    }

    var title: String {
        section.title
    }

    var correctValue: String {
        section.correctValue
    }

    var entries: [DataEntry] {
        section.entries
    }
}
