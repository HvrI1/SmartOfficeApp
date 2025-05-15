import { AffairStateType, BacKNav, HandleCardNormal, NoticeCard, TitleNav, USER_INFO, WorkCardNormal } from "basic"
import { AdvertInfo, HandleCardClass, NoticeInfo, User, WorkCardClass,AffairInfo } from "../../pojo"
import { promptAction, router } from "@kit.ArkUI"
import { getAffairApi,getUserNoticeApi,getAdvertByPosition } from "../../api/"

@Component
export struct House{
  //状态：轮播广告数据
  //异步操作，可能加载组件时还没数据。所以要为状态变量，拿到数据后再同步渲染
  @State
  advertImgList:AdvertInfo[]=[{
    advertName:"获取不到图片",
    advertUrl:"https://imagepphcloud.thepaper.cn/pph/image/141/779/94.jpg",
    duration:0
  }]

  //状态：公告数据
  //异步操作，可能加载组件时还没数据。所以要为状态变量，拿到数据后再同步渲染
  @State
  noticeList:NoticeInfo[]=[]

  //状态：事务数据
  //异步操作，可能加载组件时还没数据。所以要为状态变量，拿到数据后再同步渲染
  @State
  affairList:AffairInfo[]=[]
  @State waitWorkNum:number = 0 //待办数量
  @State finishNum:number=0 //已完成数量
  @State currentState:string= "待办"//当前点击的按钮

  //Scroll控制器
  // scroller:Scroller = new Scroller()


  //属性：卡片HandleCardNormal的数据
  HandleCardList:HandleCardClass[] = [
    {
      title:"我要查",
      text:"个人/单位查询",
      bgColor:[["#9966bb",0],["#6699bb",1]]
    },
    {
      title:"我要办",
      text:"个人/单位办事",
      bgColor:[["#fb9d85",0],["#7376fe",1]]
    },
    {
      title:"我要看",
      text:"办事指南等",
      bgColor:[["#7da6f6",0],["#ff5c64",1]]
    }
  ]

  //属性：卡片WorkCardNormal的数据
  WorkCardList:WorkCardClass[] = [
    {
      icon : $r("sys.symbol.doc_plaintext_and_pencil"),
      text :"我的工作",
      iconColor : "#8486f8"
    },
    {
      icon : $r("sys.symbol.envelope"),
      text :"消息提醒",
      iconColor : "#60b2ff"
    },
    {
      icon : $r("sys.symbol.doc_plaintext_and_pencil"),
      text :"我的审批",
      iconColor : "#ffa561"
    },
    {
      icon : $r("sys.symbol.doc_text_badge_magnifyingglass"),
      text :"我的考勤",
      iconColor : "#ff5c64"
    },
    {
      icon : $r("sys.symbol.list_square_bill"),
      text :"我的日程",
      iconColor : "#5ddac4"
    },
    {
      icon : $r("sys.symbol.doc_text_badge_arrow_up"),
      text :"考勤打卡",
      iconColor : "#397ef0"
    },
    {
      icon : $r("sys.symbol.calendar_badge_clock"),
      text :"会议预约",
      iconColor : "#fb6956"
    },
    {
      icon : $r("sys.symbol.rectangle_on_rectangle"),
      text :"更多功能",
      iconColor : "#9966bb"
    },
  ]


  //事务代办区域组件
  @Builder
  workSpaceComp(){
    Column({space:5}){
      Row({space:20}){
        Text(`${AffairStateType.WAITING}`+`(${this.waitWorkNum})`)
          .padding(5)
          .border({width:{bottom:this.currentState===AffairStateType.WAITING?3:0},color:$r("app.color.workSpaceComp_nav_border_true")})
          .fontSize($r("app.float.workSpaceComp_nav"))
          .fontColor(this.currentState===AffairStateType.WAITING?$r("app.color.workSpaceComp_nav_true"):$r("app.color.workSpaceComp_nav_false"))
          .onClick(()=>{
            this.currentState = AffairStateType.WAITING

          })
        Text(`${AffairStateType.FINISH}`+`(${this.finishNum})`)
          .padding(5)
          .border({width:{bottom:this.currentState===AffairStateType.FINISH?3:0},color:$r("app.color.workSpaceComp_nav_border_true")})
          .fontSize($r("app.float.workSpaceComp_nav"))
          .fontColor(this.currentState===AffairStateType.FINISH?$r("app.color.workSpaceComp_nav_true"):$r("app.color.workSpaceComp_nav_false"))
          .onClick(()=>{
            this.currentState = AffairStateType.FINISH

          })
      }
      .width("100%")
      Column({space:10}){
        ForEach(this.affairList,(item:AffairInfo,index:number)=>{
          if(this.currentState===item.status){
            this.affairItemCard(item,index)
          }
        })
      }
      .margin({top:8})



    }
    .width("90%")
    .padding(15)
    .borderRadius(10)
    .backgroundColor($r("app.color.workSpaceComp_background"))
  }
  //事务列表单项item
  @Builder
  affairItemCard(item:AffairInfo,index:number){
    Column({space:8}){
      Text(item.type)
        .width("100%")
        .fontSize($r("app.float.affairItemCard_title"))
        .fontWeight(FontWeight.Bold)
      Text(`申请人:${item.user}`)
        .width("100%")
        .fontSize($r("app.float.affairItemCard_text"))
      Text(`创建时间:${item.createTime}`)
        .width("100%")
        .fontSize($r("app.float.affairItemCard_text"))
        .fontColor($r("app.color.affairItemCard_date"))
    }
    .width("100%")
    .padding(10)
    .backgroundColor($r("app.color.affairItemCard_background"))
    .borderRadius(10)
    .onClick(()=>{
      //TODO:点击组件跳转到事务处理页面

    })
  }



  //方法：获取当前用户发布的公告数据
  async getUserNotice(){
    //从AppStorage获取用户id
    const user:User= AppStorage.get(USER_INFO) as User
    const  res= await getUserNoticeApi(user.id as number)
    if(res.code===200){
      this.noticeList=res.data as NoticeInfo[]
    }else {
      promptAction.showToast({message:"用户公告获取失败"})
    }
  }

  //方法：获取广告信息
  async getAdvertList(){
    const res =  await getAdvertByPosition({
      position:"index_swiper",
      advertNum:5
    })
    if(res.code === 200){
      this.advertImgList = res.data as AdvertInfo[]
    }else {
      promptAction.showToast({message:"广告数据获取失败"})
    }


  }

  //获取事务列表数据
  async getAffairList(){
    const res =  await getAffairApi()
    if(res.code===200){
      this.affairList=res.data as AffairInfo[]
      this.affairList.forEach((item:AffairInfo)=>{
        if(item.status==="待办"){
          this.waitWorkNum++
        }else if(item.status==="已完成"){
          this.finishNum++
        }
      })
    }else {
      promptAction.showToast({message:"事务列表获取失败"})
    }
  }


  //生命周期
  aboutToAppear(): void {
    //执行广告数据获取操作
    this.getAdvertList()
    //获取用户公告数据
    this.getUserNotice()
    //获取事务列表数据
    this.getAffairList()
  }
  build() {
    Column(){
      //头部导航区域
      BacKNav({
        title:"成功学院智慧办公平台",
        isShowBack:false,
        isShowSearch:true,
        searchCallBack:()=>{
          //TODO:搜索回调
        }
      })

     Scroll(){
       Column({space:10}){
         //卡片区域
         Row({space:10}){
           ForEach(this.HandleCardList,(item:HandleCardClass,index:number)=>{
             HandleCardNormal({
               title:item.title,
               text:item.text,
               bgColor:item.bgColor,
               clickCallBack:()=>{
                 if(item.title==="我要查"){
                   //TODO:我要查回调
                 }else if(item.title==="我要办"){
                   //TODO:我要办回调
                 }else if(item.title==="我要看"){}
                 //TODO:我要看回调
               }
             })
           })
         }
         .width("90%")


         //功能区域
         Grid(){
           ForEach(this.WorkCardList,(item:WorkCardClass,index:number)=>{
             GridItem(){
               WorkCardNormal({
                 text:item.text,
                 icon:item.icon,
                 iconColor:item.iconColor,
                 clickCallBack:()=>{
                   switch (item.text){
                     case "我的工作" :promptAction.showToast({message:item.text});break;//TODO:回调
                     case "消息提醒" :promptAction.showToast({message:item.text});break;//TODO:回调
                     case "我的审批" :promptAction.showToast({message:item.text});break;//TODO:回调
                     case "我的考勤" :router.pushUrl({url:"pages/Attendance/Attendance"});break;//:回调
                     case "我的日程" :promptAction.showToast({message:item.text});break;//TODO:回调
                     case "考勤打卡" :router.pushUrl({url:"pages/ClockIn/ClockIn"});break;//回调
                     case "会议预约" :router.pushUrl({url:"pages/MeetingSubscribe/MeetingSubscribe"});break;//回调
                     case "更多功能" :promptAction.showToast({message:item.text});break;//TODO:回调
                   }
                 }
               })
             }
           })
         }
         .width("90%")
         .height(170)
         .columnsTemplate("1fr 1fr 1fr 1fr")
         .columnsGap(20)
         .rowsTemplate("1fr 1fr")
         .rowsGap(20)
         .backgroundColor($r("app.color.start_window_background"))
         .borderRadius(10)
         .padding(10)

         //轮播swiper区域
         Swiper(){
           ForEach(this.advertImgList,(item:AdvertInfo,index:number)=>{
             Image(item.advertUrl)
               .width("100%")
               .height("100%")
               .borderRadius(5)
               .objectFit(ImageFit.Cover)
           })
         }
         .width("90%")
         .height(120)
         .autoPlay(true)
         .indicator(false)

         //公告区域
         TitleNav({
           title:"通知公告",
           isShowIcon:false
         })
           .width("90%")
         Column({space:10}){
           ForEach(this.noticeList,(item:NoticeInfo,index:number)=>{
             NoticeCard({
               text:item.title,
               img:item.imgUrl,
               date:item.createTime,
               viewNum:item.viewCount
             })
               .width("90%")

           })

         }
         .width("100%")


         //事务待办
         TitleNav({
           title:"事务待办",
           isShowIcon:false
         })

         //事务待办区域
         this.workSpaceComp()
       }

     }

    }
    .width("100%")
    .height("100%")
    .padding({bottom:55})
    .backgroundColor($r("app.color.page_background_normal"))
  }
}