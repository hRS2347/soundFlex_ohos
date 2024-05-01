import common from '@ohos.app.ability.common';
import media from '@ohos.multimedia.media';
import FileHelper from './file_util';

export class RecordHelper {
  private static instance: RecordHelper

  avRecorder = null
  savePath = null
  avProfile = {
    audioBitrate: 44100, // 音频比特率
    audioChannels: 1, // 音频声道数
    audioCodec: media.CodecMimeType.AUDIO_AAC, // 音频编码格式，当前只支持aac
    audioSampleRate: 44100, // 音频采样率
    fileFormat: media.ContainerFormatType.CFT_MPEG_4A, // 封装格式，当前只支持m4a
  }
  avConfig = null

  private constructor() {
    this.avRecorder = undefined;
    media.createAVRecorder().then((recorder) => {
      this.avRecorder = recorder;
    }, (err) => {
      console.error(`Invoke createAVRecorder failed, code is ${err.code}, message is ${err.message}`);
    })
    // 状态上报回调函数
    this.avRecorder.on('stateChange', (state, reason) => {
      console.log(`current state is ${state}`);
      // 用户可以在此补充状态发生切换后想要进行的动作
    })
    // 错误上报回调函数
    this.avRecorder.on('error', (err) => {
      console.error(`avRecorder failed, code is ${err.code}, message is ${err.message}`);
    })
  }

  static getInstance(): RecordHelper {
    if (!RecordHelper.instance) {
      RecordHelper.instance = new RecordHelper()
    }
    return RecordHelper.instance
  }

  startRecord() {
    //先创建录音器对象
    if (this.avRecorder == null || this.avRecorder == undefined) {
      this.savePath = FileHelper.getInstance().prepareSaveRecord()
      this.avConfig = {
        audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC, // 音频输入源，这里设置为麦克风
        profile: this.avProfile,
        url: this.savePath, // 参考应用文件访问与管理中的开发示例获取创建的音频文件fd填入此处
      }
    }
    //TODO 录音
  }

  stopRecord() {
    //TODO 停止
    this.avRecorder = null
    return this.savePath
  }

}


