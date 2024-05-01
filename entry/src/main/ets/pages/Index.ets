import hilog from '@ohos.hilog'
import { AppEvent, ToastHelper } from '../utils/event_util'
import { ControlPage } from './control_page'
import { MainPage } from './main_page'
import { MorePage } from './more_page'
import entry from 'libentry.so'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  // 自定义导航页签的样式
  @Builder TabBuilder(title: string, targetIndex: number,
  ) {
    Column() {
      Text(title)
        .fontSize(this.currentIndex === targetIndex ? 20 : 18)
        .fontWeight(this.currentIndex === targetIndex ? 700 : 'normal')
        .fontColor(this.currentIndex === targetIndex ? Color.Black : $r('app.color.light_gery'))
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.controller.changeIndex(this.currentIndex)
    })
  }

  // onPageShow(){
  //   ToastHelper.getInstance().toast(entry.add(2, 3).toString(),ToastHelper.LONG_DUR)
  // }
  //订阅
  aboutToAppear() {
    // 获取eventHub
    globalThis.context.eventHub.on(AppEvent.EVENT_CHANGE_PAGE, (pageIndex) => {
      console.info("TA11G", pageIndex);
      this.currentIndex = pageIndex
      this.controller.changeIndex(this.currentIndex)
    })
  }
  //取消
  aboutToDisappear() {
    globalThis.eventHub.off(AppEvent.EVENT_CHANGE_PAGE)
  }

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.End,
        controller: this.controller
      }) {
        TabContent() {
          MainPage()
        }.tabBar(this.TabBuilder('首页', 0))

        // TabContent() {
        //   ControlPage()
        // }.tabBar(this.TabBuilder('功能', 1))

        TabContent() {
          MorePage()
        }.tabBar(this.TabBuilder('更多', 1))
      }.scrollable(false)
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
  }
}