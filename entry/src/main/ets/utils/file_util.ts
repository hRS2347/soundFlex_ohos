import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';

export default class FileHelper {
  private static instance: FileHelper

  private constructor() {

  }

  static getInstance(): FileHelper {
    if (!FileHelper.instance) {
      FileHelper.instance = new FileHelper()
    }
    return FileHelper.instance
  }

  private key: string = null;
  private fileWriteStream = null
  public file: string = null;
  private filesDir = globalThis.context.filesDir;

  prepareSaveRecord() {
    // 获取应用文件路径
    this.key = new Date().toISOString()
    this.fileWriteStream = fs.createStreamSync(this.filesDir + '/' + this.key + '.pcm', 'w+')
    return this.filesDir + '/' + this.key + '.pcm'
  }

  delete() {
    let filesDir = globalThis.context.filesDir;
    fs.rmdir(filesDir)
  }

  // saveRecordBytes(data: ArrayBuffer) {
  //   if (this.fileWriteStream == null) {
  //     console.info("FileHelper", "未初始化");
  //     return
  //   }
  //   this.fileWriteStream.write(data)
  // }
  //
  // stopRecord() {
  //   this.fileWriteStream.closeSync();
  //   this.fileWriteStream = null;
  //   return this.filesDir + '/' + this.key + '.pcm'
  // }
}


