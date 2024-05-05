import hilog from '@ohos.hilog'
import http from '@ohos.net.http';
import request from '@ohos.request';

export default class NetworkHelper {
  private static instance: NetworkHelper

  private constructor() {

  }

  static getInstance(): NetworkHelper {
    if (!NetworkHelper.instance) {
      NetworkHelper.instance = new NetworkHelper()
    }
    return NetworkHelper.instance
  }
  // 服务端 IP 和端口，在进入 app 时就会输入的
  private ip: string = "192.168.3.90"
  private port: string = "8886"

  async delete(mode: string) {
    //直接发出请求
    let httpRequest = http.createHttp();
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      `http://${this.ip}:${this.port}/delete`,
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'multipart/form-data'
        },
        // 当使用POST请求时此字段用于传递内容
        extraData: {
          "mode": "dev",
        },
      }, (err, data) => {
      if (!err) {
        // data.result为HTTP响应内容，可根据业务需要进行解析
        console.info('Result:' + JSON.stringify(data.result));
        console.info('code:' + JSON.stringify(data.responseCode));
        // data.header为HTTP响应头，可根据业务需要进行解析
        console.info('header:' + JSON.stringify(data.header));
        console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
      } else {
        console.info('error:' + JSON.stringify(err));
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    });
  }

  async predict(path) {
    let uploadConfig = {
      url: `http://${this.ip}:${this.port}/predict`,
      header: {
        'Content-Type': 'multipart/form-data'
      },
      method: 'POST',
      files: [
        {
          filename: path, name: 'test', uri: path, type: 'm4a'
        }
      ],
      data: [
        {
          name: 'mode', value: 'dev'
        }
      ]
    }
    let uploadTask
    try {
      request.uploadFile(globalThis.context, uploadConfig).then((data) => {
        uploadTask = data;
      }).catch((err) => {
        console.error('Failed to request the upload. Cause: ' + JSON.stringify(err));
      });
    } catch (err) {
      console.error('err.code : ' + err.code + ', err.message : ' + err.message);
    }


  }

  async save(path, label) {
    let uploadConfig = {
      url: `http://${this.ip}:${this.port}/save`,
      header: {
        'Content-Type': 'multipart/form-data'
      },
      method: 'POST',
      files: [
        {
          filename: path, name: 'test', uri: path, type: 'm4a'
        }
      ],
      data: [
        {name: 'mode', value: 'dev'},
        {name: 'label', value: label}
      ]
    }
    let uploadTask;
    try {
      request.uploadFile(globalThis.context, uploadConfig).then((data) => {
        uploadTask = data;
      }).catch((err) => {
        console.error('Failed to request the upload. Cause: ' + JSON.stringify(err));
      });
    } catch (err) {
      console.error('err.code : ' + err.code + ', err.message : ' + err.message);
    }
  }
}

