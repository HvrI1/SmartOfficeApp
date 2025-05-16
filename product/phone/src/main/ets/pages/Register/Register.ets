import { BacKNav, SimpleLoading, uploadFile } from 'basic'
import { User, UserModel, UserRegisterDto } from '../../pojo'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { promptAction, router } from '@kit.ArkUI'
import { registerApi } from '../../api'

@Entry
@Component
struct Register {
  //状态：头像地址，上传头像后动态更新
  @State photoUrl:ResourceStr = $r("[basic].media.null_user")
  //状态：注册所需的dto对象
  @State @Watch("checkDataFormat") user:UserRegisterDto = {
    username:"",
    password:"",
    nick:"",
    phone:"",
    sex:0
  } as UserRegisterDto

  //状态：重复密码
  @State @Watch("checkRePassword") rePassword:string = ""

  //状态：用户名检查状态
  @State usernameCheck:boolean = false
  //状态：密码检查状态
  @State passwordCheck:boolean = false
  //状态：昵称检查状态
  @State nickCheck:boolean = false
  //状态：手机号检查状态
  @State phoneCheck:boolean = false
  //状态：重复密码检查状态
  @State rePasswordCheck:boolean = false

  //遮罩动画
  layerRegister:CustomDialogController = new CustomDialogController({
    builder: SimpleLoading({loadingText: '注册中，请稍后...'}),
    customStyle: false,
    autoCancel: false,//非常重要,必须声明false
    alignment: DialogAlignment.Center
  })

  //遮罩动画
  layerPhoto:CustomDialogController = new CustomDialogController({
    builder: SimpleLoading({loadingText: '上传图片中，请稍后...'}),
    customStyle: false,
    autoCancel: false,//非常重要,必须声明false
    alignment: DialogAlignment.Center
  })

  //@watch监听检查数据格式
  checkDataFormat(){
    //正则
    const usernameRegex = /^[0-9a-z]{5,12}$/;
    const passwordRegex = /^[0-9a-zA-Z.]{5,16}$/;
    const phoneRegex = /^1[3-9]\d{9}$/;
    const nickRegex = /^[\u4e00-\u9fa5a-zA-Z0-9_]{2,16}$/;

    //验证
    this.usernameCheck = usernameRegex.test(this.user.username as string)
    this.passwordCheck = passwordRegex.test(this.user.password as string)
    this.nickCheck = nickRegex.test(this.user.nick as string)
    this.phoneCheck = phoneRegex.test(this.user.phone as string)
  }

  //watch方法：检查两次密码是否一致
  checkRePassword(){
    if(this.user.password === this.rePassword) {
      this.rePasswordCheck=true
    }else {
      this.rePasswordCheck=false
    }
  }


  async selectImage() {
    const photoPicker = new photoAccessHelper.PhotoViewPicker();
    const result = await photoPicker.select({
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: 1
    });

    if (result.photoUris.length) {
      // 关键修改：通过媒体库API获取真实路径
      const uri = result.photoUris[0];
      return uri; // 获取可访问的真实路径
    }
    return null;
  }



  //方法：上传头像
  async execEditPhoto(){
    //1.从本地取出图片
    const localFilePath = await this.selectImage()
    //判断是否为空
    if(!localFilePath){
      promptAction.showToast({message:"本地图片地址失效"})
      return
    }
    //2.调用接口换网络地址
    try {
      this.layerPhoto.open()
      this.photoUrl =  await uploadFile(localFilePath)
      promptAction.showToast({message:"头像上传成功"})
      this.layerPhoto.close()
    }catch (e){
      promptAction.showToast({message:e})
      this.layerPhoto.close()
      return
    }finally {
      this.layerPhoto.close()
    }

  }


  //方法：注册
  async exeRegister(){

    if(JSON.stringify(this.photoUrl) === `{"id":-1,"type":20000,"params":["[basic].media.null_user"],"bundleName":"com.wsn.smartoffice","moduleName":"basic"}`){
      promptAction.showToast({message:"请先上传头像"})
      return
    }
    this.layerRegister.open()
    this.user.profilePhoto=this.photoUrl as string
    const res = await registerApi(this.user)
    if(res.code===200){
      promptAction.showToast({message:"注册成功"})
    }else {
      promptAction.showToast({message:res.message})
    }
    this.layerRegister.close()
    router.pushUrl({url:"pages/Login/Login"})
  }





  build() {
    Column(){
      BacKNav({
        title:"注册",
        isShowBack:true
      })
        .backgroundColor($r("app.color.page_nav_background_white"))


        //logo
        Column({space:5}){
          Image(this.photoUrl)
            .width(100)
            .aspectRatio(1)
            .borderRadius(50)
            .onClick(()=>{
              //上传头像操作
              this.execEditPhoto()
            })
          Text("点击图片上传头像")
            .width("100%")
            .textAlign(TextAlign.Center)
            .fontSize(16)
        }
        .margin({top:20,bottom:20})




      //注册输入区域
      Column({space:20}) {
        Column() {
          if (!this.nickCheck) {
            Text("2-16位任意字符")
              .width("90%")
              .fontSize($r("app.float.textinput_check"))
              .fontColor($r("app.color.textinput_check_false_font"))
          } else {
            Text("格式正确")
              .width("90%")
              .fontSize($r("app.float.textinput_check"))
              .fontColor($r("app.color.textinput_check_true_font"))
          }

          //账号输入行
          Row({ space: 5 }) {
            //icon
            SymbolGlyph($r("sys.symbol.person"))
              .fontSize($r("app.float.textinput_icon"))
              .margin({ left: 10 })
              .fontColor([$r("app.color.textinput_placeholder_font")])
            //输入框
            TextInput({ placeholder: "请输入昵称", text: $$this.user.nick })
              .layoutWeight(1)
              .backgroundColor($r("app.color.lucency"))
              .padding(0)
              .placeholderColor($r("app.color.textinput_placeholder_font"))
              .maxLines(1)
              .maxLength(20)
          }
          .width("90%")
          .height(50)
          .borderRadius(10)
          .backgroundColor($r("app.color.textinput_row_background"))




          if (!this.usernameCheck) {
            Text("长度5到12位的数字或小写字母组成")
              .width("90%")
              .fontSize($r("app.float.textinput_check"))
              .fontColor($r("app.color.textinput_check_false_font"))
          } else {
            Text("格式正确")
              .width("90%")
              .fontSize($r("app.float.textinput_check"))
              .fontColor($r("app.color.textinput_check_true_font"))
          }




          //账号输入行
          Row({ space: 5 }) {
            //icon
            SymbolGlyph($r("sys.symbol.person"))
              .fontSize($r("app.float.textinput_icon"))
              .margin({ left: 10 })
              .fontColor([$r("app.color.textinput_placeholder_font")])
            //输入框
            TextInput({ placeholder: "请输入账号", text: $$this.user.username })
              .layoutWeight(1)
              .backgroundColor($r("app.color.lucency"))
              .padding(0)
              .placeholderColor($r("app.color.textinput_placeholder_font"))
              .maxLines(1)
              .maxLength(20)
          }
          .width("90%")
          .height(50)
          .borderRadius(10)
          .backgroundColor($r("app.color.textinput_row_background"))
        }

        Column() {
          if (!this.passwordCheck) {
            Text("长度5到16位的数字或字母或.组成")
              .width("90%")
              .fontSize($r("app.float.textinput_check"))
              .fontColor($r("app.color.textinput_check_false_font"))
          } else {
            Text("格式正确")
              .width("90%")
              .fontSize($r("app.float.textinput_check"))
              .fontColor($r("app.color.textinput_check_true_font"))
          }

          //密码输入行
          Row({ space: 5 }) {
            //icon
            SymbolGlyph($r("sys.symbol.lock"))
              .fontSize($r("app.float.textinput_icon"))
              .margin({ left: 20 })
              .fontColor([$r("app.color.textinput_placeholder_font")])
            //输入框
            TextInput({ placeholder: "请输入密码", text: $$this.user.password })
              .layoutWeight(1)
              .backgroundColor($r("app.color.lucency"))
              .padding(0)
              .placeholderColor($r("app.color.textinput_placeholder_font"))
              .type(InputType.Password)
              .maxLines(1)
              .maxLength(16)
          }
          .width("90%")
          .height(50)
          .borderRadius(10)
          .backgroundColor($r("app.color.textinput_row_background"))
        }


       Column(){
         if (!this.rePasswordCheck) {
           Text("两次密码不同")
             .width("90%")
             .fontSize($r("app.float.textinput_check"))
             .fontColor($r("app.color.textinput_check_false_font"))
         } else {
           Text("格式正确")
             .width("90%")
             .fontSize($r("app.float.textinput_check"))
             .fontColor($r("app.color.textinput_check_true_font"))
         }
         //确认密码输入行
         Row({ space: 5 }) {
           //icon
           SymbolGlyph($r("sys.symbol.lock"))
             .fontSize($r("app.float.textinput_icon"))
             .margin({ left: 20 })
             .fontColor([$r("app.color.textinput_placeholder_font")])
           //输入框
           TextInput({ placeholder: "请输入确认密码", text: $$this.rePassword })
             .layoutWeight(1)
             .backgroundColor($r("app.color.lucency"))
             .padding(0)
             .placeholderColor($r("app.color.textinput_placeholder_font"))
             .type(InputType.Password)
             .maxLines(1)
             .maxLength(16)
         }
         .width("90%")
         .height(50)
         .borderRadius(10)
         .backgroundColor($r("app.color.textinput_row_background"))
       }

        Column() {
          if (!this.phoneCheck) {
            Text("国所有主流运营商号段")
              .width("90%")
              .fontSize($r("app.float.textinput_check"))
              .fontColor($r("app.color.textinput_check_false_font"))
          } else {
            Text("格式正确")
              .width("90%")
              .fontSize($r("app.float.textinput_check"))
              .fontColor($r("app.color.textinput_check_true_font"))
          }

          //手机号输入行
          Row({ space: 5 }) {
            //icon
            SymbolGlyph($r("sys.symbol.phone_fill"))
              .fontSize($r("app.float.textinput_icon"))
              .margin({ left: 10 })
              .fontColor([$r("app.color.textinput_placeholder_font")])
            //输入框
            TextInput({ placeholder: "请输入手机号", text: $$this.user.phone })
              .type(InputType.PhoneNumber)
              .layoutWeight(1)
              .backgroundColor($r("app.color.lucency"))
              .padding(0)
              .placeholderColor($r("app.color.textinput_placeholder_font"))
              .maxLines(1)
              .maxLength(20)
          }
          .width("90%")
          .height(50)
          .borderRadius(10)
          .backgroundColor($r("app.color.textinput_row_background"))
        }


        Row({space:5}){
          Text("性别:")
          Select([
            { value: "女" },
            { value: "男" }
          ])
            .value("请选择")
            .onSelect((index:number,value:string)=>{
              if(value === "请选择"){
                return
              }
              this.user.sex = index
            })
        }
        .width("100%")
        .height(50)
        .padding({left:20})
      }
        //登录按钮
        Button("注 册")
          .width("90%")
          .height(50)
          .borderRadius(10)
          .fontColor($r("app.color.button_login_font"))
          .backgroundColor($r("app.color.button_login_background"))
          .margin({top:50})
          .enabled(
            this.usernameCheck &&
            this.passwordCheck &&
            this.nickCheck &&
            this.phoneCheck &&
            this.rePasswordCheck
          )
          .onClick(() => {
            //执行注册
            this.exeRegister()
          })


    }
    .height('100%')
    .width('100%')
  }
}