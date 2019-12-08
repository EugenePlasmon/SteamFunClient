//
//  Dota2HeroResourceManager.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 02.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2HeroResourceManager {
    
    enum DataLoadingState {
        case loading
        case finished
        case error
    }
    
    static let shared = Dota2HeroResourceManager()
    
    var onLoad: ((DataLoadingState) -> Void)?
    
    private(set) var state: DataLoadingState = .loading
    private(set) var heroes: [Dota2Hero] = []
    
    // MARK: - Methods
    
    func hero(id: Int) -> Dota2Hero? {
        return heroes.first { $0.id == id }
    }
    
    // MARK: - Init
    
    init() {
        loadHeroes()
    }
    
    // MARK: - Private
    
    private func loadHeroes() {
        Steam.dota2Heroes { [weak self] result in
            guard let self = self else { return }
            result.onSuccess {
                self.heroes = $0
                self.state = .finished
            }.onFailure {
                // TODO: Запрос героев Dota 2 обязателен для отображения статистики по Dota 2. Необходимо добавить логику повторных попыток запроса. Если по какой-то причине запрос все время отваливается с ошибкой, то пускать пользователя в приложение, но без функционала статистики по Dota 2
                self.state = .error
                log($0)
            }
            self.onLoad?(self.state)
        }
    }
}
