import image from '@ohos.multimedia.image'
@Component
@Entry
export struct Card {
  text: string = 'Init Str'
  pic: Resource = $r('app.media.hand')

  build() {
    Stack() {
      Rect({ width: '100%', height: '100%' })
        .radius(15)
        .fill(Color.Pink)
        .stroke(Color.Transparent)

      Column(){
        Text(this.text).fontSize(24).fontWeight('bold')
        Image(this.pic).width('50%').height('50%')
          .objectFit(ImageFit.ScaleDown)
      }
    }.width('80%')
    .height('28%')

  }
}
@Component
export struct CircleButton {
  pic: Resource

  build() {
    Stack() {
      Circle({ width: 60, height: 60 }).fill(Color.White)
      Image(this.pic).width(60).height(60).padding(20)
    }
  }
}

@Component
export struct BigCircleButton {
  pic: Resource

  build() {
    Stack() {
      Circle({ width: 80, height: 80 }).fill(Color.White)
      Image(this.pic).width(80).height(80).padding(20)
    }
  }
}

