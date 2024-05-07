import web_webview from '@ohos.web.webview';
import window from '@ohos.window';
import { AppEvent, Direction, ToastHelper } from '../utils/event_util';
import router from '@ohos.router';
import { CircleButton } from '../components/card';
import common from '@ohos.app.ability.common';
import AudioRecorder from '../utils/normal_record_util';
import fs from '@ohos.file.fs';
import media from '@ohos.multimedia.media';
import NetworkHelper from '../utils/network_util';
import PlayHelper from '../utils/play_util';

// 获取程序的上下文
const context = getContext(this) as common.UIAbilityContext;
// 获取项目的files目录
const filesDir = context.filesDir;
// 如果文件夹不存在就创建
fs.access(filesDir, (err, res: boolean) => {
  if (!res) {
    // @ts-ignore
    fs.mkdirSync(filesDir)
  }
});

// 录音文件路径
let audioPath = filesDir + "/audio.m4a";

@Entry
@Component
struct Hall_page {
  hallController: web_webview.WebviewController = new web_webview.WebviewController();
  bgController: web_webview.WebviewController = new web_webview.WebviewController();
  @State isOn: boolean = false
  recorder = new AudioRecorder()

  async onPageShow() {
    // 获取旋转的方向，具体可以查看对应文档
    let orientation = window.Orientation.LANDSCAPE;
    try {
      // 设置屏幕旋转
      globalThis.windowClass.setPreferredOrientation(orientation, (err) => {
      });
    } catch (exception) {
      console.error('设置失败: ' + JSON.stringify(exception));
    }
    PlayHelper.getInstance().init()
    globalThis.context.eventHub.on(AppEvent.RERUN_ROUTINE, () => {
      this.runRoutine().then(() => {
        if (this.isOn) {
          globalThis.eventHub.emit(AppEvent.RERUN_ROUTINE)
        }
      })
    })
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
      Web({ src: '192.168.48.147:5173/index.html', controller: this.hallController })
        .height('100%')
        .width('100%')
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .focusable(true)
        .id('row1') //设置锚点为row1

      CircleButton({ pic: $r('app.media.quit') })
        .margin({ left: 20, top: 20 })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        }).id('exit').onClick((event: ClickEvent) => {
        router.back()
      })

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

      Toggle({ type: ToggleType.Button, isOn: this.isOn }) {
        Text(this.isOn === false ? "识别：停用" : "识别：停用")
          .fontSize(12)
      }
      .width(100)
      .margin({ top: 10, right: 20 })
      .alignRules({
        top: { anchor: 'setting', align: VerticalAlign.Bottom },
        right: { anchor: '__container__', align: HorizontalAlign.End }
      })
      .id('switch')
      .onClick(() => {
        this.isOn = !this.isOn
        globalThis.eventHub.emit(AppEvent.RERUN_ROUTINE)
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.light_light_gery'))
  }

  async runRoutine() {
    if (this.isOn) {
      // 执行routine
      try {
        await PlayHelper.getInstance().playAudio() // 播放超声波
        await this.recorder.run(audioPath) // 等待录音结束
        PlayHelper.getInstance().stopPlay() // 播放超声波
        //发送获取结果
        // await NetworkHelper.getInstance().predict(audioPath).then(response => {
        //   console.log('Request successful:', response.data);
        //   ToastHelper.getInstance().toast(response.data, ToastHelper.SHORT_DUR)
        //   //根据结果，调用webview函数
        //   this.hallController.runJavaScript(`restest('${this.transToKey(response.data)}')`);
        // }).catch(error => {
        //   console.error('Error sending request:', error);
        // })
      } catch (error) {
        console.error('Error:', error);
      }
    }
  }

  transToKey(index:Direction){
    return 'w'
  }


  sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
  }
}