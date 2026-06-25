/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import ZonesItem from '../viewmodel/ZonesItem';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { ZonesConstants as ZoneConst } from '../common/constants/ZonesConstants';
import { ExploreModel } from '../viewmodel/ExploreModel';
import { RoutePlan, RoutePlanner } from '../viewmodel/RoutePlanner';
import ZonesViewModel from '../viewmodel/ZonesViewModel';

@Component
export struct Zones {
  changedIndex: boolean = true;
  zonesList: ZonesItem[] = ZonesViewModel.getZonesList();
  @StorageLink("aheadIndex") aheadIndex: number = ZoneConst.HALF_COUNT;
  @StorageLink("bottomTabIndex") bottomTabIndex: number = 1;
  @StorageLink("routeFocusType") routeFocusType: number = 0;
  @StorageLink("routeFocusLongitude") routeFocusLongitude: number = 0;
  @StorageLink("routeFocusLatitude") routeFocusLatitude: number = 0;
  @StorageLink("routeFocusToken") routeFocusToken: number = 0;
  @StorageLink("visitedZoneIds") visitedZoneIds: number[] = [];
  @State selectedRouteIndex: number = 0;
  @State marginBottom: number = 0;

  getImgCoefficients(index: number): number {
    let coefficient = this.aheadIndex - index;
    let tempCoefficient = Math.abs(coefficient);
    if (tempCoefficient <= ZoneConst.HALF_COUNT) {
      return coefficient;
    }
    let dataLength = this.zonesList.length;
    let tempOffset = dataLength - tempCoefficient;
    if (tempOffset <= ZoneConst.HALF_COUNT) {
      if (coefficient > 0) {
        return -tempOffset;
      }
      return tempOffset;
    }
    return 0;
  }

  getOffSetY(index: number): number {
    let offsetIndex = this.getImgCoefficients(index);
    let tempOffset = Math.abs(offsetIndex);
    let offsetY = this.marginBottom / (tempOffset + 1);
    if (tempOffset === 1) {
      offsetY += -offsetIndex * ZoneConst.MAX_OFFSET_Y;
    } else if (tempOffset == ZoneConst.HALF_COUNT) {
      offsetY += -offsetIndex * (ZoneConst.MAX_OFFSET_Y - ZoneConst.OFFSET_COEFFICIENTS);
    }
    return offsetY;
  }

  startAnimation(isUp: boolean): void {
    this.getUIContext().animateTo({
      duration: Const.SWIPER_DURATION,
    }, () => {
      let dataLength = this.zonesList.length;
      let tempIndex = isUp ? this.aheadIndex + 1 : dataLength + this.aheadIndex - 1;
      this.aheadIndex = tempIndex % dataLength;
      this.marginBottom = 0;
    });
  }

  handlePanGesture(offsetY: number): void {
    if (Math.abs(offsetY) < ZoneConst.MAX_MOVE_OFFSET) {
      this.marginBottom = offsetY;
    } else {
      if (this.changedIndex) {
        return;
      }
      this.changedIndex = true;
      this.startAnimation(offsetY < 0);
    }
  }

  aboutToAppear() {
    this.visitedZoneIds = ExploreModel.getVisitedIds();
  }

  @Builder
  ExploreSummary() {
    Column() {
      Row() {
        Text('校园探索打卡')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182431')
        Text(`${this.visitedZoneIds.length}/${this.zonesList.length}`)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#0A59F7')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Progress({
        value: this.visitedZoneIds.length,
        total: this.zonesList.length,
        type: ProgressType.Linear
      })
        .width('100%')
        .height(8)
        .color('#0A59F7')
        .backgroundColor('#E5EAF0')
        .margin({ top: 8 })

      Text(`已探索 ${this.visitedZoneIds.length}/${this.zonesList.length} 个区域`)
        .fontSize(12)
        .fontColor('#66000000')
        .margin({ top: 6 })
    }
    .width('92%')
    .padding(12)
    .margin({ top: 8, bottom: 8 })
    .backgroundColor(Color.White)
    .borderRadius(8)
  }

  @Builder
  RoutePlannerCard() {
    Column() {
      Row() {
        Text('智能游览推荐')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182431')
        Text(`推荐乘坐 ${RoutePlanner.getPlan(this.selectedRouteIndex).trainLine} 号线`)
          .fontSize(12)
          .fontColor(RoutePlanner.getPlan(this.selectedRouteIndex).accentColor)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Scroll() {
        Row({ space: 8 }) {
          ForEach(RoutePlanner.PLANS, (item: RoutePlan, index: number) => {
            Button(item.title)
              .fontSize(12)
              .fontColor(this.selectedRouteIndex === index ? Color.White : '#182431')
              .backgroundColor(this.selectedRouteIndex === index ? item.accentColor : '#EEF2F6')
              .borderRadius(16)
              .onClick(() => {
                this.selectedRouteIndex = index;
              })
          }, (item: RoutePlan) => item.title)
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .margin({ top: 10 })

      Text(RoutePlanner.getPlan(this.selectedRouteIndex).description)
        .fontSize(13)
        .fontColor('#66000000')
        .lineHeight(18)
        .margin({ top: 10 })

      Button('在地图定位第一站')
        .width('100%')
        .height(36)
        .fontSize(13)
        .fontColor(Color.White)
        .backgroundColor(RoutePlanner.getPlan(this.selectedRouteIndex).accentColor)
        .margin({ top: 10 })
        .onClick(() => {
          const plan: RoutePlan = RoutePlanner.getPlan(this.selectedRouteIndex);
          this.routeFocusType = plan.poiType;
          this.routeFocusLongitude = plan.firstStopLongitude;
          this.routeFocusLatitude = plan.firstStopLatitude;
          this.routeFocusToken++;
          this.bottomTabIndex = 0;
        })
    }
    .width('92%')
    .padding(12)
    .margin({ bottom: 16 })
    .backgroundColor(Color.White)
    .borderRadius(8)
  }

  build() {
    Navigation() {
      Column() {
        this.ExploreSummary()
        this.RoutePlannerCard()
        Stack() {
          ForEach(this.zonesList, (item: ZonesItem, index: number) => {
            Row() {
              Image(item.thumbnail)
                .objectFit(ImageFit.Cover)
                .borderRadius($r('app.float.common_border_radius'))
                .margin({ bottom: Const.SHADOW_RADIUS })
                .shadow({
                  radius: Const.SHADOW_RADIUS,
                  color: `rgba(0,0,0,0.3)`,
                  offsetY: Const.SHADOW_RADIUS / Const.DOUBLE_NUM
                })
                .opacity(1 - Math.min(ZoneConst.HALF_COUNT,
                  Math.abs(this.getImgCoefficients(index))) * ZoneConst.OPACITY_COEFFICIENTS)
            }
            .width(index != this.aheadIndex && this.getImgCoefficients(index) === 0
              ? Const.SWIPER_DEFAULT_WIDTH
              : `${ZoneConst.ITEM_WIDTH - ZoneConst.OFFSET_COEFFICIENTS * Math.abs(this.getImgCoefficients(index))}%`)
            .aspectRatio(Const.SWIPER_ASPECT_RATIO)
            .borderRadius($r('app.float.common_border_radius'))
            .offset({ x: 0, y: this.getOffSetY(index) })
            .zIndex(index != this.aheadIndex && this.getImgCoefficients(index) === 0
              ? 0 : ZoneConst.HALF_COUNT - Math.abs(this.getImgCoefficients(index)))
            .blur(ZoneConst.OFFSET_COEFFICIENTS * Math.abs(this.getImgCoefficients(index)))
          }, (item: ZonesItem) => JSON.stringify(item))
        }
        .width(Const.FULL_PERCENT)
        .layoutWeight(1)
        .margin({ top: 12 })
        .clip(true)
        .alignContent(Alignment.Center)
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: Const.INTRODUCTION_URL, params: { id: this.zonesList[this.aheadIndex].id } });
          AppStorage.set<number>('imageHeight', Const.FULL_PERCENT_NUMBER);
          AppStorage.set<number>('arrowIconOpacity', Const.OPACITY_MAX);
        })
        .gesture(
          PanGesture({ direction: PanDirection.Vertical })
            .onActionStart((event: GestureEvent) => {
              this.changedIndex = false;
              this.handlePanGesture(event.offsetY);
            })
            .onActionUpdate((event: GestureEvent) => {
              this.handlePanGesture(event.offsetY);
            })
            .onActionEnd(() => {
              this.getUIContext().animateTo({
                duration: Const.SWIPER_DURATION,
              }, () => {
                this.marginBottom = 0;
              });
            })
        )
      }
      .width(Const.FULL_PERCENT)
      .height(Const.FULL_PERCENT)
      .alignItems(HorizontalAlign.Center)
    }
    .backgroundColor($r('app.color.common_background_color'))
    .title(Const.INTRODUCTION_TITLE)
    .titleMode(NavigationTitleMode.Full)
    .hideBackButton(true)
  }
}
