//
//  CounterViewModel.swift
//  ComparePropertyWrappers
//
//  Created by Vsevolod Oplachko on 13.01.2026.
//

import SwiftUI
import Combine

final class CounterViewModel: ObservableObject {
    @Published var count = 5
    
    init() {
        print("debug: did init")
    }

    func increaseCount() {
        count += 1
    }
}
