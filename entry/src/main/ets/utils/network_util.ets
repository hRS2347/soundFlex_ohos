import hilog from '@ohos.hilog'
import http from '@ohos.net.http';
import request from '@ohos.request';
import axios, { AxiosError, AxiosResponse, FormData, InternalAxiosRequestConfig } from '@ohos/axios'
// 添加请求拦截器
axios.interceptors.request.use((config:InternalAxiosRequestConfig) => {
  // 对请求数据做点什么
  console.log('axios','request:' +JSON.stringify(config))
  return config;
}, (error:AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});


// 添加响应拦截器
axios.interceptors.response.use((response:AxiosResponse)=> {
  // 对响应数据做点什么
  console.log('axios','response:' +JSON.stringify(response))
  return response;
}, (error:AxiosError)=> {
  // 对响应错误做点什么
  return Promise.reject(error);
});

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
  private ip: string = "192.168.3.10"
  private port: string = "8886"

  delete() {
    // //直接发出请求
    // let httpRequest = http.createHttp();
    // httpRequest.request(
    //   // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
    //   `http://${this.ip}:${this.port}/delete`,
    //   {
    //     method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
    //     // 开发者根据自身业务需要添加header字段
    //     header: {
    //       'Content-Type': 'multipart/form-data'
    //     },
    //     // 当使用POST请求时此字段用于传递内容
    //     extraData: {
    //       "mode": "dev",
    //     },
    //   });
    const requestData = {
      url:`http://${this.ip}:${this.port}/delete`,
      method: 'post',
      timeout: 1000,
      headers: {
        'Content-Type': 'application/json',
        'CharSet':'UTF-8'
      },
      data:{
        mode:"dev"
      }
    }
    return axios(requestData)
    // const url = `http://${this.ip}:${this.port}/delete`;
    // const headers = {
    //   'Content-Type': 'multipart/form-data'
    // };
    // const data = {
    //   mode: 'dev'
    // };
    //
    // const formData = new FormData();
    // Object.keys(data).forEach(key => {
    //   formData.append(key, data[key]);
    // });
    //
    // return axios.post(url, formData, { headers })
  }

  async predict(path) {
    const uploadConfig = {
      url: `http://${this.ip}:${this.port}/predict`,
      header: {
        'Content-Type': 'multipart/form-data'
      },
      method: 'POST',
      files: [
        {
          filename: path, name: 'file', uri: path, type: 'm4a'
        }
      ],
      data:
      {
        'mode': 'dev',
      }
    }
    return axios(uploadConfig)
  }

  async save(path, label) {
    const uploadConfig = {
      url: `http://${this.ip}:${this.port}/save`,
      headers: {
        'Content-Type': 'multipart/form-data'
      },
      method: 'POST',
      files: [
        {
          filename: path,
          name: 'file',
          uri: path,
          type: 'm4a'
        }
      ],
      data:
      {
        'mode': 'dev',
        'label': label
      }
    };
    return axios(uploadConfig)
  }
}

