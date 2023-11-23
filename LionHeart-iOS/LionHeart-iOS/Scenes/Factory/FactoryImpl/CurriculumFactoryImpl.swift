//
//  CurriculumFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation


struct CurriculumFactoryImpl: CurriculumFactory {

    
    func makeCurriculumListByWeekViewModel(coordinator: CurriculumCoordinator) -> any CurriculumListWeekViewModel & CurriculumListWeekViewModelPresentable {
        let adaptor = self.makeAdaptor(coordinator: coordinator)
        let apiService = APIService()
        let curriculumService = CurriculumServiceImpl(apiService: apiService)
        let bookmarkService = BookmarkServiceImpl(apiService: apiService)
        let curriculumListManager = CurriculumListManagerImpl(bookmarkService: bookmarkService, curriculumService: curriculumService)
        return CurriculumListWeekViewModelImpl(manager: curriculumListManager, navigator: adaptor)
    }
    
    func makeAdaptor(coordinator: CurriculumCoordinator) -> EntireCurriculumNavigation {
        let adaptor = CurriculumAdaptor(coordinator: coordinator)
        return adaptor
    }
    
    func makeCurriculumViewController(coordinator: CurriculumCoordinator) -> CurriculumControllerable {
        let adaptor = self.makeAdaptor(coordinator: coordinator)
        let apiService = APIService()
        let curriculumService = CurriculumServiceImpl(apiService: apiService)
        let manager = CurriculumManagerImpl(curriculumService: curriculumService)
        let curriculumViewController = CurriculumViewController(manager: manager, adaptor: adaptor)
        return curriculumViewController
    }
    
    func makeCurriculumListViewController(coordinator: CurriculumCoordinator, weekCount: Int) -> CurriculumArticleByWeekControllerable {
        let viewModel = self.makeCurriculumListByWeekViewModel(coordinator: coordinator)
        viewModel.setWeek(week: weekCount)
        return CurriculumListWeekViewController(viewModel: viewModel)
    }
}
