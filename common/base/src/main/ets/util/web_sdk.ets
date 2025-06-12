import { webview } from "@kit.ArkWeb";
import { Context } from "@kit.AbilityKit";
import { promptAction } from "@kit.ArkUI";
import { geoLocationManager } from "@kit.LocationKit";
import { map, mapCommon } from "@kit.MapKit";


export class WebSdkClass{
  //静态对象:web控制器
  static webController:webview.WebviewController

  //静态对象：上下文对象
  static context:Context

  //设置当前设备所在的Location
  //页面加载完毕后，调用网页中的js代码
  async setCurrentLocation(){
    try {
      //获取当前设备的位置信息
      const res:geoLocationManager.Location =await geoLocationManager.getCurrentLocation()
      //提取鸿蒙设备获取到的经纬度：WGS84这个格式
      const wgs84Positions:mapCommon.LatLng={
        latitude:res.latitude,
        longitude:res.longitude
      }
      //纠正/转换经纬度，适配高德底图，将wgs84Positions的类型从WGS84转为GCJ02
      const gcj02Positions:mapCommon.LatLng=map.convertCoordinateSync(
        mapCommon.CoordinateType.WGS84,//当前格式
        mapCommon.CoordinateType.GCJ02,//目标格式
        wgs84Positions//被转换的对象
      )
      //在鸿蒙端，调用网页中的js脚本函数
      //然后将转换好的经纬度传过去
      // html通过自己的函数，更新位置
      //这里要运行网页端的方法，就要通过web控制器runJavaScript调用，因为全局使用webController是同一个
      //所以在web组件下
      WebSdkClass.webController?.runJavaScript(`setLocation(${gcj02Positions.longitude},${gcj02Positions.latitude})`)
    }catch (e) {
      promptAction.showToast({message:"模拟器不支持GPS，真机可以正常使用"})
      WebSdkClass.webController?.runJavaScript(`setLocation(113.022176,34.760887)`)
    }
  }

  //弹窗：接收html提供信息呈现
  alert(message:string){
    AlertDialog.show({message:message})
  }

  //周边停车场的结果
  receiveAttendancePlace(res:string){
    //不知道什么时候接收到消息
    //接收到后还要告知页面组件，显示弹出层处理
    //eventHub：事件订阅处理,通过对象的上下文对象告知页面组件
    //发布订阅模式：什么名字，什么结果
    WebSdkClass.context?.eventHub.emit("search_near_place",res)
  }










}