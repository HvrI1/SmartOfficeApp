import { BacKNav } from 'basic'

@Entry
@Component
struct Register {

  build() {
    Column(){
      BacKNav({
        title:"注册",
        isShowBack:true
      })
        .backgroundColor($r("app.color.page_nav_background_white"))


    }
    .height('100%')
    .width('100%')
  }
}