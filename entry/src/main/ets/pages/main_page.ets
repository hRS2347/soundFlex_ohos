import { Card } from '../components/card'
import { Logo } from '../components/logo'
import router from '@ohos.router'
import emitter from '@ohos.events.emitter'
import { AppEvent } from '../utils/event_util'

@Entry
@Component
export struct MainPage {
  build() {
    Row() {
      Column() {
        Logo()

        Card({
          text: '3d展厅',
          pic: $r('app.media.exhibition')
        }).margin({ top: 60 }).onClick(() => {
          //进入
          router.pushUrl({
            url: 'pages/hall_page' // 目标url
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
            console.info('Invoke pushUrl succeeded.');
          });
        }
        )
        Card(
          {
            text: '功能',
            pic: $r('app.media.input')
          }
        ).margin({ top: 10 })
          .onClick(()=>{
            globalThis.eventHub.emit(AppEvent.EVENT_CHANGE_PAGE,1)
          })
      }.alignItems(HorizontalAlign.Center)
      .width('100%')
    }.alignItems(VerticalAlign.Center)
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.light_light_gery'))
  }
}