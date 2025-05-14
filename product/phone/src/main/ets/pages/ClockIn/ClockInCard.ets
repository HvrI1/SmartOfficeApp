import { permissionManager } from "basic"
import { WebCustomDiaLog } from "./WebCustomDiaLog"
import { promptAction, router } from "@kit.ArkUI"
import { Permissions } from "@kit.AbilityKit"

@Component
export struct ClockInCard{

  //状态：位置信息
  @State location:string = ""

  //状态：单项传递父组件对象状态，改变打卡按钮文字
  @Prop isChange:boolean

  //定义打卡回调,给父组件调用
  clickCallBack=(location:string)=>{}

  //属性：需要检查的权限列表
  permissions:Permissions[] = [
    "ohos.permission.LOCATION",
    "ohos.permission.APPROXIMATELY_LOCATION"
  ]

  //私有属性：web弹窗的控制器
  private webController:CustomDialogController = new CustomDialogController({
    builder:WebCustomDiaLog({
      clickCallBack:(address:string)=>{
        this.location = address
      }
    })
  })


  //检查权限
  async  checkPermission(){
    try {
      //检查权限，不存在就提供弹窗
      if(!permissionManager.checkPermissions(this.permissions)){
        //弹窗初次授权，如果取消：throw Error就会被catch捕获
        await permissionManager.requestPermissions(this.permissions)
      }
    }catch{
      //捕获异常，捕获的是上面的取消操作
      //弹窗提示
      const res = await promptAction.showDialog({
        title:"权限提示",
        message:"考勤打卡需要获取定位权限才可使用，请前往系统设置开启定位权限！",
        alignment:DialogAlignment.Center,
        buttons:[
          {text:"取消",color:$r("app.color.button_primary_disabled")},
          {text:"前往设置",color:$r("app.color.button_primary")},
        ]
      })
      if(res.index === 1){
        permissionManager.openPermissionSettingPage()
      }else {
        //用户选择了取消，强制返回至主页，不让打卡。
        router.clear()
        router.replaceUrl({url:"pages/Index/Index"})
      }
    }
  }

  //生命周期
  aboutToAppear(): void {
    //权限检查
    this.checkPermission()
  }
  build() {
    Column({space:15}){
      //顶部信息
      Row({space:5}){
        Text(this.isChange?"上":"下")
          .borderRadius(50)
          .backgroundColor($r("app.color.clockin_text_blue"))
          .fontSize($r("app.float.clockin_text_little"))
          .layoutWeight(1)
          .aspectRatio(1)
          .textAlign(TextAlign.Center)
          .fontColor($r("app.color.clockin_text_white"))
        Text(this.isChange?"上班打卡":"下班打卡")
          .fontSize($r("app.float.clockin_text_little"))
          .width("90%")
      }
      .width("100%")
      //打卡按钮
      Text(this.isChange?"上班打卡":"下班打卡")
        .width(150)
        .aspectRatio(1)
        .borderRadius(100)
        .backgroundColor($r("app.color.clockin_button"))
        .fontSize($r("app.float.clockin_text_bigger"))
        .textAlign(TextAlign.Center)
        .fontColor($r("app.color.clockin_text_white"))
        .onClick(()=>{
          //TODO:执行回调，将位置信息给父组件
          this.clickCallBack(this.location)
        })
      //位置
      Row({space:5}){
        SymbolGlyph($r("sys.symbol.local_fill"))
          .fontSize($r("app.float.clockin_text_glyph"))
          .fontColor([$r("app.color.clockin_text_gray")])
        Text(this.location?this.location:"点击获取位置信息")
          .fontColor($r("app.color.clockin_text_gray"))
          .fontSize($r("app.float.clockin_text_little"))
          .layoutWeight(1)
          .maxLines(2)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .ellipsisMode(EllipsisMode.END)
          .onClick(()=>{
            //打开弹窗显示web页面，选择位置，在回调处返回位置信息
            this.webController.open()

          })
      }
      .padding(10)
      .borderRadius(20)
      .backgroundColor($r("app.color.clockin_location_bacground"))
      .width("55%")

    }
    .width("90%")
    .padding(20)
    .backgroundColor($r("app.color.page_nav_background_white"))
    .borderRadius(10)
  }
}


