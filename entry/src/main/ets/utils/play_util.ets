import media from '@ohos.multimedia.media';
import fs from '@ohos.file.fs';
import resourceManager from '@ohos.resourceManager';

export default class PlayHelper {
  private static instance: PlayHelper

  private constructor() {

  }

  private avPlayer
  private playIng: boolean = false
  fdPath = ''

  async init() {
    // 创建avPlayer实例对象
    this.avPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数
    this.setAVPlayerCallback();
    await globalThis.resourceManager.getRawFd("19kHz_tone.wav", (error, value) => {
      if (error != null) {
        console.log('midi',`callback getRawFd failed error code: ${error.code}, message: ${error.message}.`);
      } else {
        let fd = value.fd;
        this.playIng = true
        this.fdPath = 'fd://'+fd
        console.info('midi', 'fd://'+fd)
      }
    });
  }

  static getInstance(): PlayHelper {
    if (!PlayHelper.instance) {
      PlayHelper.instance = new PlayHelper()
    }
    return PlayHelper.instance
  }
  // 播放音频
  async playAudio() {
    this.avPlayer.url = this.fdPath
    return
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
          console.info('midi', `prepared`)
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
}