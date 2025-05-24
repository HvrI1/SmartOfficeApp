import { CommonConstants, PreferenceUtil, TitlePicNav, } from "basic"
import { ApprovalNumInfo, ApprovalNumModel, TabClass, User, UserModel } from "../../pojo"
import { promptAction } from "@kit.ArkUI"
import { HMRouterMgr } from "@hadss/hmrouter"

@Component
export struct Mine{
  //状态：单向取出当前用户事务处理数据
  @StorageProp(CommonConstants.APP_STORAGE_USER_AFFAIR_NUM)
  approvalNumData:ApprovalNumInfo = new ApprovalNumModel({
    currentAllAffairNum:0,
    currentWaitingNum:0,
    currentFinishNum:0,
    currentRejectNum:0
  } as ApprovalNumInfo)

  //状态：从AppStorage中同步用户信息数据
  @StorageProp(CommonConstants.APP_STORAGE_USER)
  userInfo:User= new UserModel({} as User)

  //属性：设置数据列表
  settingList:TabClass[]=[
    {
      title:"我的申请",
      name:"myApply",
      icon:$r("sys.symbol.text_clipboard"),
      color:"#fd7a50"
    },
    {
      title:"我的信息",
      name:"myApply",
      icon:$r("sys.symbol.envelope"),
      color:"#02aaf5"
    },
    {
      title:"我的关注",
      name:"myApply",
      icon:$r("sys.symbol.eye"),
      color:"#ffb90c"
    },
    {
      title:"我的工资",
      name:"myApply",
      icon:$r("sys.symbol.satellite_map"),
      color:"#23d688"
    },
    {
      title:"我的课表",
      name:"myApply",
      icon:$r("sys.symbol.list_checkmask"),
      color:"#8967fc"
    },
    {
      title:"系统设置",
      name:"myApply",
      icon:$r("sys.symbol.gearshape"),
      color:"#9966bb"
    },
    {
      title:"退出登录",
      name:"myApply",
      icon:$r("sys.symbol.trash"),
      color:"#6699bb"
    },
  ]






  //方法：获取当前时间返回对应字符串
  getDateString(): string {
    const currentHour = new Date().getHours()

    if (currentHour >= 0 && currentHour < 6) {
      return "晚上好"
    } else if (currentHour >= 6 && currentHour < 12) {
      return "上午好"
    } else if (currentHour >= 12 && currentHour < 18) {
      return "下午好"
    } else {
      return "晚上好"
    }
  }

  //方法：用户退出
  async  userQuit(){
    //清空所有AppStorage
    AppStorage.clear()
    //清空首选项
    const store= AppStorage.get<PreferenceUtil>(CommonConstants.PREFERENCE_UTIL)
    store?.putPreference(CommonConstants.PREF_USER,{} as User)
    store?.putPreference(CommonConstants.PREF_TOKEN,"")
    HMRouterMgr.replace({navigationId:CommonConstants.NAVIGATION_ID_PHONE,pageUrl:"LoginComp"})

  }


  build() {
    Column(){

      //顶部信息区域
      Row({space:20}){
        //头像
        Image(this.userInfo.profilePhoto?this.userInfo.profilePhoto:$r("[basic].media.null_user"))
          .width(50)
          .aspectRatio(1)
          .borderRadius(50)
        //设置圆角
        //信息
        Column(){
          Text(this.userInfo.nick+" "+this.getDateString())
            .fontSize($r("app.float.work_page_user_info_nick"))
            .fontWeight(FontWeight.Bold)
            .width("100%")
          Row(){
            Text(this.userInfo.isVip+" | ")
              .fontSize($r("app.float.work_page_user_info_detail"))
            Text(this.userInfo.sex+" | ")
              .fontSize($r("app.float.work_page_user_info_detail"))
            Text(this.userInfo.birthdate+" | ")
              .fontSize($r("app.float.work_page_user_info_detail"))
            Text(this.userInfo.lastLoginIp)
              .fontSize($r("app.float.work_page_user_info_detail"))
          }
          .width("100%")
        }
        .height(50)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width("90%")
      .height(120)
      //内容区域
      Column(){
        //卡片信息
        Row({space:10}){
          Row({space:10}){
            Image($r("[basic].media.computer_icon"))
              .width(50)
              .aspectRatio(1)
            Column({space:10}){
              Text(this.approvalNumData.currentAllAffairNum+"")
                .width("100%")
                .fontColor($r("app.color.Mine_card_title"))
                .fontSize($r("app.float.Mine_card_title"))
              Text("事务完成")
                .width("100%")
                .fontColor($r("app.color.Mine_card_text"))
                .fontSize($r("app.float.Mine_card_text"))
            }
            .layoutWeight(1)
            .width("100%")

          }
          .backgroundColor($r("app.color.mine_card_background"))
          .layoutWeight(1)
          .borderRadius(10)
          .padding(15)
          .onClick(()=>{
            //事务待办回调
          })
          Row({space:10}){
            Image($r("[basic].media.message_icon"))
              .width(50)
              .aspectRatio(1)
            Column({space:10}){
              Text("5条")
                .width("100%")
                .fontColor($r("app.color.Mine_card_title"))
                .fontSize($r("app.float.Mine_card_title"))
              Text("消息/邮件")
                .width("100%")
                .fontColor($r("app.color.Mine_card_text"))
                .fontSize($r("app.float.Mine_card_text"))
            }
            .layoutWeight(1)
            .width("100%")

          }
          .backgroundColor($r("app.color.mine_card_background"))
          .layoutWeight(1)
          .borderRadius(10)
          .padding(20)
          .onClick(()=>{
            //TODO:消息邮件待办回调
          })
        }
        .width("100%")
        .padding(10)
        .height(100)

        //更多功能信息
        Column({space:5}){
          ForEach(this.settingList,(item:TabClass,index:number)=>{
            TitlePicNav({
              title:item.title,
              isShowIcon:true,
              icon:item.icon as Resource,
              iconColor:item.color,
              clickCallBack:()=>{
                switch (item.title){
                  case "我的申请":promptAction.showToast({message:"我的申请"});break;
                  case "我的信息":promptAction.showToast({message:"我的信息"});break;
                  case "我的关注":promptAction.showToast({message:"我的关注"});break;
                  case "我的工资":promptAction.showToast({message:"我的工资"});break;
                  case "我的课表":promptAction.showToast({message:"我的课表"});break;
                  case "系统设置":promptAction.showToast({message:"系统设置"});break;
                  case "退出登录":this.userQuit();break;
                }

              }
            })
            if(!(index === this.settingList.length-1)){
              Divider()
            }
          })
        }
        .width("95%")
        .padding(10)
        .backgroundColor($r("app.color.mine_card_background"))
        .borderRadius(10)


      }
      .width("100%")
      .height("100%")
      .padding(10)
      .backgroundColor($r("app.color.mine_background"))
      .borderRadius({topLeft:25,topRight:25})


      }
      .width("100%")
      .height("100%")
      .padding({bottom:10})
      .linearGradient({angle:180,colors:[["#828bfc",0],["#f4f8fb",1]]})
      .align(Alignment.Top)
  }
}