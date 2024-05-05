import web_webview from '@ohos.web.webview';
import window from '@ohos.window';
import emitter from '@ohos.events.emitter';
import { AppEvent, ToastHelper } from '../utils/event_util';
import router from '@ohos.router';
import { CircleButton } from '../components/card';
import common from '@ohos.app.ability.common';
import AudioRecorder from '../utils/normal_record_util';
import fs from '@ohos.file.fs';
import media from '@ohos.multimedia.media';
import NetworkHelper from '../utils/network_util';

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
  private avPlayer
  private playIng: boolean = false

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
    // 创建avPlayer实例对象
    this.avPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数
    this.setAVPlayerCallback();

    globalThis.context.eventHub.on(AppEvent.RERUN_ROUTINE, () => {
      this.runRoutine().then(()=>{
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

  // 播放音频
  async playAudio(path: string) {
    this.playIng = true
    let fdPath = 'fd://';
    let res = fs.accessSync(path);
    if (!res) {
      console.error(`音频文件不存在：${path}`);
      this.playIng = false
      return
    }
    console.info(`播放音频文件：${path}`)
    // 打开相应的资源文件地址获取fd
    let file = await fs.open(path);
    fdPath = fdPath + '' + file.fd;
    // url赋值触发initialized状态机上报
    this.avPlayer.url = fdPath;
  }

  // 停止播放
  stopPlay() {
    this.avPlayer.reset();
  }

  // 注册avplayer回调函数
  setAVPlayerCallback() {
    this.avPlayer.on('error', (err) => {
      this.playIng = false
      console.error(`播放器发生错误，错误码：${err.code}, 错误信息：${err.message}`);
      // 调用reset重置资源，触发idle状态
      this.avPlayer.reset();
    })
    // 状态机变化回调函数
    this.avPlayer.on('stateChange', async (state) => {
      switch (state) {
        case 'initialized':
        // 资源初始化完成，开始准备文件
          this.avPlayer.prepare();
          break;
        case 'prepared':
        // 资源准备完成，开始准备文件
          this.avPlayer.play();
          break;
        case 'completed':
        // 调用reset()重置资源，AVPlayer重新进入idle状态，允许更换资源url
          this.avPlayer.reset();
          break;
        case 'idle':
          this.playIng = false
          break;
      }
    })
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

  async runRoutine(){
    if (this.isOn) {
      // 执行routine
      try {
        this.playAudio(audioPath) // 播放超声波
        await this.recorder.run(audioPath) // 等待录音结束
        this.stopPlay() // 播放超声波
        //发送获取结果
        NetworkHelper.getInstance().predict(audioPath).then(()=>{

        })

      } catch (error) {
        console.error('Error:', error);
      }
    }
  }
  sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
  }
}