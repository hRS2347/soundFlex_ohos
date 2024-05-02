@Component
@Entry
export struct Logo {
  build() {
    Column() {
      Row() {
        Image($r('app.media.hand')).size({ width: 48, height: 48 }).margin(
          { right: 20 }
        )
          .objectFit(ImageFit.ScaleDown)
        Text("SoundFlex").fontSize(36).fontWeight('bold')
      }
      .justifyContent(FlexAlign.Center)
    }.justifyContent(FlexAlign.Center)
  }
}