import { BigCircleButton, CircleButton } from '../components/card'
import web_webview from '@ohos.web.webview';
import { AppEvent, Direction, ToastHelper } from '../utils/event_util';
import http from '@ohos.net.http';
import NetworkHelper from '../utils/network_util';
import PlayHelper from '../utils/play_util';
import AudioRecorder from '../utils/normal_record_util'
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
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
let audioPath = filesDir + "/audio.m4a";

@Entry
@Component
export struct SettingPage {
  btnGap = 24
  @State isRecording: boolean = false
  @State isTesting: boolean = false
  @State isSelect: string = '空'
  recorder = new AudioRecorder()
  label = '0'

  translateIndexToDir(index: Direction) {
    this.label = index
    if (index == Direction.TURN_LEFT) {
      this.isSelect = '左转'
    } else if (index == Direction.UP) {
      this.isSelect = '前进'
    } else if (index == Direction.TURN_RIGHT) {
      this.isSelect = '右转'
    } else if (index == Direction.LEFT) {
      this.isSelect = '左'
    } else if (index == Direction.DOWN) {
      this.isSelect = '后退'
    } else if (index == Direction.NO_DIRECTION) {
      this.isSelect = '无'
    } else if (index == Direction.RIGHT) {
      this.isSelect = '右'
    } else if (index == Direction.INTERACTIVE) {
      this.isSelect = '交互'
    }
    ToastHelper.getInstance().toast(index, ToastHelper.SHORT_DUR)
  }

  ports: web_webview.WebMessagePort[];
  //订阅管道
  aboutToAppear() {
    // try {
    //   // 1、创建两个消息端口。
    //   this.ports = this.webViewController.createWebMessagePorts();
    //   // 2、在应用侧的消息端口(如端口1)上注册回调事件。
    //   this.ports[1].onMessageEvent((result: web_webview.WebMessage) => {
    //     if (result == 'end') {
    //       this.isTesting = false
    //       this.isTesting = false
    //       return
    //     }
    //     ToastHelper.getInstance().toast(`识别结果：${result}`, ToastHelper.SHORT_DUR) //将预测结果打印
    //   })
    // } catch (error) {
    //   console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
    // }
  }

  build() {
    RelativeContainer() {
      // Web({ src: $rawfile('Test.html'), controller: this.webViewController })
      //   .javaScriptAccess(true)
      //   .height('1%')
      //   .width('1%')
      //   .alignRules({
      //     top: { anchor: '__container__', align: VerticalAlign.Top },
      //     left: { anchor: '__container__', align: HorizontalAlign.Start }
      //   })
      //   .id('web')

      Text('设置')
        .margin({ left: 30, top: 30 })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        }).id('title')

      Text(`已选中：${this.isSelect}`)
        .margin({ top: 30 })
        .fontSize(20)
        .fontColor('#ff262626')
        .fontWeight(700)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .id('selected')


      BigCircleButton({ pic: $r('app.media.turn_left') })
        .margin({ right: this.btnGap })
        .alignRules({
          bottom: { anchor: 'up', align: VerticalAlign.Bottom },
          right: { anchor: 'up', align: HorizontalAlign.Start }
        }).id('turn_left')
        .onClick(() => {
          this.translateIndexToDir(Direction.TURN_LEFT)
        })

      BigCircleButton({ pic: $r('app.media.up') })
        .margin({ top: 30 })
        .alignRules({
          top: { anchor: 'selected', align: VerticalAlign.Bottom },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        }).id('up')
        .onClick(() => {
          this.translateIndexToDir(Direction.UP)
        })
      BigCircleButton({ pic: $r('app.media.turn_right') })
        .margin({ left: this.btnGap })
        .alignRules({
          bottom: { anchor: 'up', align: VerticalAlign.Bottom },
          left: { anchor: 'up', align: HorizontalAlign.End }
        }).id('turn_right')
        .onClick(() => {
          this.translateIndexToDir(Direction.TURN_RIGHT)
        })
      BigCircleButton({ pic: $r('app.media.left') })
        .margin({ right: this.btnGap })
        .alignRules({
          bottom: { anchor: 'down', align: VerticalAlign.Bottom },
          right: { anchor: 'down', align: HorizontalAlign.Start }
        }).id('left')
        .onClick(() => {
          this.translateIndexToDir(Direction.LEFT)
        })

      BigCircleButton({ pic: $r('app.media.down') })
        .margin({ top: this.btnGap })
        .alignRules({
          top: { anchor: 'up', align: VerticalAlign.Bottom },
          middle: { anchor: 'up', align: HorizontalAlign.Center }
        }).id('down')
        .onClick(() => {
          this.translateIndexToDir(Direction.DOWN)
        })
      BigCircleButton({ pic: $r('app.media.right') })
        .margin({ left: this.btnGap })
        .alignRules({
          bottom: { anchor: 'down', align: VerticalAlign.Bottom },
          left: { anchor: 'down', align: HorizontalAlign.End }
        }).id('right')
        .onClick(() => {
          this.translateIndexToDir(Direction.RIGHT)
        })
      BigCircleButton({ pic: $r('app.media.no_direction') })
        .margin({ top: this.btnGap })
        .alignRules({
          top: { anchor: 'down', align: VerticalAlign.Bottom },
          middle: { anchor: 'down', align: HorizontalAlign.Center }
        }).id('null')
        .onClick(() => {
          this.translateIndexToDir(Direction.NO_DIRECTION)
        })
      BigCircleButton({ pic: $r('app.media.interactive') })
        .margin({ right: this.btnGap })
        .alignRules({
          bottom: { anchor: 'null', align: VerticalAlign.Bottom },
          right: { anchor: 'null', align: HorizontalAlign.Start }
        }).id('interactive')
        .onClick(() => {
          this.translateIndexToDir(Direction.INTERACTIVE)
        })


      Button(this.isRecording ? '录制中' : '录制')
        .width('40%')
        .margin({ top: 40, left: 24 })
        .alignRules({
          top: { anchor: 'null', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .backgroundColor(this.isRecording || this.isTesting ? '#ff7c7c7c' : '#ff0d46ff')
        .id('record')
        .onClick(() => {
          if (this.isSelect == '空') {
            ToastHelper.getInstance().toast('请先选择一个按钮', ToastHelper.SHORT_DUR)
            return
          }
          if (this.isRecording || this.isTesting) {
            ToastHelper.getInstance().toast("正在录制中", ToastHelper.SHORT_DUR)
            return
          }
          this.isRecording = true
          this.runSave()
        })


      Button(this.isTesting ? "测试中" : '测试')
        .width('40%')
        .backgroundColor(this.isRecording || this.isTesting ? '#ff7c7c7c' : '#ff0d46ff')
        .margin({ top: 40, right: 24 })
        .alignRules({
          top: { anchor: 'null', align: VerticalAlign.Bottom },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .id('test')
        .onClick(() => {
          if (this.isRecording || this.isTesting) {
            ToastHelper.getInstance().toast("正在录制中", ToastHelper.SHORT_DUR)
            return
          }
          this.isTesting = true
          this.runPredict()
        })

      Button("清空")
        .backgroundColor('#ffff4983')
        .margin({ top: 20 })
        .alignRules({
          top: { anchor: 'test', align: VerticalAlign.Bottom },
          right: { anchor: 'test', align: HorizontalAlign.Center },
          left: { anchor: 'record', align: HorizontalAlign.Center }
        })
        .id('clear')
        .onClick(() => {
          NetworkHelper.getInstance().delete().then(response => {
            ToastHelper.getInstance().toast(`清空成功`, ToastHelper.SHORT_DUR)
            console.log('axios', 'Request successful:', response.data);
          })
            .catch(error => {
              ToastHelper.getInstance().toast(`内部错误：${error}`, ToastHelper.SHORT_DUR)
              console.error('axios', 'Error sending request:', error);
            })
        })

    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.light_light_gery'))
  }

  async runSave() {
    PlayHelper.getInstance().playAudio() // 播放超声波
    await this.recorder.run(audioPath) // 等待录音结束
    PlayHelper.getInstance().stopPlay() // 播放超声波
    //发送获取结果
    NetworkHelper.getInstance()
      .save(audioPath, this.label)
      .then(response => {
        console.log('Request successful:', response.data);
        ToastHelper.getInstance().toast(`序号${response.data}保存成功`, ToastHelper.SHORT_DUR)
      })
      .catch(error => {
        ToastHelper.getInstance().toast(`内部错误：${error}`, ToastHelper.SHORT_DUR)
        console.error('axios', 'Error sending request:' + error);
      })
      .finally(() => {
        this.isRecording = false
      })
  }

  async runPredict() {
    PlayHelper.getInstance().playAudio() // 播放超声波
    await this.recorder.run(audioPath) // 等待录音结束
    PlayHelper.getInstance().stopPlay() // 播放超声波
    //发送获取结果
    NetworkHelper.getInstance()
      .predict(audioPath)
      .then(response => {
        console.log('Request successful:', response.data);
        ToastHelper.getInstance().toast(`测试结果为序号${response.data}`, ToastHelper.SHORT_DUR)
      })
      .catch(error => {
        ToastHelper.getInstance().toast(`内部错误：${error}`, ToastHelper.SHORT_DUR)
        console.error('axios', 'Error sending request:' + error);
      })
      .finally(() => {
        this.isTesting = false
      })
  }
}
