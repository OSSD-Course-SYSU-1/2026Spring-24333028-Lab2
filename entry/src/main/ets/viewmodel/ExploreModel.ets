/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

export class ExploreModel {
  static readonly TOTAL_COUNT: number = 12;
  private static readonly STORAGE_KEY: string = 'visitedZoneIds';

  static getVisitedIds(): number[] {
    const ids = AppStorage.get<number[]>(ExploreModel.STORAGE_KEY);
    return ids ? ids : [];
  }

  static isVisited(id: number): boolean {
    return ExploreModel.getVisitedIds().indexOf(id) >= 0;
  }

  static markVisited(id: number): number[] {
    let ids = ExploreModel.getVisitedIds().slice(0);
    if (ids.indexOf(id) < 0) {
      ids.push(id);
    }
    AppStorage.setOrCreate<number[]>(ExploreModel.STORAGE_KEY, ids);
    return ids;
  }

  static progressLabel(total: number = ExploreModel.TOTAL_COUNT): string {
    return `${ExploreModel.getVisitedIds().length}/${total}`;
  }
}
