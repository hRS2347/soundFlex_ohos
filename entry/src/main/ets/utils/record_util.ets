import audio from '@ohos.multimedia.audio';
import fs from '@ohos.file.fs';
import media from '@ohos.multimedia.media';

const TAG = 'AudioCapturerUtil';

export default class RecordHelper {
  private audioCapturer = undefined;
  isRecording = false
  private audioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_44100,
    channels: audio.AudioChannel.CHANNEL_1,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
  }
  private audioCapturerInfo = {
    source: audio.SourceType.SOURCE_TYPE_MIC, // 音源类型
    capturerFlags: 0 // 音频采集器标志
  }
  private audioCapturerOptions = {
    streamInfo: this.audioStreamInfo,
    capturerInfo: this.audioCapturerInfo
  }


  // 初始化，创建实例，设置监听事件
  initRecorder() {
    audio.createAudioCapturer(this.audioCapturerOptions, (err, capturer) => { // 创建AudioCapturer实例
      if (err) {
        console.error(TAG, `Invoke createAudioCapturer failed, code is ${err.code}, message is ${err.message}`);
        return;
      }

      console.info(TAG, `${TAG}: create AudioCapturer success`);
      this.audioCapturer = capturer;
    });
  }

  // 开始一次音频采集
  async start(): Promise<string> {
    console.info(TAG, `${TAG}: start `);
    let stateGroup = [audio.AudioState.STATE_PREPARED, audio.AudioState.STATE_PAUSED, audio.AudioState.STATE_STOPPED];
    if (stateGroup.indexOf(this.audioCapturer.state) === -1) { // 当且仅当状态为STATE_PREPARED、STATE_PAUSED和STATE_STOPPED之一时才能启动采集
      console.error(TAG, `${TAG}: start failed`);
      return;
    }

    await this.audioCapturer.start(); // 启动采集

    let context = getContext(this);
    const path = context.filesDir + '/test.wav'; // 采集到的音频文件存储路径

    let file = fs.openSync(path, 0o2 | 0o100); // 如果文件不存在则创建文件
    let fd = file.fd;

    let count = 0;
    this.isRecording = true
    this.switchAfter2s()
    while (this.isRecording) {
      let bufferSize = await this.audioCapturer.getBufferSize();
      let buffer = await this.audioCapturer.read(bufferSize, true);
      let options = {
        offset: count * bufferSize,
        length: bufferSize
      };
      if (buffer === undefined) {
        console.error(TAG, `${TAG}: read buffer failed`);
      } else {
        let number = fs.writeSync(fd, buffer, options);
        console.info(TAG, `${TAG}: write date: ${number}`);
      }
      count++;
    }
    await this.stop()
    return path
  }

  async switchAfter2s() {
    await this.sleep(2000); // 休眠2秒
    this.isRecording = false
  }

  sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
  }
  // 停止采集
  async stop() {
    // 只有采集器状态为STATE_RUNNING或STATE_PAUSED的时候才可以停止
    if (this.audioCapturer.state !== audio.AudioState.STATE_RUNNING && this.audioCapturer.state !== audio.AudioState.STATE_PAUSED) {
      console.info(TAG, 'Capturer is not running or paused');
      return;
    }
    await this.audioCapturer.stop(); // 停止采集
    if (this.audioCapturer.state === audio.AudioState.STATE_STOPPED) {
      console.info(TAG, 'Capturer stopped');
    } else {
      console.error(TAG, 'Capturer stop failed');
    }
  }

  // 销毁实例，释放资源
  async release() {
    // 采集器状态不是STATE_RELEASED或STATE_NEW状态，才能release
    if (this.audioCapturer.state === audio.AudioState.STATE_RELEASED || this.audioCapturer.state === audio.AudioState.STATE_NEW) {
      console.info(TAG, 'Capturer already released');
      return;
    }
    await this.audioCapturer.release(); // 释放资源
    if (this.audioCapturer.state == audio.AudioState.STATE_RELEASED) {
      console.info(TAG, 'Capturer released');
    } else {
      console.error(TAG, 'Capturer release failed');
    }
  }
}
