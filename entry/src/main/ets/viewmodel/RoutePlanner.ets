/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

import { PositionType } from '../common/constants/CommonConstants';

export interface RoutePlan {
  title: string;
  description: string;
  zoneIds: number[];
  poiType: number;
  trainLine: number;
  accentColor: string;
}

export class RoutePlanner {
  static readonly PLANS: RoutePlan[] = [
    {
      title: '咖啡学习路线',
      description: '咖啡厅 -> 图书馆 -> A区 -> L区，适合安静阅读、轻办公和短途漫游。',
      zoneIds: [0, 10],
      poiType: PositionType.CAFE,
      trainLine: 1,
      accentColor: '#0A59F7'
    },
    {
      title: '午餐观景路线',
      description: '餐厅 -> G区 -> J区，适合午餐后快速游览水景和街区风貌。',
      zoneIds: [6, 8],
      poiType: PositionType.RESTAURANT,
      trainLine: 2,
      accentColor: '#00A870'
    },
    {
      title: '活力环校园路线',
      description: '体育馆 -> 人行道 -> D区 -> H区，适合散步、运动和拍照打卡。',
      zoneIds: [3, 7],
      poiType: PositionType.GYMNASIUM,
      trainLine: 3,
      accentColor: '#C45A1C'
    }
  ];

  static getPlan(index: number): RoutePlan {
    if (index < 0 || index >= RoutePlanner.PLANS.length) {
      return RoutePlanner.PLANS[0];
    }
    return RoutePlanner.PLANS[index];
  }
}
