import { Logo } from '../components/logo'
@Entry
@Component
export struct MorePage {
  build() {
    Row() {
      Column() {
        Logo()
        Text('更多功能开发中......').fontSize(18).fontColor($r('app.color.light_gery'))
          .decoration({
            type: TextDecorationType.Underline,
            color:$r('app.color.light_gery')
          })
      }.alignItems(HorizontalAlign.Center)
      .width('100%')
    }.alignItems(VerticalAlign.Center)
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.light_light_gery'))

  }
}