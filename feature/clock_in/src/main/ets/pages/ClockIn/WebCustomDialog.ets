import { webview } from "@kit.ArkWeb"
import { WebSdkClass } from "base"

import { Permissions } from "@kit.AbilityKit"
import { WebAddressResp } from "../../pojo"

@CustomDialog
@Component
export struct WebCustomDiaLog{
  //弹窗控制器
  private controller:CustomDialogController
  //web控制器
  private webClass:WebSdkClass = new WebSdkClass()

  //状态：响应地址列表
  @State addressList:WebAddressResp[] = []


  clickCallBack=(address:string)=>{}

  //生命周期
  aboutToAppear(): void {
    //初始化WebviewController
    WebSdkClass.webController = new webview.WebviewController()
    //实例化上下文对象：静态唯一
    WebSdkClass.context= getContext()
    //为上下文对象，实践中心，添加一个订阅监听
    WebSdkClass.context.eventHub.on("search_near_place",(res:string)=>{
      //字符串转json，再转指定类型数组,给到状态变量list
        this.addressList = JSON.parse(res) as WebAddressResp[]
    })
  }


  //位置信息单项
  @Builder
  locationInfoItem(item:WebAddressResp){
    Column(){
      Row(){
        //名称
        Text(`${item.name}`)
          .fontSize(18)
          .fontColor($r("app.color.WebCustomDiaLog_text_name"))
          .fontWeight(FontWeight.Bold)
        //距离
        Text(`${item.distance}米以内`)
          .fontSize(14)
          .fontColor($r("app.color.WebCustomDiaLog_text_distance"))
          .fontWeight(FontWeight.Bold)
          .margin({left:10})
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("100%")


      Text(`${item.address}`)
        .fontSize(14)
        .fontColor($r("app.color.WebCustomDiaLog_text_name"))
        .margin({top:5})
    }
    .width("100%")
    .alignItems(HorizontalAlign.Start)
    .padding(10)
    .backgroundColor($r("app.color.clockin_text_white"))
    .borderRadius(5)
    .onClick(()=>{
      this.clickCallBack(item.address)
      this.controller.close()
    })
  }

  build() {
    Column(){
      Web({
        src:$rawfile("location.html"),
        controller:WebSdkClass.webController
      })
        .width("100%")
        .height("60%")
        .javaScriptAccess(true)
          //代理js脚本，默认会进行指定方法注入映射，这些方法都会挂载到window对象下
          //为了防止重名，他会创建一个swift9对象
          //window.swift9 = {}  所以只要保证这里的name不重名就行了
        .javaScriptProxy({
          name:"attendance",  //告知网页使用方法名称
          object:this.webClass,//代理对象
          methodList:['setCurrentLocation','alert','receiveAttendancePlace'],//暴露过去的/映射的方法
          controller:WebSdkClass.webController//控制器，对应web组件
        })
        Scroll(){
          Column(){
            ForEach(this.addressList,(item:WebAddressResp,index:number)=>{
              this.locationInfoItem(item)
            })
          }
        }
        .width("100%")
        .height("40%")
    }
    .width("100%")
    .height("100%")
  }
}