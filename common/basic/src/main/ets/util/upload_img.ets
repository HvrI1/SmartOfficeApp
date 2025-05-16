import { request } from "@kit.BasicServicesKit"
import { fileIo } from "@kit.CoreFileKit"
import { util } from "@kit.ArkTS"
import { RequestInfo, TOKEN_KEY } from "../constants"
import { Result } from "../../../../Index"


export const uploadFile = async (imgFile: string): Promise<string> => {
  try {
    const dest = getContext().cacheDir
    const source = fileIo.openSync(imgFile, fileIo.OpenMode.READ_ONLY)
    const newName = util.generateRandomUUID() + '.jpg'
    const cachePath = dest + '/' + newName
    fileIo.copyFileSync(source.fd, cachePath)
    fileIo.closeSync(source)
    const fileParams: request.File = {
      filename: newName,
      name: 'file',
      uri: 'internal://cache/' + newName,
      type: 'image/jpeg' // 修正MIME类型
    }
    const remoteUrl = await uploadImage(getContext(), fileParams)
    return remoteUrl
  } catch (err) {
    console.error('[ERROR] 上传全过程异常:', JSON.stringify(err))
    throw Error(err)
  }
}

//文件上传
//  -上传功能，本地必须是：post请求，表单内容类型：multipart/form-data
const uploadImage = (context:Context, file:request.File)=>{
  //生成文件需要时间的，提供异步操作
  return new Promise<string>(async (resolve, reject)=>{
    try{
      //数组对象：接收网络地址
      let serverImage: string  =""

      //设置：文件上传操作的请求配置对象
      const config:request.UploadConfig = {
        url: RequestInfo.BASE_URL+"/files/imageUpload",
        method: 'POST',
        files:[file],       //提交的文件列表
        data: [],       //附加数据：没有
        header: {
          'Content-Type': 'multipart/form-data',
        }
      }

      //创建上传任务
      const task = await request.uploadFile(context, config)

      //为任务添加状态的监听
      //每张图片上传完毕后执行，结果在header中
      task.on('headerReceive', (header)=>{

        //是否有完成后的回发头部信息
        if(header['body']){
          //提取结果，转响应格式的字符串
          const res = JSON.parse(header['body']) as Result<string>
          if(res.code===200){
            //将data中的网络地址放入数组
            serverImage=res.data as string
            console.log(serverImage)
          }else {
            throw Error(res.message)
          }
        }
      })

      //上传完毕
      task.on('complete', (state: request.TaskState[])=>{
        //调用resolve，传回数组
        resolve(serverImage)
      })

      //报错
      task.on('fail', (state: request.TaskState[])=>{
        reject(new Error('上传失败'))
      })
    }
    catch(err){
      AlertDialog.show({message: '上传失败！'+JSON.stringify(err)})
      reject(new Error('上传失败！'))
    }
    
    
    
  })
}