//
//  Paging.swift
//  
//
//  Created by Andrei Mirzac on 28/02/2021.
//

import Foundation

struct Paging<Value: Hashable> {

    var values: [Value]

    var state: State?

    var data: PageData?

    init(values: [Value], data: PageData?) {
        self.values = values
        self.data = data
        self.state = data?.next == nil ? .completed : nil
    }

    enum State: Equatable {
        case loading
        case completed
        case failure(Error)

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.completed, .completed):
                return true
            case (failure(let lhsError), failure(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
            }
        }
    }
}
