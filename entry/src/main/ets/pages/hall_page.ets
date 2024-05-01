import image from '@ohos.multimedia.image';
import web_webview from '@ohos.web.webview';
import window from '@ohos.window';
import emitter from '@ohos.events.emitter';
import { AppEvent } from '../utils/event_util';
import router from '@ohos.router';
import { CircleButton } from '../components/card';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import inputMethod from '@ohos.inputMethod';

@Entry
@Component
struct Hall_page {
  hallController: web_webview.WebviewController = new web_webview.WebviewController();
  bgController: web_webview.WebviewController = new web_webview.WebviewController();
  @State isOn: boolean = false

  onPageShow() {
    // 获取旋转的方向，具体可以查看对应文档
    let orientation = window.Orientation.LANDSCAPE;
    try {
      // 设置屏幕旋转
      globalThis.windowClass.setPreferredOrientation(orientation, (err) => {
      });
    } catch (exception) {
      console.error('设置失败: ' + JSON.stringify(exception));
    }
  }

  onPageHide() {
    // 获取旋转的方向，具体可以查看对应文档
    let orientation = window.Orientation.PORTRAIT;
    try {
      // 设置屏幕旋转
      globalThis.windowClass.setPreferredOrientation(orientation, (err) => {
      });
    } catch (exception) {
      console.error('设置失败: ' + JSON.stringify(exception));
    }
  }

  build() {
    RelativeContainer() {
      Web({ src: $rawfile('Test.html'), controller: this.bgController })
        .height('1%')
        .width('1%')
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .focusable(false)
        .id('bg')

      Web({ src: '192.168.3.90:5173/index.html', controller: this.hallController })
        .height('100%')
        .width('100%')
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .focusable(true)
        .id('row1') //设置锚点为row1
      //
      // CircleButton({ pic: $r('app.media.left') })
      //   .margin({ left: 20, bottom: 20 })
      //   .alignRules({
      //     bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      //     left: { anchor: '__container__', align: HorizontalAlign.Start }
      //   }).id('left')
      //   .onTouch((event: TouchEvent) => {
      //     if (event.type === TouchType.Down) {
      //       sendKeyEvent({
      //         type: KeyType.Down,
      //         keyCode: KeyCode.KEYCODE_A,
      //         keyText: 'A',
      //         keySource: KeySource.Keyboard,
      //         deviceId: 1,
      //         metaKey: 1,
      //         timestamp: Date.now(),
      //       })
      //     }
      //     if (event.type === TouchType.Up) {
      //       sendKeyEvent({
      //         type: KeyType.Up,
      //         keyCode: KeyCode.KEYCODE_A,
      //         keyText: 'A',
      //         keySource: KeySource.Keyboard,
      //         deviceId: 1,
      //         metaKey: 1,
      //         timestamp: Date.now(),
      //       })
      //     }
      //   })
      //
      // CircleButton({ pic: $r('app.media.down') })
      //   .margin({ left: 10, bottom: 20 })
      //   .alignRules({
      //     bottom: { anchor: 'left', align: VerticalAlign.Bottom },
      //     left: { anchor: 'left', align: HorizontalAlign.End }
      //   }).id('down').onTouch((event: TouchEvent) => {
      //   if (event.type === TouchType.Down) {
      //     sendKeyEvent({
      //       type: KeyType.Down,
      //       keyCode: KeyCode.KEYCODE_S,
      //       keyText: 'S',
      //       keySource: KeySource.Keyboard,
      //       deviceId: 1,
      //       metaKey: 1,
      //       timestamp: Date.now(),
      //     })
      //   }
      //   if (event.type === TouchType.Up) {
      //     sendKeyEvent({
      //       type: KeyType.Up,
      //       keyCode: KeyCode.KEYCODE_S,
      //       keyText: 'S',
      //       keySource: KeySource.Keyboard,
      //       deviceId: 1,
      //       metaKey: 1,
      //       timestamp: Date.now(),
      //     })
      //   }
      // })
      //
      // CircleButton({ pic: $r('app.media.right') })
      //   .margin({ left: 10, bottom: 20 })
      //   .alignRules({
      //     bottom: { anchor: 'left', align: VerticalAlign.Bottom },
      //     left: { anchor: 'down', align: HorizontalAlign.End }
      //   }).id('right').onTouch((event: TouchEvent) => {
      //   if (event.type === TouchType.Down) {
      //     sendKeyEvent({
      //       type: KeyType.Down,
      //       keyCode: KeyCode.KEYCODE_D,
      //       keyText: 'D',
      //       keySource: KeySource.Keyboard,
      //       deviceId: 1,
      //       metaKey: 1,
      //       timestamp: Date.now(),
      //     })
      //   }
      //   if (event.type === TouchType.Up) {
      //     sendKeyEvent({
      //       type: KeyType.Up,
      //       keyCode: KeyCode.KEYCODE_D,
      //       keyText: 'D',
      //       keySource: KeySource.Keyboard,
      //       deviceId: 1,
      //       metaKey: 1,
      //       timestamp: Date.now(),
      //     })
      //   }
      // })
      //
      // CircleButton({ pic: $r('app.media.turn_left') })
      //   .margin({ left: 20, bottom: 10 })
      //   .alignRules({
      //     bottom: { anchor: 'left', align: VerticalAlign.Top },
      //     left: { anchor: '__container__', align: HorizontalAlign.Start }
      //   }).id('turn_left')
      //   .onTouch((event: TouchEvent) => {
      //     if (event.type === TouchType.Down) {
      //       sendKeyEvent({
      //         type: KeyType.Down,
      //         keyCode: KeyCode.KEYCODE_Q,
      //         keyText: 'Q',
      //         keySource: KeySource.Keyboard,
      //         deviceId: 1,
      //         metaKey: 1,
      //         timestamp: Date.now(),
      //       })
      //     }
      //     if (event.type === TouchType.Up) {
      //       sendKeyEvent({
      //         type: KeyType.Up,
      //         keyCode: KeyCode.KEYCODE_Q,
      //         keyText: 'Q',
      //         keySource: KeySource.Keyboard,
      //         deviceId: 1,
      //         metaKey: 1,
      //         timestamp: Date.now(),
      //       })
      //     }
      //   })
      //
      // CircleButton({ pic: $r('app.media.up') })
      //   .margin({ left: 10, bottom: 10 })
      //   .alignRules({
      //     bottom: { anchor: 'left', align: VerticalAlign.Top },
      //     left: { anchor: 'left', align: HorizontalAlign.End }
      //   }).id('up').onTouch((event: TouchEvent) => {
      //   if (event.type === TouchType.Down) {
      //     sendKeyEvent({
      //       type: KeyType.Down,
      //       keyCode: KeyCode.KEYCODE_W,
      //       keyText: 'W',
      //       keySource: KeySource.Keyboard,
      //       deviceId: 1,
      //       metaKey: 1,
      //       timestamp: Date.now(),
      //     })
      //   }
      //   if (event.type === TouchType.Up) {
      //     sendKeyEvent({
      //       type: KeyType.Up,
      //       keyCode: KeyCode.KEYCODE_W,
      //       keyText: 'W',
      //       keySource: KeySource.Keyboard,
      //       deviceId: 1,
      //       metaKey: 1,
      //       timestamp: Date.now(),
      //     })
      //   }
      // })
      //
      // CircleButton({ pic: $r('app.media.turn_right') })
      //   .margin({ left: 10, bottom: 10 })
      //   .alignRules({
      //     bottom: { anchor: 'left', align: VerticalAlign.Top },
      //     left: { anchor: 'down', align: HorizontalAlign.End }
      //   }).id('turn_right').onTouch((event: TouchEvent) => {
      //   if (event.type === TouchType.Down) {
      //     sendKeyEvent({
      //       type: KeyType.Down,
      //       keyCode: KeyCode.KEYCODE_E,
      //       keyText: 'E',
      //       keySource: KeySource.Keyboard,
      //       deviceId: 1,
      //       metaKey: 1,
      //       timestamp: Date.now(),
      //     })
      //   }
      //   if (event.type === TouchType.Up) {
      //     sendKeyEvent({
      //       type: KeyType.Up,
      //       keyCode: KeyCode.KEYCODE_E,
      //       keyText: 'E',
      //       keySource: KeySource.Keyboard,
      //       deviceId: 1,
      //       metaKey: 1,
      //       timestamp: Date.now(),
      //     })
      //   }
      // })
      //
      CircleButton({ pic: $r('app.media.quit') })
        .margin({ left: 20, top: 20 })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        }).id('exit').onClick((event: ClickEvent) => {
        router.back()
      })

      // CircleButton({ pic: $r('app.media.keyboard') })
      //   .margin({ right: 20, bottom: 20 })
      //   .alignRules({
      //     bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      //     right: { anchor: '__container__', align: HorizontalAlign.End }
      //   }).id('keyboard').onClick((event: ClickEvent) => {
      //   // inputMethod.getController().showSoftKeyboard((err) => {
      //   //   if (err === undefined) {
      //   //     console.info("hall",'Succeeded in showing softKeyboard.');
      //   //   } else {
      //   //     console.error("hall",'Failed to showSoftKeyboard: ' + JSON.stringify(err));
      //   //   }
      //   // })
      //
      // })
      // CircleButton({ pic: $r('app.media.interactive') })
      //   .margin({ right: 10, bottom: 20 })
      //   .alignRules({
      //     bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      //     right: { anchor: 'keyboard', align: HorizontalAlign.Start }
      //   }).id('interactive')

      Button("设置")
        .width(100)
        .margin({ top: 20, right: 20 })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .id('setting')
        .onClick(() => {
          router.pushUrl({
            url: 'pages/setting_page' // 目标url
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
            console.info('Invoke pushUrl succeeded.');
          })
        })

      // Toggle({ type: ToggleType.Button, isOn: this.isOn }) {
      //   Text(this.isOn === false ? "识别：停用" : "识别：停用")
      //     .fontSize(12)
      // }
      // .width(100)
      // .margin({ top: 10, right: 20 })
      // .alignRules({
      //   top: { anchor: 'setting', align: VerticalAlign.Bottom },
      //   right: { anchor: '__container__', align: HorizontalAlign.End }
      // })
      // .id('switch')
      // .onClick(() => {
      //   this.isOn = !this.isOn
      // })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.light_light_gery'))
  }
}