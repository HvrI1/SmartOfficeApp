import { CommonConstants, ListDataSource, TitleNav,  WorkCardNormal } from "basic"
import { ApprovalNumInfo,
  ApprovalNumModel,
  CarSubscribeInfo, MeetingSubscribeInfo,
  User, UserModel, WorkCardClass } from "../../pojo"
import { promptAction, router } from "@kit.ArkUI"
import { getSubscribeApi } from "../../api"

@Component
export struct Work{

  //状态：从AppStorage中同步用户信息数据
  @StorageProp(CommonConstants.APP_STORAGE_USER)
  userInfo:User= new UserModel({} as User)

  //状态：单向取出当前用户事务处理数据
  @StorageProp(CommonConstants.APP_STORAGE_USER_AFFAIR_NUM)
  approvalNumData:ApprovalNumInfo = new ApprovalNumModel({
    currentAllAffairNum:0,
    currentWaitingNum:0,
    currentFinishNum:0,
    currentRejectNum:0
  } as ApprovalNumInfo)

  //属性：操作lazyForeach数据源的对象ListDataSource
  lazyMeetingDataSource:ListDataSource = new ListDataSource()

  lazyCarDataSource:ListDataSource = new ListDataSource()

  //异步加载：所以要是状态变量，拿到数据再渲染
  //状态：当前日程会议的数据
  @State  @Watch("updateMeetingDataSource") meetingSubscribeList:MeetingSubscribeInfo[] = []
  //状态：当前日程车辆预约的数据
  @State  @Watch("updateCarDataSource") carSubscribeList:CarSubscribeInfo[] =[]

  @State meetingSubscribeNum:number = 0 //会议数量
  @State carSubscribeNum:number = 0 //车辆预约数量
  @State currentType:boolean = true; //true:会议 false：车辆预约


  //当原始数据发生
  updateMeetingDataSource(){
    if(this.currentType) {
      this.lazyMeetingDataSource.reloadData(this.meetingSubscribeList)
    }
  }
  updateCarDataSource(){
    if(!this.currentType) {
      this.lazyCarDataSource.reloadData(this.carSubscribeList)
    }
  }

  //属性：卡片WorkCardNormal的数据
  WorkCardOfficeList:WorkCardClass[] = [
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

  //属性：卡片WorkCardPersonnel的数据
  WorkCardPersonnelList:WorkCardClass[] = [
    {
      icon : $r("sys.symbol.list_square_bill"),
      text :"入职管理",
      iconColor : "#8486f8"
    },
    {
      icon : $r("sys.symbol.recordingtape"),
      text :"待办提醒",
      iconColor : "#8486f8"
    },
    {
      icon : $r("sys.symbol.face_smiling"),
      text :"培训管理",
      iconColor : "#5ddac4"
    },
    {
      icon : $r("sys.symbol.onehand"),
      text :"考勤查看",
      iconColor : "#ffa561"
    },
    {
      icon : $r("sys.symbol.person_2"),
      text :"组织架构",
      iconColor : "#8486f8"
    },
    {
      icon : $r("sys.symbol.hand_tap"),
      text :"考勤打卡",
      iconColor : "#397ef0"
    },
    {
      icon : $r("sys.symbol.figure_running"),
      text :"攻读硕博",
      iconColor : "#8486f8"
    },
    {
      icon : $r("sys.symbol.label"),
      text :"我的薪资",
      iconColor : "#ffa062"
    },
  ]

  //组件：我的日程卡片区域
  @Builder
  subscribeCard(){
    Column({space:10}){
      Row({space:20}){
        Text(`会议`+`(${this.meetingSubscribeNum})`)
          .padding(5)
          .border({width:{bottom:this.currentType?3:0},color:$r("app.color.workSpaceComp_nav_border_true")})
          .fontSize($r("app.float.workSpaceComp_nav"))
          .fontColor(this.currentType?$r("app.color.workSpaceComp_nav_true"):$r("app.color.workSpaceComp_nav_false"))
          .onClick(()=>{
            this.currentType = true
          })
        Text(`车辆`+`(${this.carSubscribeNum})`)
          .padding(5)
          .border({width:{bottom:this.currentType?0:3},color:$r("app.color.workSpaceComp_nav_border_true")})
          .fontSize($r("app.float.workSpaceComp_nav"))
          .fontColor(this.currentType?$r("app.color.workSpaceComp_nav_false"):$r("app.color.workSpaceComp_nav_true"))
          .onClick(()=>{
            this.currentType = false
          })
      }
      .width("100%")

      //数据展示区域
      Scroll(){
        Column({space:10}){
          if(this.currentType){
            LazyForEach(this.lazyMeetingDataSource,(item:MeetingSubscribeInfo,index:number)=>{
              this.subscribeItemCard(index,item,undefined)
            })
          }else {
            LazyForEach(this.lazyCarDataSource,(item:CarSubscribeInfo,index:number)=>{
              this.subscribeItemCard(index,undefined,item)
            })
          }
        }
      }
      .height(300)
      .margin({top:8})
    }
    .width("100%")
    .padding(10)
  }

  //组件：我的日程卡片单项
  @Builder
  subscribeItemCard(index:number,meetingItem?:MeetingSubscribeInfo,carItem?:CarSubscribeInfo){
    if(meetingItem){
      Row(){
        Column({space:10}){
          Text(meetingItem.startTime)
            .width("100%")
            .fontSize($r("app.float.workSpaceComp_item_date"))
            .fontWeight(FontWeight.Bold)
          Text(meetingItem.endTime)
            .width("100%")
            .fontSize($r("app.float.workSpaceComp_item_date"))
            .fontColor($r("app.color.workSpaceComp_item_text_font_gray"))
            .fontWeight(FontWeight.Bold)
        }
        .width("30%")
        .height("100%")
        .padding(10)
        .border({width:{right:1},style:BorderStyle.Dashed})
        Column({space:10}){
          Text(meetingItem.meetingTheme)
            .width("100%")
            .fontSize($r("app.float.workSpaceComp_item_text"))
            .fontWeight(FontWeight.Bold)
          Row({space:10}){
            Text(meetingItem.department)
              .fontSize($r("app.float.workSpaceComp_item_text"))
              .fontColor($r("app.color.workSpaceComp_item_text_font_tag_partment"))
              .padding(5)
              .backgroundColor($r("app.color.workSpaceComp_item_tag_partment"))
              .borderRadius(5)
            Text(meetingItem.meetingType)
              .fontSize($r("app.float.workSpaceComp_item_text"))
              .fontColor($r("app.color.workSpaceComp_item_text_font_tag_type"))
              .padding(5)
              .borderRadius(5)
              .backgroundColor($r("app.color.workSpaceComp_item_tag_type"))
            Text(meetingItem.participants+"人")
              .fontSize($r("app.float.workSpaceComp_item_text"))
              .fontColor($r("app.color.workSpaceComp_item_text_font_tag"))
              .padding(5)
              .borderRadius(5)
              .backgroundColor($r("app.color.workSpaceComp_item_tag"))
          }
          .width("100%")
        }
        .layoutWeight(1)
        .height("100%")
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width("100%")
      .height(80)
      .border({width:{left:3,bottom:1},color:{left:$r("app.color.workSpaceComp_item_border_meeting_left"),bottom:$r("app.color.workSpaceComp_item_border_meeting_bottom")}})
      .borderRadius(5)
    }
    if(carItem){
      Row(){
        Column({space:10}){
          Text(carItem.startTime)
            .width("100%")
            .fontSize($r("app.float.workSpaceComp_item_date"))
            .fontWeight(FontWeight.Bold)
          Text(carItem.endTime)
            .width("100%")
            .fontSize($r("app.float.workSpaceComp_item_date"))
            .fontColor($r("app.color.workSpaceComp_item_text_font_gray"))
            .fontWeight(FontWeight.Bold)
        }
        .width("30%")
        .height("100%")
        .padding(10)
        .border({width:{right:1},style:BorderStyle.Dashed})
        Column({space:10}){
          Row({space:20}){
            Text(carItem.departure)
              .fontSize($r("app.float.workSpaceComp_item_text"))
              .fontWeight(FontWeight.Bold)
            SymbolGlyph($r("sys.symbol.arrow_right"))
              .fontSize($r("app.float.workSpaceComp_item_glyph"))
            Text(carItem.destination)
              .fontSize($r("app.float.workSpaceComp_item_text"))
              .fontWeight(FontWeight.Bold)
          }
          .width("100%")
          Row({space:10}){
            Text(carItem.passengers)
              .fontSize($r("app.float.workSpaceComp_item_text"))
              .fontColor($r("app.color.workSpaceComp_item_text_font_tag"))
              .padding(5)
              .borderRadius(5)
              .backgroundColor($r("app.color.workSpaceComp_item_tag"))
          }
          .width("100%")
        }
        .layoutWeight(1)
        .height("100%")
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width("100%")
      .height(80)
      .border({width:{left:3,bottom:1},color:{left:$r("app.color.workSpaceComp_item_border_meeting_left"),bottom:$r("app.color.workSpaceComp_item_border_meeting_bottom")}})
      .borderRadius(5)
    }
  }







  //查询当前用户的所有预约
  async getSubscribe(){
    const res = await getSubscribeApi(this.userInfo.id as number)
      //这里不需要判断状态200还是500，因为后端把异常处理掉了，只会返回成功结果，只有数据是否为空的情况之分
      if(res.data){
        this.meetingSubscribeList = res.data.meetingSubscribeVoList
        this.carSubscribeList = res.data.carSubscribeVoList
        this.meetingSubscribeNum=res.data.meetingSubscribeVoList.length
        this.carSubscribeNum=res.data.carSubscribeVoList.length
      }else {
        this.meetingSubscribeList = []
        this.carSubscribeList =[]
      }
  }



  //生命周期
  aboutToAppear(): void {
    //执行查询当前用户的所有预约
    this.getSubscribe()
  }


  build() {
    Scroll(){
      Column({space:10}){
        //用户信息区域
        Stack({alignContent:Alignment.End}){
          Row({space:20}){
            //头像
              Image(this.userInfo.profilePhoto?this.userInfo.profilePhoto:$r("[basic].media.null_user"))
                .width(50)
                .aspectRatio(1)
                .borderRadius(50)
                //设置圆角
            //信息
            Column(){
                Text(this.userInfo.nick)
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
          .width("100%")
          .height("100%")

          //特优教师
          Row(){
            Text("校 优")
              .width("100%")
              .height("100%")
              .fontWeight(FontWeight.Bold)
              .fontSize(18)
              .fontColor($r("app.color.excellent_teacher_text"))
              .textAlign(TextAlign.Center)
          }
          .width(50)
          .aspectRatio(1)
          .borderRadius("50%")
          .backgroundColor($r("app.color.excellent_teacher_background"))
          .margin({right:15})
        }
        .width("90%")
        .height(100)
        //待我审批和我发起的卡片区域
        Row({space:10}){
          //待我审批
          Row(){
            Column(){
              Text("待我审批")
                .width("100%")
                .fontSize($r("app.float.work_page_card_text_big"))
              Text(this.approvalNumData.currentWaitingNum+"")
                .width("100%")
                .fontSize($r("app.float.work_page_card_num"))
                .fontWeight(FontWeight.Bold)
            }
            .width("80%")
            .height("100%")
            .justifyContent(FlexAlign.SpaceEvenly)
            SymbolGlyph($r("sys.symbol.doc_plaintext_and_pencil"))
              .fontSize($r("app.float.work_page_card_glyph_normal"))
              .fontColor([$r("app.color.work_page_card_glyph_waiting")])
          }
          .padding(20)
          .height("100%")
          .layoutWeight(1)
          .linearGradient({angle:225,colors:[["#fffdbbbb",0],["#fefbfb",1]]})
          .borderRadius(10)
          .onClick(()=>{
            //点击组件跳转到事务处理页面
            router.pushUrl({url:"pages/Approval/Approval"})
          })
          //我完成的
          Row(){
            Column(){
              Text("我完成的")
                .width("100%")
                .fontSize($r("app.float.work_page_card_text_big"))
              Text(this.approvalNumData.currentFinishNum+"")
                .width("100%")
                .fontSize($r("app.float.work_page_card_num"))
                .fontWeight(FontWeight.Bold)
            }
            .width("80%")
            .height("100%")
            .justifyContent(FlexAlign.SpaceEvenly)
            SymbolGlyph($r("sys.symbol.doc_text_badge_checkmark"))
              .fontSize($r("app.float.work_page_card_glyph_normal"))
              .fontColor([$r("app.color.work_page_card_glyph_finish")])
          }
          .padding(20)
          .height("100%")
          .layoutWeight(1)
          .linearGradient({angle:225,colors:[["#ffa3c1fd",0],["#fefbfb",1]]})
          .borderRadius(10)
          .onClick(()=>{
            //点击组件跳转到事务处理页面
            router.pushUrl({url:"pages/Approval/Approval"})
          })
        }
        .width("90%")
        .height(100)

        //卡片功能区（行政办公）
        Column({space:10}){
          TitleNav({
            title:"行政办公",
            isShowIcon:false
          })
            .width("100%")
          //功能区域
          Grid(){
            ForEach(this.WorkCardOfficeList,(item:WorkCardClass,index:number)=>{
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
                      case "我的考勤" :promptAction.showToast({message:item.text});break;//TODO:回调
                      case "我的日程" :promptAction.showToast({message:item.text});break;//TODO:回调
                      case "考勤打卡" :promptAction.showToast({message:item.text});break;//TODO:回调
                      case "会议预约" :promptAction.showToast({message:item.text});break;//TODO:回调
                      case "更多功能" :promptAction.showToast({message:item.text});break;//TODO:回调
                    }
                  }
                })
              }
            })
          }
          .width("100%")
          .height(170)
          .columnsTemplate("1fr 1fr 1fr 1fr")
          .columnsGap(20)
          .rowsTemplate("1fr 1fr")
          .rowsGap(20)
        }
        .padding(5)
        .width("90%")
        .backgroundColor($r("app.color.start_window_background"))
        .borderRadius(10)

        //卡片功能区（人事管理）
        Column({space:10}){
          TitleNav({
            title:"人事管理",
            isShowIcon:false
          })
            .width("100%")
          //功能区域
          Grid(){
            ForEach(this.WorkCardPersonnelList,(item:WorkCardClass,index:number)=>{
              GridItem(){
                WorkCardNormal({
                  text:item.text,
                  icon:item.icon,
                  iconColor:item.iconColor,
                  clickCallBack:()=>{
                    switch (item.text){
                      case "入职管理" :promptAction.showToast({message:item.text});break;//TODO:回调
                      case "待办提醒" :promptAction.showToast({message:item.text});break;//TODO:回调
                      case "培训管理" :promptAction.showToast({message:item.text});break;//TODO:回调
                      case "考勤查看" :promptAction.showToast({message:item.text});break;//TODO:回调
                      case "组织架构" :promptAction.showToast({message:item.text});break;//TODO:回调
                      case "考勤打卡" :promptAction.showToast({message:item.text});break;//TODO:回调
                      case "攻读硕博" :promptAction.showToast({message:item.text});break;//TODO:回调
                      case "我的薪资" :promptAction.showToast({message:item.text});break;//TODO:回调
                    }
                  }
                })
              }
            })
          }
          .width("100%")
          .height(170)
          .columnsTemplate("1fr 1fr 1fr 1fr")
          .columnsGap(20)
          .rowsTemplate("1fr 1fr")
          .rowsGap(20)
        }
        .padding(5)
        .width("90%")
        .backgroundColor($r("app.color.start_window_background"))
        .borderRadius(10)

        //我的日程
        Column({space:10}){
          TitleNav({
            title:"我的日程",
            isShowIcon:false
          })
            .width("100%")

          this.subscribeCard()

        }
        .padding(5)
        .width("90%")
        .backgroundColor($r("app.color.start_window_background"))
        .borderRadius(10)



      }
    }
    .width("100%")
    .height("100%")
    .padding({bottom:10})
    .linearGradient({angle:180,colors:[["#828bfc",0],["#f4f8fb",1]]})
    .align(Alignment.Top)
  }
}