//
//  PlotDataBuilder.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class PlotDataBuilder {
    
    final class GroupedMatches {
        let timestampStart: TimeInterval
        let timestampEnd: TimeInterval
        var matches: [MatchDetails] = []
        
        init(timestampStart: TimeInterval, timestampEnd: TimeInterval) {
            self.timestampStart = timestampStart
            self.timestampEnd = timestampEnd
        }
    }
    
    let matches: [MatchDetails]
    let steamUser: SteamUser
    
    init(steamUser: SteamUser, matches: [MatchDetails]) {
        self.steamUser = steamUser
        self.matches = matches
    }
    
    func calculate() -> PlotModel {
        let groups = calculateGroups()
        let points = calculateWinratePlotPoints(from: groups)
        
        return PlotModel(points: points,
                        beginTimestamp: groups.first!.timestampStart,
                        endTimestamp: groups.last!.timestampEnd)
    }
    
    private func calculateGroups() -> [GroupedMatches] {
        var groups: [GroupedMatches] = []
        
        let matches = self.matches.sorted { $0.start < $1.start }
        let timestampStep = TimeInterval(7 * 24 * 3600)
        var currentTimestampStartInterval = matches.first!.start.timeIntervalSince1970
        var currentTimestampEndInterval = currentTimestampStartInterval + timestampStep
        var groupCreated = false
        
        for match in matches {
            
            let matchTimestamp = match.start.timeIntervalSince1970
            if matchTimestamp >= currentTimestampStartInterval && matchTimestamp < currentTimestampEndInterval {
                if !groupCreated {
                    let group = GroupedMatches(timestampStart: currentTimestampStartInterval,
                                               timestampEnd: currentTimestampEndInterval)
                    groups.append(group)
                    groupCreated = true
                }
                groups.last!.matches.append(match)
                
            } else {
                
                while matchTimestamp >= currentTimestampEndInterval {
                    currentTimestampEndInterval += timestampStep
                    currentTimestampStartInterval += timestampStep
                    let group = GroupedMatches(timestampStart: currentTimestampStartInterval,
                                               timestampEnd: currentTimestampEndInterval)
                    groups.append(group)
                }
                groups.last!.matches.append(match)
            }
        }
        
        // TODO: unit-test
        for group in groups {
            group.matches.forEach {
                let matchTimestamp = $0.start.timeIntervalSince1970
                let ok = (matchTimestamp >= group.timestampStart) && (matchTimestamp < group.timestampEnd)
                if !ok {
                    print("!!!! ALARM")
                }
            }
        }
        
        return groups
    }
    
    enum WinrateCalculationType {
        case current
        case cumulative
    }
    
    private func calculateWinratePlotPoints(from groups: [GroupedMatches], type: WinrateCalculationType = .cumulative) -> [PlotPoint] {
        var points: [PlotPoint] = []
        
        for (i, group) in groups.enumerated() {
            let consideredMatches: [MatchDetails]
            switch type {
            case .current:
                consideredMatches = group.matches
            case .cumulative:
                let allGroupsUntillCurrent = Array(groups.prefix(i))
                consideredMatches = allGroupsUntillCurrent.flatMap { $0.matches } + group.matches
            }
            
            guard !consideredMatches.isEmpty else { continue }
            
            let wins = consideredMatches.reduce(0) {
                let isWin = $1.isUserWinner(steamID: steamUser.id) ?? false
                return $0 + (isWin ? 1 : 0)
            }
            let winrate = Double(wins) / Double(consideredMatches.count)
            let point = PlotPoint(timestamp: (group.timestampStart + group.timestampEnd) / 2.0,
                                  value: winrate)
            points.append(point)
        }
        return points
    }
}
