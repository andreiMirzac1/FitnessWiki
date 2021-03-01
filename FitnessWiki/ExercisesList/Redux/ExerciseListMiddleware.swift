//
//  Thunk.swift
//  
//
//  Created by Andrei Mirzac on 02/02/2021.
//

import Foundation
import ReSwift
import ReSwiftThunk

func fetchExercises(service: ExercisesWebRepository = RealExercisesWebRepository(baseURL: "https://wger.de")) -> Thunk<ExerciseListState> {
    return Thunk<ExerciseListState> { dispatch, getState in
        guard let state = getState(), !state.isLoading else {
            return
        }

        let completion: (Result<ListingData<[Exercise]>, Error>) -> Void = { result in
            switch result {
            case .success(let listingData):
                let page = PageDataMapper().map(from: listingData)
                dispatch(ExercisesAction.fetched(listingData.results, page: page))
            case .failure(let error):
                dispatch(ExercisesAction.fetchedFailure(page: error))
            }
        }

        if let paging = state.paging {
            if paging.state != .completed {
                dispatch(ExercisesAction.fetching)
                service.fetchExercises(page: paging.data?.next, completion: completion)
            }
        } else if let filter = state.filter  {
            dispatch(ExercisesAction.fetching)
            service.fetchExercises(filter: filter, completion: completion)
        } else {
            dispatch(ExercisesAction.fetching)
            service.fetchExercises(page: nil, completion: completion)
        }
    }
}

