@Component
@Entry
export struct Logo {
  build() {
    Column() {
      Row() {
        Image($r('app.media.hand')).size({ width: 60, height: 60 }).padding(
          { right: 20 }
        )
        Text("SoundFlex").fontSize(36).fontWeight('bold')
      }
      .justifyContent(FlexAlign.Center)
    }.justifyContent(FlexAlign.Center)
  }
}