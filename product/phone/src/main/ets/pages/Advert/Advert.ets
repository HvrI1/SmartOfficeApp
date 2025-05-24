import { CommonConstants, Result } from 'basic'
import { AdvertInfo, AdvertModel, User, UserModel } from '../../pojo'
import { promptAction, router } from '@kit.ArkUI'
import { getAdvertByPosition } from '../../api'

@Entry
@Component
struct Advert{

  //状态：广告数据对象
  @State advert:AdvertInfo = new AdvertModel({} as AdvertInfo)

  //属性：定时器id
  timeId:number = -1

  //生命周期：组件构建
  aboutToAppear(): void {
    //获取广告数据
    this.getAdvertInfo()
  }

  //声明周期：页面显示
  onPageShow(): void {
    //执行定时
    this.interval()
  }

  //生命周期：组件销毁时
  aboutToDisappear(): void {
    //清除定时器
    clearInterval(this.timeId)
  }

  //判断是否有用户信息
  getUserInfo(){
    const userInfo= AppStorage.get(CommonConstants.APP_STORAGE_USER) as User
    if(userInfo){
      return true
    }else {
      return false
    }
  }

  //请求广告数据
  async  getAdvertInfo(){
    const res:Result<AdvertInfo[]> = await getAdvertByPosition({position:"app_open",advertNum:1})
    if(res.code ===200){
      const advertList:AdvertInfo[] = res.data as AdvertInfo[]
      this.advert = advertList[0]
    }else {
      this.advert = {} as AdvertInfo
      promptAction.showToast({message:"获取广告失败"+res.message})
    }

  }

  //定时方法
  interval(){
    this.timeId = setInterval(()=>{
      if(this.advert.duration>0) {this.advert.duration--}
      else if(this.getUserInfo()){
        router.replaceUrl({url:"pages/Index/Index"})
      }else {
        router.replaceUrl({url:"pages/Login/Login"})
      }
    },1000)
  }

  build() {
    Column(){
      Text(){
        Span(this.advert.duration+"秒")
        Span(" ")
        Span("跳过")
          .onClick(()=>{
            if(this.getUserInfo()){
              router.replaceUrl({url:"pages/Index/Index"})
            }else {
              router.replaceUrl({url:"pages/Login/Login"})
            }
          })
      }
      .fontSize(12)
      .alignSelf(ItemAlign.End)
      .margin({top:20,right:20})
      .padding(5)
      .borderRadius(10)
      .backgroundColor($r("app.color.button_advert_background"))
      .opacity(0.5)

    }
    .height('100%')
    .width('100%')
    //这里我们希望背景全屏展示，所以使用padding,
    // .padding({top:this.topHeight})
    //这里背景图不能是组件，因为如果是组件会被padding限制内容而不是沉浸式了，所以要在组件上设置背景
    .backgroundImage(this.advert.advertUrl)
    .backgroundImageSize({width:"100%",height:"100%"})
    .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
  }
}