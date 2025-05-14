import { BacKNav, SimpleLoading, TextInputCheckType, TOKEN_KEY, USER_INFO } from 'basic'
import { loginApi, queryUserInfoByUsernameApi } from '../../api/user'
import { User, UserLoginDto } from '../../pojo'
import { UserSettingClass } from '../../util/preferences'
import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct Login {

  @State @Watch("checkDataFormat") username:string = ""
  @State @Watch("checkDataFormat") password:string = ""

  @State usernameCheck:boolean = false
  @State passwordCheck:boolean = false

  //@watch监听检查数据格式
  checkDataFormat(){
    const usernameRegex = /^[0-9a-z]{5,12}$/;
    const passwordRegex = /^[0-9a-zA-Z.]{5,16}$/;

    this.usernameCheck = usernameRegex.test(this.username)
    this.passwordCheck = passwordRegex.test(this.password)
  }

  async login(){
      //开启动画
      this.layer.open()
      //调用接口登录
      //TODO:这个地方也应该捕获异常，请求不到数据就响应超时
      let res_token =  await loginApi({username:this.username,password:this.password} as UserLoginDto)
      if(res_token.code === 200){
        //异步执行：将token存入或更新至首选项
        new UserSettingClass(getContext()).setUserToken(res_token.data as string)
        //将token存入AppStorage
        AppStorage.setOrCreate(TOKEN_KEY,res_token.data)
        //调用接口根据用户名查询用户的信息
        let res_user = await queryUserInfoByUsernameApi(this.username)
        //存入AppStorage
        if(res_user.code===200){
          //异步执行：将用户信息存入或更新至首选项
          new UserSettingClass(getContext()).setUserInfo(res_user.data as User)
          //将user存入AppStorage
          AppStorage.setOrCreate(USER_INFO,res_user.data)
          //跳转前关闭动画
          this.layer.close()
          //跳转首页
          router.replaceUrl({url:"pages/Index/Index"})
        }else {
          //获取不到用户信息
          promptAction.showToast({message:res_user+"登录异常，请稍后再试"})
        }
      }else {
        promptAction.showToast({message:res_token.message})
      }
    this.layer.close()
  }



  //遮罩动画
  layer:CustomDialogController = new CustomDialogController({
    builder: SimpleLoading({loadingText: '登录中，请稍后...'}),
    customStyle: false,
    autoCancel: false,//非常重要,必须声明false
    alignment: DialogAlignment.Center
  })




  build() {
    Column(){
      //导航
      BacKNav({
        title:"登录"
      })

      //中间logo和文字
      Column({space:5}){
        //logo
        Image($r("[basic].media.logo"))
          .width(50)
          .aspectRatio(1)
        //文字
        Text($r("app.string.login_title"))
          .fontSize($r("app.float.title_text"))
          .fontColor($r("app.color.title_text_font"))
      }
      .width("100%")
      .height(200)
      .justifyContent(FlexAlign.Center)

      //登录输入区域
      Column({space:20}){
        Column(){
          if(!this.usernameCheck){
            Text("长度5到12位的数字或小写字母组成")
            .width("90%")
            .fontSize($r("app.float.textinput_check"))
            .fontColor($r("app.color.textinput_check_false_font"))
          }else {
            Text("格式正确")
              .width("90%")
              .fontSize($r("app.float.textinput_check"))
              .fontColor($r("app.color.textinput_check_true_font"))
          }

          //账号输入行
          Row({space:5}){
            //icon
            SymbolGlyph($r("sys.symbol.person"))
              .fontSize($r("app.float.textinput_icon"))
              .margin({left:10})
              .fontColor([$r("app.color.textinput_placeholder_font")])
            //输入框
            TextInput({placeholder:"请输入账号",text:$$this.username})
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

        Column(){
          if(!this.passwordCheck){
            Text("长度5到16位的数字或字母或.组成")
              .width("90%")
              .fontSize($r("app.float.textinput_check"))
              .fontColor($r("app.color.textinput_check_false_font"))
          }else {
            Text("格式正确")
              .width("90%")
              .fontSize($r("app.float.textinput_check"))
              .fontColor($r("app.color.textinput_check_true_font"))
          }

          //密码输入行
          Row({space:5}){
            //icon
            SymbolGlyph($r("sys.symbol.person"))
              .fontSize($r("app.float.textinput_icon"))
              .margin({left:20})
              .fontColor([$r("app.color.textinput_placeholder_font")])
            //输入框
            TextInput({placeholder:"请输入密码",text:$$this.password})
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
        //TODO:实现验证码

        //登录按钮
        Button("登 录")
          .width("90%")
          .height(50)
          .borderRadius(10)
          .fontColor($r("app.color.button_login_font"))
          .backgroundColor($r("app.color.button_login_background"))
          .enabled(this.usernameCheck && this.passwordCheck)
          .onClick(()=>{
            //执行登录
            this.login()
          })

        //其他操作行
        Row({space:10}){
          Text("忘记密码")
            .fontSize($r("app.float.other_op_text"))
            .fontColor($r("app.color.other_op_text_font"))
            .onClick(()=>{
              //TODO:忘记密码
            })
          Text("其他登录方式")
            .fontSize($r("app.float.other_op_text"))
            .fontColor($r("app.color.other_op_text_font"))
            .onClick(()=>{
              //TODO:其他登录方式
            })
        }
        .width("90%")
        .justifyContent(FlexAlign.Center)
      }


    }
    .height('100%')
    .width('100%')
  }
}